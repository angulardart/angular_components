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
library angular2_components.framework_stabilizers.testability;

import 'dart:async';

import 'package:js/js.dart';

import 'framework_stabilizers.dart';

export 'framework_stabilizers.dart' show FrameworkStabilizer, IsStableCallback;

// We are getting the URL from JS land because Dart's URI.base is more expensive
@JS('window.location.href')
external String get _url;

/// Check if the enableTestabilities URL parameter is set to true.
final bool testabilitiesEnabled = _url.contains('enableTestabilities');

/// Interface for Testabilities that frameworks can provide for tests to wait
/// on the framework to be stable.
abstract class Testability {
  void register();
  void whenStable(IsStableCallback fn);
  bool get isStable;
}

/// Tesability base class that implements some of the rules for calling the
/// [IsStableCallback]s as defined by FrameworkStabilizers. The
/// extending frameworks are responsible for providing their own implementation
/// of [isStable] and they are responsible for calling [checkStable] whenever
/// they have potentially moved from an unstable to a stable state.
abstract class AbstractTestability implements Testability {
  final List<IsStableCallback> _callbacks = [];

  /// Registers the framework's [FrameworkStabilizer] function on the global
  /// window object to make it accessable in webdriver tests.
  void register() {
    FrameworkStabilizers.add(whenStable);
  }

  /// Hook for tests to register an [IsStableCallback] that is called when
  /// a stable state is reached.
  void whenStable(IsStableCallback fn) {
    _runCallbacksIfStable(newCallback: fn);
  }

  /// The extending framework needs to call [checkStable] whenever it has
  /// potentially reached a stable state. If a stable state is reached, the
  /// callbacks will be executed.
  void checkStable() {
    _runCallbacksIfStable();
  }

  /// Execute the registered callbacks if the framework reports to be stable. If
  /// the framework is not stable, this is a noop.
  void _runCallbacksIfStable({IsStableCallback newCallback}) {
    // Run in root zone to stop blocking activity ends.
    // See b/27282628 #8 for details.
    Zone.ROOT.run(() {
      if (!isStable) {
        if (newCallback != null) _callbacks.add(newCallback);
        return;
      }

      new Future(() {
        if (newCallback != null) newCallback(false);
        while (_callbacks.isNotEmpty) {
          (_callbacks.removeLast())(true);
        }
      });
    });
  }

  /// Returns true if the framework is in a stable state, false otherwise.
  bool get isStable;
}

/// A placeholder testability that does not perform any action. Can be injected
/// into an app to disable the testability feature altogether.
class NullTestability implements Testability {
  @override
  void register() {
    // Noop
  }

  @override
  void whenStable(IsStableCallback fn) {
    throw new UnsupportedError('not supported by NoopTestability');
  }

  @override
  bool get isStable {
    throw new UnsupportedError('not supported by NoopTestability');
  }
}
