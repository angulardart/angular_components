// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';

/// A function that can be throttled or debounced.
typedef UnaryFunction<T>(T argument);
typedef Future DebouncedFunction<T>(T argument);
typedef Future DebouncedNullaryFunction();

/// A function that rate-limits a delegate function. Helper typedef for
/// consumers.
typedef UnaryFunction<T> RateLimitStrategy<T>(
    UnaryFunction<T> delegate, Duration duration);

/// Returns a wrapper function that, when called with x, executes delegate(x)
/// [delay] from now iff there is no other call to the wrapper between now and
/// [delay] from now.
///
/// The debounced function returns a future that completes when the debounced
/// function is called. The future is completed with the return results of the
/// [delegate] function.
DebouncedFunction<T> debounce<T>(UnaryFunction<T> delegate, Duration delay) {
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

/// Wraps [debounce] so that it can be called without any arguments
DebouncedNullaryFunction debounceNullary(void callback(), Duration delay) {
  var function = debounce((_) => callback(), delay);
  return () => function(null);
}

/// Returns a wrapper function that, when called with x, executes delegate(x)
/// immediately and prevents further calls to the wrapper from executing
/// [delegate] until [interval] has elapsed.
UnaryFunction<T> throttle<T>(UnaryFunction<T> delegate, Duration interval) =>
    _throttle(delegate, interval, guaranteeLast: false);

/// Like [throttle], but if the last call to this function is throttled, it will
/// be executed once the throttling period expires, starting a new throttling
/// period.
UnaryFunction<T> throttleGuaranteeLast<T>(
        UnaryFunction<T> delegate, Duration interval) =>
    _throttle(delegate, interval, guaranteeLast: true);

UnaryFunction<T> _throttle<T>(UnaryFunction<T> delegate, Duration interval,
    {@required bool guaranteeLast}) {
  bool onCooldown = false;
  bool hasLastArg = false;
  var lastArg;
  UnaryFunction<T> self;
  self = (argument) {
    if (!onCooldown) {
      onCooldown = true;
      new Timer(interval, () {
        onCooldown = false;
        if (hasLastArg) {
          self(lastArg);
          hasLastArg = false;
        }
      });
      delegate(argument);
    } else if (guaranteeLast) {
      lastArg = argument;
      hasLastArg = true;
    }
  };
  return self;
}
