// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Function to run when the timer expires.
typedef void Callback();

/// A reusable [Timer] and callback which allows for immediate execution
/// ([doNow]), cancelling ([cancel]) and throttled timer starting.
class DelayedAction {
  final Callback _callback;
  final Duration _duration;
  Timer _timer;
  Completer<bool> _completer;

  DelayedAction(this._duration, this._callback);

  void _wrappedCallback() {
    _callback();
    _reset(true);
  }

  /// Starts the timer, if it is not already started.
  ///
  /// Resolves to `true` if and when the callback is called. Otherwise, resolves
  /// to `false` when the timer is cancelled.
  Future<bool> start() {
    if (_timer == null) {
      _completer = new Completer<bool>();
      _timer = new Timer(_duration, _wrappedCallback);
    }
    return _completer.future;
  }

  /// Cancels the timer.
  void cancel() {
    _reset(false);
  }

  /// Calls the callback immediately and cancels the timer if started.
  void doNow() {
    _wrappedCallback();
  }

  /// Convenience method for calling [cancel] and [start].
  Future<bool> restart() {
    cancel();
    return start();
  }

  void _reset(complete) {
    _timer?.cancel();
    _timer = null;
    _completer?.complete(complete);
    _completer = null;
  }
}
