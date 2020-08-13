// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components.model.selection.selection_model;

import 'dart:async';
import 'dart:collection';

import 'package:observable/observable.dart';

import 'package:angular_components/src/model/selection/radio_group_single_selection_model.dart';

export 'package:angular_components/src/model/selection/delegating_selection_model.dart';
export 'package:angular_components/src/model/selection/radio_group_single_selection_model.dart';

part 'package:angular_components/src/model/selection/multi_selection_model_impl.dart';
part 'package:angular_components/src/model/selection/noop_selection_model_impl.dart';
part 'package:angular_components/src/model/selection/selection_change_notifier.dart';
part 'package:angular_components/src/model/selection/single_selection_model_impl.dart';

/// Returns a key-able object from [o].
///
/// Must not return null, which is reserved to mean "no selection".
typedef KeyProvider<T> = Object Function(T o);

/// Matching function provider, for example used in SelectSuggestInput.
typedef MatchCallback = Future<List> Function(String string);

/// A simple pass-through implementation of [KeyProvider].
Object _defaultKeyProvider(Object o) => o;

/// A mixin that provides the implementation of [castIterable].
class CastIterable<T> {
  /// Casts [values] into an Iterable<T>.
  Iterable<T> castIterable(Iterable values) => values.cast<T>();
}

/// Provides pattern to manage a collection of selected values.
/// This is used in model-view architecture to notify interested parties of
/// [changes] to selection.
abstract class SelectionModel<T> extends Object
    with CastIterable<T>
    implements Observable<ChangeRecord>, SelectionObservable<T> {
  /// Creates an immutable, constant model.
  const factory SelectionModel.empty() = NullSelectionModel<T>;

  /// Whether or not the selection model is single select.
  bool get isSingleSelect;

  /// Creates a single-selection model.
  ///
  /// [keyProvider] is used for equality checking. For example, [select] will
  /// only alter the selected value if the key of the new value does not equal
  /// the key of the already selected value.
  factory SelectionModel.single({T selected, KeyProvider<T> keyProvider}) =
      SingleSelectionModel<T>;

  /// Creates a single-selection model that always has a value selected.
  factory SelectionModel.radio(T selected) =>
      RadioGroupSingleSelectionModel<T>(selected);

  /// Creates a multi-selection model.
  ///
  /// [keyProvider] is used for equality checking. For example, [select] will
  /// only alter the set of selected values if the key of the new value is not
  /// among the keys of the already selected values.
  factory SelectionModel.multi(
      {List<T> selectedValues,
      KeyProvider<T> keyProvider}) = MultiSelectionModel<T>;

  @Deprecated('Use SelectionModel.single or SelectionModel.multi instead.')
  factory SelectionModel.withList(
      {List<T> selectedValues,
      KeyProvider<T> keyProvider,
      bool allowMulti = false}) {
    if (allowMulti) {
      return SelectionModel<T>.multi(
          selectedValues: selectedValues, keyProvider: keyProvider);
    } else {
      return SelectionModel<T>.single(
          selected: (selectedValues?.isNotEmpty ?? false)
              ? selectedValues.last
              : null,
          keyProvider: keyProvider);
    }
  }

  /// Clears selection.
  void clear();

  /// Adds [value] to list of selected items.
  ///
  /// Returns true if value was not previously selected.
  bool select(T value);

  /// Removes a value from list of selected items.
  ///
  /// If item doesn't exist, function will silently return else a [changes]
  /// event will be emitted.
  ///
  /// Returns true if value was previously selected.
  bool deselect(T value);

  /// Returns whether an item is selected.
  bool isSelected(T value);

  /// Returns true if selection is empty.
  bool get isEmpty;

  /// Returns true if selection is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Returns ordered list of selected values.
  Iterable<T> get selectedValues;

  /// Casts [values] into an Iterable<T>.
  Iterable<T> castIterable(Iterable values);
}

abstract class NullSelectionModel<T> extends SingleSelectionModel<T> {
  const factory NullSelectionModel() = _NoopSelectionModelImpl<T>;
}

abstract class SingleSelectionModel<T> extends SelectionModel<T> {
  factory SingleSelectionModel({T selected, KeyProvider<T> keyProvider}) =>
      _SingleSelectionModelImpl<T>(
          selected, keyProvider ?? _defaultKeyProvider);

  /// The selected value, or `null` if no value has been selected.
  T get selectedValue;
}

abstract class MultiSelectionModel<T> extends SelectionModel<T> {
  factory MultiSelectionModel(
          {List<T> selectedValues, KeyProvider<T> keyProvider}) =>
      _MultiSelectionModelImpl<T>(
          selectedValues ?? const [], keyProvider ?? _defaultKeyProvider);

  /// Adds all [values] to the list of selected items that were not previously
  /// selected. Will only emit a [changes] event for values that were actually
  /// added.
  void selectAll(Iterable<T> values);

  /// Removes all [values] from the list of selected items that were previously
  /// selected. Will only emit a [changes] event for values that were actually
  /// removed.
  void deselectAll(Iterable<T> values);
}

/// A change record for [SelectionModel.selectionChanges].
abstract class SelectionChangeRecord<T> extends ChangeRecord {
  factory SelectionChangeRecord({Iterable<T> added, Iterable<T> removed}) =
      _SelectionChangeRecordImpl<T>;

  /// Returns an iterable of values added to selection.
  Iterable<T> get added;

  /// Returns an iterable of values removed from selection.
  Iterable<T> get removed;
}
