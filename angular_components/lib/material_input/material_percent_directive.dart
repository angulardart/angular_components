// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_input/material_input_error_keys.dart';

export 'package:angular_components/material_input/material_number_accessor.dart'
    show materialNumberInputDirectives;

/// Directive to control `material-input` to accept percentage values.
@Directive(
  selector: 'material-input[type=percent]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialPercentInputDirective {
  MaterialPercentInputDirective(
      MaterialInputComponent input, HtmlElement element) {
    // 'percent' is an invalid 'type' attribute value for the 'input' element.
    // Use value 'text' instead.
    input.type = 'text';
    input.rightAlign = true;
    element.dir = 'ltr';
    final percentPattern = NumberFormat.percentPattern();
    final percentLocation = percentPattern.symbols.PERCENT_PATTERN
        .indexOf(percentPattern.symbols.PERCENT);
    // If the percent symbol is closer to the end of the pattern make sure it is
    // trailing.
    if (percentLocation > percentPattern.symbols.PERCENT_PATTERN.length / 2) {
      input.trailingText = percentPattern.symbols.PERCENT;
    } else {
      input.leadingText = percentPattern.symbols.PERCENT;
    }
    input.errorRenderer = _replaceErrorMessage;
  }

  // Used to override the standard error messages with percent equivalents.
  Map<String, dynamic> _replaceErrorMessage(Map<String, dynamic> errors) {
    Map<String, dynamic> overrides;
    for (var key in _errorOverrides.keys) {
      if (_errorOverrides.containsKey(key)) {
        overrides ??= Map<String, dynamic>.from(errors);
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
  Map<String, dynamic> Function(Map<String, dynamic>) percentErrorRenderer;

  static final _errorOverrides = {
    nonNegativeIntegerRequiredErrorKey: _negativePercentageErrMsg,
    numberBelowLowerBoundErrorKey: _percentTooSmallErrMsg,
    numberAboveUpperBoundErrorKey: _percentTooLargeErrMsg,
  };

  static final _negativePercentageErrMsg = Intl.message(
      'Percentages must not be negative',
      desc: 'Validation error message when input precentage is negative, it '
          'must be a positive number or zero.'
          '[BACKUP_MESSAGE_ID:4311805941549841920]');

  static final _percentTooSmallErrMsg = Intl.message('Enter a larger number',
      desc: 'Validation error message for when the input percentage is too '
          'small',
      meaning: 'Validation error message for when the input percentage is '
          'too small');

  static final _percentTooLargeErrMsg = Intl.message('Enter a smaller number',
      desc: 'Validation error message for when the input percentage is too '
          'large',
      meaning: 'Validation error message for when the input percentage is '
          'too large');
}
