// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/theme/dark_theme.dart';

import 'material_button_base.dart';

/// A flat or raised button with an optional ripple effect.
///
/// ```html
/// <!-- A button with both icon and text -->
/// <material-button (trigger)="generateNames()">
///     <material-icon icon="lightbulb_outline"></material-icon>
///     Get new ideas
/// </material-button>
/// ```
///
/// ## Attributes
///
/// The following attributes are commonly used with `<material-button>`:
///
/// - `disabled`: If present, sets the [disabled] property to true. If the
///   `disabled` property is true, this attribute is present.
/// - `raised`:  If present, sets the [raised] property to true. If the
///   `raised` property is true, this attribute is present.
/// - `icon`: If present, removes the minimum width style of the button.
///   To specify the actual icon in the button, use a `<glyph>`,
/// `<material-icon>`, or `<img>`.
/// - `no-ink`: If present, removes the ripple effect from the button.
/// - `clear-size`: If present, removes both `min-width` and `margin` from
///   the button.
/// - `dense`: If present, reduces `font-size` to 13px and button height to
///   32px.
///
/// ## Properties
///
/// The following MaterialButtonComponent properties are frequently used:
///
/// - [disabled]: True if the button should not respond to events, and
///   should have a style that suggests that interaction is not allowed.
/// - [raised]: True if the button should have a box shadow that makes the
///   button look raised.
///
/// ## Events
///
/// To react to button clicks, handle the trigger event:
///
/// - [trigger]: Fired when the button is activated via click, tap, or
///   key press.
///
/// ## Styling
///
/// Style the button with CSS as you would a normal DOM element:
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
/// To customize the color, use the `gpu-ripple` selector:
///
/// ```
/// /* Make #myButton use a blue ripple instead of foreground color */
/// #myButton gpu-ripple {
///   color: blue;
/// }
/// ```
///
/// The opacity of the ripple is not customizable via CSS.
///
/// ## See also
///
/// Examples:
///
/// * [material_button_demo example](https://github.com/dart-lang/angular_components_example/tree/master/lib/src/material_button_demo)
/// * [demo_app/demo_app.html](https://github.com/dart-lang/angular_components_example/blob/master/lib/src/demo_app/demo_app.html)
/// * [dart-lang/io_2017_components_codelab repo](https://github.com/dart-lang/io_2017_components_codelab/tree/master)
///
/// Other resources:
/// * [Material design codelab](https://codelabs.developers.google.com/codelabs/your-first-angulardart-web-app/)
///
// NOTE: CSS code above doesn't use ```css due to
// https://github.com/dart-lang/dartdoc/issues/1484.
@Component(
    selector: 'material-button',
    host: const {
      '[attr.disabled]': r'disabled ? "" : null',
      '[attr.raised]': r'raised ? "" : null',
      '[class.is-focused]': 'visualFocus',
      '[attr.elevation]': 'zElevation',
      'animated': 'true'
    },
    directives: const [MaterialRippleComponent],
    templateUrl: 'material_button.html',
    providers: const [
      AcxDarkTheme,
      const Provider(ButtonDirective, useExisting: MaterialButtonComponent)
    ],
    styleUrls: const ['material_button.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class MaterialButtonComponent extends MaterialButtonBase {
  final ChangeDetectorRef _changeDetector;

  @override
  void focusedStateChanged() {
    _changeDetector.markForCheck();
  }

  MaterialButtonComponent(
      HtmlElement element, AcxDarkTheme darktheme, this._changeDetector)
      : super(element) {
    if (_changeDetector == null)
      throw new Exception('Expecting change detector');
    darktheme.themeElement(element);
  }
}
