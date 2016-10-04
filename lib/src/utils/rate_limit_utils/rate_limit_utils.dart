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

import 'dart:async';

import 'package:meta/meta.dart';

/// A function that can be throttled or debounced.
typedef UnaryFunction(argument);
typedef Future DebouncedFunction(argument);

/// A function that rate-limits a delegate function. Helper typedef for
/// consumers.
typedef UnaryFunction RateLimitStrategy(
    UnaryFunction delegate, Duration duration);

/// Returns a wrapper function that, when called with x, executes delegate(x)
/// [delay] from now iff there is no other call to the wrapper between now and
/// [delay] from now.
///
/// The debounced function returns a future that completes when the debounced
/// function is called. The future is completed with the return results of the
/// [delegate] function.
DebouncedFunction debounce(UnaryFunction delegate, Duration delay) {
  Timer timer;
  Completer completer;

  return (argument) {
    timer?.cancel();
    completer ??= new Completer();
    timer = new Timer(delay, () {
      completer.complete(delegate(argument));
      completer = null;
      timer = null;
    });
    return completer.future;
  };
}

/// Returns a wrapper function that, when called with x, executes delegate(x)
/// immediately and prevents further calls to the wrapper from executing
/// [delegate] until [interval] has elapsed.
UnaryFunction throttle(UnaryFunction delegate, Duration interval) =>
    _throttle(delegate, interval, guaranteeLast: false);

/// Like [throttle], but if the last call to this function is throttled, it will
/// be executed once the throttling period expires, starting a new throttling
/// period.
UnaryFunction throttleGuaranteeLast(
        UnaryFunction delegate, Duration interval) =>
    _throttle(delegate, interval, guaranteeLast: true);

UnaryFunction _throttle(UnaryFunction delegate, Duration interval,
    {@required bool guaranteeLast}) {
  bool onCooldown = false;
  var lastArg;
  UnaryFunction self;
  self = (argument) {
    if (!onCooldown) {
      onCooldown = true;
      new Timer(interval, () {
        onCooldown = false;
        if (lastArg != null) {
          self(lastArg);
          lastArg = null;
        }
      });
      delegate(argument);
    } else if (guaranteeLast) {
      lastArg = argument;
    }
  };
  return self;
}
