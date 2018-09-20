///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class Date extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Date')
    ..a<int>(1, 'year', PbFieldType.O3)
    ..a<int>(2, 'month', PbFieldType.O3)
    ..a<int>(3, 'day', PbFieldType.O3)
    ..hasRequiredFields = false;

  Date() : super();
  Date.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Date.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Date clone() => new Date()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Date create() => new Date();
  static PbList<Date> createRepeated() => new PbList<Date>();
  static Date getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDate();
    return _defaultInstance;
  }

  static Date _defaultInstance;
  static void $checkItem(Date v) {
    if (v is! Date) checkItemFailed(v, 'Date');
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

class _ReadonlyDate extends Date with ReadonlyMessageMixin {}
