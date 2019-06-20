// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';

import 'material_input_error_keys.dart';

/// [Validator] which will validate a number input is positive > 0.
@Directive(
  selector: '[checkPositive]',
  providers: [ExistingProvider.forToken(NG_VALIDATORS, PositiveNumValidator)],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class PositiveNumValidator implements Validator {
  /// Boolean value allowing the validator to be turned on/off as needed.
  @Input('checkPositive')
  bool enabled = true;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (!enabled || control.value == null) {
      return null; // Handled by accessor validator
    }
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
@Directive(
  selector: '[checkNonNegative]',
  providers: [
    ExistingProvider.forToken(NG_VALIDATORS, CheckNonNegativeValidator)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class CheckNonNegativeValidator implements Validator {
  /// Boolean value allowing the validator to be turned on/off as needed.
  @Input('checkNonNegative')
  bool enabled = true;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (!enabled || control.value == null) return null;
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

/// [Validator] which validates that a number input is greater or equal
/// than [lowerBound].
@Directive(
  selector: '[lowerBound]',
  providers: [ExistingProvider.forToken(NG_VALIDATORS, LowerBoundValidator)],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class LowerBoundValidator implements Validator {
  final NumberFormat _numberFormat;

  LowerBoundValidator(@Optional() NumberFormat format)
      : _numberFormat = format ?? NumberFormat.decimalPattern();

  /// Smallest allowed value.
  @Input()
  num lowerBound;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (control.value == null || lowerBound == null) return null;
    assert(control.value is Comparable, 'Value needs to be Comparable');
    if (control.value < lowerBound) {
      final lowerText = _numberFormat.format(lowerBound);
      return {numberBelowLowerBoundErrorKey: numberIsTooSmallMsg(lowerText)};
    }
    return null;
  }

  static String numberIsTooSmallMsg(String _lowerBound) =>
      Intl.message('Enter a number $_lowerBound or greater',
          name: 'LowerBoundValidator_numberIsTooSmallMsg',
          args: [_lowerBound],
          desc: 'Error message when input number is too small.',
          examples: const {'_lowerBound': 42});
}

/// [Validator] which validates that a number input is less or equal
/// than [upperBound].
@Directive(
  selector: '[upperBound]',
  providers: [ExistingProvider.forToken(NG_VALIDATORS, UpperBoundValidator)],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class UpperBoundValidator implements Validator {
  final NumberFormat _numberFormat;

  UpperBoundValidator(@Optional() NumberFormat format)
      : _numberFormat = format ?? NumberFormat.decimalPattern();

  /// Largest allowed value.
  @Input()
  num upperBound;

  @override
  Map<String, dynamic> validate(AbstractControl control) {
    if (control.value == null) return null; // Handled by accessor validator
    assert(control.value is Comparable, 'Value needs to be Comparable');
    if (control.value > upperBound) {
      final upperText = _numberFormat.format(upperBound);
      return {numberAboveUpperBoundErrorKey: numberIsTooLargeMsg(upperText)};
    }
    return null;
  }

  static String numberIsTooLargeMsg(String _upperBound) =>
      Intl.message('Enter a number $_upperBound or smaller',
          name: 'UpperBoundValidator_numberIsTooLargeMsg',
          args: [_upperBound],
          desc: 'Error message when number input is too large.',
          examples: const {'_upperBound': 42});
}
