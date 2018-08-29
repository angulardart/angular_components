// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

abstract class ActivationHandler<T> {
  /// Called when a [value] is activated as a result of [event].
  ///
  /// Returns whether or not the activation was handled.
  bool handle(UIEvent event, T value);
}
