// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';

import '../../utils/angular/properties/properties.dart';
import 'material_input_error_keys.dart';

/// [Validator] which will validate a number input is positive > 0.
@Directive(selector: '[checkPositive]', providers: const [
  const Provider(NG_VALIDATORS, useExisting: PositiveNumValidator, multi: true)
])
class PositiveNumValidator implements Validator {
  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (control.value == null) return null; // Handled by accessor validator
    assert(control.value is Comparable, 'Value needs to be comparable');
    if (control.value <= 0) {
      return {positiveIntegerRequiredErrorKey: numberIsNotPositiveMsg()};
    }
    return null;
  }

  static String numberIsNotPositiveMsg() =>
      Intl.message('Enter a number greater than 0',
          desc: 'Error message when input number is not positive.');
}

/// [Validator] which will validate a number input is not negative, >= 0
@Directive(selector: '[checkNonNegative]', providers: const [
  const Provider(NG_VALIDATORS,
      useExisting: CheckNonNegativeValidator, multi: true)
])
class CheckNonNegativeValidator implements Validator {
  bool _enabled = true;

  /// Boolean value allowing the validator to be turned on/off as needed.
  @Input()
  set checkNotNegative(value) {
    _enabled = getBool(value);
  }

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (!_enabled || control.value == null) return null;
    assert(control.value is Comparable, 'Value needs to be comparable');
    if (control.value < 0) {
      return {nonNegativeIntegerRequiredErrorKey: numberIsNegativeMsg()};
    }
    return null;
  }

  static String numberIsNegativeMsg() =>
      Intl.message('Enter a number that is not negative',
          desc: 'Error message when input number is not positive or 0.');
}

/// [Validator] which will validate a number input is greater than [lowerBound].
@Directive(selector: '[lowerBound]', providers: const [
  const Provider(NG_VALIDATORS, useExisting: LowerBoundValidator, multi: true)
])
class LowerBoundValidator implements Validator {
  @Input()
  num lowerBound;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (control.value == null || lowerBound == null) return null;
    assert(control.value is Comparable, 'Value needs to be Comparable');
    if (control.value < lowerBound) {
      return {numberBelowLowerBoundErrorKey: numberIsTooSmallMsg(lowerBound)};
    }
    return null;
  }

  static String numberIsTooSmallMsg(num _lowerBound) =>
      Intl.message('Enter a number $_lowerBound or greater',
          name: 'LowerBoundValidator_numberIsTooSmallMsg',
          args: [_lowerBound],
          desc: 'Error message when input number is too small.',
          examples: const {'_lowerBound': 42});
}

/// [Validator] which will validate a number input is less than [upperBound].
@Directive(selector: '[upperBound]', providers: const [
  const Provider(NG_VALIDATORS, useExisting: UpperBoundValidator, multi: true)
])
class UpperBoundValidator implements Validator {
  @Input()
  num upperBound;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (control.value == null) return null; // Handled by accessor validator
    assert(control.value is Comparable, 'Value needs to be Comparable');
    if (control.value > upperBound) {
      return {numberAboveUpperBoundErrorKey: numberIsTooLargeMsg(upperBound)};
    }
    return null;
  }

  static String numberIsTooLargeMsg(num _upperBound) =>
      Intl.message('Enter a number $_upperBound or smaller',
          name: 'UpperBoundValidator_numberIsTooLargeMsg',
          args: [_upperBound],
          desc: 'Error message when number input is too large.',
          examples: const {'_upperBound': 42});
}
