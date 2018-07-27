// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/range.dart';

/// A [DatepickerPreset] represents an option for selecting a predefined date
/// range in material-date-range-picker.
///
/// Presets can optionally include [alternatives]: a list of other related
/// presets that can be selected in a dropdown menu.
class DatepickerPreset {
  /// The label to display for the preset (e.g. "Last week (Sun - Sat)").
  final String title;

  /// The date range to select when the preset is selected.
  final DatepickerDateRange range;

  /// An optional short label for the preset (e.g. "Mon - Sun").
  final String shortTitle;

  /// An optional list of related presets to display in a dropdown menu.
  final List<DatepickerPreset> alternatives;

  /// Create a [DatepickerPreset] based on a [DatepickerDateRange].
  factory DatepickerPreset.fromRange(DatepickerDateRange range) =>
      DatepickerPreset(range.title, range);

  /// Create a [DatepickerPreset] for selecting "This week".
  ///
  /// [startWeekday] is the 1-based first day of the week: e.g.
  /// [DateTime.monday] (which equals 1) for Monday, [DateTime.tuesday] for
  /// Tuesday, etc. It defaults to the first day of the week specified in the
  /// current locale.
  ///
  /// [validStartWeekdays] is a list of all starting weekdays which will be
  /// added as [alternatives].
  factory DatepickerPreset.thisWeek(Clock clock,
      {int startWeekday, List<int> validStartWeekdays}) {
    startWeekday ??= _defaultStartWeekday;
    validStartWeekdays =
        _initValidStartWeekdays(startWeekday, validStartWeekdays);

    DatepickerPreset result;
    List<DatepickerPreset> alternatives = [];
    for (var startDay in validStartWeekdays) {
      var startDayName = _weekdayName(startDay);
      var preset = DatepickerPreset(_thisWeekTitle(startDayName),
          WeekRange.weeksAgo(clock, 0, startWeekday: startDay),
          shortTitle: _thisWeekShortTitle(startDayName),
          alternatives: alternatives);
      alternatives.add(preset);
      if (startDay == startWeekday) result = preset;
    }
    return result;
  }

  /// Create a [DatepickerPreset] for selecting "Last week".
  ///
  /// [startWeekday] is the 1-based first day of the week: e.g.
  /// [DateTime.monday] (which equals 1) for Monday, [DateTime.tuesday] for
  /// Tuesday, etc. It defaults to the first day of the week specified in the
  /// current locale.
  ///
  /// [validStartWeekdays] is a list of all starting weekdays which will be
  /// added as [alternatives].
  factory DatepickerPreset.lastWeek(Clock clock,
      {int startWeekday, List<int> validStartWeekdays}) {
    startWeekday ??= _defaultStartWeekday;
    validStartWeekdays =
        _initValidStartWeekdays(startWeekday, validStartWeekdays);

    DatepickerPreset result;
    List<DatepickerPreset> alternatives = [];
    for (var startDay in validStartWeekdays) {
      var endDay = 1 + ((startDay - 1) + 6).remainder(7);
      var startDayName = _weekdayName(startDay);
      var endDayName = _weekdayName(endDay);
      var preset = DatepickerPreset(_lastWeekTitle(startDayName, endDayName),
          WeekRange.weeksAgo(clock, 1, startWeekday: startDay),
          shortTitle: _lastWeekShortTitle(startDayName, endDayName),
          alternatives: alternatives);
      alternatives.add(preset);
      if (startDay == startWeekday) result = preset;
    }
    return result;
  }

  /// Create a [DatepickerPreset].
  DatepickerPreset(this.title, this.range,
      {this.shortTitle, this.alternatives});

  static final _weekdayNames = DateFormat().dateSymbols.STANDALONESHORTWEEKDAYS;

  // Where 1 = Mon, 7 = Sun.
  static int get _defaultStartWeekday =>
      1 + DateFormat().dateSymbols.FIRSTDAYOFWEEK;

  static const _defaultValidStartWeekdays = [DateTime.sunday, DateTime.monday];

  static List<int> _initValidStartWeekdays(
      int startWeekday, List<int> validStartWeekdays) {
    validStartWeekdays ??= List<int>.from(_defaultValidStartWeekdays);
    if (!validStartWeekdays.contains(startWeekday)) {
      validStartWeekdays.insert(0, startWeekday);
    }
    return validStartWeekdays;
  }

  // [weekday] is [1 = Mon, 7 = Sun] and [_weekdayNames] is [Sun .. Sat].
  static String _weekdayName(int weekday) =>
      _weekdayNames[weekday.remainder(7)];

  static String _thisWeekTitle(String startDayName) =>
      Intl.message('This week ($startDayName – Today)',
          name: 'DatepickerPreset__thisWeekTitle',
          desc: 'Label for a date range corresponding to "this week" starting '
              'on a particular day of the week and ending today.'
              ' [REL_NOTE: zjd/2017-12-31]',
          args: [startDayName],
          examples: const {'startDayName': 'Mon'});

  static String _thisWeekShortTitle(String startDayName) =>
      Intl.message('$startDayName – Today',
          name: 'DatepickerPreset__thisWeekShortTitle',
          desc: 'Short label for a date range corresponding to "this week" '
              'indicating which day of the week is the starting day of the '
              'week.'
              ' [REL_NOTE: zjd/2017-12-31]',
          args: [startDayName],
          examples: const {'startDayName': 'Mon'});

  static String _lastWeekTitle(String startDayName, String endDayName) =>
      Intl.message('Last week ($startDayName – $endDayName)',
          name: 'DatepickerPreset__lastWeekTitle',
          desc: 'Label for a date range corresponding to "last week" starting '
              'on a particular day of the week and ending on the last day of '
              'the week.'
              ' [REL_NOTE: zjd/2017-12-31]',
          args: [startDayName, endDayName],
          examples: const {'startDayName': 'Sun', 'endDayName': 'Sat'});

  static String _lastWeekShortTitle(String startDayName, String endDayName) =>
      Intl.message('$startDayName – $endDayName',
          name: 'DatepickerPreset__lastWeekShortTitle',
          desc: 'Short label for a date range corresponding to "last week" '
              'indicating which day of the week is the starting day of the '
              'week and which is the last day of the week.'
              ' [REL_NOTE: zjd/2017-12-31]',
          args: [startDayName, endDayName],
          examples: const {'startDayName': 'Sun', 'endDayName': 'Sat'});
}

/// The default list of presets to use in material-date-range-picker.
List<DatepickerPreset> defaultPresets(Clock clock) => [
      DatepickerPreset.fromRange(today(clock)),
      DatepickerPreset.fromRange(yesterday(clock)),
      DatepickerPreset.thisWeek(clock),
      DatepickerPreset.fromRange(last7Days(clock)),
      DatepickerPreset.lastWeek(clock),
      DatepickerPreset.fromRange(last14Days(clock)),
      DatepickerPreset.fromRange(thisMonth(clock)),
      DatepickerPreset.fromRange(last30Days(clock)),
      DatepickerPreset.fromRange(lastMonth(clock)),
      DatepickerPreset.fromRange(allTime),
    ];
