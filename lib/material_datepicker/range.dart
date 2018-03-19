// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/di.dart';
import 'package:angular_components/material_datepicker/proto/date.pb.dart'
    as dateproto;
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/proto/date_range.pb.dart'
    as proto;
import 'package:angular_components/model/date/date.dart';

/// If the given range is valid (non-null with non-null start and end dates),
/// returns the result of calling the given function. Otherwise returns `null`.
DatepickerDateRange _ifValidRange(
    DatepickerDateRange r, DatepickerDateRange fn()) {
  if (r == null || r.start == null || r.end == null) {
    return null;
  }
  return fn();
}

DatepickerDateRange _genericNext(DatepickerDateRange r) => _ifValidRange(
    r,
    () => new DatepickerDateRange.custom(
        r.end.add(days: 1), r.end.add(days: daysSpanned(r.start, r.end))));
DatepickerDateRange _genericPrev(DatepickerDateRange r) => _ifValidRange(
    r,
    () => new DatepickerDateRange.custom(
        r.start.add(days: -daysSpanned(r.start, r.end)),
        r.start.add(days: -1)));

typedef DatepickerDateRange RangeFn(DatepickerDateRange range);

/// A datepicker-specific implementation of [DateRange], extended with a title
/// and an interface for computing the next/previous date range.
abstract class DatepickerDateRange implements DateRange {
  /// E.g. "Last 7 days", "This month", "Custom", etc.
  String get title;

  @override
  Date get start;

  @override
  Date get end;

  /// A date range which begins immediately after this one ends, and has either
  /// the same length or similar semantics (such as "the next month").
  DatepickerDateRange get next;

  /// A date range which ends immediately before this one starts, and has either
  /// the same length or similar semantics (such as "the previous year").
  DatepickerDateRange get prev;

  /// Whether the date range is predefined by the application.
  ///
  /// `true` if the date range is defined by the application; `false` if it's a
  /// custom date range specified by the user.
  bool get isPredefined;

  /// `true` if this date range represents all available history.
  ///
  /// All time ranges might be handled specially by backends. For instance,
  /// Shasta has preaggregated all time stats tables, so queries are a lot
  /// faster if it knows the all-time-ness of a range, instead of just the start
  /// and end dates.
  bool get isAllTime;

  /// Clamps the current date range to the given min and max dates. Returns null
  /// if this range has no overlap with the given date range.
  ///
  /// This clamping applies recursively; `range.clamp(max: someDate).prev.next`
  /// will return the clamped date range, not the original date range.
  DatepickerDateRange clamp({Date min, Date max});

  /// Reverses the effect of one call to clamp() (assuming clamp() didn't return
  /// null). If clamp() succeeds, range.clamp(...).unclamped() == range.
  ///
  /// If this range isn't clamped, it is returned unchanged.
  ///
  /// Multiple chained calls to clamp() require the same number of calls to
  /// unclamped() to undo.
  DatepickerDateRange unclamped();

  /// Returns this range as a plain [DateRange]. This is needed because
  /// [DateRange]'s equality is strict on types.
  @override
  DateRange asPlainRange();

  /// Convert this date range into the protocol buffer format defined in
  /// date_range.proto.
  proto.DatepickerDateRange toProtoBuf();

  factory DatepickerDateRange(String title, Date start, Date end,
          {RangeFn next: _genericNext,
          RangeFn prev: _genericPrev,
          bool isPredefined: false,
          bool isAllTime: false}) =>
      new _BasicDateRange(
          title, start, end, next, prev, isPredefined, isAllTime);

  /// Shortcut to define a "custom" date range with a localized "Custom" title
  /// and default behavior.
  factory DatepickerDateRange.custom(Date start, Date end) =>
      new DatepickerDateRange(_customDateRangeMsg, start, end);

  /// Construct from the protocol buffer format defined in date_range.proto.
  factory DatepickerDateRange.fromProtoBuf(
      Clock clock, proto.DatepickerDateRange pb) {
    if (pb.hasAllTimeRange()) {
      return allTime;
    } else if (pb.hasDaysAgo()) {
      return new SingleDayRange.daysAgo(clock, pb.daysAgo);
    } else if (pb.hasLastNDays()) {
      return new LastNDaysRange.beforeToday(clock, pb.lastNDays);
    } else if (pb.hasLastNDaysToToday()) {
      return new LastNDaysToTodayRange.beforeToday(clock, pb.lastNDaysToToday);
    } else if (pb.hasWeeksAgo()) {
      if (pb.hasStartWeekday()) {
        return new WeekRange.weeksAgo(clock, pb.weeksAgo,
            startWeekday: pb.startWeekday);
      } else {
        return new WeekRange.weeksAgo(clock, pb.weeksAgo);
      }
    } else if (pb.hasMonthsAgo()) {
      return new MonthRange.monthsAgo(clock, pb.monthsAgo);
    } else if (pb.hasBroadcastMonthsAgo()) {
      return new BroadcastMonthRange.monthsAgo(clock, pb.broadcastMonthsAgo);
    } else if (pb.hasYearsAgo()) {
      return new YearRange.yearsAgo(clock, pb.yearsAgo);
    }

    return new DatepickerDateRange.custom(
        _convertToDate(pb.dateRange.start), _convertToDate(pb.dateRange.end));
  }
}

DatepickerDateRange _clamp(DatepickerDateRange range, {Date min, Date max}) {
  if (min != null && max != null) assert(min <= max);
  if ((min == null || range.end == null || min <= range.end) &&
      (max == null || range.start == null || max >= range.start)) {
    return new _ClampedDateRange(range, min: min, max: max);
  }
  return null;
}

bool rangeEqual(DatepickerDateRange range, o) =>
    (range == null && o == null) ||
    (range is DatepickerDateRange &&
        o is DatepickerDateRange &&
        range.title == o.title &&
        range.start == o.start &&
        range.end == o.end);

int rangeHash(DatepickerDateRange range) =>
    range.title.hashCode ^ range.start.hashCode ^ range.end.hashCode;

String _rangeString(DatepickerDateRange range) =>
    '${range.title} (${range.start}) (${range.end})';

DateRange _plainRange(DatepickerDateRange range) =>
    new DateRange(range.start, range.end);

proto.DatepickerDateRange _makeProtoBuf(DatepickerDateRange range) =>
    range.isAllTime
        ? (new proto.DatepickerDateRange()..allTimeRange = true)
        : (new proto.DatepickerDateRange()
          ..dateRange = _makeDateRangeProto(range.start, range.end));

_makeDateRangeProto(Date start, Date end) => new proto.DateRange()
  ..start = _makeDateProto(start)
  ..end = _makeDateProto(end);

dateproto.Date _makeDateProto(Date date) => new dateproto.Date()
  ..year = date.year
  ..month = date.month
  ..day = date.day;

Date _convertToDate(dateproto.Date date) =>
    new Date(date.year, date.month, date.day);

/// An implementation of [DatepickerDateRange] that delegates to an underlying
/// instance, but clamps its start and end dates to some range.
///
/// For example, clamping the "this year" range to (null-Jul 16) would result in
/// Jan 1-Jul 16. This effect take place across calls to next/prev also --
/// calling clampedDateRange.prev.next should be equivalent to the clamped date
/// range, and not the underlying date range.
class _ClampedDateRange implements DatepickerDateRange {
  final Date _min;
  final Date _max;
  final DatepickerDateRange _delegate;

  _ClampedDateRange(this._delegate, {Date min, Date max})
      : _min = min,
        _max = max;

  @override
  String get title => _delegate.title;
  @override
  bool get isPredefined => _delegate.isPredefined;
  @override
  bool get isAllTime => _delegate.isAllTime;

  @override
  Date get start {
    final date = _delegate.start;
    return (date == null || (_min != null && _min > date)) ? _min : date;
  }

  @override
  Date get end {
    final date = _delegate.end;
    return (date == null || (_max != null && _max < date)) ? _max : date;
  }

  @override
  DatepickerDateRange get next {
    if (_max != null && _delegate.end != null && _delegate.end > _max) {
      return null;
    }
    return _delegate.next?.clamp(min: _min, max: _max);
  }

  @override
  DatepickerDateRange get prev {
    if (_min != null && _delegate.start != null && _delegate.start < _min) {
      return null;
    }
    return _delegate.prev?.clamp(min: _min, max: _max);
  }

  @override
  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);

  @override
  DatepickerDateRange unclamped() => _delegate;

  @override
  DateRange asPlainRange() => _plainRange(this);

  /// Capture the delegate's relative_preset semantics, if any, but replace its
  /// concrete dates with clamped ones.
  @override
  proto.DatepickerDateRange toProtoBuf() =>
      _delegate.toProtoBuf()..dateRange = _makeDateRangeProto(start, end);

  bool operator ==(o) =>
      rangeEqual(this, o) &&
      (o is _ClampedDateRange) &&
      _min == o._min &&
      _max == o._max;
  int get hashCode => rangeHash(this) ^ _min.hashCode ^ _max.hashCode;
  String toString() => '${_rangeString(this)} (clamped $_min - $_max)';
}

/// Dumb implementation of [DatepickerDateRange].
///
/// Implementations of `next` and `prev` are passed in, so that other
/// implementations can return dumb literal date ranges whose next and previous
/// ranges are smarter. E.g. "This year up to today" can be a dumb date range,
/// but can return a `YearRange` as its previous range.
class _BasicDateRange implements DatepickerDateRange {
  final String title;
  final Date start;
  final Date end;
  final bool isPredefined;
  final bool isAllTime;

  final RangeFn _next;
  final RangeFn _prev;

  _BasicDateRange(this.title, this.start, this.end, this._next, this._prev,
      this.isPredefined, this.isAllTime);

  DatepickerDateRange get next => _next(this);
  DatepickerDateRange get prev => _prev(this);

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() => _makeProtoBuf(this);

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);
}

/// Builds the date range title based on how many units ago the date range is.
///
/// E.g. "1 year ago" or "3 days from now"
typedef String RangeTitle(int ago);

/// A single day. Special-cased to have titles like "today", "4 days ago", etc.
class SingleDayRange implements DatepickerDateRange {
  final Date _date;
  final int _ago;
  final RangeTitle _titleFunction;
  SingleDayRange(this._date, this._ago, [this._titleFunction = _defaultTitle]);
  SingleDayRange.daysAgo(clock, ago, [RangeTitle titleFunction = _defaultTitle])
      : this(new Date.today(clock).add(days: -ago), ago, titleFunction);

  String get title => _titleFunction(_ago);
  Date get start => _date;
  Date get end => _date;
  DatepickerDateRange get next =>
      new SingleDayRange(_date.add(days: 1), _ago - 1, _titleFunction);
  DatepickerDateRange get prev =>
      new SingleDayRange(_date.add(days: -1), _ago + 1, _titleFunction);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Number of days ago relative to the current date.
  int get ago => _ago;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() => _makeProtoBuf(this)..daysAgo = _ago;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static String _defaultTitle(int daysAgo) =>
      daysAgo > 0 ? _addDaysMsg(daysAgo) : _daysFromNowMsg(-daysAgo);

  static _addDaysMsg(daysAgo) => Intl.plural(daysAgo,
      zero: 'Today',
      one: 'Yesterday',
      other: '$daysAgo days ago',
      name: '_addDaysMsg',
      args: [daysAgo],
      desc: 'A date range containing only one day a certain number '
          'of days in the past.',
      examples: const {'daysAgo': 2});

  static _daysFromNowMsg(daysFromNow) => Intl.plural(daysFromNow,
      zero: 'Today',
      one: 'Tomorrow',
      other: '$daysFromNow days from now',
      name: '_daysFromNowMsg',
      args: [daysFromNow],
      desc: 'A date range containing only one day a certain number '
          'of days in the future.',
      examples: const {'daysFromNow': 2});
}

/// A range 'N' days long, which ends yesterday (today is not included).
///
/// Special-cased to have titles like 'Last 7 days', etc.
/// 'lengthInDays' should be at least 1.
class LastNDaysRange implements DatepickerDateRange {
  final Date _start;
  final int _lengthInDays;
  final String title;
  LastNDaysRange(this._start, int lengthInDays, [String title])
      : title = title ?? _lastNDaysMsg(lengthInDays),
        _lengthInDays = lengthInDays;
  LastNDaysRange.beforeToday(clock, lengthInDays, [String title])
      : this(new Date.today(clock).add(days: -lengthInDays), lengthInDays,
            title);
  Date get start => _start;
  Date get end => _start.add(days: _lengthInDays - 1);
  DatepickerDateRange get next => _genericNext(this);
  DatepickerDateRange get prev => _genericPrev(this);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Length of the range in number of days.
  int get lengthInDays => _lengthInDays;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..lastNDays = _lengthInDays;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static _lastNDaysMsg(lengthInDays) => Intl.plural(lengthInDays,
      one: 'Yesterday',
      other: 'Last $lengthInDays days',
      name: '_lastNDaysMsg',
      args: [lengthInDays],
      desc: 'A date range containing the last "lengthInDays" days, '
          'not including today.',
      examples: const {'lengthInDays': 7});
}

/// A range 'N' days long which ends today.
///
/// Special-cased to have titles like '7 days to today', etc.
/// 'lengthInDays' should be at least 1.
class LastNDaysToTodayRange implements DatepickerDateRange {
  final Date _start;
  final int _lengthInDays;
  final String title;
  LastNDaysToTodayRange(this._start, int lengthInDays, [String title])
      : title = title ?? _lastNDaysToTodayMsg(lengthInDays),
        _lengthInDays = lengthInDays;
  LastNDaysToTodayRange.beforeToday(clock, lengthInDays, [String title])
      : this(new Date.today(clock).add(days: -(lengthInDays - 1)), lengthInDays,
            title);
  Date get start => _start;
  Date get end => _start.add(days: _lengthInDays - 1);
  DatepickerDateRange get next => _genericNext(this);
  DatepickerDateRange get prev => _genericPrev(this);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Length of the range in number of days.
  int get lengthInDays => _lengthInDays;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..lastNDaysToToday = _lengthInDays;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static _lastNDaysToTodayMsg(lengthInDays) => Intl.plural(lengthInDays,
      one: 'Today',
      other: '$lengthInDays days to today',
      name: '_lastNDaysToTodayMsg',
      args: [lengthInDays],
      desc: 'A date range containing the last "lengthInDays" days, '
          'ending today.',
      examples: const {'lengthInDays': 7});
}

/// A single week. Special-cased to have titles like "This week" or "Last week".
class WeekRange implements DatepickerDateRange {
  static Date _weekStart(Date date, int startWeekday) {
    return date.add(days: -((date.weekday - startWeekday) % 7));
  }

  final Date _start;
  final int _ago;
  final int _startWeekday;
  final RangeTitle _titleFunction;
  WeekRange(this._start, this._ago,
      [this._titleFunction = _defaultTitle, this._startWeekday]);

  /// Constructs a [WeekRange] ending [ago] weeks ago from the date given by
  /// [clock] starting on the [startWeekday].
  ///
  /// The [startWeekday] is the 1-based first day of the week: e.g.
  /// [DateTime.MONDAY] (which equals 1) for Monday, [DateTime.TUESDAY] for
  /// Tuesday, etc. It defaults to the first day of the week specified in the
  /// current locale.
  WeekRange.weeksAgo(clock, ago,
      {RangeTitle titleFunction = _defaultTitle, int startWeekday})
      : this(
            _weekStart(
                    new Date.today(clock),
                    startWeekday ??
                        (new DateFormat().dateSymbols.FIRSTDAYOFWEEK + 1))
                .add(days: -7 * ago),
            ago,
            titleFunction,
            startWeekday);

  String get title => _titleFunction(_ago);
  Date get start => _start;
  Date get end => _start.add(days: 6);
  DatepickerDateRange get next =>
      new WeekRange(_start.add(days: 7), _ago - 1, _titleFunction);
  DatepickerDateRange get prev =>
      new WeekRange(_start.add(days: -7), _ago + 1, _titleFunction);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Number of weeks ago relative to the current date.
  int get ago => _ago;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);

  proto.DatepickerDateRange toProtoBuf() {
    var result = _makeProtoBuf(this)..weeksAgo = _ago;
    if (_startWeekday != null) {
      result.startWeekday = _startWeekday;
    }
    return result;
  }

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static String _defaultTitle(int weeksAgo) =>
      weeksAgo > 0 ? _weeksAgoMsg(weeksAgo) : _weeksFromNowMsg(-weeksAgo);

  static _weeksAgoMsg(weeksAgo) => Intl.plural(weeksAgo,
      zero: 'This week', // TODO(google): 'This week (Mon-Sun)'
      one: 'Last week',
      other: '$weeksAgo weeks ago',
      name: '_weeksAgoMsg',
      args: [weeksAgo],
      desc: 'A date range spanning a single week in the past.',
      examples: const {'weeksAgo': 2});

  static _weeksFromNowMsg(weeksFromNow) => Intl.plural(weeksFromNow,
      zero: 'This week',
      one: 'Next week',
      other: '$weeksFromNow weeks from now',
      name: '_weeksFromNowMsg',
      args: [weeksFromNow],
      desc: 'A date range spanning a single week in the future.',
      examples: const {'weeksFromNow': 2});
}

/// A single month. Special-cased so that next/previous picks the next/previous
/// month, and not just a blob with the same number of days; and also to have
/// titles like "This month", "Last month", etc.
class MonthRange implements DatepickerDateRange {
  final Date _start;
  final int _ago;
  final RangeTitle _titleFunction;

  MonthRange(Date start, this._ago, [this._titleFunction = _defaultTitle])
      : _start = new Date(start.year, start.month, 1);

  MonthRange.monthsAgo(Clock clock, int ago,
      [RangeTitle titleFunction = _defaultTitle])
      : this._monthsAgo(new Date.today(clock), ago, titleFunction);

  MonthRange._monthsAgo(Date today, int ago, RangeTitle titleFunction)
      : this(
            new Date(
                today.year,
                // The [Date] constructor handles wrapping to previous years.
                today.month - ago,
                1),
            ago,
            titleFunction);

  String get title => _titleFunction(_ago);
  Date get start => _start;
  Date get end => _start.add(months: 1, days: -1);
  DatepickerDateRange get next =>
      new MonthRange(_start.add(months: 1), _ago - 1, _titleFunction);
  DatepickerDateRange get prev =>
      new MonthRange(_start.add(months: -1), _ago + 1, _titleFunction);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Number of months ago relative to the current date.
  int get ago => _ago;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..monthsAgo = _ago;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static String _defaultTitle(int monthsAgo) =>
      monthsAgo > 0 ? _monthsAgoMsg(monthsAgo) : _monthsFromNowMsg(-monthsAgo);

  static _monthsAgoMsg(monthsAgo) => Intl.plural(monthsAgo,
      zero: 'This month',
      one: 'Last month',
      other: '$monthsAgo months ago',
      name: '_monthsAgoMsg',
      args: [monthsAgo],
      desc: 'A date range spanning a single month in the past.',
      examples: const {'monthsAgo': 2});

  static _monthsFromNowMsg(monthsFromNow) => Intl.plural(monthsFromNow,
      zero: 'This month',
      one: 'Next month',
      other: '$monthsFromNow months from now',
      name: '_monthsFromNowMsg',
      args: [monthsFromNow],
      desc: 'A date range spanning a single month in the future.',
      examples: const {'monthsFromNow': 2});
}

/// A single broadcast month.
///
/// The broadcast calendar is a standardized calendar used primarily for the
/// planning and purchase of radio and television programs and advertising.
/// Every week in the broadcast calendar starts on a Monday and ends on a
/// Sunday, and every month has either four or five such weeks. Broadcast
/// calendar months thus have either 28 or 35 days. The key link between the
/// broadcast and Gregorian calendars is that the first week of every broadcast
/// month always contains the Gregorian calendar first of the month.
///
/// For details, see: https://en.wikipedia.org/wiki/Broadcast_calendar
/// Example:
/// https://www.tvb.org/Portals/0/media/file/TVB_Bdcst_Calendar_2015-17.pdf
///
/// Special-cased so that next/previous picks the next/previous
/// broadcast month; and also to have titles like "This broadcast month",
/// "Last broadcast month", etc.
class BroadcastMonthRange implements DatepickerDateRange {
  /// Finds the first day of the week. Note, that for broadcast month it's
  /// always Monday.
  static Date _weekStart(Date date) => date.add(days: 1 - date.weekday);

  /// Finds the last day of the week. Note, that for broadcast month it's
  /// always Sunday.
  static Date _weekEnd(Date date) => date.add(days: 7 - date.weekday);

  /// The first day of a calendar month. The week that contains this day is the
  /// first week of this broadcast month.
  final Date _theFirst;
  final int _ago;
  final RangeTitle _titleFunction;

  BroadcastMonthRange._(this._theFirst, this._ago,
      [this._titleFunction = _defaultTitle]);

  factory BroadcastMonthRange.monthsAgo(Clock clock, int ago,
      [RangeTitle titleFunction = _defaultTitle]) {
    var today = new Date.today(clock);
    var thisCalendarMonthTheFirst = new Date(today.year, today.month, 1);
    var nextCalendarMonthTheFirst = thisCalendarMonthTheFirst.add(months: 1);

    // Today belongs to the broadcast month containing
    // [thisCalendarMonthTheFirst] iff this week does not contain
    // [nextCalendarMonthTheFirst].
    var theFirst = nextCalendarMonthTheFirst.isAfter(_weekEnd(today))
        ? thisCalendarMonthTheFirst
        : nextCalendarMonthTheFirst;
    return new BroadcastMonthRange._(
        theFirst.add(months: -ago), ago, titleFunction);
  }

  String get title => _titleFunction(_ago);
  Date get start => _weekStart(_theFirst);
  Date get end => _weekStart(_theFirst.add(months: 1)).add(days: -1);

  DatepickerDateRange get next => new BroadcastMonthRange._(
      _theFirst.add(months: 1), _ago - 1, _titleFunction);
  DatepickerDateRange get prev => new BroadcastMonthRange._(
      _theFirst.add(months: -1), _ago + 1, _titleFunction);

  bool get isPredefined => true;
  bool get isAllTime => false;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..broadcastMonthsAgo = _ago;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static String _defaultTitle(int broadcastMonthsAgo) => broadcastMonthsAgo > 0
      ? _broadcastMonthsAgoMsg(broadcastMonthsAgo)
      : _broadcastMonthsFromNowMsg(-broadcastMonthsAgo);

  static _broadcastMonthsAgoMsg(broadcastMonthsAgo) =>
      Intl.plural(broadcastMonthsAgo,
          zero: 'This broadcast month',
          one: 'Last broadcast month',
          other: '$broadcastMonthsAgo broadcast months ago',
          name: '_broadcastMonthsAgoMsg',
          args: [broadcastMonthsAgo],
          desc: 'A date range spanning a single broadcast month in the past.',
          examples: const {'broadcastMonthsAgo': 2});

  static _broadcastMonthsFromNowMsg(broadcastMonthsFromNow) =>
      Intl.plural(broadcastMonthsFromNow,
          zero: 'This broadcast month',
          one: 'Next broadcast month',
          other: '$broadcastMonthsFromNow broadcast months from now',
          name: '_broadcastMonthsFromNowMsg',
          args: [broadcastMonthsFromNow],
          desc: 'A date range spanning a single broadcast month in the future.',
          examples: const {'broadcastMonthsFromNow': 2});
}

/// A single year. Special-cased to have titles like "This year" or "Last year".
class YearRange implements DatepickerDateRange {
  final Date _start;
  final int _ago;
  final RangeTitle _titleFunction;
  YearRange(Date start, this._ago, [this._titleFunction = _defaultTitle])
      : _start = new Date(start.year, 1, 1);
  YearRange.yearsAgo(clock, ago, [RangeTitle titleFunction = _defaultTitle])
      : this(new Date.today(clock).add(years: -ago), ago, titleFunction);

  String get title => _titleFunction(_ago);
  Date get start => _start;
  Date get end => new Date(_start.year, 12, 31);
  DatepickerDateRange get next =>
      new YearRange(_start.add(years: 1), _ago - 1, _titleFunction);
  DatepickerDateRange get prev =>
      new YearRange(_start.add(years: -1), _ago + 1, _titleFunction);
  bool get isPredefined => true;
  bool get isAllTime => false;

  /// Number of years ago relative to the current date.
  int get ago => _ago;

  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  DatepickerDateRange unclamped() => this;
  DateRange asPlainRange() => _plainRange(this);
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..yearsAgo = _ago;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  static String _defaultTitle(int yearsAgo) =>
      yearsAgo > 0 ? _yearsAgoMsg(yearsAgo) : _yearsFromNowMsg(-yearsAgo);

  static _yearsAgoMsg(yearsAgo) => Intl.plural(yearsAgo,
      zero: 'This year',
      one: 'Last year',
      other: '$yearsAgo years ago',
      name: '_yearsAgoMsg',
      args: [yearsAgo],
      desc: 'A date range spanning a single year in the past.',
      examples: const {'yearsAgo': 2});

  static _yearsFromNowMsg(yearsFromNow) => Intl.plural(yearsFromNow,
      zero: 'This year',
      one: 'Next year',
      other: '$yearsFromNow years from now',
      name: '_yearsFromNowMsg',
      args: [yearsFromNow],
      desc: 'A date range spanning a single year in the future.',
      examples: const {'yearsFromNow': 2});
}

/// A single quarter.
///
/// Special-cased so that next/previous picks the next/previous quarter, and
/// not just a blob with the same number of days; and also to have titles like
/// "This quarter", "Last quarter", etc.
class QuarterRange implements DatepickerDateRange {
  final Date start;
  final int _ago;
  final RangeTitle _titleFunction;

  QuarterRange(Date startDate, this._ago, [this._titleFunction = _defaultTitle])
      : start = new Date(startDate.year, _getStartMonth(startDate), 1);

  QuarterRange.quartersAgo(Clock clock, int ago,
      [RangeTitle titleFunction = _defaultTitle])
      : this._quartersAgo(new Date.today(clock), ago, titleFunction);

  QuarterRange._quartersAgo(Date today, int ago, RangeTitle titleFunction)
      : this(
            new Date(
                today.year,
                // The [Date] constructor handles wrapping to previous years.
                today.month - ago * 3,
                1),
            ago,
            titleFunction);

  @override
  String get title => _titleFunction(_ago);
  @override
  Date get end => start.add(months: 3, days: -1);
  @override
  DatepickerDateRange get next =>
      new QuarterRange(start.add(months: 3), _ago - 1, _titleFunction);
  @override
  DatepickerDateRange get prev =>
      new QuarterRange(start.add(months: -3), _ago + 1, _titleFunction);
  @override
  bool get isPredefined => true;
  @override
  bool get isAllTime => false;

  /// Number of quarters ago relative to the current date.
  int get ago => _ago;

  @override
  DatepickerDateRange clamp({Date min, Date max}) =>
      _clamp(this, min: min, max: max);
  @override
  DatepickerDateRange unclamped() => this;
  @override
  DateRange asPlainRange() => _plainRange(this);
  @override
  proto.DatepickerDateRange toProtoBuf() =>
      _makeProtoBuf(this)..quartersAgo = _ago;

  bool operator ==(o) => rangeEqual(this, o);
  int get hashCode => rangeHash(this);
  String toString() => _rangeString(this);

  /// Given a date, returns the start date of the quarter it belongs.
  //
  // Rounds down to nearest multiple of 3 (off by one).
  static int _getStartMonth(Date start) => ((start.month - 1) ~/ 3) * 3 + 1;

  static String _defaultTitle(int quartersAgo) => quartersAgo > 0
      ? _quartersAgoMsg(quartersAgo)
      : _quartersFromNowMsg(-quartersAgo);

  static _quartersAgoMsg(quartersAgo) => Intl.plural(quartersAgo,
      zero: 'This quarter',
      one: 'Last quarter',
      other: '$quartersAgo quarters ago',
      name: '_quartersAgoMsg',
      args: [quartersAgo],
      desc: 'A date range spanning a single quarter in the past.',
      examples: const {'quartersAgo': 2});

  static _quartersFromNowMsg(quartersFromNow) => Intl.plural(quartersFromNow,
      zero: 'This quarter',
      one: 'Next quarter',
      other: '$quartersFromNow quarters from now',
      name: '_quartersFromNowMsg',
      args: [quartersFromNow],
      desc: 'A date range spanning a single quarter in the future.',
      examples: const {'quartersFromNow': 2});
}

// Commonly used date ranges
@Injectable()
DatepickerDateRange today(Clock clock) => new SingleDayRange.daysAgo(clock, 0);
@Injectable()
DatepickerDateRange yesterday(Clock clock) =>
    new SingleDayRange.daysAgo(clock, 1);
@Injectable()
DatepickerDateRange thisWeek(Clock clock) => new WeekRange.weeksAgo(clock, 0);
@Injectable()
DatepickerDateRange lastWeek(Clock clock) => new WeekRange.weeksAgo(clock, 1);
@Injectable()
DatepickerDateRange last7Days(Clock clock) =>
    new LastNDaysRange.beforeToday(clock, 7);
@Injectable()
DatepickerDateRange last14Days(Clock clock) =>
    new LastNDaysRange.beforeToday(clock, 14);
@Injectable()
DatepickerDateRange thisMonth(Clock clock) =>
    new MonthRange.monthsAgo(clock, 0);
@Injectable()
DatepickerDateRange lastMonth(Clock clock) =>
    new MonthRange.monthsAgo(clock, 1);
@Injectable()
DatepickerDateRange thisBroadcastMonth(Clock clock) =>
    new BroadcastMonthRange.monthsAgo(clock, 0);
@Injectable()
DatepickerDateRange lastBroadcastMonth(Clock clock) =>
    new BroadcastMonthRange.monthsAgo(clock, 1);
@Injectable()
DatepickerDateRange last30Days(Clock clock) =>
    new LastNDaysRange.beforeToday(clock, 30);
@Injectable()
DatepickerDateRange thisYear(Clock clock) => new YearRange.yearsAgo(clock, 0);
@Injectable()
DatepickerDateRange lastYear(Clock clock) => new YearRange.yearsAgo(clock, 1);
@Injectable()
DatepickerDateRange thisQuarter(Clock clock) =>
    new QuarterRange.quartersAgo(clock, 0);
@Injectable()
DatepickerDateRange lastQuarter(Clock clock) =>
    new QuarterRange.quartersAgo(clock, 1);

// TODO(google): null, null is fine to send to the API, but the UI wants
// to show (account opening)-(today). If "All Time" should be represented by
// those two dates, then we need to get the account opening date down here.
// If not, we need to change the data model to have separate dates for display
// vs. what gets sent to the API.
DatepickerDateRange allTime = new DatepickerDateRange(_allTimeMsg, null, null,
    isPredefined: true, isAllTime: true);

// TODO(google): AWN no longer uses thisYear and lastYear. Check cross-team
// to see if we should remove those entries from commonRanges as well.
List<DatepickerDateRange> commonRanges(Clock clock) => [
      today(clock),
      yesterday(clock),
      thisWeek(clock),
      lastWeek(clock),
      thisMonth(clock),
      lastMonth(clock),
      allTime,
    ];

String get _customDateRangeMsg => Intl.message('Custom',
    name: '_customDateRangeMsg',
    meaning: 'Name of a date range',
    desc: 'Name of a user-specified date range, as opposed to a predefined '
        'date range like "Last 7 days"');

get _allTimeMsg => Intl.message('All time',
    name: '_allTimeMsg',
    desc: 'A date range containing the entire lifetime of the account.');
