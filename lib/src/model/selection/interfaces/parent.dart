// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// **NOTE**: This library is currently unused and will replace select.dart.

import 'dart:async';

/// Interface implemented by classes that may have nodes with children.
abstract class Parent<P, C> {
  /// Whether the [item] of parent type [P] has child a child entity [C].
  bool hasChildren(P item);

  /// Returns a stream that results in child entity [C] of [parent].
  ///
  /// Should throw [StateError] if [hasChildren] for [parent] is `false`.
  Stream<C> getChildren(P parent);
}
