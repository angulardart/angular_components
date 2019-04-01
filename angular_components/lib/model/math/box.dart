// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Class for representing a box.
///
/// A box is specified as a top, right, bottom, and left. A box is useful for
/// representing margins and padding.
class Box {
  final int top;
  final int right;
  final int bottom;
  final int left;

  const Box({this.top = 0, this.right = 0, this.bottom = 0, this.left = 0});
}
