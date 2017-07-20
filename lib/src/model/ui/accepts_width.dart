// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Interface for setting widgets programatically.
/// Preset width, 1 through 5. By default, width #2 is used.
/// Each width multiplies the base block width (64px on desktop and tablet) by
/// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
/// Set to 0 to have the list expand to fit its content.
/// Note: The spec clearly lays out predefined list sizes so use
/// the default, expanding size, sparingly.
abstract class AcceptsWidth {
  set width(dynamic val);
}
