///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library third_party.dart_src.acx.material_datepicker_date_range;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

import 'package:angular_components/material_datepicker/proto/date.pb.dart'
    as $date$type;

class DatepickerDateRange extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DatepickerDateRange')
    ..a<DateRange>(
        1, 'dateRange', PbFieldType.OM, DateRange.getDefault, DateRange.create)
    ..a<int>(2, 'daysAgo', PbFieldType.O3)
    ..a<int>(3, 'weeksAgo', PbFieldType.O3)
    ..a<int>(4, 'monthsAgo', PbFieldType.O3)
    ..a<int>(5, 'yearsAgo', PbFieldType.O3)
    ..a<int>(6, 'lastNDays', PbFieldType.O3)
    ..aOB(7, 'allTimeRange')
    ..a<int>(8, 'broadcastMonthsAgo', PbFieldType.O3)
    ..a<int>(9, 'lastNDaysToToday', PbFieldType.O3)
    ..a<int>(10, 'quartersAgo', PbFieldType.O3)
    ..a<int>(11, 'startWeekday', PbFieldType.O3)
    ..hasRequiredFields = false;

  DatepickerDateRange() : super();
  DatepickerDateRange.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DatepickerDateRange.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DatepickerDateRange clone() =>
      new DatepickerDateRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DatepickerDateRange create() => new DatepickerDateRange();
  static PbList<DatepickerDateRange> createRepeated() =>
      new PbList<DatepickerDateRange>();
  static DatepickerDateRange getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDatepickerDateRange();
    return _defaultInstance;
  }

  static DatepickerDateRange _defaultInstance;
  static void $checkItem(DatepickerDateRange v) {
    if (v is! DatepickerDateRange) checkItemFailed(v, 'DatepickerDateRange');
  }

  DateRange get dateRange => $_getN(0);
  set dateRange(DateRange v) {
    setField(1, v);
  }

  bool hasDateRange() => $_has(0);
  void clearDateRange() => clearField(1);

  int get daysAgo => $_get(1, 0);
  set daysAgo(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasDaysAgo() => $_has(1);
  void clearDaysAgo() => clearField(2);

  int get weeksAgo => $_get(2, 0);
  set weeksAgo(int v) {
    $_setUnsignedInt32(2, v);
  }

  bool hasWeeksAgo() => $_has(2);
  void clearWeeksAgo() => clearField(3);

  int get monthsAgo => $_get(3, 0);
  set monthsAgo(int v) {
    $_setUnsignedInt32(3, v);
  }

  bool hasMonthsAgo() => $_has(3);
  void clearMonthsAgo() => clearField(4);

  int get yearsAgo => $_get(4, 0);
  set yearsAgo(int v) {
    $_setUnsignedInt32(4, v);
  }

  bool hasYearsAgo() => $_has(4);
  void clearYearsAgo() => clearField(5);

  int get lastNDays => $_get(5, 0);
  set lastNDays(int v) {
    $_setUnsignedInt32(5, v);
  }

  bool hasLastNDays() => $_has(5);
  void clearLastNDays() => clearField(6);

  bool get allTimeRange => $_get(6, false);
  set allTimeRange(bool v) {
    $_setBool(6, v);
  }

  bool hasAllTimeRange() => $_has(6);
  void clearAllTimeRange() => clearField(7);

  int get broadcastMonthsAgo => $_get(7, 0);
  set broadcastMonthsAgo(int v) {
    $_setUnsignedInt32(7, v);
  }

  bool hasBroadcastMonthsAgo() => $_has(7);
  void clearBroadcastMonthsAgo() => clearField(8);

  int get lastNDaysToToday => $_get(8, 0);
  set lastNDaysToToday(int v) {
    $_setUnsignedInt32(8, v);
  }

  bool hasLastNDaysToToday() => $_has(8);
  void clearLastNDaysToToday() => clearField(9);

  int get quartersAgo => $_get(9, 0);
  set quartersAgo(int v) {
    $_setUnsignedInt32(9, v);
  }

  bool hasQuartersAgo() => $_has(9);
  void clearQuartersAgo() => clearField(10);

  int get startWeekday => $_get(10, 0);
  set startWeekday(int v) {
    $_setUnsignedInt32(10, v);
  }

  bool hasStartWeekday() => $_has(10);
  void clearStartWeekday() => clearField(11);
}

class _ReadonlyDatepickerDateRange extends DatepickerDateRange
    with ReadonlyMessageMixin {}

class DateRange extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DateRange')
    ..a<$date$type.Date>(1, 'start', PbFieldType.OM, $date$type.Date.getDefault,
        $date$type.Date.create)
    ..a<$date$type.Date>(2, 'end', PbFieldType.OM, $date$type.Date.getDefault,
        $date$type.Date.create)
    ..hasRequiredFields = false;

  DateRange() : super();
  DateRange.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DateRange.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DateRange clone() => new DateRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DateRange create() => new DateRange();
  static PbList<DateRange> createRepeated() => new PbList<DateRange>();
  static DateRange getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDateRange();
    return _defaultInstance;
  }

  static DateRange _defaultInstance;
  static void $checkItem(DateRange v) {
    if (v is! DateRange) checkItemFailed(v, 'DateRange');
  }

  $date$type.Date get start => $_getN(0);
  set start($date$type.Date v) {
    setField(1, v);
  }

  bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  $date$type.Date get end => $_getN(1);
  set end($date$type.Date v) {
    setField(2, v);
  }

  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class _ReadonlyDateRange extends DateRange with ReadonlyMessageMixin {}
