// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/interfaces/has_disabled.dart';

// TODO(google): This copies a lot of values from material-input, and yet
// material-input doesn't use it. Consider refactoring so that these
// values aren't copied.
/// Properties for a component which wants to expose typical options for a
/// input. See MaterialInput for fields definition.
class MaterialInputWrapper implements HasDisabled {
  /// A custom character counter function.
  ///
  /// Takes in the input text; returns how many characters the text should be
  /// considered as.
  @Input()
  Function characterCounter;

  @Deprecated('Use forms API instead')
  @Input()
  Function checkValid;

  /// Whether this input is disabled.
  @Input()
  bool disabled = false;

  /// Whether to display error, hint text, and character counter panel.
  @Input()
  bool displayBottomPanel = true;

  /// Error to be displayed.
  ///
  /// Higher precedent than all other errors which may be on this input.
  @Input()
  String error;

  /// Whether or not the label "floats".
  ///
  /// If false, the label disappears when text is entered into the box. If true,
  /// it instead "floats" up above the input.
  @Input()
  bool floatingLabel = false;

  /// The hint to be shown on the input.
  ///
  /// This text will not be displayed if there is an error message on the input.
  @Input()
  String hintText;

  /// Any text to show at the leading edge of the input -- e.g. a currency
  /// symbol or similar.
  @Input()
  String leadingText;

  /// Maximum allowed characters for character counting input box.
  ///
  /// Character count always is displayed when the value is non-null.
  @Input()
  int maxCount;

  /// Whether or not the hint text will be displayed when the input is not
  /// focused.
  ///
  /// Defaults to false.
  @Input()
  bool showHintOnlyOnFocus = false;

  /// Whether or not the input is required.
  ///
  /// If there's no input text, a required input will show a validation error
  /// when it's first blurred.
  @Input()
  bool required = false;

  /// Custom error message to show when the field is required and blank.
  @Input()
  String requiredErrorMsg;

  /// Whether the input contents should be always right aligned.
  ///
  /// Default value is `false`.
  @Input()
  bool rightAlign = false;

  /// Any text to show at the trailing edge of the input -- e.g. a currency
  /// symbol or similar.
  @Input()
  String trailingText;

  /// Any persistent glyph to show before the input box.
  @Input()
  String leadingGlyph;

  /// Any persistent glyph to show at the end of the input box.
  @Input()
  String trailingGlyph;

  // Set is added to allow the base classes to override this functionality.
  /// The label to use on the input.
  @Input()
  String label;

  String _ariaLabel;
  String get ariaLabel => _ariaLabel ?? label;
  // Set is added to allow the base classes to override this functionality.
  /// The label to use for assistive technology.
  ///
  /// If not provided, uses the label instead.
  @Input()
  set ariaLabel(String value) {
    _ariaLabel = value;
  }

  String _inputText;
  String get inputText => _inputText;
  // Set is added to allow the base classes to override this functionality.
  /// The text the input should have.
  ///
  /// Consider using the angular_forms [NgModel] instead.
  @Input()
  set inputText(String value) {
    _inputText = value;
  }
}
