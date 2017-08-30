// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart' hide Visibility;
import 'package:meta/meta.dart';

import '../../css/acux/zindexer.dart';
import '../../laminate/enums/alignment.dart';
import '../../laminate/enums/visibility.dart';
import '../../laminate/overlay/module.dart';
import '../../laminate/overlay/overlay.dart';
import '../../laminate/popup/module.dart';
import '../../laminate/popup/popup.dart';
import '../../model/action/async_action.dart';
import '../../model/ui/toggle.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/disposer/disposer.dart';
import '../../utils/id_generator/id_generator.dart';
import '../content/deferred_content_aware.dart';
import '../mixins/material_dropdown_base.dart';

export '../../laminate/popup/popup.dart' show PopupSourceDirective;

typedef Future _DebouncedVisibilitySetter();

/// A popup component with material design look-and-feel.
///
/// Caveats:
/// - Popups closing and opening are automatically delayed to add animations
/// - Take advantage of enforceSpaceConstraints defined in
/// [PopupInterface].
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
/// __Example use__:
///
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
///
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
    providers: const [
      const Provider(DeferredContentAware, useExisting: MaterialPopupComponent),
      const Provider(DropdownHandle, useExisting: MaterialPopupComponent),
      const Provider(
        PopupHierarchy,
        useFactory: getHierarchy,
      ),
      const Provider(
        PopupRef,
        useFactory: getResolvedPopupRef,
      ),
    ],
    templateUrl: 'material_popup.html',
    styleUrls: const ['material_popup.scss.css'])
class MaterialPopupComponent extends Object
    with PopupBase, PopupEvents, PopupHierarchyElement
    implements
        PopupInterface,
        DeferredContentAware,
        AfterViewInit,
        OnDestroy,
        DropdownHandle {
  // Visible for testing.
  static const Duration SLIDE_DELAY = const Duration(milliseconds: 218);

  @Output('opened')
  Stream get onOpened => _onOpened.stream;
  final StreamController _onOpened = new StreamController.broadcast(sync: true);
  final StreamController<bool> _onContentVisible =
      new StreamController<bool>.broadcast(sync: true);

  final ChangeDetectorRef _changeDetector;
  final ViewContainerRef _viewContainer;
  final DomService _domService;
  final Disposer _disposer = new Disposer.oneShot();
  final NgZone _ngZone;
  final OverlayService _overlayService;
  PopupHierarchy _hierarchy;

  final List<RelativePosition> _defaultPreferredPositions;
  RelativePosition _alignmentPosition;

  StreamSubscription _layoutChangeSub;
  StreamSubscription _layoutInternalSub;

  OverlayRef _overlayRef;

  // Needed to implement the PopupHierarchyElement interface.
  @override
  final ElementRef elementRef;

  final String role;
  static final _idGenerator = new SequentialIdGenerator.fromUUID();
  final _uniqueId = _idGenerator.nextId();

  PopupRef _resolvedPopupRef;

  bool _viewInitialized = false;
  bool _isDisposed = false;

  // Used to have a maximum of one timer to wait for CSS animations.
  Timer _animationTimer;
  Completer _onAnimationCompleter;

  // The last known size of the popup content.
  Future<Rectangle> _contentSize;

  // The last known size of the viewport.
  Rectangle _viewportRect;

  // Used to avoid multiple events with the same visibility.
  bool _popupReportsVisible = false;

  // Used to avoid events occurring after detached from the DOM.
  bool _isDestroyed = false;

  // Variables for the requestAnimationFrame reposition loop.
  final bool _useRepositionLoop;
  Rectangle _initialSourceDimensions;
  int _repositionOffsetX = 0;
  int _repositionOffsetY = 0;
  int _repositionLoopId;

  // Variables for [_debounceSetVisibilityFunction].
  Future _setVisibilityCompleted;
  _DebouncedVisibilitySetter _lastVisibilitySetter;

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
  @Input()
  int z = 2;

  /// The CSS transform origin based on configuration.
  String get transformOrigin => _alignmentPosition?.animationOrigin;

  int get zIndex => _zIndex;
  int _zIndex;
  final ZIndexer _zIndexer;

  void _maybeSetZIndex() {
    _zIndex ??= _zIndexer.pop();
  }

  /// Direction of popup scaling.
  String _slide;
  String get slide => _slide;
  @Input()
  set slide(String value) {
    _slide = (value?.isNotEmpty ?? false) ? value : null;
    assert(_slide == null || (slide == 'x' || slide == 'y'));
  }

  /// Optional handler for calculating popup sizes.
  PopupSizeProvider _popupSizeProvider;

  /// Sets a provider for the popup size.
  ///
  /// Overrides the injected PopupSizeProvider.
  @Input()
  set popupSizeProvider(PopupSizeProvider value) {
    _popupSizeProvider = value;
  }

  /// The max height of the popup content provided by the PopupSizeProvider.
  num maxHeight;

  /// The max width of the popup content provided by the PopupSizeProvider.
  num maxWidth;

  /// Whether or not popup should set a minimum width to the width of [source].
  bool _matchMinSourceWidth = false;

  bool get matchMinSourceWidth => _matchMinSourceWidth;

  @override
  set matchMinSourceWidth(bool value) {
    _matchMinSourceWidth = super.matchMinSourceWidth = value;
  }

  /// Sets the background color of the popup to be ink (`$mat-grey-700`).
  @Input('ink')
  bool inkBackground = false;

  /// Whether the popup panel has an enclosing box that wraps the content.
  ///
  /// This gives the panel a shadow and background color. When it's off, no
  /// animation delayed is applied.
  @Input()
  bool hasBox = true;

  MaterialPopupComponent(
      this._domService,
      @Optional() @SkipSelf() this._hierarchy,
      @Optional() @SkipSelf() MaterialPopupComponent parentPopup,
      @Attribute('role') String role,
      this._ngZone,
      this._overlayService,
      this._zIndexer,
      @Inject(defaultPopupPositions) this._defaultPreferredPositions,
      @Inject(overlayRepositionLoop) this._useRepositionLoop,
      @Optional() this._popupSizeProvider,
      this._changeDetector,
      this._viewContainer,
      this.elementRef)
      : this.role = role ?? 'dialog' {
    // Internal event listeners for popup events. Subscriptions are created in
    // the constructor so that the component can respond to these events before
    // external listeners.
    _disposer
      ..addStreamSubscription(onOpen.listen(onPopupOpened))
      ..addStreamSubscription(onClose.listen(onPopupClosed))
      ..addStreamSubscription(onVisible.listen(onVisibleChanged));

    // Close popup if parent closes.
    if (parentPopup != null) {
      parentPopup.onClose.listen((_) => close());
    }

    // Create the PopupRef for the ACX focus library.
    _resolvedPopupRef = new MaterialPopupRef(this);
  }

  @override
  Stream<bool> get contentVisible => _onContentVisible.stream.distinct();

  /// The popup visible hierarchy.
  PopupHierarchy get hierarchy {
    _hierarchy = _hierarchy ?? new PopupHierarchy();
    return _hierarchy;
  }

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
        _changeDetector.markForCheck();
      });
    }
    return completer.future;
  }

  @override
  void ngAfterViewInit() {
    _updateOverlayCssClass();
  }

  void _updateOverlayCssClass() {
    if (_overlayRef == null) return;
    // Copy host CSS classes for integration with Angular CSS shimming.
    var hostClassName = elementRef.nativeElement.className;
    _overlayRef.overlayElement.className += ' $hostClassName';
  }

  @override
  void ngOnDestroy() {
    if (_repositionLoopId != null) {
      window.cancelAnimationFrame(_repositionLoopId);
    }
    _layoutInternalSub?.cancel();
    _layoutChangeSub?.cancel();
    onVisibleController.add(false);
    _disposer.dispose();
    _isDisposed = true;
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
    if (_popupSizeProvider != null && _viewportRect != null) {
      maxHeight = _popupSizeProvider.getMaxHeight(
          _overlayRef.state.top, _viewportRect.height);
      maxWidth = _popupSizeProvider.getMaxWidth(
          _overlayRef.state.left, _viewportRect.width);
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

  void onVisibleChanged(bool newVisibility) {
    _onContentVisible.add(newVisibility);

    // Avoid extraneous events.
    if (_popupReportsVisible == newVisibility) {
      return;
    }

    // If visibility has been flipped on, animate the popup opening.
    _popupReportsVisible = newVisibility;
    if (newVisibility) {
      attachToVisibleHierarchy();
      if (hasBox) {
        _animatePopupOpen();
      } else {
        _noAnimationPopupOpen();
      }
    } else {
      detachFromVisibleHierarchy();
      // Once the popup is closed we want to reset the content width/height.
      // Otherwise when we try to re-open the popup the dimensions won't be
      // read properly by the popup infrastructure.
      _resetContentSize();
    }
  }

  @override
  final PopupState state = new PopupState();

  /// The popup pane ID, which is added to the DOM (as pane-id) for testing.
  @HostBinding('attr.pane-id')
  String get paneId => _overlayRef?.uniqueId;

  /// The unique DOM ID assigned to the popup element.
  String get uniqueId => _uniqueId;

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
        _onOpened.add(null);
      });
    });
  }

  void _noAnimationPopupOpen() {
    showPopup = true;
    _resetContentSize();
    _onOpened.add(null);
  }

  void _nextFrame(void fn()) {
    Timer.run(() {
      if (!_isDestroyed) {
        fn();
      }
    });
  }

  Future onPopupOpened(PopupEvent popupEvent) async {
    // Wait for all listeners to have a chance to either defer or cancel this.
    await popupEvent.onDefer;

    // Initializes the maximum size and content size based on the viewport size
    // before popup position is populated.
    if (_popupSizeProvider != null) {
      _viewportRect =
          new Rectangle(0, 0, window.innerWidth, window.innerHeight);
      contentHeight =
          maxHeight = _popupSizeProvider.getMaxHeight(0, _viewportRect.height);
      contentWidth =
          maxWidth = _popupSizeProvider.getMaxWidth(0, _viewportRect.width);
    }

    // Trigger *deferredContent to create a little early so we can measure it.
    _onContentVisible.add(true);
    _contentSize = popupEvent.size();
    _changeDetector.markForCheck();
  }

  Future onPopupClosed(PopupEvent popupEvent) async {
    if (hasBox) {
      // Wait for all listeners to have a chance to either defer or cancel this
      // event - this is sort of a loose "almost completed". If the event was
      // cancelled, then this will never complete -
      // which is good - we don't want to close the popup anymore.
      popupEvent
          .defer(popupEvent.onDefer.then(((_) => _afterAnimationDelay())));
      await popupEvent.onDefer;
    }

    // Start closing the popup if we were not cancelled.
    //
    // This probably has faulty logic if you defer and then cancel at a later
    // time but since this is probably an extreme edge case it is fine for now.
    if (!popupEvent.cancelled) {
      _contentSize = popupEvent.size();
      showPopup = false;
      // Delay removing deferred content until the popup has finished animating.
      if (hasBox) {
        _afterAnimationDelay().then((_) {
          // Only remove content if the popup is still not showing after delay.
          // User may have quickly opened the popup again.
          if (showPopup == false) _onContentVisible.add(false);
        });
      } else {
        _onContentVisible.add(false);
      }
      _changeDetector.markForCheck();
      return _animateContentSize();
    }
  }

  @ViewChild('template')
  TemplateRef templateRef;

  void _initView() {
    assert(_viewInitialized == false);

    _overlayRef = _overlayService.createOverlayRefSync();
    _disposer.addFunction(_overlayRef.dispose);
    var view = _viewContainer.createEmbeddedView(templateRef);
    view.rootNodes.forEach(_overlayRef.overlayElement.append);
    _updateOverlayCssClass();
    _viewInitialized = true;
  }

  @override
  set visible(bool visible) {
    if (visible) {
      // If visibility is immediately true, we need to create the view before
      // opening the popup.
      if (!_viewInitialized) _initView();
      _open();
    } else if (_viewInitialized) {
      _close();
    }
  }

  bool get isVisible => _popupReportsVisible;

  @override
  void toggle() {
    visible = !isVisible;
  }

  @override
  void open() {
    visible = true;
  }

  @override
  void close() {
    visible = false;
  }

  @override
  Element get container => _overlayRef.overlayElement;

  @override
  set source(PopupSource source) {
    super.source = source;

    // Set the popup ID on the source for ARIA attributes.
    source.popupId = uniqueId;

    // This component supports direct control over the [PopupRef] by way
    // of the Toggle library. Here, we register the [PopupRef] as a
    // [Toggleable] iff [source] uses the library.
    if (source is Toggler) {
      (source as Toggler).toggleable = new _DeferredToggleable(this);
    }
  }

  @override
  List<Element> get autoDismissBlockers {
    // If the popup source is based on an element, exclude the source element
    // from the auto dismiss logic, i.e. clicking on the source element does
    // not trigger auto dismiss.
    var sourceElement = state.source is ElementPopupSource
        ? (state.source as ElementPopupSource).sourceElement
        : null;
    return sourceElement?.nativeElement != null
        ? <Element>[sourceElement.nativeElement]
        : <Element>[];
  }

  // TODO(google): Move dismiss logic to PopupRef once old component removed
  @override
  void onDismiss() {
    // Wait until the VM turn to allow capture logic on other places on the UI
    // to act (e.g. close or hide the popup via something like a button).
    _domService.nextFrame.then((_) {
      // Re-enter Angular if we are closing the popup.
      if (isVisible) {
        _ngZone.run(_close);
      }
    });
  }

  Future _open() => _debounceSetVisibilityFunction(() async {
        _maybeSetZIndex();
        if (!_viewInitialized) {
          throw new StateError('No content is attached.');
        } else if (state.source == null) {
          throw new StateError('Cannot open popup: no source set.');
        }

        if (isVisible) return;

        final eventController = new AsyncActionController<Rectangle>();
        // Create an event, and give listeners a chance to cancel it.
        final event = new AsyncPopupEvent<Rectangle<num>>.open(
            eventController.action, _resolvedPopupRef, () {
          return _overlayRef.measureSizeChanges().first;
        });

        onOpenController.add(event);
        eventController.execute(_onPopupOpened, onCancel: () {
          // Revert the visible property back to false.
          onVisibleController.add(false);
        });
        await eventController.action.onDone;
      });

  Future<Rectangle> _onPopupOpened() async {
    // Put the overlay in the live DOM so we can measure its size.
    _overlayRef.state.visibility = Visibility.Hidden;

    // Start listening to both the popup and the source's layout.
    var initialData = new Completer<Rectangle>();
    var popupContentsLayoutStream =
        _overlayRef.measureSizeChanges().asBroadcastStream(onCancel: (sub) {
      _layoutInternalSub = sub;
    });
    var popupSourceLayoutStream = state.source.onDimensionsChanged(
        track: state.trackLayoutChanges && !_useRepositionLoop);
    if (!state.trackLayoutChanges || _useRepositionLoop) {
      popupContentsLayoutStream = popupContentsLayoutStream.take(1);
    }

    // Merge the results of both streams.
    var mergedLayoutStream =
        _mergeStreams([popupContentsLayoutStream, popupSourceLayoutStream]);
    _layoutChangeSub = mergedLayoutStream.listen((layoutRects) {
      // Ignore partial results.
      if (layoutRects.every((r) => r != null)) {
        if (!initialData.isCompleted) {
          onVisibleController.add(true);
          initialData.complete(layoutRects[0]);
          if (state.trackLayoutChanges && _useRepositionLoop) {
            _startRepositionLoop();
          }
        }
        _schedulePositionUpdate(layoutRects[0], layoutRects[1]);
      }
    });
    return initialData.future;
  }

  Future _close() => _debounceSetVisibilityFunction(() async {
        if (!isVisible) return;

        final eventController = new AsyncActionController<bool>();

        // Create an event, and give listeners a chance to cancel it.
        final event = new AsyncPopupEvent<bool>.close(eventController.action,
            _resolvedPopupRef, () => _overlayRef.measureSizeChanges().first);

        _layoutInternalSub?.cancel();
        _layoutChangeSub?.cancel();

        if (_repositionLoopId != null) {
          _stopRepositionLoop();
        }

        onCloseController.add(event);

        // Wait until the event could have been cancelled.
        eventController.execute(_onPopupClosed, onCancel: () {
          // Revert the visible property back to true.
          onVisibleController.add(true);
        });
        await eventController.action.onDone;
      });

  bool _onPopupClosed() {
    // Update the visibility.
    _overlayRef.state.visibility = Visibility.None;

    // Update the stream if there are listeners.
    onVisibleController.add(false);

    return true;
  }

  Rectangle get _sourceDimensions {
    var sourceDimensions = state.source?.dimensions;
    if (sourceDimensions == null) return null;
    var containerRect = _overlayRef.containerElement?.getBoundingClientRect();
    if (containerRect == null) return null;
    return new Rectangle(
        (sourceDimensions.left - containerRect.left).round(),
        (sourceDimensions.top - containerRect.top).round(),
        sourceDimensions.width.round(),
        sourceDimensions.height.round());
  }

  void _startRepositionLoop() {
    _ngZone.runOutsideAngular(() {
      _initialSourceDimensions = _sourceDimensions;
      _repositionLoopId = window.requestAnimationFrame(_reposition);
    });
  }

  void _stopRepositionLoop() {
    window.cancelAnimationFrame(_repositionLoopId);
    _repositionLoopId = null;

    if (_repositionOffsetX != 0 || _repositionOffsetY != 0) {
      // Prevent later overlay state changes from resetting the reposition
      // transform.
      _overlayRef.state
        ..left += _repositionOffsetX
        ..top += _repositionOffsetY;
      _repositionOffsetX = _repositionOffsetY = 0;
    }
  }

  void _reposition(_) {
    _repositionLoopId = window.requestAnimationFrame(_reposition);
    var sourceDimensions = _sourceDimensions;
    if (sourceDimensions == null) return;

    int newOffsetX =
        (sourceDimensions.left - _initialSourceDimensions.left).round();
    int newOffsetY =
        (sourceDimensions.top - _initialSourceDimensions.top).round();
    int scrollShiftX = newOffsetX - _repositionOffsetX;
    int scrollShiftY = newOffsetY - _repositionOffsetY;
    _repositionOffsetX = newOffsetX;
    _repositionOffsetY = newOffsetY;

    if (state.enforceSpaceConstraints) {
      // If necessary, move the popup to fit within the viewport.
      _viewportRect ??=
          new Rectangle(0, 0, window.innerWidth, window.innerHeight);
      var popupRect = _overlayRef.overlayElement.getBoundingClientRect();
      popupRect =
          _shiftRectangle(popupRect, left: scrollShiftX, top: scrollShiftY);
      var viewportShift = _shiftRectangleToFitWithin(popupRect, _viewportRect);
      _repositionOffsetX += viewportShift.left;
      _repositionOffsetY += viewportShift.top;
    }

    _overlayRef.overlayElement.style.transform =
        'translate(${_repositionOffsetX}px, ${_repositionOffsetY}px)';
  }

  Future _debounceSetVisibilityFunction(
      _DebouncedVisibilitySetter visibilitySetter) async {
    _lastVisibilitySetter = visibilitySetter;
    if (_setVisibilityCompleted != null) await _setVisibilityCompleted;
    if (visibilitySetter != _lastVisibilitySetter) return;

    final setVisibilityCompleter = new Completer();
    _setVisibilityCompleted = setVisibilityCompleter.future;
    try {
      await visibilitySetter();
    } finally {
      _setVisibilityCompleted = null;
      setVisibilityCompleter.complete();
    }
  }

  Iterable get _preferredPositions {
    return _flatten(state.preferredPositions).isNotEmpty
        ? state.preferredPositions
        : _defaultPreferredPositions;
  }

  /// Returns the best possible alignment from preferred positions.
  RelativePosition _getBestPosition(
      Rectangle contentRect, Rectangle sourceRect, Rectangle viewportRect) {
    // This should only be used when space constraints is enforced.
    assert(state.enforceSpaceConstraints);

    // ViewportRect kind of conflates the screen and the container together, so
    // let's pull it apart some. The top-left of the rectangle is actually how
    // much the container is offset from the screen.
    //
    // E.g. if the user has a 1024x768 screen, and has scrolled down 500px, then
    // viewportRect is (0, -500) 1024x768.
    //
    // Hopefully this'll make things easier to understand.
    var screenSize = new _Size.fromRect(viewportRect);
    var containerOffset = viewportRect.topLeft;

    // Determine best fit.
    final positions = _flatten(_preferredPositions);
    var bestPosition = positions.first;
    var bestUnscrollableOverflow = double.INFINITY;
    var bestHorizOverflow = double.INFINITY;
    var bestVertOverflow = double.INFINITY;

    bool better(unscrollableOverflow, horizOverflow, vertOverflow) {
      if (unscrollableOverflow < bestUnscrollableOverflow) return true;
      if (unscrollableOverflow > bestUnscrollableOverflow) return false;
      // If we reach here, unscrollable overflow was the same.
      if (horizOverflow < bestHorizOverflow) return true;
      if (horizOverflow > bestHorizOverflow) return false;
      // If we reach here, horiz overflow was the same.
      return vertOverflow < bestVertOverflow;
    }

    // Also keep track of which positions we've already tried. (If people are
    // just stitching together premade sets of positions, there will probably be
    // some overlap between those sets.
    final tried = new Set();

    for (var position in positions) {
      if (state.source.isRtl == true) {
        position = position.flipRelativePosition();
      }

      if (!tried.add(position)) continue;

      // Build up a tentative position for the popup. These numbers are all
      // relative to the container div.
      var containerPos = new Rectangle(
          position.originX.calcLeft(sourceRect, contentRect) as num,
          position.originY.calcTop(sourceRect, contentRect) as num,
          contentRect.width,
          contentRect.height);
      // Now translate that into screen space.
      var screenPos = new Rectangle.fromPoints(
          containerPos.topLeft + containerOffset,
          containerPos.bottomRight + containerOffset);

      // Now we want to check to see how much the popup overflows off the
      // screen. This happens in screen space.
      var screenLeftOverflow = max(-screenPos.left, 0);
      var screenRightOverflow = max(screenPos.right - screenSize.width, 0);
      var screenTopOverflow = max(-screenPos.top, 0);
      var screenBottomOverflow = max(screenPos.bottom - screenSize.height, 0);

      var horizOverflow = screenLeftOverflow + screenRightOverflow;
      var vertOverflow = screenTopOverflow + screenBottomOverflow;

      // BUT! If a position that overflows less does it by going off the top or
      // left of the page, then that's not great, because we can't scroll to see
      // the rest of it. In that case we should prefer the one that overflows a
      // lot to the bottom or right, because then we can at least scroll to see
      // the rest.
      //
      // To check for this, we need to check coordinates in *document space*,
      // not in screen space. We'll use the container as an approximation for
      // that.
      var documentLeftOverflow = max(-containerPos.left, 0);
      var documentTopOverflow = max(-containerPos.top, 0);

      var unscrollableOverflow = documentLeftOverflow + documentTopOverflow;

      // If there's no overflow, we fit on screen -- just use this position
      if (unscrollableOverflow == 0 &&
          horizOverflow == 0 &&
          vertOverflow == 0) {
        return position;
      }

      // Otherwise try to minimize unscrollable overflow, then horiz overflow,
      // then vert overflow.
      if (better(unscrollableOverflow, horizOverflow, vertOverflow)) {
        bestPosition = position;
        bestUnscrollableOverflow = unscrollableOverflow;
        bestHorizOverflow = horizOverflow;
        bestVertOverflow = vertOverflow;
      }
    }

    return bestPosition;
  }

  /// Schedule an update on [state]'s position.
  ///
  /// Requires the [contentClientRect] and [sourceClientRect].
  ///
  /// Returns a future that completes when the state change is submitted.
  Future _schedulePositionUpdate(
      Rectangle<num> contentClientRect, Rectangle<num> sourceClientRect) async {
    RelativePosition position;

    var viewportRect = await _overlayService.measureContainer();
    final isRtl = state.source.isRtl == true;

    // Must be set first so contentSizeFuture is correct.
    _overlayRef.state.width = null;
    if (state.matchMinSourceWidth) {
      _overlayRef.state.minWidth = sourceClientRect.width;
    }

    // Immediately update contentClientRect width (if applicable) since
    // _overlayRef.state.width/_overlay.state.minWidth updates are applied
    // asynchronously, and are thus not accounted for in the position
    // calculations.
    if (state.matchMinSourceWidth) {
      contentClientRect = _resizeRectangle(contentClientRect,
          width: max(sourceClientRect.width, contentClientRect.width));
    }

    if (state.enforceSpaceConstraints) {
      // Instead of using user-provided positioning, try to determine what
      // would be the best positioning given the viewport bounds and the size
      // of the content being popped-up.
      position =
          _getBestPosition(contentClientRect, sourceClientRect, viewportRect);
    }
    if (position == null) {
      position = new RelativePosition(
          originX: state.source.alignOriginX,
          originY: state.source.alignOriginY);
      if (isRtl) {
        position = position.flipRelativePosition();
      }
    }
    // Find the size of the content, and move the overlay as an offset based
    // on the calculated position.
    final offsetX = isRtl
        ? viewportRect.left - state.offsetX
        : state.offsetX - viewportRect.left;
    final offsetY = state.offsetY - viewportRect.top;
    _overlayRef.state
      ..left = position.originX.calcLeft(sourceClientRect, contentClientRect) +
          offsetX
      ..top = position.originY.calcTop(sourceClientRect, contentClientRect) +
          offsetY
      ..visibility = Visibility.Visible;

    _alignmentPosition = position;
  }
}

@Injectable()
PopupHierarchy getHierarchy(MaterialPopupComponent c) => c.hierarchy;

@Injectable()
PopupRef getResolvedPopupRef(MaterialPopupComponent c) => c._resolvedPopupRef;

@visibleForTesting
class MaterialPopupRef implements PopupRef {
  final MaterialPopupComponent _popupComponent;

  MaterialPopupRef(this._popupComponent);

  @override
  bool get isVisible => _popupComponent.isVisible;

  @override
  Stream<bool> get onVisibleChanged => _popupComponent.onVisible;
}

class _DeferredToggleable extends Toggleable {
  final MaterialPopupComponent _popupComponent;

  _DeferredToggleable(this._popupComponent);

  @override
  bool get isOn => _popupComponent.isVisible;

  @override
  set isOn(bool state) {
    _popupComponent.visible = state;
  }
}

// Sort of the effective counterpart to Futures.wait.
//
// Returns a Stream of responses based on responses from all streams given,
// which may be `null` if no response was received from a stream.
//
// TODO(google): This belongs as a utility not inlined here.
Stream<List<T>> _mergeStreams<T>(List<Stream<T>> streams) {
  var streamSubscriptions = new List<StreamSubscription<T>>(streams.length);
  var cachedResults = new List<T>(streams.length);
  StreamController<List<T>> streamController;
  streamController = new StreamController<List<T>>.broadcast(
      sync: true,
      onListen: () {
        var i = 0;
        streams.forEach((stream) {
          var n = i++;
          streamSubscriptions[n] = stream.listen((result) {
            cachedResults[n] = result;
            streamController.add(cachedResults);
          });
        });
      },
      onCancel: () {
        for (var sub in streamSubscriptions) {
          sub.cancel();
        }
      });
  return streamController.stream;
}

/// Recursively flattens an arbitrarily-nested iterable.
//
// TODO(google): This belongs as a utility not inlined here.
Iterable _flatten(Iterable nested) sync* {
  for (var item in nested) {
    if (item is Iterable) {
      yield* _flatten(item);
    } else {
      yield item;
    }
  }
}

Rectangle _resizeRectangle(Rectangle rect, {num width, num height}) =>
    new Rectangle(
        rect.left, rect.top, width ?? rect.width, height ?? rect.height);

Rectangle _shiftRectangle(Rectangle rect, {num top: 0, num left: 0}) =>
    new Rectangle(rect.left + left, rect.top + top, rect.width, rect.height);

/// Returns a transformation which, when applied to [rect], will cause [rect] to
/// be entirely within [container].
///
/// Currently only handles translation, not scale.
Rectangle _shiftRectangleToFitWithin(Rectangle rect, Rectangle container) {
  num x = 0;
  num y = 0;
  if (rect.left < container.left) {
    x = container.left - rect.left;
  } else if (rect.right > container.right) {
    x = container.right - rect.right;
  }
  if (rect.top < container.top) {
    y = container.top - rect.top;
  } else if (rect.bottom > container.bottom) {
    y = container.bottom - rect.bottom;
  }
  return new Rectangle(x.round(), y.round(), 0, 0);
}

/// The size of something.
///
/// Like a [Rectangle], except without a position. Since all these positions are
/// relative to different things (screen space, container space, etc.), it's
/// easier to clearly call out when we care about position vs. when we don't.
class _Size {
  final num width;
  final num height;
  _Size(this.width, this.height);
  _Size.fromRect(Rectangle r) : this(r.width, r.height);
}
