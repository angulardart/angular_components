// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library angular2_components.model.action.delayed_action;

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