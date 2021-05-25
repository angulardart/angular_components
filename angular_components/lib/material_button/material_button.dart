// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/theme/dark_theme.dart';

import 'material_button_base.dart';

/// A flat or raised button with an optional ripple effect.
///
/// __Attributes:__
///
/// The following attributes are commonly used with `<material-button>`:
///
/// - `icon`: If present, removes the minimum width style of the button.
///   To specify the actual icon in the button, use a `<glyph>`,
/// `<material-icon>`, or `<img>`.
/// - `no-ink`: If present, removes the ripple effect from the button.
/// - `clear-size`: If present, removes both `min-width` and `margin` from
///   the button.
/// - `dense`: If present, reduces `font-size` to 13px and button height to
///   32px.
///
/// __Styling:__
///
/// The preferred way of specifying button colors is to use mixins:
///
/// ```
/// /* Make #myButton green with yellow text */
/// @include button-background-color('#myButton', green);
/// @include button-color('#myButton', yellow);
/// ```
///
/// The advantage of using mixins for color is that they will not overwrite the
/// disabled state colors. You can also style the button with CSS as you would a
/// normal DOM element, although this will also affect the disabled state:
///
/// ```
/// /* Make #myButton green with yellow text */
/// #myButton {
///   background: green;
///   color: yellow;
/// }
/// ```
///
/// By default the ripple is the same color as the foreground at 25% opacity.
/// To customize the color, use the `material-ripple` selector:
///
/// ```
/// /* Make #myButton use a blue ripple instead of foreground color */
/// #myButton material-ripple {
///   color: blue;
/// }
/// ```
///
/// The opacity of the ripple is not customizable via CSS.
///
/// __See also:__
///
/// Examples:
/// * [dart-lang/io_2017_components_codelab repo](https://github.com/dart-lang/io_2017_components_codelab/tree/master)
///
/// Other resources:
/// * [Material design codelab](https://codelabs.developers.google.com/codelabs/your-first-angulardart-web-app/)
///
// NOTE: CSS code above doesn't use ```css due to
// https://github.com/dart-lang/dartdoc/issues/1484.
@Component(
  selector: 'material-button',
  directives: [MaterialRippleComponent],
  templateUrl: 'material_button.html',
  providers: [
    AcxDarkTheme,
    ExistingProvider(ButtonDirective, MaterialButtonComponent),
    ExistingProvider(HasDisabled, MaterialButtonComponent),
  ],
  styleUrls: ['material_button.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialButtonComponent extends MaterialButtonBase {
  final ChangeDetectorRef _changeDetector;

  @override
  void focusedStateChanged() {
    _changeDetector.markForCheck();
  }

  MaterialButtonComponent(HtmlElement element, AcxDarkTheme darktheme,
      this._changeDetector, @Attribute('role') String role)
      : super(element, role) {
    if (_changeDetector == null) throw Exception('Expecting change detector');
    darktheme.themeElement(element);
  }

  @HostBinding('attr.disabled')
  @visibleForTemplate
  String get hostDisabled => disabled ? "" : null;

  @HostBinding('attr.raised')
  @visibleForTemplate
  String get hostRaised => raised ? "" : null;

  @HostBinding('class.is-focused')
  @visibleForTemplate
  bool get hostClassIsFocused => visualFocus;

  @HostBinding('attr.elevation')
  @visibleForTemplate
  String get hostElevation => '$zElevation';

  @HostBinding('attr.animated')
  @visibleForTemplate
  static const String hostAnimated = 'true';

  // not used for M1
  final String ariaLabel = null;
}
