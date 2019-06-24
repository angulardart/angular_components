// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:angular_components/utils/angular/scroll_host/interface.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Helper class to detect scroll activity start/end points.
///
/// Used to defer code execution during scrolling such as hover on row.
class ScrollObserver implements Disposable {
  // Default to 150 due to typically mousewheel events arriving < 50ms when
  // slowly scrolling through table. On some old trackpads this increases to
  // 100..120ms range.
  final int _idleCheckDurationMs;
  final Duration _idleCheckDuration;
  @visibleForTesting
  static const int defaultIdleCheckDurationMs = 150;

  ScrollHost _scrollHost;
  StreamSubscription<ScrollHostEvent> _scrollSub;
  int _scrollTimestamp = 0;
  bool _isScrolling = false;
  Timer _timer;

  /// Sets callback for scroll idle event.
  ScrollObserverIdleCallback scrollStatusCallback;

  /// Uses the default duration for the idle callback.
  ScrollObserver(ScrollHost scrollHost)
      : this.withDurationMs(scrollHost, defaultIdleCheckDurationMs);

  /// Specifies a different duration for the idle callback.
  ///
  /// Useful for setting a longer duration to limit activity logging.
  ScrollObserver.withDurationMs(this._scrollHost, this._idleCheckDurationMs)
      : _idleCheckDuration = Duration(milliseconds: _idleCheckDurationMs) {
    _subscribe();
  }

  void _subscribe() {
    _scrollSub = _scrollHost.onScroll.listen((_) {
      _scrollTimestamp = _now;
      if (!_isScrolling) {
        _isScrolling = true;
        _raiseIdleEvent(false);
        if (_timer == null) {
          // Since listenOnScroll gets called outside angular zone,
          // it is safe to start timer here which will also execute outside.
          _timer = Timer.periodic(_idleCheckDuration, _checkIdle);
        }
      }
    });
  }

  int get _now => DateTime.now().millisecondsSinceEpoch;

  void _checkIdle(Timer _) {
    int elapsedTimeSinceLastScroll = _now - _scrollTimestamp;
    if (elapsedTimeSinceLastScroll > _idleCheckDurationMs) {
      _isScrolling = false;
      _raiseIdleEvent(true);
      _timer?.cancel();
      _timer = null;
    }
  }

  void _raiseIdleEvent(bool idle) {
    if (scrollStatusCallback != null) {
      scrollStatusCallback(idle);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _scrollSub.cancel();
    _scrollSub = null;
  }
}

typedef ScrollObserverIdleCallback = void Function(bool idle);
