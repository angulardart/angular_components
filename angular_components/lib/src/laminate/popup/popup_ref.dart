// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// A handle to manipulate an existing popup.
abstract class PopupRef {
  /// Whether the popup is currently visible.
  ///
  /// **NOTE**: This will not change until after open or close have completed.
  ///
  /// See [onVisibleChanged] for a stream of changes.
  bool get isVisible;

  /// An event stream that fires when the popup's visibility changes.
  ///
  /// **NOTE**: This will occur **after** open or close have completed.
  Stream<bool> get onVisibleChanged;
}
