// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:angular_components/model/date/date.dart';

final _dayFmt = DateFormat.d();
final _dateFmt = DateFormat.yMMMd();
final _yearFmt = DateFormat.y();
final _monthFmt = DateFormat.MMM();

/// Formats the date, or returns '' if the date is null.
String formatDate(Date date) => date?.format(_dateFmt) ?? '';
String formatRange(DateRange range) {
  if (range == null) return '';
  if (range.start == null && range.end == null)
    return _DateFormatterMessages._allTimeMsg;
  if (range.start == range.end) return formatDate(range.start);

  if ((range.start == null || range.end == null) ||
      range.start.year != range.end.year) {
    return _DateFormatterMessages._formatArbitraryRange(
        formatDate(range.start), formatDate(range.end));
  }
  if (range.start.month != range.end.month) {
    return _DateFormatterMessages._formatSameYearRange(
        range.start.format(_monthFmt),
        range.start.format(_dayFmt),
        range.end.format(_monthFmt),
        range.end.format(_dayFmt),
        range.start.format(_yearFmt));
  }
  return _DateFormatterMessages._formatSameMonthRange(
      range.start.format(_monthFmt),
      range.start.format(_dayFmt),
      range.end.format(_dayFmt),
      range.start.format(_yearFmt));
}

class _DateFormatterMessages {
  static final _allTimeMsg = Intl.message('All time',
      name: '_allTimeMsg',
      desc: 'Indicates that the selected date range has no start or end');

  // I give it about a 50/50 chance that these messages actually work
  // (There is actually a CLDR spec for date ranges, but it doesn't look like
  // Dart implements it)
  static String _formatSameYearRange(String month1, String day1, String month2,
          String day2, String year) =>
      Intl.message('$month1 $day1 – $month2 $day2, $year',
          name: '_DateFormatterMessages__formatSameYearRange',
          desc: 'Date range format when a range starts and ends in the same '
              'year. Please reorder and adjust punctuation as appropriate for '
              'the locale. Do not include time units such as 년 or 年.',
          args: [
            month1,
            day1,
            month2,
            day2,
            year
          ],
          examples: const {
            'month1': 'Jul',
            'day1': '25',
            'month2': 'Aug',
            'day2': '3',
            'year': '2015'
          });

  static String _formatSameMonthRange(
          String month, String day1, String day2, String year) =>
      Intl.message('$month $day1 – $day2, $year',
          name: '_DateFormatterMessages__formatSameMonthRange',
          desc: 'Date range format when a range starts and ends in the same '
              'month. Please reorder and adjust punctuation as appropriate '
              'for the locale. Do not include time units such as 년 or 年.',
          args: [
            month,
            day1,
            day2,
            year
          ],
          examples: const {
            'month': 'Jul',
            'day1': '25',
            'day2': '29',
            'year': '2015'
          });

  static String _formatArbitraryRange(String start, String end) =>
      Intl.message('$start – $end',
          name: '_DateFormatterMessages__formatArbitraryRange',
          desc: 'Date range containing two arbitrary dates which can fall in '
              'different years. Please reorder and adjust punctuation as '
              'appropriate for the locale, if necessary. Do not include '
              'time units such as 년 or 年.',
          args: [start, end],
          examples: const {'start': 'Jul 27, 2015', 'end': 'Aug 3, 2015'});
}
