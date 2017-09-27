// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import '../material_ripple/material_ripple.dart';
import 'material_button_base.dart';

/// Material FAB is a Floating Action Button. It is round, and behaves mostly
/// the same as a MaterialButton.
///
/// It may be flat or raised. A raised button is styled with a shadow.
///
/// __Example usage:__
///     <!-- A Floating Action Button (FAB). -->
///     <material-fab aria-label="add">
///       <material-icon icon="add"></material-icon>
///     </material-fab>
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
/// Style the button with CSS as you would a normal DOM element.
///     /* Make #myButton green with yellow text */
///     #myButton {
///       background: green;
///       color: yellow;
///     }
///
/// By default the ripple is the same color as the foreground at 25% opacity.
/// You may customize the color using this selector:
///     /* Make #myButton use a blue ripple instead of foreground color */
///     #myButton material-ripple {
///       color: blue;
///     }
///
/// The opacity of the ripple is not customizable via CSS.
@Component(
    selector: 'material-fab',
    host: const {
      '[attr.disabled]': r'disabled ? "" : null',
      '[attr.raised]': r'raised ? "" : null',
      '[class.is-focused]': 'visualFocus',
      '[attr.elevation]': 'zElevation',
      'animated': 'true'
    },
    directives: const [MaterialRippleComponent],
    preserveWhitespace: false,
    templateUrl: 'material_button.html',
    styleUrls: const ['material_fab.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialFabComponent extends MaterialButtonBase {
  final ChangeDetectorRef _changeDetector;
  MaterialFabComponent(HtmlElement element, this._changeDetector)
      : super(element);

  @override
  void focusedStateChanged() {
    _changeDetector.markForCheck();
  }
}
