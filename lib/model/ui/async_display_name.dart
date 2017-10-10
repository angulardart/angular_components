// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// All implementations of ComparisionPredicate that need asynchronous display
/// names must implement HasAsyncDisplayName.
abstract class HasAsyncDisplayName {
  /// A future that resolves when a display name is available for rendering.
  /// For example, when filtering by an identifier, an asynchronous formatter
  /// could fetch relevant data from API to format the identifier.
  Future<String> get asyncDisplayName;
}
