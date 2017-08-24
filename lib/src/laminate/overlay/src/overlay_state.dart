// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:quiver/core.dart';

import '../../../utils/async/async.dart';
import '../../enums/position.dart';
import '../../enums/visibility.dart';

// The default implementation of OverlayState's '==' operator.
//
// It exists here to be re-used across implementations without inheritance.
bool _stateEquals(OverlayState a, OverlayState b) {
  if (identical(a, b)) return true;
  return a.captureEvents == b.captureEvents &&
      a.left == b.left &&
      a.top == b.top &&
      a.right == b.right &&
      a.bottom == b.bottom &&
      a.width == b.width &&
      a.minWidth == b.minWidth &&
      a.height == b.height &&
      a.zIndex == b.zIndex &&
      a.position == b.position;
}

// The default implementation of OverlayState's 'hashCode' property.
//
// It exists here to be re-used across implementations without inheritance.
int _stateHashCode(OverlayState a) {
  return hashObjects([
    a.captureEvents,
    a.left,
    a.top,
    a.right,
    a.bottom,
    a.width,
    a.minWidth,
    a.height,
    a.zIndex,
    a.position
  ]);
}

/// The state of an overlay pane.
abstract class OverlayState {
  /// An overlay pane that centers its content both on the x and y-axis and
  /// captures events, preventing interaction with underlying content.
  static const Dialog = const OverlayState(
      captureEvents: true, top: 0, bottom: 0, left: 0, right: 0);

  const factory OverlayState(
      {bool captureEvents,
      num left,
      num top,
      num right,
      num bottom,
      num width,
      num minWidth,
      num height,
      int zIndex,
      Position position,
      Visibility visibility}) = _ImmutableOverlayState;

  /// Whether to capture mouse and touch events on the pane itself.
  ///
  /// In most use cases, this should be kept to false. Some components like
  /// dialogs may wish to make this "true" in order to prevent interacting with
  /// the rest of the application when the pane is active.
  bool get captureEvents;

  /// The left position relative to the container viewport.
  num get left;

  /// The top position relative to the container viewport.
  num get top;

  /// The right position relative to the container viewport.
  num get right;

  /// The bottom position relative to the container viewport.
  num get bottom;

  /// The width of the pane.
  ///
  /// Can be set as 0 to signify full width.
  num get width;

  /// The minimum width of the pane.
  num get minWidth;

  /// The height of the pane.
  ///
  /// Can be set as 0 to signify full height.
  num get height;

  /// If the overlay should be visible.
  Visibility get visibility;

  /// A stream updated once per microtask queue when any property has changed.
  Stream get onUpdate;

  /// ZIndex of the pane.
  int get zIndex;

  /// The positioning method to use for this state.
  Position get position;
}

/// The state of an overlay pane.
class _ImmutableOverlayState implements OverlayState {
  @override
  final bool captureEvents;

  @override
  final num left;

  @override
  final num top;

  @override
  final num right;

  @override
  final num bottom;

  @override
  final num width;

  @override
  final num minWidth;

  @override
  final num height;

  @override
  final Visibility visibility;

  @override
  final int zIndex;

  @override
  final Position position;

  const _ImmutableOverlayState(
      {this.captureEvents: false,
      this.left,
      this.top,
      this.right,
      this.bottom,
      this.width,
      this.minWidth,
      this.height,
      this.zIndex,
      this.visibility: Visibility.None,
      this.position});

  @override
  bool operator ==(o) => o is OverlayState && _stateEquals(this, o);

  // TODO(google): Consider caching since this is immutable anyway.
  @override
  int get hashCode => _stateHashCode(this);

  @override
  Stream get onUpdate => const Stream.empty();

  @override
  String toString() =>
      'ImmutableOverlayState ' +
      {
        'captureEvents': captureEvents,
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
        'width': width,
        'height': height,
        'visibility': visibility,
        'zIndex': zIndex,
        'position': position,
      }.toString();
}

/// An interface that can mutate an active overlay pane.
///
/// Change notifies are delivered asynchronously through [onUpdate].
class MutableOverlayState implements OverlayState {
  // Fires a single notification once per microtask queue.
  final _asyncScheduler = new AsyncUpdateScheduler();

  bool _captureEvents;
  num _left;
  num _top;
  num _right;
  num _bottom;
  num _width;
  num _minWidth;
  num _height;
  int _zIndex;
  Visibility _visibility;
  Position _position;

  /// Creates a mutable state by copying values from [other].
  factory MutableOverlayState.from(OverlayState other) {
    if (other == null) return new MutableOverlayState();
    if (other is MutableOverlayState) return other;
    return new MutableOverlayState(
        captureEvents: other.captureEvents,
        left: other.left,
        top: other.top,
        right: other.right,
        bottom: other.bottom,
        width: other.width,
        minWidth: other.minWidth,
        height: other.height,
        zIndex: other.zIndex,
        visibility: other.visibility,
        position: other.position);
  }

  MutableOverlayState(
      {bool captureEvents: false,
      num left,
      num top,
      num right,
      num bottom,
      num width,
      num minWidth,
      num height,
      int zIndex,
      Visibility visibility: Visibility.None,
      Position position}) {
    _captureEvents = captureEvents;
    _left = left;
    _top = top;
    _right = right;
    _bottom = bottom;
    _width = width;
    _minWidth = minWidth;
    _height = height;
    _zIndex = zIndex;
    _visibility = visibility;
  }

  @override
  bool operator ==(o) => o is OverlayState && _stateEquals(this, o);

  @override
  int get hashCode => _stateHashCode(this);

  @override
  Stream get onUpdate => _asyncScheduler.onUpdate;

  @override
  bool get captureEvents => _captureEvents;
  set captureEvents(bool captureEvents) {
    if (_captureEvents != captureEvents) {
      _captureEvents = captureEvents;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get left => _left;
  set left(num left) {
    if (_left != left) {
      _left = left;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get top => _top;
  set top(num top) {
    if (_top != top) {
      _top = top;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get right => _right;
  set right(num right) {
    if (_right != right) {
      _right = right;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get bottom => _bottom;
  set bottom(num bottom) {
    if (_bottom != bottom) {
      _bottom = bottom;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get width => _width;
  set width(num width) {
    if (_width != width) {
      _width = width;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get minWidth => _minWidth;
  set minWidth(num minWidth) {
    if (_minWidth != minWidth) {
      _minWidth = minWidth;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  num get height => _height;
  set height(num height) {
    if (_height != height) {
      _height = height;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  int get zIndex => _zIndex;
  set zIndex(int zIndex) {
    if (_zIndex != zIndex) {
      _zIndex = zIndex;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  Visibility get visibility => _visibility;
  set visibility(Visibility visibility) {
    if (_visibility != visibility) {
      _visibility = visibility;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  Position get position => _position;
  set position(Position position) {
    if (_position != position) {
      _position = position;
      _asyncScheduler.scheduleUpdate();
    }
  }

  @override
  String toString() =>
      'MutableOverlayState ' +
      {
        'captureEvents': captureEvents,
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
        'width': width,
        'minWidth': minWidth,
        'height': height,
        'zIndex': zIndex,
        'visibility': visibility,
        'position': position
      }.toString();
}
