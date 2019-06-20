// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/focus/focus_interface.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/mixins/button_wrapper.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// A button styled specifically for dropdowns.
///
/// By default, this button is rendered with a triangle icon and an underline.
/// The component itself does not have a popup itself but can be used to build
/// dropdowns that are not provided. Use `material-dropdown-select` for a
/// component that has the same button style, and implements the dropdown
/// itself.
@Component(
  selector: 'dropdown-button',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'dropdown_button.html',
  styleUrls: [
    'package:angular_components/button_decorator/button_decorator.scss.css',
    'dropdown_button.scss.css'
  ],
  directives: [
    ButtonDirective,
    GlyphComponent,
    KeyboardOnlyFocusIndicatorDirective,
    NgIf,
  ],
  providers: [
    ExistingProvider(HasDisabled, DropdownButtonComponent),
    ExistingProvider(Focusable, DropdownButtonComponent),
  ],
)
class DropdownButtonComponent extends Object
    with FocusableMixin, MaterialButtonWrapper
    implements OnInit {
  String _role;
  String _ariaRole;

  DropdownButtonComponent() {
    iconName = 'arrow_drop_down';
  }

  ButtonDirective _button;

  @ViewChild(ButtonDirective)
  set button(ButtonDirective b) {
    _button = b;
    focusable = b;
  }

  String get role => _role;

  /// The ARIA role of the dropdown button.
  @Input()
  set role(String value) {
    assert(
        ariaRole == null, 'Aria role can only be set before initialization.');
    _role = value;
  }

  String get ariaRole => _ariaRole;

  @override
  void ngOnInit() {
    _ariaRole = role ?? 'button';
  }

  /// The value for aria-haspopup.
  ///
  /// See https://www.w3.org/TR/wai-aria-1.1/#aria-haspopup for valid values.
  @Input()
  String popupType = 'dialog';

  /// An error displayed below the button.
  ///
  /// The button also gets a red underline when this is set.
  @Input()
  String error;

  /// The id of the content of the dropdown.
  @Input()
  String ariaOwns;

  /// True if the dropdown is expanded.
  @Input()
  bool ariaExpanded;

  /// The id of the active element of the dropdown.
  @Input()
  String ariaActiveDescendant;

  /// A unique id for the button element.
  final String uuid = SequentialIdGenerator.fromUUID().nextId();

  String _ariaLabelledBy;

  /// The id of an element that additionally describes the button.
  ///
  /// For example, a text element that says "results per page" for a dropdown
  /// with numerical options.
  @Input()
  set ariaLabelledBy(String labelledBy) => _ariaLabelledBy = labelledBy;

  /// The aria-labelledby value to apply to the button, or null.
  ///
  /// Must also include the id of the button to read both.
  String get ariaLabelledBy =>
      _ariaLabelledBy == null ? null : '$_ariaLabelledBy $uuid';

  @Input()
  String ariaDescribedBy;

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

  /// Event that fires when the dropdown button is blurred.
  @Output('blur')
  Stream<FocusEvent> get onBlur => _blur.stream;
  final _blur = StreamController<FocusEvent>(sync: true);

  void handleBlur(FocusEvent event) {
    _blur.add(event);
  }

  /// Event fired when the button is clicked or keyboard activated.
  @Output()
  Stream<UIEvent> get trigger => _button.trigger;

  /// Is the component tabbable.
  @Input()
  bool tabbable = true;
}
