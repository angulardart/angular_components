///
//  Generated code. Do not modify.
//  source: date_range.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

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
  static const $core.Map<$core.int, DatepickerDateRange_RelativePreset> _DatepickerDateRange_RelativePresetByTag = {
    2 : DatepickerDateRange_RelativePreset.daysAgo,
    3 : DatepickerDateRange_RelativePreset.weeksAgo,
    4 : DatepickerDateRange_RelativePreset.monthsAgo,
    5 : DatepickerDateRange_RelativePreset.yearsAgo,
    6 : DatepickerDateRange_RelativePreset.lastNDays,
    7 : DatepickerDateRange_RelativePreset.allTimeRange,
    8 : DatepickerDateRange_RelativePreset.broadcastMonthsAgo,
    9 : DatepickerDateRange_RelativePreset.lastNDaysToToday,
    10 : DatepickerDateRange_RelativePreset.quartersAgo,
    12 : DatepickerDateRange_RelativePreset.nextNDaysFromToday,
    0 : DatepickerDateRange_RelativePreset.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DatepickerDateRange', package: const $pb.PackageName('angular_components.lib.material_datepicker.proto'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 12])
    ..aOM<DateRange>(1, 'dateRange', subBuilder: DateRange.create)
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
    ..hasRequiredFields = false
  ;

  DatepickerDateRange._() : super();
  factory DatepickerDateRange() => create();
  factory DatepickerDateRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DatepickerDateRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DatepickerDateRange clone() => DatepickerDateRange()..mergeFromMessage(this);
  DatepickerDateRange copyWith(void Function(DatepickerDateRange) updates) => super.copyWith((message) => updates(message as DatepickerDateRange));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DatepickerDateRange create() => DatepickerDateRange._();
  DatepickerDateRange createEmptyInstance() => create();
  static $pb.PbList<DatepickerDateRange> createRepeated() => $pb.PbList<DatepickerDateRange>();
  @$core.pragma('dart2js:noInline')
  static DatepickerDateRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DatepickerDateRange>(create);
  static DatepickerDateRange _defaultInstance;

  DatepickerDateRange_RelativePreset whichRelativePreset() => _DatepickerDateRange_RelativePresetByTag[$_whichOneof(0)];
  void clearRelativePreset() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  DateRange get dateRange => $_getN(0);
  @$pb.TagNumber(1)
  set dateRange(DateRange v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDateRange() => $_has(0);
  @$pb.TagNumber(1)
  void clearDateRange() => clearField(1);
  @$pb.TagNumber(1)
  DateRange ensureDateRange() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get daysAgo => $_getIZ(1);
  @$pb.TagNumber(2)
  set daysAgo($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDaysAgo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDaysAgo() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get weeksAgo => $_getIZ(2);
  @$pb.TagNumber(3)
  set weeksAgo($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWeeksAgo() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeeksAgo() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get monthsAgo => $_getIZ(3);
  @$pb.TagNumber(4)
  set monthsAgo($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMonthsAgo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMonthsAgo() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get yearsAgo => $_getIZ(4);
  @$pb.TagNumber(5)
  set yearsAgo($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasYearsAgo() => $_has(4);
  @$pb.TagNumber(5)
  void clearYearsAgo() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lastNDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set lastNDays($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLastNDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastNDays() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get allTimeRange => $_getBF(6);
  @$pb.TagNumber(7)
  set allTimeRange($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAllTimeRange() => $_has(6);
  @$pb.TagNumber(7)
  void clearAllTimeRange() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get broadcastMonthsAgo => $_getIZ(7);
  @$pb.TagNumber(8)
  set broadcastMonthsAgo($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBroadcastMonthsAgo() => $_has(7);
  @$pb.TagNumber(8)
  void clearBroadcastMonthsAgo() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get lastNDaysToToday => $_getIZ(8);
  @$pb.TagNumber(9)
  set lastNDaysToToday($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLastNDaysToToday() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastNDaysToToday() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get quartersAgo => $_getIZ(9);
  @$pb.TagNumber(10)
  set quartersAgo($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasQuartersAgo() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuartersAgo() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get startWeekday => $_getIZ(10);
  @$pb.TagNumber(11)
  set startWeekday($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasStartWeekday() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartWeekday() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get nextNDaysFromToday => $_getIZ(11);
  @$pb.TagNumber(12)
  set nextNDaysFromToday($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasNextNDaysFromToday() => $_has(11);
  @$pb.TagNumber(12)
  void clearNextNDaysFromToday() => clearField(12);
}

class DateRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DateRange', package: const $pb.PackageName('angular_components.lib.material_datepicker.proto'), createEmptyInstance: create)
    ..aOM<$0.Date>(1, 'start', subBuilder: $0.Date.create)
    ..aOM<$0.Date>(2, 'end', subBuilder: $0.Date.create)
    ..hasRequiredFields = false
  ;

  DateRange._() : super();
  factory DateRange() => create();
  factory DateRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DateRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DateRange clone() => DateRange()..mergeFromMessage(this);
  DateRange copyWith(void Function(DateRange) updates) => super.copyWith((message) => updates(message as DateRange));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DateRange create() => DateRange._();
  DateRange createEmptyInstance() => create();
  static $pb.PbList<DateRange> createRepeated() => $pb.PbList<DateRange>();
  @$core.pragma('dart2js:noInline')
  static DateRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DateRange>(create);
  static DateRange _defaultInstance;

  @$pb.TagNumber(1)
  $0.Date get start => $_getN(0);
  @$pb.TagNumber(1)
  set start($0.Date v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);
  @$pb.TagNumber(1)
  $0.Date ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Date get end => $_getN(1);
  @$pb.TagNumber(2)
  set end($0.Date v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => clearField(2);
  @$pb.TagNumber(2)
  $0.Date ensureEnd() => $_ensure(1);
}

