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

  /// This constructor can be used when creating an SVG icon.
  /// Usage instructions: Set the 'icon' in the component you are using to
  /// this blank icon. Use the following svg-icon mixin to render your svg
  /// file as an icon:
  /// http://google3/third_party/dart_src/acx/material_icon/lib/_mixins.scss?l=45
  ///
  /// The icon name is set to an empty string because the material-icon
  /// styling must be preserved in order to properly render the SVG as a
  /// background-image in place of the material font icon.
  const Icon.blank() : name = '';
}
