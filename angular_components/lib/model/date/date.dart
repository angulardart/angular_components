// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Contains date-related models.

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:quiver/core.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/comparators/comparators.dart';

/// A calendar date. Year / month / day.
class Date extends Comparators<Date> {
  final DateTime _time;

  Date(int year, [int month = 1, int day = 1])
      : _time = DateTime.utc(year, month, day);

  /// Extracts the [Date] from the given time.
  ///
  /// By default this acts the same as just grabbing the year/month/day fields
  /// out of the given [DateTime]. But if a [tzOffset] is provided, this'll
  /// convert the time to the given timezone first:
  ///
  ///     // Midnight UTC. In Zurich, it's November 17th, but in Atlanta, it's
  ///     // still November 16th.
  ///     var time = new DateTime.utc(2015, 11, 17);
  ///     var est = new Duration(hours: -5); // Eastern time; GMT -5
  ///
  ///     new Date.fromTime(time); // 2015-11-17
  ///     new Date.fromTime(time, tzOffset: est); // 2015-11-16
  ///
  factory Date.fromTime(DateTime time, {Duration tzOffset}) {
    if (time.timeZoneOffset.inMicroseconds.isNaN) {
      throw ArgumentError.value(time, 'time', 'has a NaN time zone offset');
    }

    tzOffset ??= time.timeZoneOffset;
    if (tzOffset.inMicroseconds.isNaN) {
      throw ArgumentError.value(tzOffset, 'tzOffset', 'has a NaN duration');
    }

    final localTime = time.add(tzOffset - time.timeZoneOffset);
    return Date(localTime.year, localTime.month, localTime.day);
  }

  /// Creates a Date from an [int] representing milliseconds since epoch.
  factory Date.fromTimestamp(int msSinceEpoch) =>
      Date.fromTime(DateTime.fromMillisecondsSinceEpoch(msSinceEpoch));

  // TODO(google): Passing in a timezone here every time would be
  // frustrating. How about a "Calendar" class -- like a Clock, but for dates
  // instead of times?
  factory Date.today([Clock clock]) {
    var now = (clock ?? const Clock()).now();
    if (now.timeZoneOffset.inMicroseconds.isNaN) {
      throw StateError('Clock $clock returned a time with a NaN timezone '
          'offset: $now');
    }
    return Date.fromTime(now);
  }

  factory Date.parse(String input, DateFormat format) =>
      Date.fromTime(format.parse(input));

  factory Date.parseStrict(String input, DateFormat format) =>
      Date.fromTime(format.parseStrict(input));

  factory Date.parseLoose(String input, DateFormat format) =>
      Date.fromTime(format.parseLoose(input));

  String format(DateFormat format) => format.format(asUtcTime());

  /// Returns this [Date] as a [DateTime] at midnight UTC.
  DateTime asUtcTime() => _time;

  /// Subtracts the years, months, days from the Date.
  /// Equivalent to add with negative values.
  Date subtract({int years = 0, int months = 0, int days = 0}) =>
      add(years: -years, months: -months, days: -days);

  Date add({int years = 0, int months = 0, int days = 0}) =>
      // Let Dart's [DateTime] handle all the arithmetic. It intelligently
      // handles bogus values like (2015, 43, -32) and generally does what we
      // want here. This behavior isn't documented anywhere, but at the very
      // least, treating a day of 0 as the last day of the previous month is
      // guaranteed behavior[1], so it's probably OK to depend on it as long as
      // we also have tests around it.
      //
      // [1]: http://stackoverflow.com/a/14815209
      Date(year + years, month + months, day + days);

  int get year => asUtcTime().year;
  int get month => asUtcTime().month;
  int get day => asUtcTime().day;
  int get weekday => asUtcTime().weekday;

  bool isBefore(Date other) => this < other;
  bool isOnOrBefore(Date other) => this <= other;
  bool isAfter(Date other) => this > other;
  bool isOnOrAfter(Date other) => this >= other;

  @override
  int compareTo(Date other) => asUtcTime().compareTo(other.asUtcTime());

  @override
  int get hashCode => asUtcTime().hashCode;

  @override
  String toString() =>
      '${asUtcTime().year}-${asUtcTime().month}-${asUtcTime().day}';
}

/// The number of days spanned by the range defined by the two dates. Defaults
/// to including the end date, so that `daysSpanned(d, d) == 1`.
int daysSpanned(Date start, Date end, {bool inclusive = true}) =>
    // Use inHours / 24 instead of inDays to account for daylight savings
    (end.asUtcTime().difference(start.asUtcTime()).inHours / 24).round() +
    (inclusive ? 1 : 0);

/// Gets the earlier of the two given dates.
///
/// Requires both dates to be non-null.
Date earlierOf(Date a, Date b) => a.isAfter(b) ? b : a;

/// Gets the later of the two given dates.
///
/// Requires both dates to be non-null.
Date laterOf(Date a, Date b) => a.isAfter(b) ? a : b;

/// A date range with a start and end, inclusive. `null` values for either means
/// the range is unbounded in that direction.
class DateRange {
  final Date start;
  final Date end;
  // TODO(google): Nikhil brought up some good reasons for wanting a
  // localized title and date rendering here. Might be worth adding, or maybe
  // creating a `NamedDateRange` subclass would make sense.

  DateRange(this.start, this.end);

  /// Returns the intersection of [DateRange]s [a] and [b].
  ///
  /// If [a] does not overlap with [b], this factory returns `null`. Note
  /// that this is distinct from a [DateRange] with `start == end == null`,
  /// which represents a [DateRange] that is unbounded in both directions.
  factory DateRange.intersectionOf(DateRange a, DateRange b) {
    final start = _laterStartDateOf(a.start, b.start);
    final end = _earlierEndDateOf(a.end, b.end);

    // Note that we don't use >= here, as [DateRange]s are inclusive;
    // `start == end` is a valid condition for a date range.
    if (start != null && end != null && start > end) return null;

    return DateRange(start, end);
  }

  /// Returns the later of [a] and [b], where [a] and [b] both represent start
  /// dates.
  ///
  /// In this context, a null date represents the start of time.
  static Date _laterStartDateOf(Date a, Date b) {
    if (a == null) return b;
    if (b == null) return a;
    return laterOf(a, b);
  }

  /// Returns the later of [a] and [b], where [a] and [b] both represent end
  /// dates.
  ///
  /// In this context, a null date represents the end of time.
  static Date _earlierEndDateOf(Date a, Date b) {
    if (a == null) return b;
    if (b == null) return a;
    return earlierOf(a, b);
  }

  @override
  bool operator ==(o) => o is DateRange && start == o.start && end == o.end;

  @override
  int get hashCode => hash2(start, end);

  @override
  String toString() => '$start - $end';

  DateRange asPlainRange() => this;
}

/// Whether or not [date] is inside [range].
///
/// Inclusive, and treats a null [range.start] or [range.end] as unbounded.
bool rangeContains(DateRange range, Date date) =>
    (range.start == null || date >= range.start) &&
    (range.end == null || date <= range.end);

/// Whether or not [subrange] is fully contained by [range].
///
/// Inclusive, and treats a null [range.start], [range.end], [subrange.start],
/// [subrange.end] as unbounded.
bool rangeContainsRange(DateRange range, DateRange subrange) {
  final containsStart = (range.start == null && subrange.start == null) ||
      (subrange.start != null && rangeContains(range, subrange.start));
  final containsEnd = (range.end == null && subrange.end == null) ||
      (subrange.end != null && rangeContains(range, subrange.end));
  return containsStart && containsEnd;
}

/// Enumerates all dates from [start] to [end], inclusive.
///
/// For example, if [start] is 2016-01-01 and [end] is 2016-01-02, then two
/// elements, [2016-01-01, 2016-01-02], will be in the returned iterator.
Iterable<Date> enumerateDates(Date start, Date end) sync* {
  for (var date = start; date <= end; date = date.add(days: 1)) {
    yield date;
  }
}

/// Enumerates all dates from [range.start] to [range.end], inclusive.
///
/// Returns an empty iterator when [range] is null.
/// Throws [ArgumentError] when [range] is unbounded on either side.
/// See [enumerateDates] for more details.
Iterable<Date> enumerateRange(DateRange range) {
  if (range == null) {
    return [];
  }
  if (range.start == null || range.end == null) {
    throw ArgumentError(
        'Cannot call enumerateRange with a range with a null start or end.');
  }
  return enumerateDates(range.start, range.end);
}

/// A date range and an optional comparison date range.
class DateRangeComparison {
  final DateRange range;
  final DateRange comparison;
  bool get isComparisonEnabled => comparison != null;
  DateRangeComparison(this.range, {this.comparison});
}

/// Represents something that might be chosen by some hypothetical date picker
/// component.
///
/// This class is just a dumb wrapper around [ObservableView]. It's here mostly
/// so that dependency injection can be used without going through all that
/// TypeLiteral unpleasantness. Having an actual implementation around is also
/// handy in tests.
class DatepickerSelection extends ObservableViewMixin<DateRangeComparison> {
  final ObservableView<DateRangeComparison> _ref;
  DatepickerSelection.wrap(this._ref);

  /// Constructs a new selection. Intended for tests: this creates a new
  /// [ObservableReference] but doesn't give you any way of disposing of its
  /// streams, so it'd result in memory leaks in prod.
  DatepickerSelection.test([DateRangeComparison initialValue])
      : _ref = ObservableReference(initialValue);

  @override
  DateRangeComparison get value => _ref.value;

  @override
  Stream<DateRangeComparison> get stream => _ref.stream;

  @override
  void dispose() {}
}
