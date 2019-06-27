// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// An action whose lifecycle states may be controlled and deferred by
/// receivers.
///
/// The action moves through the following states.
/// 1. creation
/// 2. reception
/// 3. execution
/// 4. completion
///
/// *Creation* The action is created by the broadcaster.
///
/// *Reception* Event is added to a stream or otherwise broadcast to receivers
/// for the chance to cancel or defer action execution.
///
/// *Execution* The broadcaster's execution closure is run, only if all
/// `whetherToCancel` futures return false, and after all `deferExecution`
/// futures complete.
///
/// *Completion* The action has either executed or has been cancelled.
///
/// Receivers may cancel an action before execution and can do so asynchronously
/// by registering a future via [cancelIf] (or synchronously via [cancel]).
///
/// The execution of the action can be delayed by registering a Future via
/// [defer]. Deferring futures are only
///
/// Finally, receivers and the broadcaster may run code after the action has
/// executed (or has been cancelled), via the [onDone] future.
///
/// Usage is as follows:
///
/// Component Firing Event:
///     var ctrl = new AsyncActionController();
///     streamCtrl.add(ctrl.action);
///     ctrl.execute((shouldProceed) {
///       // `shouldProceed` is true only if `whetherToCancel` futures all
///       // returned false.
///     }
///
///     return ctrl.action.onDone.then((completed) {
///       // Clean up.
///       if (completed) {
///       } else {
///       }
///     }
///
/// Subscribing Component
///
///     <my-component (saveEvent) = "onSave($event)">
///
///     class MyComponent {
///       void onSave(AsyncAction action) {
///         // possibly cancel the action.
///         action.cancelIf(whetherToCancelFuture));
///         // lazily defer the action.
///         action.defer(action.onDefer.then(someAsyncMethod));
///         // do something after the action has executed.
///         action.onDone.then(onEventComplete);
///       }
///     }
///
/// <V> is the value type returned/resolved by the execution closure.
class AsyncAction<V> {
  final Future<V> _onDone;
  final Future<bool> _onDefer;
  final List<Future<bool>> _futureCancellations;
  final List<Future<dynamic>> _executionDeferrals;
  final Function _cancelledGetter;
  final Function _lockedGetter;
  final Function _doneGetter;

  bool _syncCancelled = false;
  bool get _waitingForDone => _lockedGetter();

  AsyncAction(
      this._onDone,
      this._onDefer,
      this._futureCancellations,
      this._executionDeferrals,
      this._lockedGetter,
      this._cancelledGetter,
      this._doneGetter);

  /// Indicates whether the action has been cancelled.
  bool get cancelled => _syncCancelled || _cancelledGetter();

  /// Indicates that the action has either completed or was cancelled.
  bool get isDone => _doneGetter();

  /// Future which resolves to null if the action is cancelled. If the execution
  /// is not cancelled, the future resolves to whatever the execution returns.
  Future<V> get onDone => _onDone;

  /// A Future which resolves only if an action has not been cancelled, and
  /// and before the action execution. Use this future to begin a chain for
  /// [#defer].  Beginning a chain with this future allows for lazy evaluation
  /// of the deferring future.
  /// This future resolves to false if the action has been cancelled. If the
  /// action is cancelled, no futures registered with [defer] will be awaited
  /// before resolving the [onDone] future.
  Future<bool> get onDefer => _onDefer;

  /// Register [whetherToCancel] to later decide whether to [cancel]. It is
  /// expected that whatever async processing required to determine whether to
  /// cancel the action is started by the action receiver. The resolved value
  /// will only be looked at once the action broadcaster has attempted to
  /// execute.
  ///
  /// If [whetherToContinue] returns true, the action will be cancelled.
  void cancelIf(Future<bool> whetherToCancel) {
    // Do nothing, it will be cancelled anyway.
    if (cancelled) return;

    if (isDone) {
      throw StateError('Cannot register. Action is complete.');
    }

    // Don't allow more registrations.
    if (_waitingForDone) {
      throw StateError('Cannot register. Already waiting.');
    }

    // Register a future.
    _futureCancellations.add(whetherToCancel);
  }

  /// Synchronously cancel the action. Once called, all future calls to
  /// [cancelIf] and [defer] will have no effect, nor will any futures
  /// previously registered with [cancelIf] be awaited before resolving the
  /// [onDefer] and [onDone] futures.
  void cancel() {
    if (cancelled) return;

    // Don't allow more registrations.
    if (isDone) {
      throw StateError('Cannot register. Action is complete.');
    }

    if (_waitingForDone) {
      throw StateError('Cannot register. Already waiting.');
    }

    _syncCancelled = true;
    _futureCancellations
      ..clear()
      ..add(Future.value(true));
  }

  /// Defer the action execution, if the action is not already executed or
  /// canceled. Use [onDefer] to delay starting your executionDeferral until the
  /// action is ready to execute.
  ///
  /// Example:
  ///     asyncEvent.defer(asyncEvent.onDefer.then((_) {
  ///       return doSomeAsyncThingThatDelaysTheEvent();
  ///     });
  void defer(Future<dynamic> executionDeferral) {
    // Do nothing, it will be cancelled anyway.
    if (cancelled) return;

    // Don't allow more registrations.
    if (isDone) {
      throw StateError('Cannot register. Action is complete.');
    }

    if (_waitingForDone) {
      throw StateError('Cannot register. Already waiting.');
    }

    // Register a future.
    _executionDeferrals.add(executionDeferral);
  }
}
