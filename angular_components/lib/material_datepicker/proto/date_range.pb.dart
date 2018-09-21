///
//  Generated code. Do not modify.
//  source: date_range.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'date.pb.dart' as $0;

class DatepickerDateRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DatepickerDateRange',
      package: const $pb.PackageName(
          'angular_components.lib.material_datepicker.proto'))
    ..a<DateRange>(1, 'dateRange', $pb.PbFieldType.OM, DateRange.getDefault,
        DateRange.create)
    ..a<int>(2, 'daysAgo', $pb.PbFieldType.O3)
    ..a<int>(3, 'weeksAgo', $pb.PbFieldType.O3)
    ..a<int>(4, 'monthsAgo', $pb.PbFieldType.O3)
    ..a<int>(5, 'yearsAgo', $pb.PbFieldType.O3)
    ..a<int>(6, 'lastNDays', $pb.PbFieldType.O3)
    ..aOB(7, 'allTimeRange')
    ..a<int>(8, 'broadcastMonthsAgo', $pb.PbFieldType.O3)
    ..a<int>(9, 'lastNDaysToToday', $pb.PbFieldType.O3)
    ..a<int>(10, 'quartersAgo', $pb.PbFieldType.O3)
    ..a<int>(11, 'startWeekday', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DatepickerDateRange() : super();
  DatepickerDateRange.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DatepickerDateRange.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DatepickerDateRange clone() =>
      new DatepickerDateRange()..mergeFromMessage(this);
  DatepickerDateRange copyWith(void Function(DatepickerDateRange) updates) =>
      super.copyWith((message) => updates(message as DatepickerDateRange));
  $pb.BuilderInfo get info_ => _i;
  static DatepickerDateRange create() => new DatepickerDateRange();
  static $pb.PbList<DatepickerDateRange> createRepeated() =>
      new $pb.PbList<DatepickerDateRange>();
  static DatepickerDateRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DatepickerDateRange _defaultInstance;
  static void $checkItem(DatepickerDateRange v) {
    if (v is! DatepickerDateRange) $pb.checkItemFailed(v, _i.messageName);
  }

  DateRange get dateRange => $_getN(0);
  set dateRange(DateRange v) {
    setField(1, v);
  }

  bool hasDateRange() => $_has(0);
  void clearDateRange() => clearField(1);

  int get daysAgo => $_get(1, 0);
  set daysAgo(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasDaysAgo() => $_has(1);
  void clearDaysAgo() => clearField(2);

  int get weeksAgo => $_get(2, 0);
  set weeksAgo(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasWeeksAgo() => $_has(2);
  void clearWeeksAgo() => clearField(3);

  int get monthsAgo => $_get(3, 0);
  set monthsAgo(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasMonthsAgo() => $_has(3);
  void clearMonthsAgo() => clearField(4);

  int get yearsAgo => $_get(4, 0);
  set yearsAgo(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasYearsAgo() => $_has(4);
  void clearYearsAgo() => clearField(5);

  int get lastNDays => $_get(5, 0);
  set lastNDays(int v) {
    $_setSignedInt32(5, v);
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
    $_setSignedInt32(7, v);
  }

  bool hasBroadcastMonthsAgo() => $_has(7);
  void clearBroadcastMonthsAgo() => clearField(8);

  int get lastNDaysToToday => $_get(8, 0);
  set lastNDaysToToday(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasLastNDaysToToday() => $_has(8);
  void clearLastNDaysToToday() => clearField(9);

  int get quartersAgo => $_get(9, 0);
  set quartersAgo(int v) {
    $_setSignedInt32(9, v);
  }

  bool hasQuartersAgo() => $_has(9);
  void clearQuartersAgo() => clearField(10);

  int get startWeekday => $_get(10, 0);
  set startWeekday(int v) {
    $_setSignedInt32(10, v);
  }

  bool hasStartWeekday() => $_has(10);
  void clearStartWeekday() => clearField(11);
}

class DateRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DateRange',
      package: const $pb.PackageName(
          'angular_components.lib.material_datepicker.proto'))
    ..a<$0.Date>(
        1, 'start', $pb.PbFieldType.OM, $0.Date.getDefault, $0.Date.create)
    ..a<$0.Date>(
        2, 'end', $pb.PbFieldType.OM, $0.Date.getDefault, $0.Date.create)
    ..hasRequiredFields = false;

  DateRange() : super();
  DateRange.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DateRange.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DateRange clone() => new DateRange()..mergeFromMessage(this);
  DateRange copyWith(void Function(DateRange) updates) =>
      super.copyWith((message) => updates(message as DateRange));
  $pb.BuilderInfo get info_ => _i;
  static DateRange create() => new DateRange();
  static $pb.PbList<DateRange> createRepeated() => new $pb.PbList<DateRange>();
  static DateRange getDefault() => _defaultInstance ??= create()..freeze();
  static DateRange _defaultInstance;
  static void $checkItem(DateRange v) {
    if (v is! DateRange) $pb.checkItemFailed(v, _i.messageName);
  }

  $0.Date get start => $_getN(0);
  set start($0.Date v) {
    setField(1, v);
  }

  bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  $0.Date get end => $_getN(1);
  set end($0.Date v) {
    setField(2, v);
  }

  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}
