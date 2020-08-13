// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Represents the state of expansion of an option in a material tree.
///
/// If [expanded] is true, then the option's children will be expanded.
/// The material tree will sync state with options inheriting from
/// MaterialTreeExpandState.
///
/// Pre-existing values will be overwritten if `MaterialTree.expandAll` is set
/// to true.
abstract class MaterialTreeExpandState {
  bool _pending = false;
  bool _expanded = false;

  /// Whether this option is expanded (or should be upon becoming visible)
  bool get expanded => _expanded;
  set expanded(bool expanded) {
    if (_expanded == expanded) return;
    _expanded = expanded;
    if (!_pending) {
      _pending = true;
      // Schedules a microtask (if one isn't pending already). This ensures that
      // any iterative code deciding the value of expanded doesn't flood the
      // stream with incidental events (only broadcasts when writing is done)
      scheduleMicrotask(() {
        _pending = false;
        _expandEvents.add(_expanded);
      });
    }
  }

  final _expandEvents = StreamController<bool>.broadcast(sync: true);
  Stream<bool> get expandEvents => _expandEvents.stream.distinct();
}
