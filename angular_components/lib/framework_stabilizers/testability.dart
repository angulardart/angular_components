// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library angular_components.framework_stabilizers.testability;

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
  String get name;
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
  @override
  void register() {
    FrameworkStabilizers.add(whenStable);
  }

  /// Hook for tests to register an [IsStableCallback] that is called when
  /// a stable state is reached.
  @override
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
    Zone.root.run(() {
      if (!isStable) {
        if (newCallback != null) _callbacks.add(newCallback);
        return;
      }

      Future(() {
        if (newCallback != null) newCallback(false, name);
        while (_callbacks.isNotEmpty) {
          (_callbacks.removeLast())(true, name);
        }
      });
    });
  }

  /// Returns true if the framework is in a stable state, false otherwise.
  @override
  bool get isStable;

  /// Name of the testability. Defaults to the runtimeType.
  ///
  /// Subclasses should redefine this. runtimeType is obsfucated when compiled.
  @override
  String get name => this.toString();
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
    throw UnsupportedError('not supported by NullTestability');
  }

  @override
  bool get isStable {
    throw UnsupportedError('not supported by NullTestability');
  }

  @override
  String get name {
    throw UnsupportedError('not supported by NullTestability');
  }
}
