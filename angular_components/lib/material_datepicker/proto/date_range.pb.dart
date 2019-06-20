///
//  Generated code. Do not modify.
//  source: date_range.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core
    show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'date.pb.dart' as $0;

enum DatepickerDateRange_RelativePreset {
  daysAgo,
  weeksAgo,
  monthsAgo,
  yearsAgo,
  lastNDays,
  allTimeRange,
  broadcastMonthsAgo,
  lastNDaysToToday,
  quartersAgo,
  nextNDaysFromToday,
  notSet
}

class DatepickerDateRange extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, DatepickerDateRange_RelativePreset>
      _DatepickerDateRange_RelativePresetByTag = {
    2: DatepickerDateRange_RelativePreset.daysAgo,
    3: DatepickerDateRange_RelativePreset.weeksAgo,
    4: DatepickerDateRange_RelativePreset.monthsAgo,
    5: DatepickerDateRange_RelativePreset.yearsAgo,
    6: DatepickerDateRange_RelativePreset.lastNDays,
    7: DatepickerDateRange_RelativePreset.allTimeRange,
    8: DatepickerDateRange_RelativePreset.broadcastMonthsAgo,
    9: DatepickerDateRange_RelativePreset.lastNDaysToToday,
    10: DatepickerDateRange_RelativePreset.quartersAgo,
    12: DatepickerDateRange_RelativePreset.nextNDaysFromToday,
    0: DatepickerDateRange_RelativePreset.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DatepickerDateRange',
      package: const $pb.PackageName(
          'angular_components.lib.material_datepicker.proto'))
    ..a<DateRange>(1, 'dateRange', $pb.PbFieldType.OM, DateRange.getDefault,
        DateRange.create)
    ..a<$core.int>(2, 'daysAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'weeksAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(4, 'monthsAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(5, 'yearsAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(6, 'lastNDays', $pb.PbFieldType.O3)
    ..aOB(7, 'allTimeRange')
    ..a<$core.int>(8, 'broadcastMonthsAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(9, 'lastNDaysToToday', $pb.PbFieldType.O3)
    ..a<$core.int>(10, 'quartersAgo', $pb.PbFieldType.O3)
    ..a<$core.int>(11, 'startWeekday', $pb.PbFieldType.O3)
    ..a<$core.int>(12, 'nextNDaysFromToday', $pb.PbFieldType.O3)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 12])
    ..hasRequiredFields = false;

  DatepickerDateRange() : super();
  DatepickerDateRange.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DatepickerDateRange.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DatepickerDateRange clone() => DatepickerDateRange()..mergeFromMessage(this);
  DatepickerDateRange copyWith(void Function(DatepickerDateRange) updates) =>
      super.copyWith((message) => updates(message as DatepickerDateRange));
  $pb.BuilderInfo get info_ => _i;
  static DatepickerDateRange create() => DatepickerDateRange();
  DatepickerDateRange createEmptyInstance() => create();
  static $pb.PbList<DatepickerDateRange> createRepeated() =>
      $pb.PbList<DatepickerDateRange>();
  static DatepickerDateRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DatepickerDateRange _defaultInstance;

  DatepickerDateRange_RelativePreset whichRelativePreset() =>
      _DatepickerDateRange_RelativePresetByTag[$_whichOneof(0)];
  void clearRelativePreset() => clearField($_whichOneof(0));

  DateRange get dateRange => $_getN(0);
  set dateRange(DateRange v) {
    setField(1, v);
  }

  $core.bool hasDateRange() => $_has(0);
  void clearDateRange() => clearField(1);

  $core.int get daysAgo => $_get(1, 0);
  set daysAgo($core.int v) {
    $_setSignedInt32(1, v);
  }

  $core.bool hasDaysAgo() => $_has(1);
  void clearDaysAgo() => clearField(2);

  $core.int get weeksAgo => $_get(2, 0);
  set weeksAgo($core.int v) {
    $_setSignedInt32(2, v);
  }

  $core.bool hasWeeksAgo() => $_has(2);
  void clearWeeksAgo() => clearField(3);

  $core.int get monthsAgo => $_get(3, 0);
  set monthsAgo($core.int v) {
    $_setSignedInt32(3, v);
  }

  $core.bool hasMonthsAgo() => $_has(3);
  void clearMonthsAgo() => clearField(4);

  $core.int get yearsAgo => $_get(4, 0);
  set yearsAgo($core.int v) {
    $_setSignedInt32(4, v);
  }

  $core.bool hasYearsAgo() => $_has(4);
  void clearYearsAgo() => clearField(5);

  $core.int get lastNDays => $_get(5, 0);
  set lastNDays($core.int v) {
    $_setSignedInt32(5, v);
  }

  $core.bool hasLastNDays() => $_has(5);
  void clearLastNDays() => clearField(6);

  $core.bool get allTimeRange => $_get(6, false);
  set allTimeRange($core.bool v) {
    $_setBool(6, v);
  }

  $core.bool hasAllTimeRange() => $_has(6);
  void clearAllTimeRange() => clearField(7);

  $core.int get broadcastMonthsAgo => $_get(7, 0);
  set broadcastMonthsAgo($core.int v) {
    $_setSignedInt32(7, v);
  }

  $core.bool hasBroadcastMonthsAgo() => $_has(7);
  void clearBroadcastMonthsAgo() => clearField(8);

  $core.int get lastNDaysToToday => $_get(8, 0);
  set lastNDaysToToday($core.int v) {
    $_setSignedInt32(8, v);
  }

  $core.bool hasLastNDaysToToday() => $_has(8);
  void clearLastNDaysToToday() => clearField(9);

  $core.int get quartersAgo => $_get(9, 0);
  set quartersAgo($core.int v) {
    $_setSignedInt32(9, v);
  }

  $core.bool hasQuartersAgo() => $_has(9);
  void clearQuartersAgo() => clearField(10);

  $core.int get startWeekday => $_get(10, 0);
  set startWeekday($core.int v) {
    $_setSignedInt32(10, v);
  }

  $core.bool hasStartWeekday() => $_has(10);
  void clearStartWeekday() => clearField(11);

  $core.int get nextNDaysFromToday => $_get(11, 0);
  set nextNDaysFromToday($core.int v) {
    $_setSignedInt32(11, v);
  }

  $core.bool hasNextNDaysFromToday() => $_has(11);
  void clearNextNDaysFromToday() => clearField(12);
}

class DateRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DateRange',
      package: const $pb.PackageName(
          'angular_components.lib.material_datepicker.proto'))
    ..a<$0.Date>(
        1, 'start', $pb.PbFieldType.OM, $0.Date.getDefault, $0.Date.create)
    ..a<$0.Date>(
        2, 'end', $pb.PbFieldType.OM, $0.Date.getDefault, $0.Date.create)
    ..hasRequiredFields = false;

  DateRange() : super();
  DateRange.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DateRange.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DateRange clone() => DateRange()..mergeFromMessage(this);
  DateRange copyWith(void Function(DateRange) updates) =>
      super.copyWith((message) => updates(message as DateRange));
  $pb.BuilderInfo get info_ => _i;
  static DateRange create() => DateRange();
  DateRange createEmptyInstance() => create();
  static $pb.PbList<DateRange> createRepeated() => $pb.PbList<DateRange>();
  static DateRange getDefault() => _defaultInstance ??= create()..freeze();
  static DateRange _defaultInstance;

  $0.Date get start => $_getN(0);
  set start($0.Date v) {
    setField(1, v);
  }

  $core.bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  $0.Date get end => $_getN(1);
  set end($0.Date v) {
    setField(2, v);
  }

  $core.bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}
