// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';

import '../../model/ui/icon.dart';

/// A component that creates a material style icon. Currently only font icons
/// are supported and
/// [material-icons-extended](https://www.google.com/design/icons/) is the only
/// supported font.
///
/// ## Usage
///
///     <glyph icon="android"></glyph>
///
/// This stylesheet should be included at the top of the page:
///
/// ```html
/// <link rel="stylesheet" type="text/css"
///     href="https://fonts.googleapis.com/icon?family=Material+Icons">
/// ```
/// __Attributes:__
///
/// - `size: string {x-small, small, medium, large, x-large}` -- Sizes names for
///   the icon, corresponding to 12px, 13px, 16px, 18px, and 20px, respectively.
///   If no size is specified, the default of 24px is used.
@Component(
    selector: 'glyph',
    templateUrl: 'glyph.html',
    styleUrls: const ['glyph.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class GlyphComponent {
  static const String _materialIconsExtended = 'material-icons-extended';

  /// `Icon` model (/model/ui/icon.dart) or Icon identifier - see
  /// [https://www.google.com/design/icons/](https://goo.gl/YKrYlu) for
  /// available icons.
  @Input()
  var icon;

  bool get _isIconModel => icon is Icon;

  String get iconName => _isIconModel ? icon.name : icon;

  /// The icon font to use. Default (and only) is **material-icons-extended**.
  String _iconSet;

  String get iconSet => _iconSet == null ? _materialIconsExtended : _iconSet;

  /// The set of icons to use. Only allowed value currently is
  /// `material-icons-extended`.
  ///
  @Input()
  set iconSet(String value) {
    assert(value == null || value == _materialIconsExtended);
    _iconSet = value;
  }

  bool _useMaterialIconsExtended = true;

  bool get useMaterialIconsExtended => _useMaterialIconsExtended;
}

/// Size names which can be used on the glyph icon.
class GlyphSize {
  static const DEFAULT = '';
  static const X_SMALL = 'x-small';
  static const SMALL = 'small';
  static const MEDIUM = 'medium';
  static const LARGE = 'large';
  static const X_LARGE = 'x-large';
  List<String> get values => [DEFAULT, X_SMALL, SMALL, MEDIUM, LARGE, X_LARGE];
}
