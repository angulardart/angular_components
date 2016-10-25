// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// A container which controls the visibility of its content via a Stream.
///
/// This allows content to defer its view creation until it is actually visible.
/// The `DeferredContentDirective` is a directive which looks for a parent
/// providing this stream and creates/clears its view based on the stream.
abstract class DeferredContentAware {
  /// Component publishes to this stream to control the visibility of contents.
  Stream<bool> get contentVisible;
}
