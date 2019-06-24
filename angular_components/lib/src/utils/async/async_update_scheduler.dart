// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// A callback registered with [AsyncNotifier].
typedef OnUpdateCallback = void Function();

/// An utility class for notifying ~once per VM turn to do an update action.
///
/// This is to handle patterns where many properties may be updated,
/// synchronously, such as through Angular property setters, but the user would
/// like to wait and apply an update once after they are all called.
///
/// Example:
///     class Foo {
///       String _bar;
///       String _baz;
///       AsyncUpdateScheduler _scheduler;
///
///       Foo() {
///         _scheduler = new AsyncUpdateScheduler(_doExpensiveWork);
///       }
///
///       String get bar => _bar;
///       set bar(String bar) {
///         if (bar != _bar) {
///           _bar = bar;
///           _scheduler.scheduleUpdate();
///         }
///       }
///
///       String get baz => _baz;
///       set baz(String baz) {
///         if (baz != _baz) {
///           _baz = baz;
///           _scheduler.scheduleUpdate();
///         }
///       }
///
///       // Will only be called once, even if both bar and baz are set.
///       void doExpensive() { ... }
///     }
class AsyncUpdateScheduler {
  final OnUpdateCallback _updateCallback;

  bool _isUpdateScheduled = false;
  StreamController<Null> _onUpdateStreamController;

  /// Creates a new scheduler, optionally with a callback.
  AsyncUpdateScheduler([this._updateCallback]);

  Stream<Null> get onUpdate {
    if (_onUpdateStreamController == null) {
      _onUpdateStreamController = StreamController.broadcast(sync: true);
    }
    return _onUpdateStreamController.stream;
  }

  /// Asynchronously schedule an action for later in the VM turn.
  ///
  /// Calling multiple times before one completes has no effect.
  void scheduleUpdate() {
    if (!_isUpdateScheduled) {
      _isUpdateScheduled = true;
      scheduleMicrotask(() {
        _isUpdateScheduled = false;
        if (_updateCallback != null) {
          _updateCallback();
        }
        if (_onUpdateStreamController != null) {
          _onUpdateStreamController.add(null);
        }
      });
    }
  }
}
