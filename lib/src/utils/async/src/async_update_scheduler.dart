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

library ads.acx2.utils.async.src.async_update_scheduler;

import 'dart:async';

/// A callback registered with [AsyncNotifier].
typedef void OnUpdateCallback();

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
  StreamController _onUpdateStreamController;

  /// Creates a new scheduler, optionally with a callback.
  AsyncUpdateScheduler([this._updateCallback]);

  Stream get onUpdate {
    if (_onUpdateStreamController == null) {
      _onUpdateStreamController = new StreamController.broadcast(sync: true);
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