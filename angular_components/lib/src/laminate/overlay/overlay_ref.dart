// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular_components/laminate/enums/visibility.dart';
import 'package:angular_components/src/laminate/overlay/overlay_state.dart';
import 'package:angular_components/laminate/portal/portal.dart';

/// A handler to apply [state] to an existing [element].
///
/// Returns a future that completes when the state is applied. This normally
/// should apply in a DOM write queue.
///
/// This exists to separate the ruler API from tight coupling on overlays; see
/// [Ruler.update] for the default implementation.
typedef AsyncApplyState<E> = Future<Object> Function(
    OverlayState state, E element);

/// A handler to return the position and size of the *content* of [element].
///
/// If [track] is true, should observe the DOM for layout changes.
///
/// This exists to separate the ruler API from tight coupling on overlays; see
/// [Ruler.measure] and [Ruler.track] for the default implementations.
typedef AsyncMeasureSize<E> = Stream<Rectangle> Function(E element,
    {bool track});

/// A handle to manipulate an existing overlay pane.
class OverlayRef implements PortalHost {
  /// True if the overlay is not display: none.
  bool get isVisible => state.visibility != Visibility.None;

  /// A stream that fires whenever the pane is pressed.
  ///
  /// **NOTE**: This can only fire when [state.captureEvents] is true.
  Stream<MouseEvent> get onPanePressed => overlayElement.onMouseDown;

  /// An event stream that fires when the inner content of the overlay has a
  /// dimension or position change.
  ///
  /// This allows to measure how big a popup or tooltip will be once made
  /// visible, as it will silently change visibility from [Visibility.None] to
  /// [Visibility.Hidden] in order to be able to measure layout.
  Stream<Rectangle> measureSizeChanges() async* {
    // Visibility cannot be None to calculate overlay dimensions (display:
    // none; elements have width and height of 0). It must be at least Hidden
    // (i.e. visibility: hidden;).
    if (state.visibility == Visibility.None) {
      state.visibility = Visibility.Hidden;
    }
    await _applyChanges();
    yield* _runOutsideAngular(() {
      return _asyncMeasureSize(overlayElement, track: true)
          .distinct(_isEqualSize);
    }) as Stream<Rectangle>;
  }

  /// An event stream that fires when the overlay's visibility changes.
  Stream<bool> get onVisibleChanged {
    _onVisibleController ??= StreamController.broadcast(sync: true);
    return _onVisibleController.stream;
  }

  /// The current state of the overlay.
  ///
  /// Changes to the state are applied asynchronously in the next DOM write.
  final MutableOverlayState state;

  /// The .acx-overlay-container element where the overlay pane resides.
  final HtmlElement containerElement;

  /// The .pane element corresponding to this overlay.
  final HtmlElement overlayElement;

  /// Sets whether the overlay should capture events and prevent interaction
  /// with the underlying application.
  void setPreventInteraction([bool preventInteraction]) {
    state.captureEvents = preventInteraction ?? true;
  }

  /// Sets whether the overlay should be visible.
  void setVisible([bool visible]) {
    state.visibility = Visibility.fromBoolean(visible ?? true);
  }

  /// A unique ID that represents the overlay pane.
  String get uniqueId => overlayElement.attributes['pane-id'];

  @override
  Future<Object> attach(Portal<Object> portal) =>
      _delegatePortalHost.attach(portal);

  @override
  Future<void> detach() => _delegatePortalHost.detach();

  @override
  bool get hasAttached => _delegatePortalHost.hasAttached;

  @override
  void dispose() {
    overlayElement.remove();
    if (_onVisibleController != null) {
      _onVisibleController.close();
    }
    if (_delegatePortalHost.hasAttached == true) {
      _delegatePortalHost.dispose();
    }
    _stateUpdateListener.cancel();
  }

  static bool _isEqualSize(Rectangle a, Rectangle b) {
    return a.width == b.width && a.height == b.height;
  }

  final AsyncApplyState<HtmlElement> _asyncApplyState;
  final AsyncMeasureSize<HtmlElement> _asyncMeasureSize;
  final PortalHost _delegatePortalHost;
  final Function _runOutsideAngular;

  bool _lastVisible = false;

  StreamController<bool> _onVisibleController;

  // Tracks whenever [OverlayRef.onUpdate] changes.
  StreamSubscription<Null> _stateUpdateListener;

  Future<Object> _applyChanges() {
    if (_lastVisible != isVisible) {
      _lastVisible = isVisible;
      if (_onVisibleController != null) {
        _onVisibleController.add(isVisible);
      }
    }
    return _asyncApplyState(state, overlayElement);
  }

  OverlayRef(
      this._asyncApplyState,
      this._asyncMeasureSize,
      this._delegatePortalHost,
      this.containerElement,
      this.overlayElement,
      this._runOutsideAngular,
      {OverlayState state})
      : this.state = MutableOverlayState.from(state) {
    _stateUpdateListener = this.state.onUpdate.listen((_) => _applyChanges());
  }
}
