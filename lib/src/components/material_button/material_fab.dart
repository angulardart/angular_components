// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:angular2/angular2.dart';

import '../material_ripple/material_ripple.dart';

import 'material_button_base.dart';

// TODO(google): Right now we use is-raised and isDisabled for CSS styling.
// When Angular supports conditionally adding/removing an attribute, use.
// See https://github.com/angular/angular/issues/2869.

/// Material FAB is a Floating Action Button. It is round, and behaves mostly
/// the same as a MaterialButton.
///
/// It may be flat or raised. A raised button is styled with a shadow.
///
/// __Example usage:__
///     <!-- A Floating Action Button (FAB). -->
///     <material-fab aria-label="add">
///       <glyph icon="add"></glyph>
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
      '[class.is-disabled]': 'disabled',
      '[class.is-raised]': 'raised',
      '(mousedown)': r'onMouseDown($event)',
      '(mouseup)': r'onMouseUp($event)',
      '(click)': r'handleClick($event)',
      '(keypress)': r'handleKeyPress($event)',
      '(focus)': r'onFocus($event)',
      '(blur)': r'onBlur($event)',
      '[attr.aria-disabled]': 'disabledStr',
      '[attr.tabindex]': 'tabIndex',
      'role': 'button',
      '[attr.elevation]': 'zElevation',
      'animated': 'true'
    },
    inputs: const ['disabled', 'raised'],
    outputs: const ['trigger'],
    directives: const [MaterialRippleComponent],
    templateUrl: 'material_button.html',
    styleUrls: const ['material_fab.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialFabComponent extends MaterialButtonBase {
  final ChangeDetectorRef _changeDetector;
  MaterialFabComponent(ElementRef element, this._changeDetector)
      : super(element);

  @override
  void focusedStateChanged() {
    _changeDetector.markForCheck();
  }
}
