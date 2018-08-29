// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A calendar week.
class CalendarWeek extends _HasHighlights {
  final Date _start;
  final int _startingWeekday;
  List<CalendarDay> _days;
  List _spacers;
  Date _end;

  CalendarWeek(this._start, CalendarState state,
      [this._startingWeekday = DateTime.monday])
      : super(state) {
    _end = _start.add(days: numDays - 1);
    if (_end.isAfter(_endOfMonth)) {
      _end = _endOfMonth;
    }

    if (state?._resolutionAtLeast(CalendarResolution.weeks) ?? false) {
      _days = [];
    } else {
      _days = _generateDays().toList();
    }
    _spacers = List(numBlankDays);
    _updateHighlights();
  }

  /// The [CalendarDay] instances within this week.
  ///
  /// Note that if the [CalendarResolution] of the associated [CalendarState]
  /// is >= [CalendarResolution.weeks], this list will be empty.
  List<CalendarDay> get days => _days;

  int get numDays => 7 - ((_start.weekday - 1) - (_startingWeekday - 1)) % 7;

  /// Blank 'spacer' days, if this is the first week of the month and the month
  /// does not start on the first day of the week. Publicly visible for tests.
  int get numBlankDays => 7 - numDays;

  List get spacers => _spacers;

  @override
  List<Highlight> get highlights => _highlights;

  void update(CalendarState state) {
    _state = state;
    days.forEach((d) => d.updateClasses(state));
    _updateHighlights();
  }

  CalendarWeek get next {
    if (_end.isBefore(_endOfMonth)) {
      return CalendarWeek(_end.add(days: 1), _state, _startingWeekday);
    }
    return null;
  }

  Iterable<CalendarDay> _generateDays() =>
      _iterateDays().map((d) => CalendarDay(d, _state));

  /// Generates highlight objects based on which calendar selections match each
  /// pair of adjacent dates. This yields one highlight per date considered; use
  /// `_mergedHighlights` to consolidate adjacent matching highlights into one
  /// bigger highlight.
  ///
  /// Basically the way to think about these highlights is that there are 9
  /// positions on the calendar: the start of the week, the end of the week,
  /// and the 7 days of the week. For the days of the week, the highlight has to
  /// start/end within the weekday, and not at its start or end. Take for
  /// instance March 2015:
  ///
  ///        |    Mon Tue Wed Thu Fri Sat Sun    |
  ///        |                             1     |
  ///        |     2   3   4   5   6   7   8     |
  ///                        (...)
  ///     positions:
  ///        0     1   2   3   4   5   6   7     8
  ///
  /// What this does is it goes over the spaces between these positions and
  /// figures out what color each should be. First it'll yield the data for the
  /// space between the start of the week and Monday, and then for Monday to
  /// Tuesday, and so on. Say for instance that we had a blue range from Mar 1
  /// to Mar 4, and a green range from Mar 4 to Mar 7:
  ///
  ///     |       Mon      Tue      Wed       Thu       Fri       Sat Sun |
  ///     |        2        3        4         5         6         7   8  |
  ///     | (blue)   (blue)   (blue)   (green)   (green)   (green) 7   8  |
  @override
  Iterable<Highlight> _generateHighlights() sync* {
    // Position 0: day before this week
    var last = _start.add(days: -1);
    var lastPos = 0;
    var pos = numBlankDays + 1;

    // Positions `numBlankDays + 1` - 7: days in this week
    for (var day in _iterateDays()) {
      yield Highlight(lastPos, pos, _matching(last, day));
      last = day;
      lastPos = pos;
      pos++;
    }

    // Position 8: day after this week
    var day = _end.add(days: 1);
    yield Highlight(lastPos, 8, _matching(last, day));
  }

  /// Iterator over all the dates contained in this calendar week
  Iterable<Date> _iterateDays() sync* {
    var day = _start;
    while (!day.isAfter(_end)) {
      yield day;
      day = day.add(days: 1);
    }
  }

  // Specifying day 0 of the next month is a way to get the last day of the
  // current month. (This behavior is actually guaranteed by DateTime's API.)
  Date get _endOfMonth => Date(_start.year, _start.month + 1, 0);
}
