// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'async_action.dart';

/// Controller Class for an [AsyncAction].
/// The [AsyncController] provides a private handle to execute a closure if and
/// only if the action is not cancelled.
/// The AsyncAction implementation defers to the controller for its state, and
/// the sequencing of futures to resolve the execution.
///
/// <V> Is the value type returned/resolved by the execution closure.
class AsyncActionController<V> {
  // The controller uses the indirection of a [Completer] in order to coalesce
  // subscribers to [AsyncAction#onDone] and to provide a [Future] for
  // [AsyncAction#onDone] before [execute] has been called.
  final _executeCompleter = Completer<V>();

  // This [Completer] resolves its future when the controller is ready to
  // proceed with the action execution, and is ready to be deferred.
  final _deferCompleter = Completer<bool>();

  // Futures to await before completing the execution.
  final _executionDeferrals = <Future<dynamic>>[];

  // Futures to await and check for cancelling.
  final _futureCancellations = <Future<bool>>[];

  // Locks the action from cancelIf and defer calls.
  bool _locked = false;
  bool _cancelled = false;
  bool _done = false;

  AsyncAction<V> get action {
    if (_action == null) {
      _action = AsyncAction<V>(
          _executeCompleter.future,
          _deferCompleter.future,
          _futureCancellations,
          _executionDeferrals,
          () => _locked,
          () => _cancelled,
          () => _done);
    }
    return _action;
  }

  AsyncAction<V> _action;

  /// Execute a closure either async or sync. The [Executor] is only called if
  /// all deferred cancels return false and only after all `executionDeferrals`
  /// have completed. If [exec] returns a future, its result is piped through to
  /// the [onDone] future, otherwise, the [onDone] future is completed with the
  /// result.
  Future<void> execute(dynamic Function() exec,
      {dynamic Function() onCancel, V valueOnCancel}) {
    // This function is very time-sensitive.
    // We are using explicit `Future`s to avoid breaking changes when the
    // behavior of `async` changes.
    // TODO(google): switch back to `async` with an explicit `await null;` at
    // the beginning of the function, once the migration is done.
    return Future.microtask(() {
      if (_locked) {
        throw StateError('Cannot execute, execution already in process.');
      }
      _locked = true;

      // Check for cancellations
      return _shouldCancel().then((shouldCancel) {
        _cancelled = shouldCancel;
        var shouldProceed = !_cancelled;
        _deferCompleter.complete(shouldProceed);
        if (shouldProceed) {
          // Wait for any execution deferrals.
          return _maybeWait().then((_) {
            _executeAndAttach(exec);
          });
        } else {
          _done = true;

          // FutureCancellations have cancelled this action. Run the onCancel,
          // then complete with [valueOnCancel].
          if (onCancel == null) {
            _executeCompleter.complete(valueOnCancel);
          } else {
            var cancelRes = onCancel();
            if (cancelRes is! Future) {
              _executeCompleter.complete(valueOnCancel);
            } else {
              // The action should resolve [onDone] with [valueOnCancel] if
              // canceled, so, while we need to await the cancel result, we want
              // to throw it away.
              _attachFuture(cancelRes.then((_) => valueOnCancel));
            }
          }
          return null;
        }
      });
    });
  }

  Future<dynamic> _maybeWait() {
    // Don't wait for the deferrals if the execution has been stayed.
    return Future.wait(_executionDeferrals);
  }

  Future<bool> _shouldCancel() {
    // This function is very time-sensitive.
    // We are using explicit `Future`s to avoid breaking changes when the
    // behavior of `async` changes.
    return Future.microtask(() {
      return Future.wait(_futureCancellations)
          .then((results) => results.any((cancel) {
                return cancel == true;
              }));
    });
  }

  void _executeAndAttach(dynamic Function() exec) {
    var execResult = exec();
    _done = true;
    if (execResult is Future) {
      _attachFuture(execResult);
    } else {
      _executeCompleter.complete(execResult);
    }
  }

  void _attachFuture(Future<V> future) {
    future
        .then(_executeCompleter.complete)
        .catchError(_executeCompleter.completeError);
  }
}
