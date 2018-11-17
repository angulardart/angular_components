// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Interface that defines how a type `T` should be formatted into a String.
abstract class Formatter<T> {
  String format(T value, [String parameters]);
}

/// Generates list of css classes based on cell value.
abstract class StyleFormatter<T> implements Formatter<T> {
  /// Returns list of classes to style value.
  List<String> computeStyle(T value, [String parameters]) => const [];

  /// Base name to style table column containing these values, actual style
  /// values are derived using this name.
  String get primaryStyle => null;
}

/// Formats a value using parameters and the entity containing the
/// source field.
///
/// T is the type of the value that is being formatted.
///
/// Please keep it mind that this makes the formatter much less reusable,
/// it is worth documenting what entities it does support or what fields are
/// required/optional for it to work correctly.
abstract class EntityFormatter<T> implements Formatter<T> {
  String formatEntityField(Map entity, T value, [String parameters]);
}

/// Generates list of css classes based on entity value.
///
/// This list will be merged with one returned by [StyleFormatter.computeStyle].
abstract class EntityStyleFormatter<T> implements StyleFormatter<T> {
  /// Returns list of classes to style the value.
  List<String> computeEntityStyle(Map entity, T value, [String parameters]);
}
