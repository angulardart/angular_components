// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';

/// A denomination type for defining how large values are mapped to [suffix]es
class Denomination {
  static const Hundreds = const Denomination._(1, '', null);
  static const Thousands = const Denomination._(1000, 'k', 1000);
  static const Millions = const Denomination._(1000000, 'M', 1000000);
  static const Billions = const Denomination._(1000000000, 'B', 1000000000);
  static const Trillions =
      const Denomination._(1000000000000, 'T', 1000000000000);

  /// The minimum value to gain the attached suffix
  final num minValue;

  /// An amount that can be multiplied by the formatted number to cancel out
  /// the suffix when parsing
  final int multiplier;

  /// The string suffix, if any.
  final String suffix;

  /// Returns a [Denomination] from [suffix], or null if there was no match.
  factory Denomination.fromSuffix(String suffix) {
    if (Thousands.suffix == suffix) {
      return Thousands;
    } else if (Millions.suffix == suffix) {
      return Millions;
    } else if (Billions.suffix == suffix) {
      return Billions;
    } else if (Trillions.suffix == suffix) {
      return Trillions;
    } else {
      return null;
    }
  }

  /// Returns a [Denomination] based on the size of [value].
  ///
  /// If a [max] [Denomination] is provided, will not return a denomination
  /// larger than [max].
  factory Denomination.fromValue(num value, [Denomination max]) {
    if (value < Thousands.minValue || max == Hundreds) {
      return Hundreds;
    } else if (value < Millions.minValue || max == Thousands) {
      return Thousands;
    } else if (value < Billions.minValue || max == Millions) {
      return Millions;
    } else if (value < Trillions.minValue || max == Billions) {
      return Billions;
    } else {
      return Trillions;
    }
  }

  const Denomination._(this.minValue, this.suffix, this.multiplier);
}

/// Converts [value] into a [num].
///
/// If [value] is a [String], it is parsed.
/// If [value] is a [num] or [Int64], it is converted to a double.
///
/// Otherwise, `null` is returned.
num toNum(Object value) {
  if (value is num) {
    return value;
  } else if (value is Int64) {
    return value.toDouble();
  } else if (value is String) {
    return double.parse(value, (String s) => null);
  } else {
    return null;
  }
}
