// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

import 'package:quiver/time.dart';

/// A utility class to time both mouse down and up and return calculated times.
class TimeTracker {
  final Clock _clock;

  TimeTracker([this._clock = const Clock()]);

  num _mouseDownStart;
  num _mouseUpStart;

  num _now() => _clock.now().millisecondsSinceEpoch;

  /// Trigger a 'down' start time.
  void down() {
    _mouseDownStart = _now();
  }

  /// Trigger an 'up' start time.
  void up() {
    _mouseUpStart = _now();
  }

  /// Reset all interaction times.
  void reset() {
    _mouseDownStart = _mouseUpStart = null;
  }

  /// True if a down action is hit and waiting for an up action.
  bool get isMouseDown => _mouseDownStart != null && _mouseUpStart == null;

  /// True if an up action is hit.
  bool get isMouseUp => _mouseUpStart != null;

  /// The amount of time that has elapsed since the mouse was pressed down.
  ///
  /// If it has not been pressed, returns 0.
  /// If the mouse has been released back up, returns only the period of time
  /// between when the mouse was pressed down and then released back up.
  num get mouseDownElapsed {
    if (_mouseDownStart == null) {
      return 0;
    }
    var elapsed = _now() - _mouseDownStart;
    if (_mouseUpStart != null) {
      elapsed -= mouseUpElapsed;
    }
    return elapsed;
  }

  /// The amount of time since [up] was triggered.
  num get mouseUpElapsed {
    return _mouseUpStart != null ? _now() - _mouseUpStart : 0;
  }

  /// The fraction of seconds that [mouseDownElapsed] has occurred.
  num get mouseDownElapsedSeconds => mouseDownElapsed / aSecond.inMilliseconds;

  /// The fraction of seconds that [mouseUpElapsed] has occurred.
  num get mouseUpElapsedSeconds => mouseUpElapsed / aSecond.inMilliseconds;

  /// Returns the sum of [mouseDownElapsedSeconds] and [mouseUpElapsedSeconds],
  /// which represents the total time since both events have happened, added
  /// together.
  num get mouseInteractionSeconds {
    return mouseDownElapsedSeconds + mouseUpElapsedSeconds;
  }

  @override
  String toString() =>
      'TimeTracker ' +
      {
        'isMouseDown': isMouseDown,
        'isMouseUp': isMouseUp,
        'mouseDownElapsedSeconds': mouseDownElapsedSeconds,
        'mouseUpElapsedSeconds': mouseUpElapsedSeconds
      }.toString();
}

/// A UI model representing a single wave.
class Wave {
  /// The default initial opacity for a wave.
  static const defaultInitialOpacity = 0.25;

  /// The default for how quickly opacity should decay to invisible.
  static const defaultOpacityDecayVelocity = 0.8;

  /// A material design wave should not exceed 300 pixels.
  static const MAX_RADIUS = 300;

  /// Returns the distance to the furthest corner in [clientRect] from [origin].
  static num _furthestCornerDistanceFrom(Rectangle clientRect, Point origin) {
    return max(
        max(clientRect.topLeft.distanceTo(origin),
            clientRect.topRight.distanceTo(origin)),
        max(clientRect.bottomLeft.distanceTo(origin),
            clientRect.bottomRight.distanceTo(origin)));
  }

  // Tracks the amount of time between a mouse down and mouse up.
  final TimeTracker _timeTracker;

  final bool _centerRipples;
  final bool _recenterRipples;
  final num _initialOpacity;
  final num _opacityDecayVelocity;

  final HtmlElement _containerElement;
  final Rectangle _containerMetrics;
  final num _containerSize;
  final HtmlElement _waveElement;

  // The maximum radius that the wave should be.
  num _maxRadius = 0;

  // The start and end positions.
  Point _startPosition;
  Point _endPosition;

  /// Creates a new wave within [hostLocation].
  ///
  /// This creates both a container and wave element, and manages both the style
  /// and the DOM of these element nodes.
  ///
  /// If [stopwatch] is supplied, uses, otherwise creates a default - this is
  /// supplied in order to have a testable component.
  ///
  /// Other properties:
  ///   - [center]: Will center all waves
  ///   - [recenter]: Will translate the wave towards the center.
  factory Wave(HtmlElement hostElement,
      {Clock clock: const Clock(), bool center: false, bool recenter: false}) {
    final containerElement = new DivElement()
      ..classes.add('__material-ripple_wave-container');
    final waveElement = new DivElement()..classes.add('__material-ripple_wave');
    containerElement.append(waveElement);
    hostElement.append(containerElement);
    final containerMetrics = hostElement.getBoundingClientRect();
    return new Wave._(
        new TimeTracker(clock),
        containerElement,
        containerMetrics,
        max(containerMetrics.width, containerMetrics.height),
        waveElement,
        center,
        recenter,
        defaultInitialOpacity,
        defaultOpacityDecayVelocity);
  }

  Wave._(
      this._timeTracker,
      this._containerElement,
      this._containerMetrics,
      this._containerSize,
      this._waveElement,
      this._centerRipples,
      this._recenterRipples,
      this._initialOpacity,
      this._opacityDecayVelocity) {
    resetInteractionState();
  }

  /// Trigger a ripple down action from [origin].
  void downAction([Point origin]) {
    final xCenter = _containerMetrics.width / 2;
    final yCenter = _containerMetrics.height / 2;

    resetInteractionState();

    _timeTracker.down();

    if (_centerRipples) {
      _startPosition = new Point(xCenter, yCenter);
    } else {
      _startPosition = new Point(
          origin != null ? origin.x - _containerMetrics.left : xCenter,
          origin != null ? origin.y - _containerMetrics.top : yCenter);
    }

    if (_recenterRipples) {
      _endPosition = new Point(xCenter, yCenter);
    }

    _maxRadius = _furthestCornerDistanceFrom(_containerMetrics, _startPosition);

    _containerElement.style
      ..top = '${(_containerMetrics.height - _containerSize) / 2}px'
      ..left = '${(_containerMetrics.width - _containerSize) / 2}px'
      ..width = '${_containerSize}px'
      ..height = '${_containerSize}px';
  }

  bool get isAnimationComplete {
    return _timeTracker.isMouseUp
        ? isOpacityFullyDecayed
        : isRestingAtMaxRadius;
  }

  bool get isOpacityFullyDecayed => opacity < 0.01;

  bool get isRestingAtMaxRadius {
    return opacity >= _initialOpacity && radius >= min(_maxRadius, MAX_RADIUS);
  }

  /// Trigger a ripple up action from [origin].
  void upAction([Point origin]) {
    _timeTracker.up();
  }

  /// Reset internal state.
  void resetInteractionState() {
    _maxRadius = 0;
    _startPosition = null;
    _timeTracker.reset();
  }

  /// Removes the wave from the parent host.
  void remove() {
    _containerElement.remove();
  }

  /// Returns the opacity for the wave.
  num get opacity {
    // If mouse is currently down, the opacity should be the initial opacity.
    if (!_timeTracker.isMouseUp) return _initialOpacity;

    // Calculate the new opacity.
    final opacityBasedOnPressLength = _initialOpacity -
        _timeTracker.mouseUpElapsedSeconds * _opacityDecayVelocity;

    // If it was pressed too long, make sure the max opacity is 0.
    return max(0, opacityBasedOnPressLength);
  }

  /// Returns the opacity for the container.
  num get outerOpacity {
    // Linear increase in background opacity, capped at the opacity of the
    // wavefront (waveOpacity).
    final outerOpacity = _timeTracker.mouseDownElapsedSeconds * 0.3;
    final waveOpacity = opacity;

    // Cap the outer opacity at the wave, but no lower than 0.
    return max(0, min(outerOpacity, waveOpacity));
  }

  /// Returns the radius for the wave.
  num get radius {
    final widthX2 = _containerMetrics.width * _containerMetrics.width;
    final heightX2 = _containerMetrics.height * _containerMetrics.height;
    final waveRadius = min(sqrt(widthX2 + heightX2), MAX_RADIUS) * 1.1 + 5;

    // Sorry for the magic numbers/vars, this is copied from Polymer's code.
    // TODO(google): Investigate and see if we can label these.
    final duration = 1.1 - 0.2 * (waveRadius / MAX_RADIUS);
    final timeNow = _timeTracker.mouseInteractionSeconds / duration;
    final size = waveRadius * (1 - pow(80, -timeNow));
    return size.abs();
  }

  /// How much to modify the translate by.
  num get translationFraction => min(1, radius / _containerSize * 2 / sqrt(2));

  /// Returns translate.x.
  num get _xNow {
    if (_endPosition != null) {
      return _startPosition.x +
          translationFraction * (_endPosition.x - _startPosition.x);
    } else {
      return _startPosition.x;
    }
  }

  /// Returns translate.y.
  num get _yNow {
    if (_endPosition != null) {
      return _startPosition.y +
          translationFraction * (_endPosition.y - _startPosition.y);
    } else {
      return _startPosition.y;
    }
  }

  /// Where to translate the ripple relatively.
  ///
  /// Visible for testing.
  Point get translate => new Point(_xNow, _yNow);

  void draw() {
    // Set the opacity.
    _waveElement.style.opacity = opacity.toString();

    // Calculate the scale and transform.
    var scale = radius / (_containerSize / 2);
    var dX = _xNow - (_containerMetrics.width / 2);
    var dY = _yNow - (_containerMetrics.height / 2);

    // Apply translation.
    _containerElement.style..transform = 'translate3d(${dX}px, ${dY}px, 0)';

    // Apply scale.
    _waveElement.style..transform = 'scale3d($scale, $scale, 1)';
  }
}
