// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

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
  // TODO(google).
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
  ],
)
class DropdownButtonComponent extends Object with MaterialButtonWrapper {
  DropdownButtonComponent() {
    iconName = 'arrow_drop_down';
  }

  @ViewChild(ButtonDirective)
  ButtonDirective button;

  /// An error displayed below the button.
  ///
  /// The button also gets a red underline when this is set.
  @Input()
  String error;

  bool get invalid => error != null;

  @Output()
  Stream<FocusEvent> get blur => _blur.stream;
  final _blur = new StreamController<FocusEvent>(sync: true);

  void onBlur(FocusEvent event) {
    _blur.add(event);
  }

  @Output()
  Stream<FocusEvent> get focus => _focus.stream;
  final _focus = new StreamController<FocusEvent>(sync: true);

  void onFocus(FocusEvent event) {
    _focus.add(event);
  }

  @Output()
  Stream<UIEvent> get trigger => button.trigger;
}
