// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A calendar month; the basic unit of the scrolling calendar. It has a
/// localized title ("Mar 2015") and a collection of weeks.
class CalendarMonth {
  final Date _start;
  final int startingWeekday;
  String _title;
  CalendarState calendarState;
  List<CalendarWeek> _weeks;
  List<String> _classes = [];

  CalendarMonth(int year, int month,
      {CalendarState state, this.startingWeekday = DateTime.monday})
      : _start = Date(year, month),
        calendarState = state {
    _title = _start.format(DateFormat.yMMM());
    if (state?._resolutionAtLeast(CalendarResolution.months) ?? false) {
      _weeks = [];
    } else {
      _weeks = _generateWeeks().toList();
    }
    update(state);
  }

  CalendarMonth.fromDate(Date date,
      {CalendarState state, int startingWeekday = DateTime.monday})
      : this(date.year, date.month,
            state: state, startingWeekday: startingWeekday);

  CalendarMonth.fromTime(DateTime time,
      {CalendarState state, int startingWeekday = DateTime.monday})
      : this(time.year, time.month,
            state: state, startingWeekday: startingWeekday);

  Date get start => _start;
  int get year => _start.year;
  int get month => _start.month;
  String get title => _title;
  List<CalendarWeek> get weeks => _weeks;
  List<String> get classes => _classes;

  void update(CalendarState state) {
    // TODO(google): Disable CSS transitions here somehow
    this.calendarState = state;
    if (weeks != null) {
      weeks.forEach((w) => w.update(state));
    }
    if (state == null || state.resolution != CalendarResolution.months) {
      _classes = [];
    } else {
      _classes = state.selections
          .where((selection) =>
              containsDate(selection.start) || containsDate(selection.end))
          .expand((selection) => ['boundary', 'boundary-${selection.id}'])
          .toList();
    }
  }

  // Return true if we should display this month's title "inline" (adjacent
  // to the first few days of the month) on the calendar.
  // For currently-supported locales, there should be room for an inline title
  // on months that start on the 4th day of the week (or later).
  bool get displayTitleInline => _weeks[0].numBlankDays >= 3;

  /// Adds the given number of months to this month. For instance:
  ///
  ///     <Mar 2015>.addMonths(4) --> Jul 2015
  ///     <Mar 2015>.addMonths(-3) --> Dec 2014
  CalendarMonth addMonths(int months) {
    var newYear = year + (months / 12).floor();
    var newMonth = month + months % 12;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    return CalendarMonth(newYear, newMonth,
        state: calendarState, startingWeekday: startingWeekday);
  }

  /// The difference in months between the other month and this month. If
  /// `other` is later than this month, this will be a positive number. For all
  /// `N`, `month.deltaMonths(month.addMonths(N)) == N`.
  int deltaMonths(CalendarMonth other) =>
      (other.year - year) * 12 + other.month - month;

  /// Index of the row in the month that contains the day. If no days match, -1
  /// is returned.
  int getRowIndex(int day) {
    var position = (day - 1) + weeks.first.numBlankDays;
    var row = position ~/ 7;
    return displayTitleInline ? row : row + 1;
  }

  bool containsDate(Date date) => date.year == year && date.month == month;

  Iterable<CalendarWeek> _generateWeeks() sync* {
    var week = CalendarWeek(_start, calendarState, startingWeekday);
    while (week != null) {
      yield week;
      week = week.next;
    }
  }

  /// Get the next month within this month's year, unless it's at the end of
  /// the year, in which case return null.
  ///
  /// Based on [CalendarWeek.next].
  CalendarMonth get next {
    if (month < DateTime.december) {
      return addMonths(1);
    }
    return null;
  }

  @override
  bool operator ==(o) => o is CalendarMonth && o._start == _start;

  @override
  int get hashCode => _start.hashCode;

  @override
  String toString() => '$title (${_start.toString()})';
}

/// Lightweight class representing one or more consecutive months.
class MonthRange {
  /// The month at the beginning of the range. The 'day' field is
  /// generally ignored, but should be 1, by convention.
  final Date start;

  /// The number of months in the range. Should be at least 1.
  final int length;

  /// Create a [MonthRange] with the given [start] and [length].
  MonthRange(this.start, this.length);

  /// Create a [MonthRange] with desired [length] and (ideally) start,
  /// constrained by [min] and [max].
  ///
  /// The created range will never start before [min] or end after [max]. The
  /// length will match [length] as closely as possible, subject to that
  /// constraint. If possible, the range will start at or close to
  /// [tryToStartAt], but this has the lowest priority.
  ///
  /// Throws ArgumentError if length is less than 1, min/max are null, or
  /// max is before min.
  ///
  /// - `length: int` -- Must be at least 1.
  factory MonthRange.within(CalendarMonth min, CalendarMonth max, int length,
      {final CalendarMonth tryToStartAt}) {
    if (length < 1) {
      throw ArgumentError.value(length, 'length', 'must be at least 1');
    }
    if (min == null) {
      throw ArgumentError.notNull('min');
    }
    if (max == null) {
      throw ArgumentError.notNull('max');
    }

    int months = min.deltaMonths(max) + 1;
    if (months < 1) {
      throw ArgumentError('max must not be before min');
    }

    var start = tryToStartAt?.start ?? min.start;

    // Clamp to maximum possible length
    if (length > months) length = months;

    // Enforce minimum
    if (start < min.start) {
      start = min.start;
    }

    // Enforce maximum (the end cannot go past max)
    var end = start.add(months: length - 1);
    if (end > max.start) {
      start = max.start.add(months: -(length - 1));
    }

    return MonthRange(start, length);
  }

  /// Eagerly construct a list of [CalendarMonth] instances corresponding to
  /// this [MonthRange].
  ///
  /// The first entry will have the same month and year as [startDate]. All
  /// entries will have the specified [state] and [startingWeekday].
  List<CalendarMonth> toList(CalendarState state, int startingWeekday) {
    var startMonth = CalendarMonth(start.year, start.month,
        state: state, startingWeekday: startingWeekday);
    return List.generate(length, (i) => startMonth.addMonths(i));
  }
}
