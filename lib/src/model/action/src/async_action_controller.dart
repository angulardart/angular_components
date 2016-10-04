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

library angular2_components.model.action.src.async_action_controller;

import 'dart:async';

import 'async_action.dart';

typedef dynamic /* Future | dynamic */ Executor();
typedef dynamic /* Future | dynamic */ OnCancelFunction();

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
  final _executeCompleter = new Completer<V>();

  // This [Completer] resolves its future when the controller is ready to
  // proceed with the action execution, and is ready to be deferred.
  final _deferCompleter = new Completer<bool>();

  // Futures to await before completing the execution.
  final _executionDeferrals = <Future>[];

  // Futures to await and check for cancelling.
  final _futureCancellations = <Future<bool>>[];

  // Locks the action from cancelIf and defer calls.
  bool _locked = false;
  bool _cancelled = false;
  bool _done = false;

  AsyncAction<V> get action {
    if (_action == null) {
      _action = new AsyncAction<V>(
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
  Future execute(Executor exec,
      {OnCancelFunction onCancel, V valueOnCancel}) async {
    if (_locked) {
      throw new StateError('Cannot execute, execution already in process.');
    }
    _locked = true;

    // Check for cancellations
    _cancelled = await _shouldCancel();
    var shouldProceed = !_cancelled;
    _deferCompleter.complete(shouldProceed);
    if (shouldProceed) {
      // Wait for any execution deferrals.
      await _maybeWait();
      _executeAndAttach(exec);
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
    }
  }

  Future _maybeWait() {
    // Don't wait for the deferrals if the execution has been stayed.
    return Future.wait(_executionDeferrals);
  }

  Future<bool> _shouldCancel() async =>
      Future.wait(_futureCancellations).then((results) => results.any((cancel) {
            return cancel == true;
          }));

  void _executeAndAttach(dynamic /* AsyncExecutor|Executor */ exec) {
    var execResult = exec();
    _done = true;
    if (execResult is Future) {
      _attachFuture(execResult);
    } else {
      _executeCompleter.complete(execResult);
    }
  }

  void _attachFuture(Future future) {
    future
      ..then(_executeCompleter.complete)
      ..catchError(_executeCompleter.completeError);
  }
}
