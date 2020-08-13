// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:angular_components/material_datepicker/range.dart';

/// Converts current date range to comparison date range.
///
/// Return null if this is a "custom".
typedef ComparisonFn = DatepickerDateRange Function(DatepickerDateRange range);

/// The [ComparisonOption]s the component provides to the user by default.
List<ComparisonOption> defaultComparisonOptions = [
  ComparisonOption.previousPeriod,
  ComparisonOption.samePeriodLastYear,
  ComparisonOption.custom
];

/// Comparison option for comparing [DatepickerDateRange].
class ComparisonOption {
  /// The label to display for the preset (e.g. "Previous period").
  final String displayName;

  /// Get date shifting base on the given date range.
  final ComparisonFn computeComparisonRange;

  const ComparisonOption(this.displayName, this.computeComparisonRange);

  static final ComparisonOption previousPeriod =
      ComparisonOption(_prevPeriodMsg, (DatepickerDateRange range) {
    var prev = range.prev;
    if (prev != null && !prev.isPredefined) {
      return DatepickerDateRange(_prevPeriodMsg, prev.start, prev.end);
    }
    return prev;
  });

  static final ComparisonOption samePeriodLastYear = ComparisonOption(
      _previousYearMsg,
      (DatepickerDateRange range) => DatepickerDateRange(_previousYearMsg,
          range.start.add(years: -1), range.end.add(years: -1)));

  static final ComparisonOption custom =
      ComparisonOption(_customMsg, (DatepickerDateRange range) => null);

  static final String _prevPeriodMsg = Intl.message('Previous period',
      name: '_prevPeriodMsg',
      meaning: 'An option name, the date range before the selected date '
          'range',
      desc: 'Setting to compare the selected date range with the previous '
          'period. E.g. if the selected range were May, this would be April'
          '.');
  static final String _previousYearMsg = Intl.message('Previous year',
      name: '_previousYearMsg',
      meaning: 'An option name, the same date range in the last year',
      desc: 'Setting to compare the selected date range with the same range '
          'last year. E.g. if the selected range were May 2015, this would'
          ' be May 2014.');

  static final String _customMsg = Intl.message('Custom',
      name: '_customMsg',
      meaning: 'An option name, user could enter the date range they want',
      desc: 'Setting to compare the selected date range with another '
          'arbitrary user-selected date range.');

  bool operator ==(o) =>
      o is ComparisonOption &&
      this.displayName == o.displayName &&
      this.computeComparisonRange == o.computeComparisonRange;

  int get hashCode => displayName.hashCode ^ computeComparisonRange.hashCode;

  String toString() => displayName;
}
