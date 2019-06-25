// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/angular/scroll_host/interface.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A non-touchscreen version of pan controller, as it relies on wheel events
/// that are not present on touchscreen displays.
class NonTouchPanController implements PanController {
  /// The duration while we are collecting multiple events, to merge them into
  /// a single interpretation.
  static final _eventCollectDuration = Duration(milliseconds: 50);

  /// The duration to wait after an active scrolling to prevent false positives.
  static final _scrollCooldownDuration = Duration(seconds: 1);

  /// The duration to wait after intent recognition, to prevent multiples.
  static final _deduplicationDuration = Duration(seconds: 4);

  final NgZone ngZone;
  final DomService domService;
  final Element host;

  StreamController<PanEvent> _controller;
  Stream<PanEvent> _stream;
  StreamSubscription<WheelEvent> _onWheelSubscription;
  StreamSubscription<Event> _onScrollSubscription;

  // border pan indicators
  bool _panTop = false;
  bool _panRight = false;
  bool _panBottom = false;
  bool _panLeft = false;
  // registering the fact that we have left a panning state
  bool _wasPanning = false;
  // registering the fact that we have had a scrolling event
  bool _wasScrolling = false;
  // registering the fact that the scrolling happened after the panning state
  bool _endPan = false;

  PanEvent _lastEvent;

  Timer _eventCollectTimer;
  Disposable _notificationSender;
  Timer _scrollCooldownTimer;
  Timer _deduplicationTimer;

  NonTouchPanController(this.ngZone, this.domService, this.host);

  @override
  Stream<PanEvent> get onPan {
    if (_controller == null) {
      assert(_stream == null);
      _controller = StreamController.broadcast(
          sync: true, onListen: _onListen, onCancel: _onCancel);
      _stream =
          ZonedStream<PanEvent>(_controller.stream, ngZone.runOutsideAngular);
    }
    return _stream;
  }

  int get maxScrollX => (host.scrollWidth - host.clientWidth);
  int get maxScrollY => (host.scrollHeight - host.clientHeight);

  void _onListen() {
    assert(_onWheelSubscription == null);
    ngZone.runOutsideAngular(() {
      _onWheelSubscription = host.onMouseWheel.listen((WheelEvent event) {
        if (_wasScrolling) return;
        _panTop = _panTop || ((event.deltaY < 0) && (host.scrollTop == 0));
        _panRight = _panRight ||
            ((event.deltaX > 0) && (host.scrollLeft == maxScrollX));
        _panBottom = _panBottom ||
            ((event.deltaY > 0) && (host.scrollTop == maxScrollY));
        _panLeft = _panLeft || ((event.deltaX < 0) && (host.scrollLeft == 0));
        _scheduleNotification();
      });
      _onScrollSubscription = host.onScroll.listen((event) {
        _wasScrolling = true;
        _scheduleScrollingCooldown();
        if (_wasPanning) {
          _endPan = true;
          _scheduleNotification();
        }
      });
    });
  }

  bool get _hasPan => _panTop || _panRight || _panBottom || _panLeft;
  bool get _hasNotification => _hasPan || _endPan;

  void _resetPans() {
    _panTop = false;
    _panRight = false;
    _panBottom = false;
    _panLeft = false;
  }

  void _scheduleNotification() {
    if (_eventCollectTimer != null) return;
    if (!_hasNotification) return;
    _eventCollectTimer = Timer(_eventCollectDuration, () {
      _eventCollectTimer = null;
      // wait until the previous event is actually sent
      if (_notificationSender != null) {
        _scheduleNotification();
        return;
      }
      if (_endPan) _resetPans();
      PanEventImpl event =
          PanEventImpl(_panTop, _panRight, _panBottom, _panLeft);
      if ((event != _lastEvent) &&
          (event.isValid) &&
          (!event.isSubsetOf(_lastEvent))) {
        _notificationSender = domService.scheduleRead(() {
          _notificationSender = null;
          _controller.add(event);
        });
        _lastEvent = event;
        _scheduleDeduplication();
      }
      _wasPanning = (_wasPanning || _hasPan) && (!_endPan);
      _resetPans();
      _endPan = false;
    });
  }

  void _onCancel() {
    _cancelSubscriptions();
  }

  void _cancelSubscriptions() {
    if (_onWheelSubscription != null) {
      _onWheelSubscription.cancel();
      _onWheelSubscription = null;
    }
    if (_onScrollSubscription != null) {
      _onScrollSubscription.cancel();
      _onScrollSubscription = null;
    }
  }

  void _scheduleScrollingCooldown() {
    _cancelScrollingCooldown();
    _scrollCooldownTimer = Timer(_scrollCooldownDuration, () {
      _scrollCooldownTimer = null;
      _wasScrolling = false;
    });
  }

  void _cancelScrollingCooldown() {
    if (_scrollCooldownTimer != null) {
      _scrollCooldownTimer.cancel();
      _scrollCooldownTimer = null;
    }
  }

  void _scheduleDeduplication() {
    _cancelDeduplication();
    _deduplicationTimer = Timer(_deduplicationDuration, () {
      _deduplicationTimer = null;
      _lastEvent = null;
    });
  }

  void _cancelDeduplication() {
    if (_deduplicationTimer != null) {
      _deduplicationTimer.cancel();
      _deduplicationTimer = null;
    }
  }

  @override
  void dispose() {
    if (_notificationSender != null) {
      _notificationSender.dispose();
      _notificationSender = null;
    }
    if (_controller != null) {
      _controller.close();
    }
    _cancelSubscriptions();
    if (_eventCollectTimer != null) {
      _eventCollectTimer.cancel();
      _eventCollectTimer = null;
    }
    _cancelScrollingCooldown();
    _cancelDeduplication();
  }
}

class PanEventImpl implements PanEvent {
  @override
  final bool isTop;

  @override
  final bool isRight;

  @override
  final bool isBottom;

  @override
  final bool isLeft;

  PanEventImpl(this.isTop, this.isRight, this.isBottom, this.isLeft);

  @override
  bool get isPanning => isTop || isRight || isBottom || isLeft;

  @override
  int get deltaX => 0;

  @override
  int get deltaY => 0;

  /// Whether the collect pan flags does not make sense and it is better to skip
  /// such event.
  bool get hasConflicts => (isTop && isBottom) || (isLeft && isRight);

  bool get isValid => !hasConflicts;

  /// Whether the event is a subset of [other], e.g. pan to top is a subset of
  /// pan to top-left.
  bool isSubsetOf(other) =>
      (other is PanEventImpl) &&
      (!isTop || other.isTop) &&
      (!isRight || other.isRight) &&
      (!isBottom || other.isBottom) &&
      (!isLeft || other.isLeft) &&
      isPanning;

  @override
  bool operator ==(other) =>
      (other is PanEventImpl) &&
      (isTop == other.isTop) &&
      (isRight == other.isRight) &&
      (isBottom == other.isBottom) &&
      (isLeft == other.isLeft);

  @override
  String toString() => '$isPanning ${isTop ? "t" : ""}'
      '${isRight ? "r" : ""}${isBottom ? "b" : ""}${isLeft ? "l" : ""}';
}
