// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:quiver/core.dart';

import '../formatters/formatter.dart';

/// Designates a model class which has a canonical _display name_ (label) field.
abstract class HasUIDisplayName {
  String get uiDisplayName;
}

/// Contains a value with ui label.
///
/// This is a value type object.
class LabeledValue<T> implements HasUIDisplayName {
  final T value;

  @override
  final String uiDisplayName;

  const LabeledValue(this.value, this.uiDisplayName);

  /// Creates a new [LabeledValue] by executing the provided [formatter] on
  /// the provided [value].
  factory LabeledValue.format(T value, Formatter formatter) =>
      new LabeledValue(value, formatter.format(value));

  @override
  String toString() => uiDisplayName;

  @override
  int get hashCode => hash2(value.hashCode, uiDisplayName.hashCode);

  @override
  bool operator ==(o) =>
      o is LabeledValue && o.uiDisplayName == uiDisplayName && o.value == value;
}
