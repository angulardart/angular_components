// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.overlay.src.overlay_ref;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import '../../enums/visibility.dart';
import './overlay_state.dart';
import '../../portal/portal.dart';

/// A handle to manipulate an existing overlay pane.
abstract class OverlayRef implements PortalHost {
  /// True if the overlay is visible.
  bool get isVisible;

  /// A stream that fires whenever the pane is pressed.
  ///
  /// **NOTE**: This can only fire when [state.captureEvents] is true.
  Stream<MouseEvent> get onPanePressed;

  /// An event stream that fires when the inner content of the overlay has a
  /// dimension or position change.
  ///
  /// This allows to measure how big a popup or tooltip will be once made
  /// visible, as it will silently change visibility from [Visibility.None] to
  /// [Visibility.Hidden] in order to be able to measure layout.
  Stream<Rectangle> onSizeChanged();

  /// An event stream that fires when the overlay's visibility changes.
  Stream<bool> get onVisibleChanged;

  /// The current state of the overlay.
  ///
  /// Changes to the state are applied asynchronously in the next DOM write.
  MutableOverlayState get state;

  /// Sets whether the overlay should capture events and prevent interaction
  /// with the underlying application.
  ///
  /// A value of `null` is treated as `true`.
  void setPreventInteraction(bool preventInteraction);

  /// Sets whether the overlay should be visible.
  ///
  /// A value of `null` is treated as `false`.
  void setVisible(bool visible);

  /// A unique ID that represents the overlay pane.
  String get uniqueId;
}

/// A handler to apply [state] to an existing [element].
///
/// Returns a future that completes when the state is applied. This normally
/// should apply in a DOM write queue.
///
/// This exists to separate the ruler API from tight coupling on overlays; see
/// [Ruler.update] for the default implementation.
typedef Future AsyncApplyState<E>(OverlayState state, E element);

/// A handler to return the position and size of the *content* of [element].
///
/// If [track] is true, should observe the DOM for layout changes.
///
/// This exists to separate the ruler API from tight coupling on overlays; see
/// [Ruler.measure] and [Ruler.track] for the default implementations.
typedef Stream<Rectangle> AsyncMeasureSize<E>(E element, {bool track});

/// An internal base implementation of [OverlayRef].
abstract class BaseOverlayRef<E> implements OverlayRef {
  static bool _isEqualSize(Rectangle a, Rectangle b) {
    return a.width == b.width && a.height == b.height;
  }

  final AsyncApplyState<E> _asyncApplyState;
  final AsyncMeasureSize<E> _asyncMeasureSize;
  final PortalHost _delegatePortalHost;
  final E elementRef;
  final Function _runOutsideAngular;

  bool _lastVisible = false;

  // Tracks whenever the content size has changed.
  final Set<StreamController<Rectangle>> _sizeControllers =
      new Set<StreamController<Rectangle>>();
  StreamController<bool> _onVisibleController;

  // Tracks whenever [OverlayRef.onUpdate] changes.
  StreamSubscription _stateUpdateListener;

  BaseOverlayRef(
      this._asyncApplyState,
      this._asyncMeasureSize,
      this._delegatePortalHost,
      this.elementRef,
      this._runOutsideAngular,
      OverlayState state)
      : this.state = new MutableOverlayState.from(state) {
    _stateUpdateListener = this.state.onUpdate.listen((_) => applyChanges());
  }

  @override
  Future attach(Portal portal) => _delegatePortalHost.attach(portal);

  @override
  Future detach() => _delegatePortalHost.detach();

  @override
  bool get hasAttached => _delegatePortalHost.hasAttached;

  Future applyChanges() {
    if (_lastVisible != isVisible) {
      _lastVisible = isVisible;
      if (_onVisibleController != null) {
        _onVisibleController.add(isVisible);
      }
    }
    return _asyncApplyState(state, elementRef);
  }

  @override
  void dispose() {
    for (final controller in _sizeControllers) {
      controller.close();
    }
    _sizeControllers.clear();
    if (_onVisibleController != null) {
      _onVisibleController.close();
    }
    if (_delegatePortalHost.hasAttached == true) {
      _delegatePortalHost.dispose();
    }
    _stateUpdateListener.cancel();
  }

  @override
  bool get isVisible => state.visibility != Visibility.None;

  @override
  Stream<Rectangle> onSizeChanged() async* {
    // We need to be at least visibility: hidden to calculate layout.
    if (state.visibility == Visibility.None) {
      state.visibility = Visibility.Hidden;
    }
    await applyChanges();
    yield* _runOutsideAngular(() {
      return _asyncMeasureSize(elementRef, track: true).distinct(_isEqualSize);
    }) as Stream<Rectangle>;
  }

  @override
  Stream<bool> get onVisibleChanged {
    if (_onVisibleController == null) {
      _onVisibleController = new StreamController.broadcast(sync: true);
    }
    return _onVisibleController.stream;
  }

  @override
  final MutableOverlayState state;

  @override
  void setPreventInteraction(bool preventInteraction) {
    preventInteraction = preventInteraction != false;
    state.captureEvents = preventInteraction;
  }

  @override
  void setVisible(bool visible) {
    visible = visible != false;
    state.visibility = new Visibility.fromBoolean(visible);
  }
}
