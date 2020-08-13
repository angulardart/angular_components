// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/focus/focus_interface.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/enums/visibility.dart'
    as visibility;
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/laminate/overlay/overlay.dart';
import 'package:angular_components/laminate/overlay/zindexer.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/math/box.dart';
import 'package:angular_components/model/ui/toggle.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';
import 'package:angular_components/utils/disposer/disposer.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

export 'package:angular_components/laminate/popup/popup.dart'
    show PopupSourceDirective;

/// A popup component with material design look-and-feel.
///
/// Caveats:
/// - Popups closing and opening are automatically delayed to add animations
/// - Take advantage of enforceSpaceConstraints defined in
/// [PopupInterface].
///
/// This is useful if content size is such that adds scroll to the page.
/// - If the contents change and need to readjust position use
///  [trackLayoutChanges] which is also defined in [PopupInterface].
///
/// Material popup also supports deferred/lazy-loaded content.
///
/// This component publishes itself as a [DropdownHandle], so its children may
/// control its visibility by injecting it:
///
/// ``` Dart
/// class MyComponent {
///   final DropdownHandle _dropdownHandle;
///
///   MyComponent(this._dropdownHandle);
///
///   void onSomethingThatShouldCloseTheDropdown() {
///     _dropdownHandle.close();
///   }
/// }
/// ```
@Component(
  selector: 'material-popup',
  providers: [
    ExistingProvider(DeferredContentAware, MaterialPopupComponent),
    ExistingProvider(DropdownHandle, MaterialPopupComponent),
    FactoryProvider(PopupHierarchy, getHierarchy),
    FactoryProvider(PopupRef, getResolvedPopupRef),
  ],
  templateUrl: 'material_popup.html',
  styleUrls: ['material_popup.scss.css'],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
  visibility: Visibility.all, // injected by hierarchy
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialPopupComponent extends Object
    with PopupBase, PopupEvents, PopupHierarchyElement
    implements
        PopupInterface,
        DeferredContentAware,
        AfterViewInit,
        OnDestroy,
        DropdownHandle {
  static const Duration SLIDE_DELAY = Duration(milliseconds: 150);

  /// Stream on which an event is fired after the popup has finished opening.
  @Output('opened')
  Stream<void> get onOpened => _onOpened.stream;
  final StreamController<void> _onOpened =
      StreamController<void>.broadcast(sync: true);

  final StreamController<bool> _onContentVisible =
      StreamController<bool>.broadcast(sync: true);

  /// Stream on which an event is fired when the popup is auto dismissed.
  /// Output event should be either a [FocusEvent] or a [MouseEvent].
  @Output('autoDismissed')
  Stream<Event> get onAutoDismissed => _onAutoDismissed.stream;
  final StreamController<Event> _onAutoDismissed =
      StreamController<Event>.broadcast(sync: true);

  final ChangeDetectorRef _changeDetector;
  final ViewContainerRef _viewContainer;
  final Disposer _disposer = Disposer.oneShot();
  final Disposer _visibleDisposer = Disposer.multi();
  final NgZone _ngZone;
  final OverlayService _overlayService;
  final DomService _domService;
  PopupHierarchy _hierarchy;

  final List<RelativePosition> _defaultPreferredPositions;
  RelativePosition _alignmentPosition;

  OverlayRef _overlayRef;

  // Needed to implement the PopupHierarchyElement interface.
  @override
  final ElementRef elementRef;

  final String role;
  static final _idGenerator = SequentialIdGenerator.fromUUID();
  final _uniqueId = _idGenerator.nextId();

  PopupRef _resolvedPopupRef;

  bool _viewInitialized = false;

  // Used to have a maximum of one timer to wait for CSS animations.
  Timer _animationTimer;

  // The last known size of the viewport.
  //
  // The top/left of this [Rectangle] is always (0, 0). A Rectangle returned by
  // getBoundingClientRect() will be positioned relative to this point (i.e.
  // will be in the viewport vector space).
  final MutableRectangle _viewportRect = MutableRectangle(0, 0, 0, 0);

  // The top/bottom/left/right boundaries for the popup within the viewport
  // rect.
  final Box _viewportBoundaries;

  // The window.resize event is throttled because it can occur at a high
  // frequency (> 20 times per second).
  static const _resizeThrottleDuration = Duration(milliseconds: 100);

  // Whether the popup is in the process of opening (or has finished opening).
  //
  // If true, then the popup is in the process of opening, or is already open.
  // This means that [_open] has already been called, and subsequent calls to
  // [_open] should be a no-op.
  //
  // If false, then the popup is in the process of closing, or is already
  // closed. This means that [_close] has already been called, and subsequent
  // calls to [_close] should be a no-op.
  bool _isOpening = false;

  // Variables for the requestAnimationFrame reposition loop.
  final bool _useRepositionLoop;
  Rectangle _initialSourceDimensions;
  int _repositionOffsetX = 0;
  int _repositionOffsetY = 0;
  int _repositionLoopId;
  List<Element> _autoDismissBlockers = [];

  @override
  bool get autoDismiss => state.autoDismiss;

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

  /// Direction of popup scaling.
  String _slide;

  String get slide => _slide;

  /// Direction of popup scaling.
  ///
  /// Valid values are `x`, `y`, or `null`.
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

  /// The min height of the popup content provided by the PopupSizeProvider.
  num minHeight;

  /// The min width of the popup content provided by the PopupSizeProvider.
  num minWidth;

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

  /// Page elements that do not auto-dismiss the popup in addition to the popup
  /// up source element.
  @Input()
  set autoDismissBlockers(List<Element> elements) {
    _autoDismissBlockers = elements;
  }

  /// The label to be used for assistive technologies.
  ///
  /// If [role] is "dialog" and this is set, screenreaders will read this label
  /// when focus first enters the popup.
  @Input()
  String ariaLabel;

  MaterialPopupComponent(
      @Optional() @SkipSelf() this._hierarchy,
      @Optional() @SkipSelf() MaterialPopupComponent parentPopup,
      @Attribute('role') String role,
      this._ngZone,
      this._overlayService,
      this._domService,
      this._zIndexer,
      @Inject(defaultPopupPositions) this._defaultPreferredPositions,
      @Inject(overlayRepositionLoop) this._useRepositionLoop,
      @Inject(overlayViewportBoundaries) this._viewportBoundaries,
      @Optional() this._popupSizeProvider,
      this._changeDetector,
      this._viewContainer,
      this.elementRef)
      : this.role = role ?? 'dialog' {
    // Close popup if parent closes.
    if (parentPopup != null) {
      _disposer
          .addStreamSubscription(parentPopup.onClose.listen((_) => close()));
    }

    // Create the PopupRef for the ACX focus library.
    _resolvedPopupRef = MaterialPopupRef(this);
  }

  @override
  Stream<bool> get contentVisible => _onContentVisible.stream.distinct();

  /// The popup visible hierarchy.
  PopupHierarchy get hierarchy {
    _hierarchy = _hierarchy ?? PopupHierarchy();
    return _hierarchy;
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
    _visibleDisposer.dispose();
    _disposer.dispose();
    _animationTimer?.cancel();
    _isVisible = false;
    onVisibleController.add(false);
  }

  @override
  final PopupState state = PopupState();

  /// The popup pane ID, which is added to the DOM (as pane-id) for testing.
  @HostBinding('attr.pane-id')
  String get paneId => _overlayRef?.uniqueId;

  /// The unique DOM ID assigned to the popup element.
  String get uniqueId => _uniqueId;

  @ViewChild('template')
  TemplateRef templateRef;

  void _initView() {
    assert(_viewInitialized == false);

    _overlayRef = _overlayService.createOverlayRefSync();
    _disposer.addFunction(_overlayRef.dispose);
    _zIndex = _zIndexer.pop();
    var view = _viewContainer.createEmbeddedView(templateRef);
    for (var node in view.rootNodes) {
      _overlayRef.overlayElement.append(node);
    }
    _updateOverlayCssClass();
    _viewInitialized = true;
  }

  @override
  set visible(bool visible) {
    if (visible) {
      // If visibility is immediately true, we need to create the view and wait
      // for other Angular @Inputs to be processed before opening the popup.
      if (!_viewInitialized) {
        _initView();
        scheduleMicrotask(_open);
      } else {
        _open();
      }
    } else if (_viewInitialized) {
      _close();
    }
  }

  bool get isVisible => _isVisible;
  bool _isVisible = false;

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
  Element get container => _overlayRef?.overlayElement;

  @override
  set source(PopupSource source) {
    super.source = source;

    // Set the popup ID on the source for ARIA attributes.
    source.popupId = uniqueId;

    // This component supports direct control over the [PopupRef] by way
    // of the Toggle library. Here, we register the [PopupRef] as a
    // [Toggleable] iff [source] uses the library.
    if (source is Toggler) {
      (source as Toggler).toggleable = _DeferredToggleable(this);
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
    return sourceElement != null
        ? (_autoDismissBlockers.toList()..add(sourceElement))
        : _autoDismissBlockers.toList();
  }

  @override
  void onDismiss() {
    close();
  }

  @override
  void onAutoDismiss(Event event) {
    close();
    _onAutoDismissed.add(event);
  }

  /// Open the popup.
  ///
  /// Returns a [Future] which resolves once the popup has started opening.
  Future _open() {
    // Avoid duplicate events.
    if (_isOpening) return Future.value();
    _isOpening = true;

    // Cancel pending animation timer callback if it exists.
    _animationTimer?.cancel();

    // Notify listeners that the popup is being opened.
    onOpenController.add(null);

    // If the event was cancelled, exit early.
    if (!_isOpening) return Future.value();

    if (!_viewInitialized) {
      throw StateError('No content is attached.');
    } else if (state.source == null) {
      throw StateError('Cannot open popup: no source set.');
    }

    // Update the viewport size.
    _updateViewportSize();
    // Initialize the minimum/maximum size and content size based on the
    // viewport size before popup position is populated.
    _updatePopupMinMaxSize();

    _visibleDisposer.addStreamSubscription(window.onResize
        .transform(throttleStream(_resizeThrottleDuration, guaranteeLast: true))
        .listen((_) {
      _updateViewportSize();
      _updatePopupMinMaxSize();
    }));

    // Put the overlay in the live DOM so we can measure its size.
    _overlayRef.state.visibility = visibility.Visibility.Hidden;
    _overlayRef.overlayElement.style
      ..display = ''
      ..visibility = 'hidden';

    // Trigger *deferredContent.
    _onContentVisible.add(true);
    _changeDetector.markForCheck();

    // Start listening to both the popup and the source's layout.
    var initialData = Completer<Rectangle>();
    var popupContentsLayoutStream = _overlayRef
        .measureSizeChanges()
        .asBroadcastStream(onListen: _visibleDisposer.addStreamSubscription);
    var popupSourceLayoutStream =
        state.source.onDimensionsChanged(track: state.trackLayoutChanges);
    if (!state.trackLayoutChanges) {
      popupContentsLayoutStream = popupContentsLayoutStream.take(1);
    }

    // Merge the results of both streams.
    var mergedLayoutStream =
        _mergeStreams([popupContentsLayoutStream, popupSourceLayoutStream]);
    _visibleDisposer
        .addStreamSubscription(mergedLayoutStream.listen((layoutRects) {
      // Ignore partial results.
      if (layoutRects.every((r) => r != null)) {
        if (!initialData.isCompleted) {
          _onPopupOpened();
          initialData.complete(null);
        }
        _initialSourceDimensions = null;
        _schedulePositionUpdate(layoutRects[0], layoutRects[1]);
      }
    }));

    // Resolve when the popup has started opening.
    return initialData.future;
  }

  // Callback triggered when the popup has started opening.
  void _onPopupOpened() {
    // Double-check that the popup should still be opened.
    //
    // This is necessary because there is an async gap between [_open()] and
    // [_onPopupOpened()].
    if (!_isOpening) return;

    // Start the opening animation.
    showPopup = true;
    _changeDetector.markForCheck();

    // Start the reposition loop (if enabled).
    if (state.trackLayoutChanges && _useRepositionLoop) {
      _startRepositionLoop();
    }

    // Start listening to autodismiss triggers.
    attachToVisibleHierarchy();

    // Tell the source that it is open.
    state.source.onOpen();

    if (hasBox) {
      // If animating, wait until the animation has finished before notifying
      // listeners.
      _animationTimer = Timer(SLIDE_DELAY, () {
        // No need to check whether the popup has been closed in the meantime,
        // since this callback will not fire in that case (clearTimeout).
        _animationTimer = null;
        _isVisible = true;
        onVisibleController.add(true);
        _onOpened.add(null);
      });
    } else {
      // No animation, but still need to wait for *deferredContent to render.
      Timer.run(() {
        if (!_isOpening) return;
        _isVisible = true;
        onVisibleController.add(true);
        _onOpened.add(null);
      });
    }
  }

  /// Close the popup.
  void _close() {
    // Avoid duplicate events.
    if (!_isOpening) return;
    _isOpening = false;

    // Cancel pending animation timer callback if it exists.
    _animationTimer?.cancel();

    // Notify listeners that the popup is being closed.
    onCloseController.add(null);

    // If the event was cancelled, exit early.
    if (_isOpening) return;

    // Stop listening to popup layout changes.
    _visibleDisposer.dispose();

    // Stop the reposition loop (if it's running).
    if (_repositionLoopId != null) {
      _stopRepositionLoop();
    }

    // If the focus is inside of popup when the popup closes, restore focus on
    // the popup source element instead of some seemingly random DOM location.
    // TODO(google): removed the islastTriggerWithKeyboard to better support
    // mouse/keyboard mixed interactions.
    if (state.source is Focusable && hierarchy.islastTriggerWithKeyboard) {
      _domService.scheduleWrite(() {
        if (_overlayRef.overlayElement
            .contains(window.document.activeElement)) {
          (state.source as Focusable).focus();
        }
      });
    }

    // Stop listening to autodismiss triggers.
    detachFromVisibleHierarchy();

    // Start the closing animation.
    showPopup = false;
    _changeDetector.markForCheck();

    // Tell the source that it is closed.
    state.source.onClose();

    if (hasBox) {
      // If animating, wait until the animation has finished before removing
      // popup contents.
      _animationTimer = Timer(SLIDE_DELAY, () {
        // No need to check whether the popup has been opened in the meantime,
        // since this callback will not fire in that case (clearTimeout).
        _animationTimer = null;
        _onPopupClosed();
      });
    } else {
      // No animation; remove popup contents immediately.
      _onPopupClosed();
    }
  }

  // Callback triggered when the popup has finished closing.
  void _onPopupClosed() {
    // Hide the deferred content.
    _onContentVisible.add(false);
    _changeDetector.markForCheck();

    // Set the overlay .pane to display: none.
    _overlayRef.state.visibility = visibility.Visibility.None;
    _overlayRef.overlayElement.style.display = 'none';

    // Notify listeners that the popup is not visible.
    _isVisible = false;
    onVisibleController.add(false);
  }

  Rectangle get _sourceDimensions {
    var sourceDimensions = state.source?.dimensions;
    if (sourceDimensions == null) return null;
    var containerRect = _overlayRef.containerElement?.getBoundingClientRect();
    if (containerRect == null) return null;
    return Rectangle(
        (sourceDimensions.left - containerRect.left).round(),
        (sourceDimensions.top - containerRect.top).round(),
        sourceDimensions.width.round(),
        sourceDimensions.height.round());
  }

  void _startRepositionLoop() {
    _ngZone.runOutsideAngular(() {
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
    _initialSourceDimensions ??= sourceDimensions;

    int newOffsetX =
        (sourceDimensions.left - _initialSourceDimensions.left).round();
    int newOffsetY =
        (sourceDimensions.top - _initialSourceDimensions.top).round();
    int scrollShiftX = newOffsetX - _repositionOffsetX;
    int scrollShiftY = newOffsetY - _repositionOffsetY;
    _repositionOffsetX = newOffsetX;
    _repositionOffsetY = newOffsetY;

    if (state.constrainToViewport) {
      // If necessary, move the popup to fit within the viewport.
      var popupRect = _overlayRef.overlayElement.getBoundingClientRect();
      popupRect =
          _shiftRectangle(popupRect, left: scrollShiftX, top: scrollShiftY);
      var boundedViewportRect =
          _boundRectangle(_viewportRect, _viewportBoundaries);
      var viewportShift =
          _shiftRectangleToFitWithin(popupRect, boundedViewportRect);
      _repositionOffsetX += viewportShift.left;
      _repositionOffsetY += viewportShift.top;
    }

    _overlayRef.overlayElement.style.transform =
        'translate(${_repositionOffsetX}px, ${_repositionOffsetY}px)';
  }

  void _updateViewportSize() {
    _viewportRect.width = window.innerWidth;
    _viewportRect.height = window.innerHeight;
  }

  void _updatePopupMinMaxSize() {
    if (_popupSizeProvider == null) return;
    var boundedViewportRect =
        _boundRectangle(_viewportRect, _viewportBoundaries);
    minHeight = _popupSizeProvider.getMinHeight(
        _overlayRef.state.top ?? 0, boundedViewportRect.height);
    minWidth = _popupSizeProvider.getMinWidth(
        _overlayRef.state.left ?? 0, boundedViewportRect.width);
    maxHeight = _popupSizeProvider.getMaxHeight(
        _overlayRef.state.top ?? 0, boundedViewportRect.height);
    maxWidth = _popupSizeProvider.getMaxWidth(
        _overlayRef.state.left ?? 0, boundedViewportRect.width);
  }

  Iterable get _preferredPositions {
    return _flatten(state.preferredPositions).isNotEmpty
        ? state.preferredPositions
        : _defaultPreferredPositions;
  }

  /// Returns the best possible alignment from preferred positions.
  RelativePosition _getBestPosition(
      Rectangle contentRect, Rectangle sourceRect, Rectangle containerRect) {
    // This should only be used when space constraints is enforced.
    assert(state.enforceSpaceConstraints);

    // ContainerRect kind of conflates the screen and the container together, so
    // let's pull it apart some. The top-left of the rectangle is actually how
    // much the container is offset from the screen.
    //
    // E.g. if the user has a 1024x768 screen, and has scrolled down 500px, then
    // containerRect is (0, -500) 1024x768.
    //
    // Hopefully this'll make things easier to understand.
    var containerOffset = containerRect.topLeft;

    // Try each position, and use the one which overlaps most with the viewport.
    var positions = _flatten(_preferredPositions);
    var bestPosition = positions.first;
    var bestOverlap = 0.0;
    for (var position in positions) {
      if (state.source.isRtl == true) {
        position = position.flipRelativePosition();
      }
      // Build up a tentative position for the popup. These numbers are all
      // relative to the container div.
      var containerPos = Rectangle<num>(
          position.originX.calcLeft(sourceRect, contentRect),
          position.originY.calcTop(sourceRect, contentRect),
          contentRect.width,
          contentRect.height);
      // Now translate that into screen space.
      var screenPos = Rectangle<num>.fromPoints(
          containerPos.topLeft + containerOffset,
          containerPos.bottomRight + containerOffset);
      if (_viewportRect.containsRectangle(screenPos)) {
        bestPosition = position;
        break;
      }
      var overlapRect = _viewportRect.intersection(screenPos);
      if (overlapRect == null) continue;
      var overlap = overlapRect.width * overlapRect.height;
      if (overlap > bestOverlap) {
        bestOverlap = overlap;
        bestPosition = position;
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

    var containerRect = await _overlayService.measureContainer();
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
          _getBestPosition(contentClientRect, sourceClientRect, containerRect);
    }
    if (position == null) {
      position = RelativePosition(
          originX: state.source.alignOriginX,
          originY: state.source.alignOriginY);
      if (isRtl) {
        position = position.flipRelativePosition();
      }
    }
    // Find the size of the content, and move the overlay as an offset based
    // on the calculated position.
    final offsetX = isRtl
        ? containerRect.left - state.offsetX
        : state.offsetX - containerRect.left;
    final offsetY = state.offsetY - containerRect.top;
    _overlayRef.state
      ..left = position.originX.calcLeft(sourceClientRect, contentClientRect) +
          offsetX
      ..top = position.originY.calcTop(sourceClientRect, contentClientRect) +
          offsetY
      ..visibility = visibility.Visibility.Visible;
    _overlayRef.overlayElement.style
      ..visibility = 'visible'
      ..display = '';

    _alignmentPosition = position;

    // Update the min and max sizes now that the popup has been positioned.
    _updatePopupMinMaxSize();
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
  var streamSubscriptions = List<StreamSubscription<T>>(streams.length);
  var cachedResults = List<T>(streams.length);
  StreamController<List<T>> streamController;
  streamController = StreamController<List<T>>.broadcast(
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
    Rectangle(rect.left, rect.top, width ?? rect.width, height ?? rect.height);

Rectangle _shiftRectangle(Rectangle rect, {num top = 0, num left = 0}) =>
    Rectangle(rect.left + left, rect.top + top, rect.width, rect.height);

Rectangle _boundRectangle(Rectangle rect, Box boundaries) => Rectangle(
    rect.left + boundaries.left,
    rect.top + boundaries.top,
    rect.width - boundaries.left - boundaries.right,
    rect.height - boundaries.top - boundaries.bottom);

/// Returns a transformation which, when applied to [rect], will cause [rect] to
/// be entirely within [container].
///
/// If [rect] is larger than the container, this function will prefer to keep
/// the top left corner visible.
///
/// Currently only handles translation, not scale.
Rectangle _shiftRectangleToFitWithin(Rectangle rect, Rectangle container) {
  num x = 0;
  num y = 0;
  if (rect.left < container.left) {
    x = container.left - rect.left;
  } else if (rect.right > container.right) {
    x = max(container.right - rect.right, container.left - rect.left);
  }
  if (rect.top < container.top) {
    y = container.top - rect.top;
  } else if (rect.bottom > container.bottom) {
    y = max(container.bottom - rect.bottom, container.top - rect.top);
  }
  return Rectangle(x.round(), y.round(), 0, 0);
}
