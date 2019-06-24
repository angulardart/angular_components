// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_event_impl.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_interface.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

enum GestureDirection { up, down, left, right }

GestureDirection scrollDirection(num deltaX, num deltaY) {
  num deltaXAbs = deltaX.abs();
  num deltaYAbs = deltaY.abs();
  if (deltaY >= deltaXAbs) {
    return GestureDirection.up;
  } else if (deltaY <= -deltaXAbs) {
    return GestureDirection.down;
  } else if (deltaX > deltaYAbs) {
    return GestureDirection.right;
  } else if (deltaX < -deltaYAbs) {
    return GestureDirection.left;
  }
  return null;
}

typedef DirectionCheck = bool Function(GestureDirection direction);

/// A layer of indirection to allow injection.
@Injectable()
class GestureListenerFactory {
  final Clock _clock;

  GestureListenerFactory(this._clock);

  GestureListener create(
          Element element, DirectionCheck isDirectionScrollable) =>
      GestureListener(element, isDirectionScrollable, _clock);
}

/// Directions in which a parent of [target] can scroll within the [host].
Map<GestureDirection, bool> innerScrollableDirections(
    Element host, EventTarget target) {
  Map<GestureDirection, bool> directions = {
    GestureDirection.up: false,
    GestureDirection.down: false,
    GestureDirection.left: false,
    GestureDirection.right: false
  };
  Element element = target;
  while (element != host && element != null) {
    var style = element.getComputedStyle();
    String overflowX = style.getPropertyValue('overflow-x');
    if (overflowX == 'auto' || overflowX == 'scroll') {
      directions[GestureDirection.left] =
          directions[GestureDirection.left] || element.scrollLeft > 0;
      directions[GestureDirection.right] = directions[GestureDirection.right] ||
          element.scrollLeft + element.clientWidth < element.scrollWidth;
    }
    String overflowY = style.getPropertyValue('overflow-y');
    if (overflowY == 'auto' || overflowY == 'scroll') {
      directions[GestureDirection.up] =
          directions[GestureDirection.up] || element.scrollTop > 0;
      directions[GestureDirection.down] = directions[GestureDirection.down] ||
          element.scrollTop + element.clientHeight < element.scrollHeight;
    }
    element = element.parent;
  }
  return directions;
}

/// Adds the element where the gesture began to [ScrollHostEvent].
class GestureEvent extends ScrollHostEventImpl {
  final EventTarget startingTarget;

  GestureEvent(int deltaX, int deltaY, this.startingTarget)
      : super(deltaX, deltaY);
}

/// Listens to touch events on an element and exposes a [scrollStream] of
/// [ScrollHostEvent] events fired as the user moves their finger.
class GestureListener implements Disposable {
  static const Duration _defaultScrollInterval = Duration(milliseconds: 17);

  final Element _element;
  final DirectionCheck _isDirectionScrollable;
  final Clock _clock;
  final Duration _scrollInterval;
  StreamController<GestureEvent> _scrollController;
  Disposer _disposer;

  /// Events are added to [scrollStream] at [scrollInterval] intervals.
  ///
  /// If the listener to [scrollStream] cannot keep up with the default rate,
  /// a larger [scrollInterval] should be passed.
  GestureListener(this._element, this._isDirectionScrollable, this._clock,
      {Duration scrollInterval = _defaultScrollInterval})
      : _scrollInterval = scrollInterval;

  _Gesture _gesture;

  Stream<GestureEvent> get scrollStream {
    if (_scrollController == null) {
      _scrollController = StreamController<GestureEvent>.broadcast(
          onListen: _startListeners, onCancel: _onCancel);
    }

    return _scrollController.stream;
  }

  /// Starts listening for touch events on [_element].
  void _startListeners() {
    if (_disposer != null) return;
    _disposer = Disposer.oneShot();
    _disposer
        .addStreamSubscription(_element.onTouchStart.listen(_onTouchStart));
    _disposer.addStreamSubscription(_element.onTouchMove.listen(_onTouchMove));
    _disposer.addStreamSubscription(_element.onTouchEnd.listen(_onTouchEnd));
  }

  void _onCancel() {
    if (_scrollController.hasListener) return;
    _disposer.dispose();
    _disposer = null;
  }

  // Only used for testing.
  bool get isGestureInProgress {
    if (_gesture?._scrollTimer == null) return false;
    return _gesture._scrollTimer.isActive;
  }

  Map<GestureDirection, bool> _directions;
  Point _startPoint;
  bool _capturing = false;
  void _onTouchStart(TouchEvent touchStart) {
    // Don't capture multi-touch events.
    if (touchStart.touches.length > 1) return;

    _directions = innerScrollableDirections(_element, touchStart.target);
    _startPoint = touchStart.touches.single.screen;
    _capturing = false;

    _gesture?.cancel();
    _gesture = _Gesture(_scrollController, _clock, _scrollInterval);
    _gesture.start(touchStart);
  }

  void _onTouchMove(TouchEvent touchMove) {
    if (_gesture == null) return null;
    if (_gesture.finished) return _onTouchStart(touchMove);

    // Start capturing events if the scroll host can scroll in the direction of
    // movement, and no child can.
    if (!_capturing) {
      Point delta = touchMove.touches.first.screen - _startPoint;

      // Don't capture events that will trigger child scrolling.
      // If delta is diagonal, we let the child handle scrolling even if it can
      // only scroll along the smaller of the two directions, since we cannot
      // make assumptions about how it intends to handle this case.
      if ((delta.y > 0 && _directions[GestureDirection.up]) ||
          (delta.y < 0 && _directions[GestureDirection.down]) ||
          (delta.x > 0 && _directions[GestureDirection.left]) ||
          (delta.x < 0 && _directions[GestureDirection.right])) {
        _gesture = null;
        return null;
      }

      // However, we only allow the scroll host to handle scrolling if it can
      // scroll along the larger of the two directions. This prevents multiple
      // scroll hosts from fighting each other.
      if (!_isDirectionScrollable(scrollDirection(delta.x, delta.y))) {
        _gesture = null;
        return null;
      }

      _capturing = true;
    }

    touchMove.stopPropagation();
    touchMove.preventDefault();
    _gesture.update(touchMove);
  }

  void _onTouchEnd(TouchEvent touchEnd) {
    if (_gesture == null) return null;
    touchEnd.stopPropagation();
    _gesture.finish();
  }

  @override
  void dispose() {
    _gesture?.cancel();
    _gesture = null;
    _scrollController?.close();
    _scrollController = null;
    _disposer?.dispose();
    _disposer = null;
  }
}

/// Encapsulates a single gesture, sending ScrollHostEvents to
/// [_scrollController] at regular intervals until complete.
///
/// There are two kinds of gestures, drags and flings, which are distinguished
/// by speed. Slower gestures are drags, which follow the users finger on the
/// screen and stop as soon as they remove their fingers. Faster gestures are
/// flings, which continue to emit events after the user has raised their
/// finger, slowing down as if subject to friction.
class _Gesture {
  // An extremely low value of timeout can lead to missed touch drag events.
  static const Duration _touchMoveTimeout = Duration(milliseconds: 500);
  static const double _flingSpeedThreshold = 2.0; // in pixels/ms
  static const double _frictionCoefficient = 0.005; // in pixels/ms^2

  final StreamController<GestureEvent> _scrollController;
  final Clock _clock;
  final Duration _scrollInterval;

  _Gesture(this._scrollController, this._clock, this._scrollInterval);

  Timer _scrollTimer;
  DateTime _startTime;
  DateTime _lastTime;
  Point _startPoint;
  Point _lastTouchPoint;
  Point _lastSyncPoint;
  bool _finished = false;
  EventTarget _startingTarget;

  bool get finished => _finished;

  /// Velocity along Y axis in pixels per ms.
  double get _velocityX {
    int deltaX = _startPoint.x - _lastTouchPoint.x;
    int deltaT = _lastTime.difference(_startTime).inMilliseconds;
    return deltaT == 0 ? 0.0 : deltaX.toDouble() / deltaT;
  }

  /// Velocity along Y axis in pixels per ms.
  double get _velocityY {
    int deltaY = _startPoint.y - _lastTouchPoint.y;
    int deltaT = _lastTime.difference(_startTime).inMilliseconds;
    return deltaT == 0 ? 0.0 : deltaY.toDouble() / deltaT;
  }

  double get _velocity {
    double x = _velocityX;
    double y = _velocityY;
    return math.sqrt(x * x + y * y);
  }

  /// Begin a new gesture.
  void start(TouchEvent touchStart) {
    assert(_scrollTimer == null); // This should only be called once.
    _scrollTimer = Timer.periodic(_scrollInterval, _addDragEvent);
    _startTime = _clock.now();
    _lastTime = _startTime;
    _startPoint = touchStart.touches.single.screen;
    _lastTouchPoint = _startPoint;
    _lastSyncPoint = _startPoint;
    _startingTarget = touchStart.target;
  }

  /// Update the gesture when the user has moved their finger.
  ///
  /// Because the rate at which the browser fires touchmove events may be too
  /// fast, this method does not directly add events to [scrollController], but
  /// instead updates the next event's deltaY.
  void update(TouchEvent touchMove) {
    assert(!_finished);
    _lastTime = _clock.now();
    _lastTouchPoint = touchMove.touches.first.screen;
  }

  /// Called when the user has finished their gesture, either by removing their
  /// finger or not moving for longer than [_touchMoveTimeout].
  ///
  /// Note that fling gestures may keep adding events to [_scrollController].
  void finish() {
    if (_finished) return;
    _finished = true;
    _scrollTimer.cancel();

    if (_velocity.abs() >= _flingSpeedThreshold) {
      _scrollTimer = Timer.periodic(_scrollInterval, _addFlingEvent);
    } else {
      _syncToLastTouchPoint();
    }
  }

  /// Stop adding any events to [_scrollController], even for fling gestures.
  void cancel() {
    _finished = true;
    _scrollTimer.cancel();
  }

  void _syncToLastTouchPoint() {
    Point delta = _lastSyncPoint - _lastTouchPoint;
    if (delta.x != 0 || delta.y != 0) {
      _scrollController.add(GestureEvent(delta.x, delta.y, _startingTarget));
      _lastSyncPoint = _lastTouchPoint;
    }
  }

  void _addDragEvent(Timer _) {
    // Stop scrolling if there has been no touchmove event recently.
    // In this case, the user must have kept their finger on the screen,
    // so they almost certainly do not want a fling event, thus we call [cancel]
    // instead of [finish].
    if (_lastTime.add(_touchMoveTimeout).isBefore(_clock.now())) {
      return cancel();
    }
    _syncToLastTouchPoint();
  }

  void _addFlingEvent(Timer _) {
    int deltaT = _clock.now().difference(_lastTime).inMilliseconds;
    double speed = _velocity.abs() - _frictionCoefficient * deltaT;
    int deltaX =
        (speed * _velocityX.sign * _scrollInterval.inMilliseconds).round();
    int deltaY =
        (speed * _velocityY.sign * _scrollInterval.inMilliseconds).round();
    if (speed > 0 && (deltaX != 0 || deltaY != 0)) {
      _scrollController.add(GestureEvent(deltaX, deltaY, _startingTarget));
    } else {
      cancel();
    }
  }
}
