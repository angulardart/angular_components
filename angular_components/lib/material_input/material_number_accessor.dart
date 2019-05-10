// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fixnum/fixnum.dart';
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
  MaterialInt64ValueAccessor,
  MaterialNumberValueAccessor,
  MaterialNumberValidator,
  PositiveNumValidator,
  CheckNonNegativeValidator,
  UpperBoundValidator
];

/// Base accessor to handle various numerical types with MaterialInput.
///
/// Accessor always sets the raw [String] value that is set from the input, but
/// only sets the value of a [Control] if the input could be parsed.
abstract class BaseMaterialNumberValueAccessor<T>
    extends BaseMaterialInputValueAccessor<T> {
  final NumberFormat _numberFormat;
  Stream _updateStream;

  BaseMaterialNumberValueAccessor(
      MaterialInputComponent input,
      NgControl control,
      bool changeUpdate,
      bool keypressUpdate,
      bool blurFormat,
      [this._numberFormat])
      : super(input, control) {
    // The type values set via number directives are invalid values for the
    // 'type' attribute on the underlying 'input' element, so set the value
    // back to 'text' instead.
    input.type = 'text';

    assert(!(changeUpdate && keypressUpdate),
        'Cannot update both on keypress and change.');
    if (changeUpdate) {
      _updateStream = input.onChange;
    } else if (keypressUpdate) {
      _updateStream = input.onKeypress;
    } else {
      _updateStream = input.onBlur;
    }
    if (blurFormat) {
      disposer.addStreamSubscription(input.onBlur.listen((_) {
        if (input == null) return; // Input is no longer valid
        final parsedNumber = parseNumber(input.inputText);
        // If the value parses, it's a number so format it as such.
        if (parsedNumber != null) {
          super.writeValue(parsedNumber);
        }
      }));
    }
  }

  @override
  void writeValue(T newValue) {
    // Treat null as special as an invalid input will also parse as null.
    if (newValue == null) super.writeValue(null);
    if (parseNumber(input.inputText) != newValue) {
      // If the numeric value of the current input text doesn't equal to the
      // new numeric value, update the input text accordingly.
      super.writeValue(newValue);
    }
  }

  @override
  void registerOnChange(callback) {
    disposer.addStreamSubscription(_updateStream.listen((_) {
      if (input == null) return; // Input is no longer valid
      final rawValue = input.inputText;
      final value = parseNumber(rawValue);
      // Pass the rawValue and the num value. This allows validators to process
      // whichever one they would like.
      callback(value, rawValue: rawValue);
    }));
  }

  /// Coerces the [String] value of the [MaterialInput] into type of [T].
  T parseNumber(String input);

  /// Formats a value using provided [NumberFormat], falling back to
  /// [MaterialInputDefaultValueAccessor] formatValue if none provided.
  @override
  String formatValue(T value) {
    if (value == null) return '';
    return _numberFormat?.format(value) ?? super.formatValue(value);
  }
}

/// [ControlValueAccessor] which will coerce an input into an [Int64].
///
/// There is currently no Int64-specific formatter, so note that numberFormat
/// cannot be safely used if your values are vulnerable to overflowing in size.
///
/// Use [materialNumberInputDirectives] to get a set of directives to use with
/// the input to provide validations. Such as the default to ensure it is a
/// number, `checkInteger`, `checkPositive`, `checkNonNegative` (allows 0,)
/// `lowerBound`, and `upperBound`.
///
/// `keypressUpdate` attribute has the value update on every keypress while
/// the default is the value only updating on a blur event.
/// `blurFormat` attribute causes the input to be formatted on blur events.
@Directive(
  selector: 'material-input[type=int64]',
)
class MaterialInt64ValueAccessor
    extends BaseMaterialNumberValueAccessor<Int64> {
  MaterialInt64ValueAccessor(
      BaseMaterialInput input,
      @Self() NgControl control,
      @Attribute('changeUpdate') String changeUpdateAttr,
      @Attribute('keypressUpdate') String keypressUpdateAttr,
      @Attribute('checkInteger') String checkInteger,
      @Attribute('blurFormat') String blurFormat,
      @Optional() NumberFormat numberFormat)
      : super(
            input,
            control,
            attributeToBool(changeUpdateAttr, defaultValue: false),
            attributeToBool(keypressUpdateAttr, defaultValue: false),
            attributeToBool(blurFormat, defaultValue: false),
            numberFormat) {
    assert(
        _checkValues(
            numberFormat, attributeToBool(blurFormat, defaultValue: false)),
        'You must supply a NumberFormat if using blurFormat');
  }

  bool _checkValues(NumberFormat numberFormat, bool blurFormat) {
    if (numberFormat != null) {
      print('Warning: numberFormat only works with num and will overflow '
          'if the number is larger than a native int, even when using '
          'material-input[type=int64].');
      return blurFormat;
    }
    return true;
  }

  @override
  Int64 parseNumber(String input) {
    if (input == null || input.isEmpty) {
      return null;
    }

    try {
      // If using formatting, we must firsrt parse back to a non-formatted
      // String representation as Int64 cannot handle commas.
      if (_numberFormat != null) {
        input = _numberFormat.parse(input).toString();
      }

      return Int64.parseInt(input);
    } on FormatException {
      return null;
    }
  }
}

/// [ControlValueAccessor] which will coerce an input into a [num].
///
/// Use [materialNumberInputDirectives] to get a set of directives to use with
/// the input to provide validations. Such as the default to ensure it is a
/// number, `checkInteger`, `checkPositive`, `checkNonNegative` (allows 0,)
/// `lowerBound`, and `upperBound`.
///
/// `keypressUpdate` attribute has the value update on every keypress while
/// the default is the value only updating on a blur event.
/// `blurFormat` attribute causes the input to be formatted on blur events.
@Directive(
  selector: 'material-input[type=number],material-input[type=percent]',
)
class MaterialNumberValueAccessor extends BaseMaterialNumberValueAccessor<num> {
  final bool _checkInteger;

  MaterialNumberValueAccessor(
      BaseMaterialInput input,
      @Self() NgControl control,
      @Attribute('changeUpdate') String changeUpdateAttr,
      @Attribute('keypressUpdate') String keypressUpdateAttr,
      @Attribute('checkInteger') String checkInteger,
      @Attribute('blurFormat') String blurFormat,
      @Optional() NumberFormat numberFormat)
      : this._checkInteger = attributeToBool(checkInteger, defaultValue: false),
        super(
            input,
            control,
            attributeToBool(changeUpdateAttr, defaultValue: false),
            attributeToBool(keypressUpdateAttr, defaultValue: false),
            attributeToBool(blurFormat, defaultValue: false),
            numberFormat ?? NumberFormat.decimalPattern());

  @override
  num parseNumber(String input) {
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
    ExistingProvider.forToken(NG_VALIDATORS, MaterialNumberValidator)
  ],
)
class MaterialNumberValidator implements Validator {
  /// Validation that works in concert with the number accessor.
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    assert(control is Control);
    // If the control doesn't have a value, but had a value from the input then
    // it is considered an error. Producing error here as accessors can't easily
    // add errors themselves, but validators can.
    if (control.value == null && !isEmpty((control as Control).rawValue)) {
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
      'material-input[type=percent][checkInteger],'
      'material-input[type=int64]',
  providers: [ExistingProvider.forToken(NG_VALIDATORS, CheckIntegerValidator)],
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

  static String numberIsNotIntegerMsg() => Intl.message('Enter a whole number',
      desc: 'Error message when input number is not an integer.',
      meaning: 'Error message when input number is not an integer.');
}

NumberFormat decimalNumberFormat() => NumberFormat.decimalPattern();

/// Helper directive to provide a basic [NumberFormat] pattern for use with
/// number accessors.
///
/// This is not necessary for standard material-input[type=num] as it's provided
/// as the default.  It should only be used with material-input[type=int64].
@Directive(
  selector: '[decimalNumberFormat]',
  providers: [FactoryProvider(NumberFormat, decimalNumberFormat)],
)
class DecimalNumberFormatDirective {}
