// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import '../button_decorator/button_decorator.dart';
import '../material_ripple/material_ripple.dart';
import '../theme/dark_theme.dart';

import 'material_button_base.dart';

/// Material button is a button.
///
/// When the user touches the button, a ripple effect emanates from the point of
/// contact. It may be flat or raised. A raised button is styled with a shadow.
///
/// __Example usage:__
///     <material-button>Flat button</material-button>
///     <material-button raised>Raised button</material-button>
///     <material-button no-ink>No ripple effect</material-button>
///     <material-button disabled>Disabled</material-button>
///     <!-- With an icon -->
///     <material-button icon>
///       <material-icon icon="check"></material-icon>
///     </material-button>
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
///     #myButton gpu-ripple {
///       color: blue;
///     }
///
/// The opacity of the ripple is not customizable via CSS.
///
/// __Attributes:__
///
///   Button
/// - `disabled` -- Linked to the disabled property. If present, sets the
///    disabled property to true. If the disabled property is true, this
///    attribute will be present.
/// - `raised` -- Linked to the raised property. If present, sets the raised
///    property to true. If the raised property is true, this attribute will be
///    present.
/// - `icon` -- If present, removes the minimum width style of the button.
/// - `no-ink` -- If present, removes the ripple effect from the button.
/// - `clear-size` -- If present, removes both the min-width and margin from
///   the button.
/// - `dense` -- If present, font-size is reduced to 13px and button height to
///   32px.
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
