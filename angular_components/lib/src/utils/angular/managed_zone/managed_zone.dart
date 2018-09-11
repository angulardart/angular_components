// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular_components/utils/disposer/disposer.dart';

/// A generic implementation of managed zone that has no dependencies directly
/// on a framework like Angular. This makes it more testable than the VmTurnZone
/// provided by Angular.
@Deprecated('Use NgZone directly instead')
abstract class ManagedZone implements Disposable {
  /// Whether we are currently executing in the inner zone. This can be used by
  /// clients to optimize and call [runOutside] when needed.
  bool get inInnerZone;

  /// Whether we are currently executing in the outer zone. This can be used by
  /// clients to optimize and call [runInside] when needed.
  bool get inOuterZone;

  /// Whether [onTurnStart] has been triggered and [onTurnDone] has not.
  bool get isRunning;

  /// A synchronous stream that fires when the VM turn is finished, which means
  /// when the inner (managed) zone has completed it's private microtask queue.
  ///
  /// Note:
  /// - This won't wait for microtasks schedules in outer zones.
  /// - Causing any turn action, e.g., spawning a Future, within this zone will
  ///   cause an infinite loop.
  Stream get onTurnDone;

  /// A synchronous stream that fires when the last turn in an event completes.
  /// This indicates VM event loop end.
  ///
  /// Note:
  /// - This won't wait for microtasks schedules in outer zones.
  /// - Causing any turn action, e.g., spawning a Future, within this zone will
  ///   cause an infinite loop.
  Stream get onEventDone;

  /// A synchronous stream that fires when the VM turn has started, which means
  /// that the inner (managed) zone has not executed any microtasks.
  ///
  /// Note:
  /// - Causing any turn action, e.g., spawning a Future, within this zone will
  ///   cause an infinite loop.
  Stream get onTurnStart;

  /// Runs the code within [fn] inside of this zone. This may trigger an
  /// [onTurnStart] and [onTurnDone] event if you are outside the zone when
  /// calling. [onTurnStart] may be executed *after* executing [fn].
  ///
  /// If [inInnerZone] is true, [fn] is just called normally.
  T runInside<T>(T fn());

  /// Runs the code within [fn] outside of this zone.
  ///
  /// If [inOuterZone] is true, [fn] is just called normally.
  T runOutside<T>(T fn());
}

/// A partial implementation of [ManagedZone] without bindings to Angular.
abstract class ManagedZoneBase extends ManagedZone {
  StreamController _onTurnDoneController;
  StreamController _onTurnStartController;
  StreamController _onEventDoneController;
  Zone get innerZone;
  Zone get outerZone;

  bool _isRunning = false;

  void capturedTurnStart(dynamic event) {
    _isRunning = true;
    if (_onTurnStartController != null) {
      _onTurnStartController.add(null);
    }
  }

  void capturedTurnDone(dynamic event) {
    _isRunning = false;
    if (_onTurnDoneController != null) {
      _onTurnDoneController.add(null);
    }
  }

  void capturedEventDone(dynamic event) {
    if (_onEventDoneController != null) {
      _onEventDoneController.add(null);
    }
  }

  @override
  bool get isRunning => _isRunning;

  @override
  void dispose() {}

  @override
  bool get inInnerZone => Zone.current == innerZone;

  @override
  bool get inOuterZone => Zone.current == outerZone;

  @override
  Stream get onTurnStart {
    if (_onTurnStartController == null) {
      _onTurnStartController = StreamController.broadcast(sync: true);
    }
    return _onTurnStartController.stream;
  }

  @override
  Stream get onTurnDone {
    if (_onTurnDoneController == null) {
      _onTurnDoneController = StreamController.broadcast(sync: true);
    }
    return _onTurnDoneController.stream;
  }

  @override
  Stream get onEventDone {
    if (_onEventDoneController == null) {
      _onEventDoneController = StreamController.broadcast(sync: true);
    }
    return _onEventDoneController.stream;
  }

  @override
  T runInside<T>(T fn()) {
    if (inInnerZone) {
      return fn();
    } else {
      return innerZone.run(fn);
    }
  }

  @override
  T runOutside<T>(T fn()) {
    if (inOuterZone) {
      return fn();
    } else {
      return outerZone.run(fn);
    }
  }

  @override
  String toString() =>
      'ManagedZone ' +
      {'inInnerZone': inInnerZone, 'inOuterZone': inOuterZone}.toString();
}
