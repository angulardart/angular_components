// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_input/material_input_auto_select.dart';
import 'package:angular_components/material_input/material_input_multiline.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';

typedef ValidityCheck = String Function(String inputText);

/// This directive applies a custom Validator to any material-input that uses
/// the Forms API, and also has this directive.
///
/// It adds validation to ensure
/// that a given substring cannot be part of the input.
///
/// Usage:
///
///     <material-input textValidator="abc" [ngFormControl]="form">
///
/// This will prevent "abc" from being in the text controlled by 'form'.
@Directive(
  selector: '[textValidator]',
  providers: [ExistingProvider.forToken(NG_VALIDATORS, TextValidator)],
)
class TextValidator {
  @Input('textValidator')
  String text;
  Map<String, dynamic> call(AbstractControl c) {
    return (c.value != null && text != null && c.value.contains(text))
        ? {'material-input-error': 'cannot contain $text'}
        : null;
  }
}

String demoValidator(String inputText) {
  if (inputText.isEmpty) return null;

  if (inputText.contains('0')) return 'Input contains 0';

  if (inputText.length < 5) return 'Input should be at least 5 characters.';

  return null;
}

int countIgnoringAdCustomizers(String inputText) {
  String withoutAdCutomizers = inputText.replaceAll(
      RegExp(r'({=[^}]*}*)|({=[^}]*$)', caseSensitive: false), '');
  return withoutAdCutomizers.length;
}

@Component(
  selector: 'material-input-demo',
  templateUrl: 'material_input_demo.html',
  styleUrls: ['material_input_demo.scss.css'],
  directives: [
    formDirectives,
    AutoFocusDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    materialInputDirectives,
    MaterialMultilineInputComponent,
    MaterialInputAutoSelectDirective,
    materialNumberInputDirectives,
    MaterialPaperTooltipComponent,
    MaterialTooltipTargetDirective,
    NgIf,
    TextValidator,
  ],
  preserveWhitespace: true,
)
class MaterialInputDemoComponent {
  String manualUpdateInputText = '';
  String boundText = '';
  num numericValue = 88888;
  String urlValue;
  ValidityCheck get checkValid => demoValidator;
  Function get characterCount => countIgnoringAdCustomizers;
  Control form;
  bool showAuto = false;

  @ViewChild('manualSelectInput')
  MaterialInputComponent manualSelectInput;

  MaterialInputDemoComponent() {
    form = Control(
        'initial text',
        // add a secondary validator that prevents 'def' (to
        // illustrate that validators can come from multiple
        // sources, and all will be used)
        (TextValidator()..text = 'def'));
  }

  void logEvent(String type) {
    print('Listening to $type event.');
  }

  void onChange(String text) {
    manualUpdateInputText = text;
  }

  void resetForm() {
    form.reset(value: 'initial text');
  }

  void selectAllManualInput() {
    manualSelectInput.selectAll();
  }
}
