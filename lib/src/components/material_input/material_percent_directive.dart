// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import './material_input.dart';
import './material_input_error_keys.dart';

export './material_number_accessor.dart' show materialNumberInputDirectives;

/// Directive to control `material-input` to accept percentage values.
///
/// __Example Usage:__
///
///     <material-input type="percent" [(ngModel)]="percentage">
///     </material-input>
///
@Directive(selector: 'material-input[type=percent]')
class MaterialPercentInputDirective {
  MaterialPercentInputDirective(
      MaterialInputComponent input, HtmlElement element) {
    input.rightAlign = true;
    input.trailingText = '%';
    element.dir = 'ltr';
    input.errorRenderer = _replaceErrorMessage;
  }

  // Used to override the standard error messages with percent equivalents.
  Map<String, dynamic> _replaceErrorMessage(Map<String, dynamic> errors) {
    var overrides;
    for (var key in _errorOverrides.keys) {
      if (_errorOverrides.containsKey(key)) {
        overrides ??= new Map.from(errors);
        overrides[key] = _errorOverrides[key];
      }
    }
    final result = overrides ?? errors;
    return (percentErrorRenderer != null)
        ? percentErrorRenderer(result)
        : result;
  }

  /// Function that allows clients to use their own error messages instead of
  /// the default.
  // In case the client wants to override the errors we need to intercept the
  // value instead of material-input so that we can use the percent errors as
  // needed.
  @Input()
  Function percentErrorRenderer;

  static Map<String, String> _errorOverrides = {
    nonNegativeIntegerRequiredErrorKey: _negativePercentageErrMsg,
    numberBelowLowerBoundErrorKey: _percentTooSmallErrMsg,
    numberAboveUpperBoundErrorKey: _percentTooLargeErrMsg,
  };

  static String get _negativePercentageErrMsg => Intl.message(
      'Percentages must be positive',
      desc: 'Validation error message when input precentage is negative, it '
          'must be a positive number.');

  static String get _percentTooSmallErrMsg =>
      Intl.message('Enter a larger number',
          desc: 'Validation error message for when the input percentage is too '
              'small',
          meaning: 'Validation error message for when the input percentage is '
              'too small');

  static String get _percentTooLargeErrMsg =>
      Intl.message('Enter a smaller number',
          desc: 'Validation error message for when the input percentage is too '
              'large',
          meaning: 'Validation error message for when the input percentage is '
              'too large');
}
