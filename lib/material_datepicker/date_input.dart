// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'calendar.dart';
import 'module.dart';

/// A decorator which makes the decorated input automatically parse localized
/// dates.
///
/// When a user types in a date, dates with 2-digit years are handled specially.
/// E.g. 7/7/77 is interpreted as July 7, 1977, not July 7, 77. This logic looks
/// 20 years into the future: right now (August 2015), "35" is interpreted as
/// 2035 but "36" is interpreted as "1936". Next year, "36" will start to be
/// interpreted as 2036.
///
/// The value of the decorated input is two-way bound with the `date` attribute:
/// - When that date changes, the input will update to display it.
/// - When the input's text is changed (only on "change" events, not on each
///   keypress), the decorator will try to parse that text as a date. If it's a
///   valid date, it'll update the selected date to reflect that.
///
/// This hijacks the input's `on-change` property, so don't specify that on the
/// input, or this won't work.
///
/// __Example usage:__
///
///     <material-input dateParsing type="text" [(date)]="statsDate">
///     </material-input>
///
@Directive(
  selector: 'material-input[dateParsing]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class DateInputDirective implements OnDestroy {
  /// Various recognized input formats.
  final _inputFormats = [
    new DateFormat.yMMMd(), // 'Jan 23, 2015'
    new DateFormat.yMd(), // '1/23/2015' (or '23/1/2015' in non-US)
    new DateFormat.yMEd(), // 'Fri, 1/23/2015' (or 'Fri, 23/1/2015')
    new DateFormat.yMMMEd(), // 'Fri, Jan 23, 2015'
    new DateFormat.yMMMMd(), // 'January 23, 2015'
    new DateFormat.yMMMMEEEEd(), // 'Friday, January 23, 2015'
    new DateFormat('yyyy-MM-dd') // ISO format ('2015-01-23')
  ];

  /// Recognized day input formats which omit the year.
  final _dayInputFormatsWithoutYear = [
    new DateFormat.MMMd(), // 'Jan 23'
    new DateFormat.Md(), // '1/23' (or '23/1' in non-US)
    new DateFormat.MEd(), // 'Fri, 1/23' (or 'Fri, 23/1')
    new DateFormat.MMMEd(), // 'Fri, Jan 23'
    new DateFormat.MMMMd(), // 'January 23'
    new DateFormat.MMMMEEEEd() // 'Friday, January 23'
  ];

  /// Recognized month input formats which omit the day.
  final _monthInputFormatsWithoutDay = [
    new DateFormat.yMMM(), // 'Jan 2015'
    new DateFormat.yM(), // '1/2015'
    new DateFormat.yMMMM(), // 'January 2015'
    new DateFormat('yyyy-MM') // ISO format ('2015-01')
  ];

  /// Recognized month input formats which only contain months.
  final _monthInputFormatsMonthOnly = [
    new DateFormat.MMM(), // 'Jan'
    new DateFormat.M(), // '1
    new DateFormat.MMMM() // 'January'
  ];

  final _defaultMonthFormat = new DateFormat.yMMM();
  final _defaultDayFormat = new DateFormat.yMMMd();

  /// The [DateFormat] used to format dates. When [isMonthInput] is false, this
  /// defaults to `yMMMd`, e.g. "Jul 31, 2015". When [isMonthInput] is true,
  /// this defaults to `yMMM`, e.g. "Jul 2015".
  @Input()
  set dateFormat(DateFormat value) {
    _dateFormat = value;
    _input.inputText = _date?.format(dateFormat) ?? '';
  }

  DateFormat _dateFormat;
  DateFormat get dateFormat {
    if (_dateFormat != null) {
      return _dateFormat;
    } else {
      return isMonthInput ? _defaultMonthFormat : _defaultDayFormat;
    }
  }

  /// The latest recognized date, inclusive.
  /// Defaults to Dec 31, 9999 -- i.e., limited to 4-digit years.
  @Input()
  set maxDate(Date date) {
    if (date == null || date == _maxDate) return;
    _maxDate = date;

    // If we rejected the last parsed date because it was bogus... maybe it's
    // not bogus anymore?
    if (_lastParse != _date) _trySetDate(_lastParse, setAsCurrent: true);
  }

  Date _maxDate = new Date(9999, DateTime.DECEMBER, 31);
  Date get maxDate => _maxDate;

  /// The earliest recognized date, inclusive.
  /// Defaults to Jan 1, 1000 -- i.e., limited to 4-digit years.
  @Input()
  set minDate(Date date) {
    if (date == null || date == _minDate) return;
    _minDate = date;

    // If we rejected the last parsed date because it was bogus... maybe it's
    // not bogus anymore?
    if (_lastParse != _date) _trySetDate(_lastParse, setAsCurrent: true);
  }

  Date _minDate = new Date(1000, DateTime.JANUARY, 1);
  Date get minDate => _minDate;

  /// The selected date.
  @Input()
  set date(Date date) {
    _date = _clampDate(date);
    var text = _date?.format(dateFormat) ?? '';
    if (_input.inputText != text) {
      var valid = !_input.required || text.isNotEmpty;
      _input.inputChange(text, valid, valid ? null : invalidDateMsg);
    }
  }

  Date _date;
  Date get date => _date;

  /// Controls whether entered dates are snapped to the beginning of the
  /// specified month (false), or to the end of the specified month (true).
  ///
  /// Only used when [isMonthInput] is true.
  @Input()
  set rangeEnd(isRangeEnd) {
    _isRangeEnd = getBool(isRangeEnd);
  }

  bool _isRangeEnd = false;

  final Disposer _disposer = new Disposer.oneShot();

  final _controller = new StreamController<Date>.broadcast();

  /// Fired when a valid date value is entered.
  @Output()
  Stream<Date> get dateChange => _controller.stream;

  /// If true, the control is used for inputting months rather than specific
  /// days. This impacts both how dates are parsed and how they may be altered
  /// to fit to the beginning or end of the selected month (depending on
  /// [rangeEnd]).
  @Input('month')
  bool isMonthInput = false;

  final Clock _clock;
  final MaterialInputComponent _input;

  // Support for _parseDateCached
  String _cachedResult;
  String _cachedInput = '';
  Date _cachedMinDate;
  Date _cachedMaxDate;
  Date _lastParse;

  DateInputDirective(@Optional() @Inject(datepickerClock) Clock clock,
      Clock legacyClock, this._input)
      : _clock = clock ?? legacyClock {
    // TODO(google): Migrate to use only datepickerClock
    // TODO(google): Participate in Forms API?
    _disposer.addStreamSubscription(_input.onChange
        .listen((String input) => _parseDate(input, setAsCurrent: true)));

    _input.checkValid = (String input) => _parseDateCached(input);
    _input.requiredErrorMsg = invalidDateMsg;
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  // Clamp the date to first or last day of the month, depending on whether
  // this input field is for the start or the end of a month range.
  Date _clampDate(Date date) {
    if (date != null && isMonthInput) {
      if (_isRangeEnd) {
        return lastDayOfMonth(date);
      } else {
        return firstDayOfMonth(date);
      }
    }
    return date;
  }

  /// Parse the given string as a date using one of the listed formats.
  /// Returns the parsed date, or null if the string didn't match any format.
  Date _parseDateUsingFormatList(String input, List<DateFormat> formatList) {
    Date date;
    formatList.any((format) {
      try {
        date = new Date.parseLoose(input, format);
        date = _clampDate(date);
        return true;
      } on FormatException {
        return false;
      } on ArgumentError {
        // This could be a valid date format, but a date greater than
        // DateTime's max allowed time
        return false;
      }
    });
    return date;
  }

  /// A cache for _parseDate, to speed up change detection.
  /// Does not update [date] or change the textbox contents.
  String _parseDateCached(String input) {
    var minOrMaxDateChanged =
        minDate != _cachedMinDate || maxDate != _cachedMaxDate;
    if (minOrMaxDateChanged) {
      _cachedMinDate = minDate;
      _cachedMaxDate = maxDate;
    }
    // Parse the input when text has changed, or when min or max date has
    // changed and user has already entered text.
    if (input != _cachedInput || (input.isNotEmpty && minOrMaxDateChanged)) {
      _cachedResult = _parseDate(input, setAsCurrent: false);
      _cachedInput = input;
    }
    return _cachedResult;
  }

  /// Parse the given string as a date, perform fixup, and check date limits.
  /// Returns null on success, or a localized error string on failure.
  /// - `setAsCurrent: bool` -- If true, and parsing succeeds, set the text
  ///   to the parsed date.
  String _parseDate(String input, {bool setAsCurrent: false}) {
    if (input.trim().isEmpty) {
      // Empty input is invalid iff input is required
      _lastParse = null;
      if (_input.required) {
        return invalidDateMsg;
      }
    } else {
      // Non-empty input is invalid iff parsing fails
      if (isMonthInput) {
        _lastParse = _parseDateUsingFormatList(input, _inputFormats) ??
            _parseDateUsingFormatList(input, _monthInputFormatsWithoutDay) ??
            _guessYear(
                _parseDateUsingFormatList(input, _monthInputFormatsMonthOnly));
      } else {
        _lastParse = _parseDateUsingFormatList(input, _inputFormats) ??
            _guessYear(
                _parseDateUsingFormatList(input, _dayInputFormatsWithoutYear));
      }

      if (_lastParse == null) {
        return invalidDateMsg;
      }
    }

    if (_lastParse != null && _lastParse.year < 100) {
      _lastParse = new Date(
          _guessCentury(_lastParse.year), _lastParse.month, _lastParse.day);
    }

    return _trySetDate(_lastParse, setAsCurrent: setAsCurrent);
  }

  /// Given an already parsed date, checks its validity and optionally sets it
  /// as the current value if valid.
  String _trySetDate(Date date, {bool setAsCurrent: false}) {
    // Always update the textbox if the date parses successfully. This is useful
    // feedback for users even if the entered date is too early/late.
    if (setAsCurrent) {
      _input.inputText = date?.format(dateFormat) ?? '';
    }

    if (date != null) {
      if (date < minDate) {
        return dateIsTooEarlyMsg(minDate.format(dateFormat));
      } else if (date > maxDate) {
        return dateIsTooLateMsg(maxDate.format(dateFormat));
      }
    }

    if (setAsCurrent) {
      if (isMonthInput &&
          date != null &&
          _date != null &&
          date.month == _date.month &&
          date.year == _date.year) {
        // If the new date is the same month and year as the current value,
        // use the current (already clamped) value instead.
        date = _date;
      } else {
        _date = date;
      }
      _controller.add(date);
    }

    return null;
  }

  /// Given a two-digit year, guess which century it belongs to. For instance,
  /// `15` probably means `2015` and `99` probably means `1999`.
  ///
  /// As of today, `44` probably means `1944`, but at some point in the future
  /// it'll start to mean `2044`. By default, we'll look 20 years into the
  /// future, so `44` will switch from meaning `1944` to `2044` in 2024.
  int _guessCentury(int year, {int lookahead: 20}) {
    var currentYear = _clock.now().year;
    var currentCentury = currentYear ~/ 100;
    var guess = year + currentCentury * 100;
    if (guess - currentYear > lookahead) {
      guess -= 100;
    }
    return guess;
  }

  /// Given a date which parsed successfully but didn't specify a year, guess
  /// which year the user probably meant. Usually this is "this year". But, if
  /// "this year" violates date limits then "last year" or "next year" may make
  /// more sense. For example, if it's January 2015 and the max date is today,
  /// "12/31" probably means "12/31/2014", not "12/31/2015".
  /// Returns a fixed-up date with the guessed year and the same month and day,
  /// or null if null was passed.
  Date _guessYear(Date date) {
    if (date == null) return null;

    final thisYear = new Date(_clock.now().year, date.month, date.day);
    for (var candidate in [
      thisYear,
      thisYear.add(years: 1),
      thisYear.add(years: -1)
    ]) {
      if (candidate >= minDate && candidate <= maxDate) {
        return candidate;
      }
    }

    // If none of the candidates are valid, default to the current year, rather
    // than making wilder guesses.
    return thisYear;
  }

  String get invalidDateMsg => Intl.message('Enter a date',
      name: 'invalidDateMsg',
      meaning: 'Error message',
      desc: 'Displayed when the user types text into a date input field which '
          'isn\'t recognized as a valid date.');

  String dateIsTooEarlyMsg(String minimumDate) => Intl.message(
      'Enter $minimumDate or later',
      name: 'dateIsTooEarlyMsg',
      args: [minimumDate],
      examples: const {'minimumDate': 'Jan 1, 2005'},
      meaning: 'Error message',
      desc: 'Displayed when the user enters a valid date, but it\'s before the '
          'minimum date accepted by the date input field.');

  String dateIsTooLateMsg(String maximumDate) => Intl.message(
      'Enter $maximumDate or earlier',
      name: 'dateIsTooLateMsg',
      args: [maximumDate],
      examples: const {'maximumDate': 'Dec 31, 2025'},
      meaning: 'Error message',
      desc: 'Displayed when the user enters a valid date, but it\'s after the '
          'maximum date accepted by the date input field.');
}
