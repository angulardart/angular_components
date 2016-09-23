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

@JS()
library angular2_components.framework_stabilizers;

import 'dart:js';

import 'package:js/js.dart';

/// Function provided by a framework to register an [IsStableCallback] that is
/// invoked by the framework when it reaches a stable state.
typedef void FrameworkStabilizer(IsStableCallback callback);

/// Function invoked by a framework when it has reached a stable state. The
/// `didWork` parameter indicates, if the framework did any work between
/// callback registration and callback invocation.
typedef void IsStableCallback(bool didWork);

// frameworkStabilizers is a property of the window object.
@JS('frameworkStabilizers')
external List get _frameworkStabilizersJs;

/// Provides a set of helper functions for frameworks to register and deregister
/// stabilizing functions. These functions will be called by tests, whenever
/// they require the page to be stable before they can perform the next action.
class FrameworkStabilizers {
  static final Map<int, dynamic> _idToFrameworkStabilizer = {};
  static int _nextId = 0;

  static List get _frameworkStabilizers {
    if (_frameworkStabilizersJs == null) {
      // TODO(google): switch this to
      //     "_frameworkStabilizersJs = []" when bug is resolved.
      context['frameworkStabilizers'] = new JsArray();
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