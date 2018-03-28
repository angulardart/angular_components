// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';

import 'material_button_base.dart';

/// Material FAB is a Floating Action Button. It is round, and behaves mostly
/// the same as a MaterialButton.
///
/// It may be flat or raised. A raised button is styled with a shadow.
///
/// __Example usage:__
///
/// ```
/// <!-- A Floating Action Button (FAB). -->
/// <material-fab aria-label="add">
///   <material-icon icon="add"></material-icon>
/// </material-fab>
/// ```
///
/// __Properties:__
///
/// - `disabled: bool` -- Whether the button should not respond to events, and
///   have a style that suggests that interaction is not allowed.
/// - `raised: bool` -- Whether to have a box-shadow that makes the button look
///   raised.
///
/// __Events:__
///
/// - `trigger: Event` -- Published when the button is activated via click or
///   keypress.
///
/// __Styling:__
///
/// The preferred way of specifying FAB colors is to use mixins:
///
/// ```
/// /* Make #myButton green with yellow icon */
/// @include button-background-color('#myButton', green);
/// @include icon-button-color('#myButton', yellow);
/// ```
///
/// The advantage of using mixins for color is that they will not overwrite the
/// disabled state colors. You can also style the FAB with CSS as you would a
/// normal DOM element, although this will also affect the disabled state:
///
/// ```
/// /* Make #myButton green with yellow icon */
/// #myButton {
///   background: green;
///   color: yellow;
/// }
/// ```
///
/// By default the ripple is the same color as the foreground at 25% opacity.
/// You may customize the color using this selector:
///
/// ```
/// /* Make #myButton use a blue ripple instead of foreground color */
/// #myButton material-ripple {
///   color: blue;
/// }
/// ```
///
/// The opacity of the ripple is not customizable via CSS.
@Component(
    selector: 'material-fab',
    host: const {
      '[attr.disabled]': r'disabled ? "" : null',
      '[attr.raised]': r'raised ? "" : null',
      '[class.is-focused]': 'visualFocus',
      '[class.is-pressed]': 'isPressed',
      'animated': 'true'
    },
    directives: const [MaterialRippleComponent],
    templateUrl: 'material_button.html',
    styleUrls: const ['material_fab.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    visibility: Visibility.local)
class MaterialFabComponent extends MaterialButtonBase {
  final ChangeDetectorRef _changeDetector;
  MaterialFabComponent(HtmlElement element, this._changeDetector)
      : super(element, null);

  bool get isPressed => isMouseDown || focused;

  @override
  void focusedStateChanged() {
    _changeDetector.markForCheck();
  }
}
