// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Interface that defines how a type `T` should be formatted.
abstract class Formatter<T> {
  String format(T value, [String parameters]);
}

abstract class StyleFormatter<T> implements Formatter<T> {
  /// Returns list of classes to style value.
  List<String> computeStyle(T value, [String parameters]) => const [];
}

/// Formats a value using parameters and the entity containing the
/// source field.
///
/// T is the type of the value that is being formatted.
/// In order to use, extend the [Formatter] class and implement the
/// [EntityFormatter] interface, then have the format method return null.
///
/// Example usage:
/// ```dart
/// class MyFormatter extends Formatter implements EntityFormatter {
///   @override
///   String format(value, [String args]) => null;
///
///   @override
///   String formatEntityField(Map entity, value, [String args]) => ...
/// }
/// ```
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
