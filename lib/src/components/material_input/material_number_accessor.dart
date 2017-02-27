// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../utils/angular/properties/properties.dart';
import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

import 'base_material_input.dart';
import 'material_input.dart';
import 'material_input_default_value_accessor.dart';
import 'material_number_validators.dart';

export 'material_number_validators.dart';
export 'material_input.dart' show MaterialInputComponent;

const List<Type> materialNumberInputDirectives = const [
  CheckIntegerValidator,
  LowerBoundValidator,
  MaterialInputComponent,
  MaterialNumberValueAccessor,
  MaterialNumberValidator,
  PositiveNumValidator,
  CheckNonNegativeValidator,
  UpperBoundValidator
];

/// [ControlValueAccessor] which will coerce an input into a [num].
///
/// Accessor always sets the raw [String] value that is set from the input, but
/// only sets the value of a [Control] if the input could be parsed.
///
/// `keypressUpdate` attribute has the value update on every keypress while
/// the default is the value only updating on a blur event.
@Directive(selector: 'material-input[type=number],material-input[type=percent]')
class MaterialNumberValueAccessor extends BaseMaterialInputValueAccessor
    implements ControlValueAccessor, OnDestroy {
  final NumberFormat _numberFormat = new NumberFormat.decimalPattern();
  final Stream _updateStream;
  final bool _checkInteger;

  MaterialNumberValueAccessor(
      BaseMaterialInput input,
      @Self() NgControl control,
      @Attribute('keypressUpdate') String keypressUpdate,
      @Attribute('checkInteger') String integer)
      : _updateStream =
            getBool(keypressUpdate ?? false) ? input.onKeypress : input.onBlur,
        _checkInteger = getBool(integer ?? false),
        super(input, control);

  @override
  void writeValue(newValue) {
    if (_parseNumber(input.inputText) != newValue) {
      // If the numeric value of the current input text doesn't equal to the
      // new numeric value, update the input text accordingly.
      super.writeValue(newValue == null ? '' : _numberFormat.format(newValue));
    }
  }

  @override
  void registerOnChange(callback) {
    disposer.addStreamSubscription(_updateStream.listen((_) {
      final rawValue = input.inputText;
      final value = _parseNumber(rawValue);
      // Pass the rawValue and the num value. This allows validators to process
      // whichever one they would like.
      callback(value, rawValue: rawValue);
    }));
  }

  num _parseNumber(String input) {
    try {
      if (_checkInteger && input.contains(_numberFormat.symbols.DECIMAL_SEP)) {
        // Invalid value no longer an integer
        return null;
      }
      final value = _numberFormat.parse(input);
      return _checkInteger ? value.toInt() : value;
    } on FormatException {
      return null;
    }
  }
}

@Directive(
    selector: 'material-input[type=number]:not([checkInteger]),'
        'material-input[type=percent]:not([checkInteger])',
    providers: const [
      const Provider(NG_VALIDATORS,
          useExisting: MaterialNumberValidator, multi: true)
    ])
class MaterialNumberValidator implements Validator {
  /// Validation that works in concert with the number accessor.
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    assert(control is Control);
    // If the control doesn't have a value, but had a value from the input then
    // it is considered an error. Producing error here as accessors can't easily
    // add errors themselves, but validators can.
    if (control.value == null && !isEmpty((control as Control).rawValue)) {
      return {'material-input-number-error': inputIsNotNumberMsg()};
    }
    return null;
  }

  static String inputIsNotNumberMsg() => Intl.message('Enter a number',
      desc: 'Error message when input is not a number.',
      meaning: 'Error message when input is not a number.');
}

/// [Validator] which will validate a number input is an integer.
@Directive(
    selector: 'material-input[type=number][checkInteger],'
        'material-input[type=percent][checkInteger]',
    providers: const [
      const Provider(NG_VALIDATORS,
          useExisting: CheckIntegerValidator, multi: true)
    ])
class CheckIntegerValidator implements Validator {
  /// Validation that works in concert with the number accessor.
  @override
  Map<String, dynamic> validate(AbstractControl abstractControl) {
    assert(abstractControl is Control, 'Can only be used with a Control');
    final control = abstractControl as Control;
    // Handled by accessor validator or value set by forms system
    if (control.value == null && !isEmpty(control.rawValue)) {
      return {'check-integer': numberIsNotIntegerMsg()};
    }
    return null;
  }

  static String numberIsNotIntegerMsg() => Intl.message('Enter an integer',
      desc: 'Error message when input number is not an integer.',
      meaning: 'Error message when input number is not an integer.');
}
