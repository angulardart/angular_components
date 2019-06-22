// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_datepicker/comparison_option.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/model/date/date.dart';

/// An implementation of [DateRangeComparison] that has [DatepickerDateRange]s
/// instead of plain [DateRange]s.
class DatepickerComparison implements DateRangeComparison {
  /// The selected date range.
  final DatepickerDateRange range;

  /// The selected comparison range, if any.
  final DatepickerDateRange comparison;

  DatepickerComparison(DatepickerDateRange range, ComparisonOption option)
      : this.custom(range, option.computeComparisonRange(range));

  DatepickerComparison.noComparison(DatepickerDateRange range)
      : this.custom(range, null);

  DatepickerComparison.previousPeriod(DatepickerDateRange range)
      : this(range, ComparisonOption.previousPeriod);

  DatepickerComparison.samePeriodLastYear(DatepickerDateRange range)
      : this(range, ComparisonOption.samePeriodLastYear);

  /// Construct a copy of `original` clamped to the given `min`/`max` dates.
  /// Existing clamping is removed before the new clamping is applied.
  DatepickerComparison.reclamp(DatepickerComparison orig, Date min, Date max)
      : this.custom(orig?.range?.unclamped()?.clamp(min: min, max: max),
            orig?.comparison?.unclamped()?.clamp(min: min, max: max));

  DatepickerComparison.custom(this.range, this.comparison);

  bool get isComparisonEnabled => comparison != null;

  /// Checks the comparison date range has same logic as given comparisonOption.
  bool comparesTo(ComparisonOption option) =>
      comparison != null &&
      option != null &&
      range != null &&
      comparison.unclamped() ==
          option.computeComparisonRange(range.unclamped());

  bool operator ==(o) =>
      o is DatepickerComparison &&
      rangeEqual(range, o.range) &&
      rangeEqual(comparison, o.comparison);
  int get hashCode => isComparisonEnabled
      ? rangeHash(range) ^ rangeHash(comparison)
      : rangeHash(range);
  String toString() => 'DatepickerComparison -- $range / $comparison';
}
