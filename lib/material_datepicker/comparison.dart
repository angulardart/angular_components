// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/model/date/date.dart';

/// An implementation of [DateRangeComparison] that has [DatepickerDateRange]s
/// instead of plain [DateRange]s.
class DatepickerComparison implements DateRangeComparison {
  /// The selected date range.
  final DatepickerDateRange range;

  /// The selected comparison range, if any.
  final DatepickerDateRange comparison;

  DatepickerComparison.noComparison(DatepickerDateRange range)
      : this.custom(range, null);

  DatepickerComparison.previousPeriod(DatepickerDateRange range)
      : this.custom(range, _getPreviousRange(range));

  DatepickerComparison.samePeriodLastYear(DatepickerDateRange range)
      : this.custom(range, _getSamePeriodLastYearRange(range));

  /// Construct a copy of `original` clamped to the given `min`/`max` dates.
  /// Existing clamping is removed before the new clamping is applied.
  DatepickerComparison.reclamp(DatepickerComparison orig, Date min, Date max)
      : this.custom(orig?.range?.unclamped()?.clamp(min: min, max: max),
            orig?.comparison?.unclamped()?.clamp(min: min, max: max));

  DatepickerComparison.custom(this.range, this.comparison);

  bool get isComparisonEnabled => comparison != null;

  bool comparesToPreviousPeriod() =>
      comparison != null && rangeEqual(comparison, _getPreviousRange(range));

  bool comparesToSamePeriodLastYear() =>
      comparison != null &&
      comparison.unclamped() == _getSamePeriodLastYearRange(range);

  bool operator ==(o) =>
      o is DatepickerComparison &&
      rangeEqual(range, o.range) &&
      rangeEqual(comparison, o.comparison);
  int get hashCode => isComparisonEnabled
      ? rangeHash(range) ^ rangeHash(comparison)
      : rangeHash(range);
  String toString() => 'DatepickerComparison -- $range / $comparison';

  /// If the previous date range has an interesting title like '3 weeks ago',
  /// keep it; if it's the generic 'Custom' title, replace it with 'Previous
  /// period'.
  static DatepickerDateRange _getPreviousRange(DatepickerDateRange range) {
    var prev = range.prev;
    if (prev != null && !prev.isPredefined) {
      return new DatepickerDateRange(_prevPeriodMsg(), prev.start, prev.end);
    }
    return prev;
  }

  static DatepickerDateRange _getSamePeriodLastYearRange(
          DatepickerDateRange range) =>
      new DatepickerDateRange(
          _lastYearMsg(), range.start.add(years: -1), range.end.add(years: -1));

  static String _prevPeriodMsg() => Intl.message('Previous period',
      name: '_prevPeriodMsg',
      meaning: 'Name of a date range',
      desc: 'Generic name for the period before a time range. E.g. if someone '
          'has selected the last 30 days, this represents the 30 days previous.');
  static String _lastYearMsg() => Intl.message('Same period last year',
      name: '_lastYearMsg',
      meaning: 'Name of a date range',
      desc: 'Generic name for a time period matching a selected date range, '
          'but one year prior. E.g. if someone has selected Feb 2015, this '
          'represents Feb 2014.');
}
