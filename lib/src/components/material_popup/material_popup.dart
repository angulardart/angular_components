// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import '../annotations/rtl_annotation.dart';
import '../content/deferred_content_aware.dart';
import '../mixins/material_dropdown_base.dart';
import '../../laminate/components/popup/hierarchy.dart';
import '../../laminate/components/popup/popup.dart';
import '../../laminate/overlay/overlay.dart';
import '../../laminate/popup/popup.dart'
    show PopupEvent, PopupRef, PopupService, PopupSizeProvider;
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import 'package:angular2/angular2.dart';

export '../../laminate/popup/popup.dart' show PopupSourceDirective;

/// A styled alternative to [PopupComponent] with material design look-and-feel.
///
/// It delegates and has an API equivalent to using [PopupComponent].
///
/// Caveats:
/// - Popups closing and opening are automatically delayed to add animations
/// - An additional event, `animationComplete`, is available.
/// - Take advantage of enforceSpaceConstraints defined in
/// [PopupInterface](https://github.com/dart-lang/angular2_components/tree/master/lib/src/laminate/components/popup/src/base.dart).
///
/// This is useful if content size is such that adds scroll to the page.
/// - Even though this component supports [ChangeDetectionStrategy.OnPush]
///   for the cases tested in examples, it does not set ChangeDetectionStrategy.
///   This means that usage of this component within another component in OnPush
///   mode is possible but at the implementors discretion since any such
///   implementation would require all it's content children to support OnPush
///   as well.
///
/// - If the contents change and need to readjust position use
///  [trackLayoutChanges] which is also defined in [PopupInterface].
///
/// __Events__:
/// - `animationComplete`: Triggers after an open or close animation finishes.
///
/// __Example use__:
///     <button (click)="showPopup = !showPopup"
///             popupSource
///             #source="popupSource">
///       Toggle
///     </button>
///     <material-popup [visible]="showPopup" [source]="source">
///       Hello World
///     </material-popup>
///
/// Material popup also supports deferred/lazy-loaded content:
///     <material-popup [visible]="showPopup" [source]="source">
///       <expensive-component *deferredContent></expensive-component>
///     </material-popup>
///
/// This component publishes itself as a [DropdownHandle], so its children may
/// control its visibility by injecting it:
///
///     class MyComponent {
///       final DropdownHandle _dropdownHandle;
///
///       MyComponent(this._dropdownHandle);
///
///       void onSomethingThatShouldCloseTheDropdown() {
///         _dropdownHandle.close();
///       }
///     }
///
/// __Inputs:__
///
/// - `slide: String` -- Direction of popup scaling. Valid values are `x`, `y`,
/// or `null`.
@Component(
    selector: 'material-popup',
    host: const {'[attr.pane-id]': 'uniqueId'},
    inputs: const [
      'alignContentX',
      'alignContentY',
      'autoDismiss',
      'enforceSpaceConstraints',
      // Deprecated
      'matchSourceWidth',
      'matchMinSourceWidth',
      'offsetX',
      'offsetY',
      'preferredPositions',
      'slide',
      'source',
      'trackLayoutChanges',
      'visible',
      'z'
    ],
    outputs: const [
      'onAnimationComplete: animationComplete',
      'onOpen: open',
      // TODO(google): See if we can refactor this out (from old component).
      'onOpened: opened',
      'onClose: close',
      'visibleChange',
    ],
    providers: const [
      const Provider(PopupComponent, useExisting: MaterialPopupComponent),
      const Provider(DropdownHandle, useExisting: MaterialPopupComponent),
      const Provider(DeferredContentAware, useExisting: PopupComponent),
      const Provider(PopupHierarchy,
          useFactory: MaterialPopupComponent_getHierarchy,
          deps: const [PopupComponent]),
      const Provider(PopupRef,
          useFactory: MaterialPopupComponent_getResolvedPopupRef,
          deps: const [PopupComponent])
    ],
    directives: const [PopupRefDirective, NgClass],
    templateUrl: 'material_popup.html',
    styleUrls: const ['material_popup.scss.css'])
class MaterialPopupComponent extends PopupComponent
    implements OnDestroy, DropdownHandle {
  // Visible for testing.
  static const Duration SLIDE_DELAY = const Duration(milliseconds: 218);

  final LazyEventEmitter onAnimationComplete = new LazyEventEmitter();
  final LazyEventEmitter onOpened = new LazyEventEmitter();
  final LazyEventEmitter<bool> _onContentVisible =
      new LazyEventEmitter<bool>.broadcast();
  final ChangeDetectorRef _changeDetector;

  // Used to have a maximum of one timer to wait for CSS animations.
  Timer _animationTimer;
  Completer _onAnimationCompleter;

  // The last known size of the popup content.
  Future<Rectangle> _contentSize;

  // The last known size of the viewport.
  Rectangle _viewportSize;

  // Used to avoid multiple events with the same visibility.
  bool _popupReportsVisible = false;

  // Used to avoid events occurring after detached from the DOM.
  bool _isDestroyed = false;

  // PopupComponent has the setter, but we need the getter to satisfy the
  // [DropdownHandle] interface.
  @override
  bool get autoDismiss => state.autoDismiss;

  /// The height of the inner-content.
  ///
  /// If null, the height is automatic (e.g. similar to no style="height:...").
  num contentHeight;

  /// The width of the inner-content.
  ///
  /// If null, the width is automatic (e.g. similar to no style="width:...").
  num contentWidth;

  /// Whether the underlying popup should be content visible.
  bool showPopup = false;

  /// The z-elevation of the border effect.
  int z = 2;

  /// Output stream that supports [(visible)] syntax.
  Stream<bool> get visibleChange => onVisible;

  /// The CSS transform origin based on configuration.
  String get transformOrigin =>
      resolvedPopupRef?.popupAlignment?.animationOrigin;

  int get zIndex => resolvedPopupRef?.zIndex;

  /// Direction of popup scaling.
  String _slide;
  String get slide => _slide;
  set slide(String value) {
    _slide = (value?.isNotEmpty ?? false) ? value : null;
    assert(_slide == null || (slide == 'x' || slide == 'y'));
  }

  final OverlayService _overlayService;

  /// Optional handler for calculating popup sizes.
  final PopupSizeProvider _popupSizeProvider;

  /// The max height of the popup content provided by the PopupSizeProvider.
  num maxHeight;

  /// The max width of the popup content provided by the PopupSizeProvider.
  num maxWidth;

  /// Whether or not popup should set a minimum width to the width of [source].
  bool _matchMinSourceWidth = false;

  bool get matchMinSourceWidth => _matchMinSourceWidth;

  @override
  set matchMinSourceWidth(var value) {
    _matchMinSourceWidth = super.matchMinSourceWidth = getBool(value);
  }

  /// Sets the background color of the popup to be ink (`$mat-grey-700`).
  @Input('ink')
  set inkBackground(value) {
    _inkBackground = getBool(value);
  }

  bool _inkBackground = false;
  bool get inkBackground => _inkBackground;

  /// Whether the popup panel has an enclosing box that wraps the content.
  ///
  /// This gives the panel a shadow and background color.
  bool _hasBox = true;
  @Input()
  set hasBox(value) {
    _hasBox = getBool(value);
  }

  bool get hasBox => _hasBox;

  MaterialPopupComponent(
      DomService domService,
      @Optional() @SkipSelf() PopupHierarchy hierarchy,
      @Optional() @SkipSelf() PopupRef parentPopup,
      NgZone ngZone,
      PopupService popupService,
      this._overlayService,
      @Optional() this._popupSizeProvider,
      @Optional() @Inject(rtlToken) bool rtl,
      this._changeDetector)
      : super(domService, hierarchy, parentPopup, ngZone, popupService, rtl);

  @override
  Stream<bool> get contentVisible => _onContentVisible.distinct();

  // Returns a future that completes after a short duration that an animation
  // may occur (in this case, via CSS). If a pending animation is already in
  // progress, we wait until it is done before scheduling another delay.
  Future _afterAnimationDelay() async {
    // If there is already a pending animation, wait for it to be done first.
    if (_onAnimationCompleter != null) {
      await _onAnimationCompleter.future;
      return _afterAnimationDelay();
    }

    // Schedule an animation.
    assert(_animationTimer == null);
    var completer = _onAnimationCompleter = new Completer.sync();
    if (!_isDestroyed) {
      _animationTimer = new Timer(SLIDE_DELAY, () {
        _animationTimer = null;
        _onAnimationCompleter = null;
        completer.complete();
        onAnimationComplete.add(null);
        _changeDetector.markForCheck();
      });
    }
    return completer.future;
  }

  @override
  void ngOnDestroy() {
    super.ngOnDestroy();
    _animationTimer?.cancel();
    _isDestroyed = true;
  }

  // Set the dimensions to the size previously reported in order to have CSS
  // animate. If popupSizeProvider is available, restrict the content size to be
  // below the calculated maximum size.
  Future _animateContentSize() async {
    var contentSize = await _contentSize;
    // Recompute the max size based on the viewport size as well as the popup
    // position.
    if (_popupSizeProvider != null && _viewportSize != null) {
      maxHeight = _popupSizeProvider.getMaxHeight(
          resolvedPopupRef.top, _viewportSize.height);
      maxWidth = _popupSizeProvider.getMaxWidth(
          resolvedPopupRef.left, _viewportSize.width);
    }
    contentHeight =
        maxHeight != null ? min(contentSize.height, maxHeight) : null;
    contentWidth = maxWidth != null ? min(contentSize.width, maxWidth) : null;
  }

  // Reset the content size to the maximum size (flow automatically).
  void _resetContentSize() {
    contentHeight = maxHeight;
    contentWidth = maxWidth;
  }

  @override
  void onVisibleChanged(bool newVisibility) {
    super.onVisibleChanged(newVisibility);
    _onContentVisible.add(newVisibility);

    // Avoid extraneous events.
    if (_popupReportsVisible == newVisibility) {
      return;
    }

    // If visibility has been flipped on, animate the popup opening.
    _popupReportsVisible = newVisibility;
    if (newVisibility) {
      _animatePopupOpen();
    } else {
      // Once the popup is closed we want to reset the content width/height.
      // Otherwise when we try to re-open the popup the dimensions won't be
      // read properly by the popup infrastructure.
      _resetContentSize();
    }
  }

  // Start visible, but at 0px dimensions.
  //
  // Then, in the next frame, set the dimensions to the size previously reported
  // in order to have CSS animate. After the CSS animation, just reset (flow).
  void _animatePopupOpen() {
    showPopup = true;
    _nextFrame(() {
      _animateContentSize();
      _afterAnimationDelay().then((_) {
        _resetContentSize();
        onOpened.add(null);
      });
    });
  }

  void _nextFrame(void fn()) {
    Timer.run(() {
      if (!_isDestroyed) {
        fn();
      }
    });
  }

  @override
  Future onPopupOpened(PopupEvent popupEvent) async {
    super.onPopupOpened(popupEvent);

    // Wait for all listeners to have a chance to either defer or cancel this.
    await popupEvent.onDefer;

    // Initializes the maximum size and content size based on the viewport size
    // before popup position is populated.
    if (_popupSizeProvider != null) {
      _viewportSize = await _overlayService.measureContainer();
      contentHeight =
          maxHeight = _popupSizeProvider.getMaxHeight(0, _viewportSize.height);
      contentWidth =
          maxWidth = _popupSizeProvider.getMaxWidth(0, _viewportSize.width);
    }

    // Trigger *deferredContent to create a little early so we can measure it.
    _onContentVisible.add(true);
    _contentSize = popupEvent.size();
    _changeDetector.markForCheck();
  }

  @override
  Future onPopupClosed(PopupEvent popupEvent) async {
    // Forward the event to any listeners.
    super.onPopupClosed(popupEvent);

    // Wait for all listeners to have a chance to either defer or cancel this
    // event - this is sort of a loose "almost completed". If the event was
    // cancelled, then this will never complete -
    // which is good - we don't want to close the popup anymore.
    popupEvent.defer(popupEvent.onDefer.then(((_) => _afterAnimationDelay())));
    await popupEvent.onDefer;

    // Start closing the popup if we were not cancelled.
    //
    // This probably has faulty logic if you defer and then cancel at a later
    // time but since this is probably an extreme edge case it is fine for now.
    if (!popupEvent.cancelled) {
      _contentSize = popupEvent.size();
      showPopup = false;
      _onContentVisible.add(false);
      _changeDetector.markForCheck();
      return _animateContentSize();
    }
  }

  @override
  void open() {
    visible = true;
  }

  @override
  void close() {
    visible = false;
  }

  /// Custom css class to be set on material-shadow inside the popup.
  // TODO(google): clean this up with more sophisticated solution.
  @Input()
  String shadowCssClass;
}

MaterialPopupComponent_getResolvedPopupRef(c) =>
    PopupComponent.getResolvedPopupRef(c);

MaterialPopupComponent_getHierarchy(c) => c.hierarchy;
