// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use this as a mixin to be able to use arithmetic comparison operators
/// in your class.
abstract class Comparators<T> implements Comparable<T> {
  bool operator <(T other) => compareTo(other) < 0;

  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >(T other) => compareTo(other) > 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  @override
  bool operator ==(other) =>
      other is T && runtimeType == other.runtimeType && compareTo(other) == 0;
}

/// This can be extended in classes that are using const constructors.
abstract class ConstComparators<T> implements Comparable<T> {
  const ConstComparators();
  bool operator <(T other) => compareTo(other) < 0;

  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >(T other) => compareTo(other) > 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  @override
  bool operator ==(other) =>
      other is T && runtimeType == other.runtimeType && compareTo(other) == 0;
}
