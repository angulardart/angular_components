// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../utils/async/async.dart';
import '../button_decorator/button_decorator.dart';
import '../focus/keyboard_only_focus_indicator.dart';
import '../glyph/glyph.dart';
import '../mixins/button_wrapper.dart';

/// A button styled specifically for dropdowns.
///
/// By default, this button is rendered with a triangle icon and an underline.
///
/// __Properties:__
///
///  - `iconName: String` -- Material icon displayed on the right of the button.
///   Defaults to `arrow_drop_down`.
///  - `icon: Icon` -- `Icon` model instance.
///  - `buttonText: String` -- Text on the button.
///  - `buttonAriaLabel: String` - Optional aria label for the button.
///  - `disabled: bool` - Whether the button should be disabled.
///
/// __Events:__
///
/// - `trigger: Event` -- Published when the button is activated via click or
///   keypress.
@Component(
    selector: 'dropdown-button',
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dropdown_button.html',
    inputs: const [
      'buttonText',
      'buttonAriaLabel',
      'disabled',
      'icon',
      'iconName',
    ],
    styleUrls: const [
      '../button_decorator/button_decorator.scss.css',
      'dropdown_button.scss.css'
    ],
    directives: const [
      ButtonDirective,
      GlyphComponent,
      KeyboardOnlyFocusIndicatorDirective,
      NgIf,
    ])
class DropdownButtonComponent extends Object with MaterialButtonWrapper {
  DropdownButtonComponent() {
    iconName = 'arrow_drop_down';
  }

  @ViewChild(ButtonDirective)
  ButtonDirective button;

  @Output()
  LazyEventEmitter<FocusEvent> blur = new LazyEventEmitter<FocusEvent>();

  void onBlur(FocusEvent event) {
    blur.add(event);
  }

  @Output()
  LazyEventEmitter<FocusEvent> focus = new LazyEventEmitter<FocusEvent>();

  void onFocus(FocusEvent event) {
    focus.add(event);
  }

  @Output()
  LazyEventEmitter<UIEvent> get trigger => button.trigger;
}
