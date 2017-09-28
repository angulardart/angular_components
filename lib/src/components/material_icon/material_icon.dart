// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import '../../model/ui/icon.dart';

/// Icons that should be horizontally flipped when the direction is RTL.
///
/// Please add to this list as needed.
const List<String> _flippedIcons = const [
  'arrow_back',
  'arrow_forward',
  'chevron_left',
  'chevron_right',
  'navigate_before',
  'navigate_next',
  'last_page',
  'first_page',
  'open_in_new',
  'exit_to_app',
];

/// A material style icon.
///
/// __Example usage:__
///
///     <material-icon
///         icon="android">
///     </material-icon>
///
/// This stylesheet should be included at the top of the page:
///
/// ```html
/// <link
///     rel="stylesheet"
///     type="text/css"
///     href="https://fonts.googleapis.com/icon?family=Material+Icons">
/// ```
///
/// Make sure to take RTL into account. Specifically, use the [flip] attribute
/// if the icon should be flipped for RTL UIs. Read [these
/// guidelines](https://material.io/guidelines/usability/bidirectionality.html#bidirectionality-rtl-mirroring-guidelines)
/// for advice on when and when not to flip the icon.
///
/// __Attributes:__
///
/// - `size: String` -- The size of the icon. Options are: x-small, small,
///   medium, large, and x-large, corresponding to 12px, 13px, 16px, 18px, and
///   20px, respectively. If no size is specified, the default of 24px is used.
/// - `flip` -- Whether the icon should be flipped for RTL languages.
/// - `light` -- Whether the opacity of the icon should be reduced.
///
/// __Inputs:__
///
/// - `icon: Icon|String` -- The `Icon` model
///   (lib/src/model/ui/icon.dart) or icon identifier (String) this
///   component should display.
@Component(
    selector: 'material-icon',
    templateUrl: 'material_icon.html',
    styleUrls: const ['material_icon.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class MaterialIconComponent {
  /// The `Icon` model (lib/src/model/ui/icon.dart) or icon
  /// identifier (String) this component should display.
  ///
  /// See [https://www.google.com/design/icons/](https://goo.gl/YKrYlu) for
  /// available icons.
  @Input()
  set icon(dynamic value) {
    _icon = value;
    if (_flippedIcons.contains(iconName)) {
      _element.setAttribute('flip', '');
    }
  }

  dynamic _icon;

  /// The icon identifier.
  String get iconName => _icon is Icon ? _icon.name : _icon;

  final HtmlElement _element;

  MaterialIconComponent(this._element);
}

/// The values that can be used as sizes for a [MaterialIconComponent].
class IconSize {
  static const defaultSize = '';
  static const xSmall = 'x-small';
  static const small = 'small';
  static const medium = 'medium';
  static const large = 'large';
  static const xLarge = 'x-large';

  static const values = const [
    defaultSize,
    xSmall,
    small,
    medium,
    large,
    xLarge
  ];
}
