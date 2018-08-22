// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library angular_components.framework_stabilizers.framework_stabilizers;

import 'dart:js';

import 'package:js/js.dart';

/// Function provided by a framework to register an [IsStableCallback] that is
/// invoked by the framework when it reaches a stable state.
typedef void FrameworkStabilizer(IsStableCallback callback);

/// Function invoked by a framework when it has reached a stable state. The
/// `didWork` parameter indicates, if the framework did any work between
/// callback registration and callback invocation.
typedef void IsStableCallback(bool didWork, String name);

// frameworkStabilizers is a property of the window object.
@JS('frameworkStabilizers')
external List get _frameworkStabilizersJs;

@JS('frameworkStabilizers')
external set _frameworkStabilizersJs(List values);

/// Provides a set of helper functions for frameworks to register and deregister
/// stabilizing functions. These functions will be called by tests, whenever
/// they require the page to be stable before they can perform the next action.
class FrameworkStabilizers {
  static final Map<int, dynamic> _idToFrameworkStabilizer = {};
  static int _nextId = 0;

  static List get _frameworkStabilizers {
    if (_frameworkStabilizersJs == null) {
      _frameworkStabilizersJs = [];
    }
    return _frameworkStabilizersJs;
  }

  /// Add a stabilize function for a framework.
  ///
  /// This function will be called
  /// whenever a test needs to wait for the framework to stabilize. When the
  /// framework is stable, it needs to call the [IsStableCallback] provided
  /// as an argument to the [FrameworkStabilizer].
  /// Rules for calling the callback by the framework:
  ///   - If a framework is already stable at the time of callback
  ///     registration, the callback should be called in the next event loop
  ///     iteration with the `didWork` parameter set to false.
  ///   - Otherwise, the callback should be called as soon as the framework is
  ///     stable with `didWork` set to true.
  ///   - A registered callback should never be called more than once.
  ///
  /// The id returned by [add] can be used to remove the [FrameworkStabilizer]
  /// with [remove].
  static int add(FrameworkStabilizer fn) {
    var wrappedFn = allowInterop(fn);
    var id = _nextId++;
    _idToFrameworkStabilizer[id] = wrappedFn;
    _frameworkStabilizers.add(wrappedFn);
    return id;
  }

  /// Removes the [FrameworkStabilizer] identified by [id].
  static bool remove(int id) {
    var wrappedFn = _idToFrameworkStabilizer.remove(id);
    return wrappedFn == null ? false : _frameworkStabilizers.remove(wrappedFn);
  }

  static void removeAll() {
    _idToFrameworkStabilizer.clear();
    _frameworkStabilizers.clear();
  }
}
