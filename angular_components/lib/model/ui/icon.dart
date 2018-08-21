// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Designates a model class which has a canonical _icon_ field.
abstract class HasIcon {
  Icon get uiIcon;
}

/// Designates a model class which has a canonical _icon_ field when it is
/// hovered.
abstract class HasHoverIcon {
  Icon get uiHoverIcon;
}

/// Simple container for icons. Models may implement this class, or the
/// `HasIcon` interface.
class Icon {
  final String name;

  const Icon(this.name);
}
