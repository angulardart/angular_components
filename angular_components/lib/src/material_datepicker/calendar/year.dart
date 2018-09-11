// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A calendar year; the basic unit of the scrolling month grid. It has a
/// localized title ("2015") and a collection of months.
///
/// The months in the year are logically grouped into 2 rows of 6 months.
/// Highlights within the year are split at the 6 month boundary, and the CSS
/// classes applied to the months in the second row (after the boundary) are
/// shifted to align with those of the first row.
class CalendarYear extends _HasHighlights {
  static const _monthsPerRow = 6;
  static const _afterFirstRow = _monthsPerRow + 1;
  static const _beforeSecondRow = _monthsPerRow;

  final Date _start;
  final int startingWeekday;
  String _title;
  List<CalendarMonth> _months;

  CalendarYear(int year, CalendarState state,
      {this.startingWeekday = DateTime.monday})
      : _start = Date(year),
        super(state) {
    _title = _start.format(DateFormat.y());
    if (state?._resolutionAtLeast(CalendarResolution.years) ?? false) {
      _months = [];
    } else {
      _months = _generateMonths().toList();
    }
    _updateHighlights();
  }

  CalendarYear.fromDate(Date date,
      {CalendarState state, int startingWeekday = DateTime.monday})
      : this(date.year, state, startingWeekday: startingWeekday);

  CalendarYear.fromTime(DateTime time,
      {CalendarState state, int startingWeekday = DateTime.monday})
      : this(time.year, state, startingWeekday: startingWeekday);

  Date get start => _start;
  int get year => _start.year;
  String get title => _title;
  List<CalendarMonth> get months => _months;

  @override
  List<Highlight> get highlights => _highlights;

  void update(CalendarState state) {
    // TODO(google): Disable CSS transitions here somehow
    _state = state;
    if (months != null) {
      months.forEach((m) => m.update(state));
    }
    _updateHighlights();
  }

  static bool _isMonthInRow(int month, int row) {
    if (row == 0) {
      return month <= _monthsPerRow;
    }
    if (row == 1) {
      return month > _monthsPerRow;
    }
    return false;
  }

  @override
  Iterable<Highlight> _mergedHighlights() sync* {
    for (var highlight in super._mergedHighlights()) {
      if (_isMonthInRow(highlight.start, 0) &&
          _isMonthInRow(highlight.end, 1)) {
        yield Highlight(
            highlight.start, _afterFirstRow, highlight.containedRanges,
            group: 0);
        yield Highlight(
            _beforeSecondRow, highlight.end, highlight.containedRanges,
            classIndexOffset: -_monthsPerRow, group: 1);
      } else if (_isMonthInRow(highlight.start, 1)) {
        yield Highlight(
            highlight.start, highlight.end, highlight.containedRanges,
            classIndexOffset: -_monthsPerRow, group: 1);
      } else {
        yield Highlight(
            highlight.start, highlight.end, highlight.containedRanges,
            group: 0);
      }
    }
  }

  @override
  Iterable<Highlight> _generateHighlights() sync* {
    // Position 0: month before this year
    var last = _start.add(months: -1);
    var lastPos = 0;
    var pos = 1;

    // Positions 1 - 12: months in this year
    for (var month in _monthDates()) {
      yield Highlight(lastPos, pos, _matching(last, month));
      last = month;
      lastPos = pos;
      pos++;
    }

    // Position 13: month after this year
    yield Highlight(lastPos, 13, _matching(last, _start.add(months: 12)));
  }

  Iterable<Date> _monthDates() =>
      Iterable.generate(12, (offset) => _start.add(months: offset));

  Iterable<CalendarMonth> monthsInRow(int row) {
    return months.where((m) => _isMonthInRow(m.month, row));
  }

  /// Adds the given number of years to this year. For instance:
  ///
  ///     <2015>.addYears(4) --> 2019
  ///     <2015>.addYears(-3) --> 2012
  CalendarYear addYears(int years) =>
      CalendarYear(year + years, _state, startingWeekday: startingWeekday);

  int getRowIndex(int month, {int monthsPerRow = 4}) =>
      ((month - 1) / monthsPerRow).round();

  CalendarYear get next => addYears(1);

  /// The difference in years between the other year and this year. If
  /// `other` is later than this year, this will be a positive number. For all
  /// `N`, `year.deltaYears(year.addYears(N)) == N`.
  int deltaYears(CalendarYear other) => other.year - year;

  Iterable<CalendarMonth> _generateMonths() sync* {
    var month = CalendarMonth(year, DateTime.january,
        state: _state, startingWeekday: startingWeekday);
    while (month != null) {
      yield month;
      month = month.next;
    }
  }

  @override
  bool operator ==(o) => o is CalendarYear && o._start == _start;

  @override
  int get hashCode => _start.hashCode;

  @override
  String toString() => title;
}

/// Lightweight class representing one or more consecutive years.
class YearRange {
  /// The year at the beginning of the range. The 'month' and 'day' fields are
  /// generally ignored, but should be 1, by convention.
  final Date start;

  /// The number of years in the range. Should be at least 1.
  final int length;

  /// Create a [YearRange] with the given [start] and [length].
  YearRange(this.start, this.length);

  /// Create a [YearRange] with desired [length] and (ideally) start,
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
  factory YearRange.within(CalendarYear min, CalendarYear max, int length,
      {final CalendarYear tryToStartAt}) {
    if (length < 1) {
      throw ArgumentError.value(length, 'length', 'must be at least 1');
    }
    if (min == null) {
      throw ArgumentError.notNull('min');
    }
    if (max == null) {
      throw ArgumentError.notNull('max');
    }

    int years = min.deltaYears(max) + 1;
    if (years < 1) {
      throw ArgumentError('max must not be before min');
    }

    var start = tryToStartAt?.start ?? min.start;

    // Clamp to maximum possible length
    if (length > years) length = years;

    // Enforce minimum
    if (start < min.start) {
      start = min.start;
    }

    // Enforce maximum (the end cannot go past max)
    var end = start.add(years: length - 1);
    if (end > max.start) {
      start = max.start.add(years: -(length - 1));
    }

    return YearRange(start, length);
  }

  /// Eagerly construct a list of [CalendarYear] instances corresponding to
  /// this [YearRange].
  ///
  /// The first entry will have the same year as [startDate]. All
  /// entries will have the specified [state] and [startingWeekday].
  List<CalendarYear> toList(CalendarState state, int startingWeekday) {
    var startYear =
        CalendarYear(start.year, state, startingWeekday: startingWeekday);
    return List.generate(length, (i) => startYear.addYears(i));
  }
}
