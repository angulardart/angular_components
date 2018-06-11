// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A component or directive that can be programmatically focused.
///
/// Directive can manage if it means to put focus on root of itself
/// or meaningful component inside.
abstract class Focusable {
  /// Item/component focuses itself
  void focus();
}
