///
//  Generated code. Do not modify.
//  source: date.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class Date extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Date',
      package: const $pb.PackageName(
          'angular_components.lib.material_datepicker.proto'))
    ..a<int>(1, 'year', $pb.PbFieldType.O3)
    ..a<int>(2, 'month', $pb.PbFieldType.O3)
    ..a<int>(3, 'day', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  Date() : super();
  Date.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Date.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Date clone() => new Date()..mergeFromMessage(this);
  Date copyWith(void Function(Date) updates) =>
      super.copyWith((message) => updates(message as Date));
  $pb.BuilderInfo get info_ => _i;
  static Date create() => new Date();
  static $pb.PbList<Date> createRepeated() => new $pb.PbList<Date>();
  static Date getDefault() => _defaultInstance ??= create()..freeze();
  static Date _defaultInstance;
  static void $checkItem(Date v) {
    if (v is! Date) $pb.checkItemFailed(v, _i.messageName);
  }

  int get year => $_get(0, 0);
  set year(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasYear() => $_has(0);
  void clearYear() => clearField(1);

  int get month => $_get(1, 0);
  set month(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasMonth() => $_has(1);
  void clearMonth() => clearField(2);

  int get day => $_get(2, 0);
  set day(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDay() => $_has(2);
  void clearDay() => clearField(3);
}
