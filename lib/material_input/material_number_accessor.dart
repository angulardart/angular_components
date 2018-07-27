// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';

import 'base_material_input.dart';
import 'material_input.dart';
import 'material_input_default_value_accessor.dart';
import 'material_input_error_keys.dart';
import 'material_number_validators.dart';

export 'material_input.dart' show MaterialInputComponent;
export 'material_number_validators.dart';

const List<Type> materialNumberInputDirectives = [
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
/// Use [materialNumberInputDirectives] to get a set of directives to use with
/// the input to provide validations. Such as the default to ensure it is a
/// number, `checkInteger`, `checkPositive`, `checkNonNegative` (allows 0,)
/// `lowerBound`, and `upperBound`.
///
///
/// Accessor always sets the raw [String] value that is set from the input, but
/// only sets the value of a [Control] if the input could be parsed.
///
/// `keypressUpdate` attribute has the value update on every keypress while
/// the default is the value only updating on a blur event.
/// `blurFormat` attribute causes the input to be formatted on blur events.
@Directive(
  selector: 'material-input[type=number],material-input[type=percent]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialNumberValueAccessor extends BaseMaterialInputValueAccessor
    implements ControlValueAccessor, OnDestroy {
  final NumberFormat _numberFormat;
  final Stream _updateStream;
  final bool _checkInteger;

  factory MaterialNumberValueAccessor(
      BaseMaterialInput input,
      @Self() NgControl control,
      @Optional() NumberFormat numberFormat,
      @Attribute('changeUpdate') String changeUpdateAttr,
      @Attribute('keypressUpdate') String keypressUpdateAttr,
      @Attribute('checkInteger') String integer,
      @Attribute('blurFormat') String blurFormat) {
    var updateStream;
    final changeUpdate = attributeToBool(changeUpdateAttr, defaultValue: false);
    final keypressUpdate =
        attributeToBool(keypressUpdateAttr, defaultValue: false);
    assert(!(changeUpdate && keypressUpdate),
        'Cannot update both on keypress and change.');
    if (changeUpdate) {
      updateStream = input.onChange;
    } else if (keypressUpdate) {
      updateStream = input.onKeypress;
    } else {
      updateStream = input.onBlur;
    }
    numberFormat ??= NumberFormat.decimalPattern();
    final checkInteger = attributeToBool(integer, defaultValue: false);
    return MaterialNumberValueAccessor._(
        updateStream,
        checkInteger,
        numberFormat,
        input,
        control,
        attributeToBool(blurFormat, defaultValue: false));
  }

  MaterialNumberValueAccessor._(
      this._updateStream,
      this._checkInteger,
      this._numberFormat,
      BaseMaterialInput input,
      NgControl control,
      bool blurFormat)
      : super(input, control) {
    if (blurFormat) {
      disposer.addStreamSubscription(input.onBlur.listen((_) {
        if (input == null) return; // Input is no longer valid
        final parsedNumber = _parseNumber(input.inputText);
        // If the value parses, it's a number so format it as such.
        if (parsedNumber != null) {
          super.writeValue(_numberFormat.format(parsedNumber));
        }
      }));
    }
  }

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
      if (input == null) return; // Input is no longer valid
      final rawValue = input.inputText;
      final value = _parseNumber(rawValue);
      // Pass the rawValue and the num value. This allows validators to process
      // whichever one they would like.
      callback(value, rawValue: rawValue);
    }));
  }

  num _parseNumber(String input) {
    // NaN is a valid parsable entity for NumberFormat, but not a value a user
    // is expected to be able to input.
    if (input == null || input == 'NaN') return null;

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
  providers: [
    Provider(NG_VALIDATORS, useExisting: MaterialNumberValidator, multi: true)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialNumberValidator implements Validator {
  /// Validation that works in concert with the number accessor.
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    assert(control is Control);
    // If the control doesn't have a value, but had a value from the input then
    // it is considered an error. Producing error here as accessors can't easily
    // add errors themselves, but validators can.
    if (control.value == null && !isBlank((control as Control).rawValue)) {
      return {inputNotNumberErrorKey: inputIsNotNumberMsg()};
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
  providers: [
    Provider(NG_VALIDATORS, useExisting: CheckIntegerValidator, multi: true)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class CheckIntegerValidator implements Validator {
  /// Validation that works in concert with the number accessor.
  @override
  Map<String, dynamic> validate(AbstractControl abstractControl) {
    assert(abstractControl is Control, 'Can only be used with a Control');
    final control = abstractControl as Control;
    // Handled by accessor validator or value set by forms system
    if (control.value == null && !isBlank(control.rawValue)) {
      return {checkIntegerErrorKey: numberIsNotIntegerMsg()};
    }
    return null;
  }

  static String numberIsNotIntegerMsg() => Intl.message('Enter an integer',
      desc: 'Error message when input number is not an integer.',
      meaning: 'Error message when input number is not an integer.');
}
