// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/mixins/button_wrapper.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';

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
///  - `showButtonBorder: bool` - Whether to show the bottom border of the
///   dropdown button.
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
  styleUrls: const [
    'package:angular_components/button_decorator/button_decorator.scss.css',
    'dropdown_button.scss.css'
  ],
  directives: const [
    ButtonDirective,
    GlyphComponent,
    KeyboardOnlyFocusIndicatorDirective,
    NgIf,
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class DropdownButtonComponent extends Object
    with FocusableMixin, MaterialButtonWrapper {
  DropdownButtonComponent() {
    iconName = 'arrow_drop_down';
  }

  ButtonDirective _button;

  @ViewChild(ButtonDirective)
  set button(ButtonDirective b) {
    _button = b;
    focusable = b;
  }

  /// An error displayed below the button.
  ///
  /// The button also gets a red underline when this is set.
  @Input()
  String error;

  bool get invalid => error != null;

  /// Whether to show the bottom border of the dropdown button.
  @Input()
  set showButtonBorder(bool value) {
    _showButtonBorder = value;
  }

  bool get showButtonBorder {
    if (_showButtonBorder != null) return _showButtonBorder;
    // If the input field is not specified, maitain backwards compatible
    // behavior, which decides based on whether the text is null.
    return buttonText != null;
  }

  bool _showButtonBorder;

  @Output('blur')
  Stream<FocusEvent> get onBlur => _blur.stream;
  final _blur = new StreamController<FocusEvent>(sync: true);

  void handleBlur(FocusEvent event) {
    _blur.add(event);
  }

  @Output()
  Stream<UIEvent> get trigger => _button.trigger;
}
