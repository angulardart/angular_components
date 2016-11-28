// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_ref;

import 'dart:async';
import 'dart:math';

import '../../../css/acux/zindexer.dart';
import '../../enums/alignment.dart';
import '../../enums/visibility.dart';
import '../../overlay/overlay.dart';
import './popup_event.dart';
import './popup_state.dart';
import '../../portal/portal.dart';
import '../../../model/action/async_action.dart';
import '../../../model/ui/toggle.dart';
import '../../../utils/disposer/disposer.dart';

/// A handle to manipulate an existing popup.
abstract class PopupRef implements PortalHost, Toggleable {
  /// Whether the popup is currently visible.
  ///
  /// **NOTE**: This will not be true until [open] or [close] entirely resolves
  /// and is **not** cancelled. Otherwise, this will not change.
  ///
  /// See [onVisibilityChanged] for a stream of changes.
  bool get isVisible;

  /// Opens the popup.
  ///
  /// Throws [StateError] if there is no content [attach]ed.
  ///
  /// Returns a [Future] that completes if it is opened successfully.
  Future open();

  /// Closes the popup.
  ///
  /// Returns a [Future] that completes if it is closed successfully.
  Future close();

  /// An event stream that fires when a popup is attempted to be [open]ed.
  ///
  /// Listeners have the opportunity to [AsyncAction.cancelIf] or register a
  /// [AsyncAction.defer] to later choose to cancel or not. All listeners must
  /// resolve before [open] will complete.
  Stream<PopupEvent<Rectangle>> get onOpen;

  /// An event stream that fires when a popup is attempted to be [close]d.
  ///
  /// Listeners have the opportunity to [AsyncAction.cancelIf] or register a
  /// [AsyncAction.defer] to later choose to cancel or not. All listeners must
  /// resolve before [close] will complete.
  Stream<PopupEvent<bool>> get onClose;

  /// An event stream that fires when the popup's visibility changes.
  ///
  /// **NOTE**: This will occur **after** [onOpen] and [onClose] have completed
  /// and were not cancelled.
  Stream<bool> get onVisibleChanged;

  /// An event stream that fires when the popup [isVisible] and the size of
  /// interior content changes.
  ///
  /// **NOTE**: Listening to this stream has performance impacts and should
  /// only be used sparingly.
  Stream<Rectangle> get onSizeChanged;

  /// The current state of the popup.
  ///
  /// Changes to the state are applied asynchronously in the next DOM write.
  PopupState get state;

  /// The parent of the popup.
  ///
  /// A popup can only have one parent.
  PopupRef get parentPopup;

  /// Sets [alignX], which is automatically converted into an [Alignment].
  void setAlignX(String alignX);

  /// Sets [alignY], which is automatically converted into an [Alignment].
  void setAlignY(String alignY);

  /// Sets the [state.dismissOnDocumentPressed] property.
  void setAutoDismiss(bool autoDismiss);

  /// Sets [enforceSpaceConstraints].
  ///
  /// Since an Angular setter can be null, null is considered true here.
  void setEnforceSpaceConstraints(bool enforceSpaceConstraints);

  /// Sets [matchSourceWidth].
  ///
  /// Since an Angular setter can be null, null is considered true here.
  void setMatchSourceWidth(bool matchSourceWidth);

  /// Sets the different [preferredPositions] to use when
  /// [setEnforceSpaceConstraints] == `true` is used.
  ///
  /// [preferredPositions] can be an `Iterable<RelativePosition>` or an
  /// `Iterable<Iterable>`.
  ///
  /// Similarly to Angular providers, this supports nested lists of preferred
  /// positions. The popup will flatten out the list of positions and choose the
  /// first one that fits on screen.
  void setPreferredPositions(Iterable preferredPositions);

  /// Sets [visible].
  ///
  /// Since an Angular setter can be null, null is considered false here.
  void setVisible(bool visible);

  /// The unique ID that represents the popup.
  String get uniqueId;

  /// What [RelativePosition] is being used to align this popup.
  RelativePosition get popupAlignment;

  /// A unique z-index for this ref.
  int get zIndex;

  /// The left position of the popup relative to the container viewport.
  num get left;

  /// The top position of the popup relative to the container viewport.
  num get top;
}

/// A function that will return the bounds of the current viewport.
typedef Future<Rectangle> ViewportBoundsGetter();

typedef Future _DebouncedVisibilitySetter();

/// An implementation of [PopupRef].
///
/// Should not be exported publicly.
class PopupRefImpl extends DelegatingPortalHost
    with Toggleable
    implements PopupRef {
  final List<RelativePosition> _defaultPreferredPositions;

  /// The underlying overlay instance.
  final OverlayRef _overlayRef;
  final _disposer = new Disposer.oneShot();
  final ViewportBoundsGetter _viewportBoundsFn;

  @override
  final PopupState state;

  Future _setVisibilityCompleted;
  _DebouncedVisibilitySetter _lastVisibilitySetter;

  @override
  PopupRef parentPopup;

  StreamSubscription _layoutChangeSub;
  StreamSubscription _layoutInternalSub;
  StreamController<PopupEvent<Rectangle>> _onOpenController;
  StreamController<PopupEvent<bool>> _onCloseController;
  StreamController<bool> _onVisibleController;

  bool _isVisible = false;
  RelativePosition _alignmentPosition;

  PopupRefImpl(OverlayRef overlayRef, this._zIndexer,
      {List<RelativePosition> defaultPreferredPositions: const [],
      PopupState state,
      ViewportBoundsGetter viewportFn,
      Future<PopupRef> parent})
      : _defaultPreferredPositions = defaultPreferredPositions,
        _overlayRef = overlayRef,
        _viewportBoundsFn = viewportFn,
        this.state = state ?? new PopupState(),
        super(overlayRef) {
    // Also destroy the overlay.
    _disposer.addFunction(_overlayRef.dispose);

    // Apply initial state.
    applyChanges();

    // Close popup if parent closes.
    if (parent != null) {
      parent.then((popup) {
        this.parentPopup = popup;
        if (popup != null) {
          popup.onClose.listen((_) => close());
        }
      });
    }

    // Listen to additional state changes.
    _disposer.addStreamSubscription(this.state.changes.listen((_) {
      applyChanges();
    }));
  }

  /// Apply [state] to [overlayState].
  void applyChanges() {
    _overlayRef.state
      ..alignX = state.alignContentX
      ..alignY = state.alignContentY;
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
    // TODO(google): Sync with Particle's 'RelativeElementHolder'.
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
      // then vert ovewrflow.
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
    var viewportRect = await _viewportBoundsFn();

    // Must be set first so contentSizeFuture is correct.
    if (state.matchSourceWidth) {
      _overlayRef.state.width = sourceClientRect.width;
    } else {
      _overlayRef.state.width = null;
    }
    if (state.matchMinSourceWidth == true) {
      _overlayRef.state.minWidth = sourceClientRect.width;
    }
    if (state.enforceSpaceConstraints) {
      // Instead of using user-provided positioning, try to determine what
      // would be the best positioning given the viewport bounds and the size
      // of the content being popped-up.
      position =
          _getBestPosition(contentClientRect, sourceClientRect, viewportRect);
      state
        ..alignContentX = position.contentX
        ..alignContentY = position.contentY;
    }
    if (position == null) {
      position = new RelativePosition(
          originX: state.source.alignOriginX,
          originY: state.source.alignOriginY);
    }
    // Find the size of the content, and move the overlay as an offset based
    // on the calculated position.
    _overlayRef.state
      ..left = position.originX.calcLeft(sourceClientRect, contentClientRect) +
          state.offsetX -
          max(viewportRect.left, 0)
      ..top = position.originY.calcTop(sourceClientRect, contentClientRect) +
          state.offsetY -
          max(viewportRect.top, 0)
      ..visibility = Visibility.Visible;

    _alignmentPosition = position;
  }

  @override
  void dispose() {
    _layoutInternalSub?.cancel();
    _layoutChangeSub?.cancel();
    _disposer.dispose();
    _isVisible = false;
  }

  @override
  bool get isVisible => _isVisible;

  @override
  set isOn(bool state) {
    setVisible(state);
  }

  @override
  bool get isOn => isVisible;

  @override
  int get zIndex => _zIndex;
  int _zIndex;
  final ZIndexer _zIndexer;

  void _maybeSetZIndex() {
    _zIndex ??= _zIndexer.pop();
  }

  @override
  num get left => _overlayRef.state.left;

  @override
  num get top => _overlayRef.state.top;

  @override
  Future open() => _debounceSetVisibilityFunction(() async {
        _maybeSetZIndex();
        if (!hasAttached) {
          throw new StateError('No content is attached.');
        } else if (state.source == null) {
          throw new StateError('Cannot open popup: no source set.');
        }

        if (_isVisible) return;

        final eventController = new AsyncActionController<Rectangle>();
        // Create an event, and give listeners a chance to cancel it.
        final event = new AsyncPopupEvent<Rectangle<num>>.open(
            eventController.action, this, () {
          return _overlayRef.onSizeChanged().first;
        });

        _onOpenController?.add(event);
        eventController.execute(_onPopupOpened, onCancel: () {
          // Revert the visible property back to false.
          _onVisibleController?.add(false);
        });
        await eventController.action.onDone;
      });

  Future<Rectangle> _onPopupOpened() async {
    // Put the overlay in the live DOM so we can measure its size.
    _overlayRef.state.visibility = Visibility.Hidden;

    // Start listening to both the popup and the source's layout.
    var initialData = new Completer<Rectangle>();
    var popupContentsLayoutStream =
        _overlayRef.onSizeChanged().asBroadcastStream(onCancel: (sub) {
      _layoutInternalSub = sub;
    });
    var popupSourceLayoutStream =
        state.source.onDimensionsChanged(track: state.trackLayoutChanges);
    if (!state.trackLayoutChanges) {
      popupContentsLayoutStream = popupContentsLayoutStream.take(1);
    }

    // Merge the results of both streams.
    // TODO(google): This belongs as a utility not inlined here.
    var mergedLayoutStream =
        _mergeStreams([popupContentsLayoutStream, popupSourceLayoutStream]);
    _layoutChangeSub = mergedLayoutStream.listen((layoutRects) {
      // Ignore partial results.
      if (layoutRects.every((r) => r != null)) {
        if (!initialData.isCompleted) {
          _isVisible = true;
          _onVisibleController?.add(true);
          initialData.complete(layoutRects[0]);
        }
        _schedulePositionUpdate(
            layoutRects[0] as Rectangle<num>, layoutRects[1] as Rectangle<num>);
      }
    });
    return initialData.future;
  }

  // Sort of the effective counterpart to Futures.wait.
  //
  // Returns a Stream of responses based on responses from all streams given,
  // which may be `null` if no response was received from a stream.
  static Stream<List> _mergeStreams(List<Stream> streams) {
    var streamSubscriptions = new List<StreamSubscription>(streams.length);
    var cachedResults = new List(streams.length);
    StreamController<List> streamController;
    streamController = new StreamController.broadcast(
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

  @override
  Future close() => _debounceSetVisibilityFunction(() async {
        if (!_isVisible) return;

        final eventController = new AsyncActionController<bool>();

        // Create an event, and give listeners a chance to cancel it.
        final event = new AsyncPopupEvent<bool>.close(eventController.action,
            this, () => _overlayRef.onSizeChanged().first);

        _onCloseController?.add(event);

        // Wait until the event could have been cancelled.
        eventController.execute(_onPopupClosed, onCancel: () {
          // Revert the visible property back to true.
          _onVisibleController?.add(true);
        });
        await eventController.action.onDone;
      });

  bool _onPopupClosed() {
    _layoutInternalSub?.cancel();
    _layoutChangeSub?.cancel();
    // Update the visibility.
    _overlayRef.state.visibility = Visibility.None;
    _isVisible = false;

    // Update the stream if there are listeners.
    _onVisibleController?.add(false);
    return true;
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

  @override
  Stream<PopupEvent<Rectangle>> get onOpen {
    if (_onOpenController == null) {
      _onOpenController = _disposer.addEventSink(
          new StreamController<PopupEvent<Rectangle>>.broadcast(sync: true));
    }
    return _onOpenController.stream;
  }

  @override
  Stream<PopupEvent<bool>> get onClose {
    if (_onCloseController == null) {
      _onCloseController = _disposer.addEventSink(
          new StreamController<PopupEvent<bool>>.broadcast(sync: true));
    }
    return _onCloseController.stream;
  }

  @override
  Stream<bool> get onVisibleChanged {
    if (_onVisibleController == null) {
      _onVisibleController = _onVisibleController =
          new StreamController<bool>.broadcast(sync: true);
    }
    return _onVisibleController.stream;
  }

  @override
  Stream<Rectangle> get onSizeChanged => _overlayRef.onSizeChanged();

  /// The underlying Overlay instance, visible internally only.
  OverlayRef get overlay => _overlayRef;

  @override
  void setAlignX(String alignX) {
    state.alignContentX = new Alignment.parse(alignX);
  }

  @override
  void setAlignY(String alignY) {
    state.alignContentY = new Alignment.parse(alignY);
  }

  @override
  void setAutoDismiss(bool autoDismiss) {
    state.autoDismiss = autoDismiss != false;
  }

  @override
  void setEnforceSpaceConstraints(bool enforceSpaceConstraints) {
    state.enforceSpaceConstraints = enforceSpaceConstraints != false;
  }

  @override
  void setMatchSourceWidth(bool matchSourceWidth) {
    state.matchSourceWidth = matchSourceWidth != false;
  }

  @override
  RelativePosition get popupAlignment => _alignmentPosition;

  @override
  void setPreferredPositions(Iterable preferredPositions) {
    state.preferredPositions =
        preferredPositions ?? RelativePosition.OffsetPositions;
  }

  Iterable get _preferredPositions {
    return _flatten(state.preferredPositions).isNotEmpty
        ? state.preferredPositions
        : _defaultPreferredPositions;
  }

  @override
  void setVisible(bool visible) {
    // If visibility is null, consider false.
    visible = visible == true;
    // No change.
    if (visible == isVisible) return;

    // TODO(google): If there is the opposite pending, is it worth cancelling?
    if (visible) {
      open();
    } else {
      close();
    }
  }

  @override
  String get uniqueId => _overlayRef.uniqueId;
}

/// Recursively flattens an arbitrarily-nested iterable.
Iterable _flatten(Iterable nested) sync* {
  for (var item in nested) {
    if (item is Iterable) {
      yield* _flatten(item);
    } else {
      yield item;
    }
  }
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
