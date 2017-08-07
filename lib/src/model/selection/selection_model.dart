// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components.model.selection.selection_model;

import 'dart:async';
import 'dart:collection';

import 'package:observable/observable.dart';

import 'src/interfaces/selectable.dart';

export 'src/delegating_selection_model.dart';
export 'src/radio_group_single_selection_model.dart';

part 'src/multi_selection_model_impl.dart';
part 'src/noop_selection_model_impl.dart';
part 'src/selectable_change_notifier.dart';
part 'src/selection_change_notifier.dart';
part 'src/single_selection_model_impl.dart';

/// Returns a key-able object from [o].
///
/// Must not return null, which is reserved to mean "no selection".
typedef Object KeyProvider<T>(T o);

/// Matching function provider, for example used in SelectSuggestInput.
typedef Future<List> MatchCallback(String string);

/// A simple pass-through implementation of [KeyProvider].
Object _defaultKeyProvider(Object o) => o;

/// Provides pattern to manage a collection of selected values.
/// This is used in model-view architecture to notify interested parties of
/// [changes] to selection.
abstract class SelectionModel<T>
    implements Observable<ChangeRecord>, SelectionObservable<T> {
  /// Returns an immutable, constant model.
  const factory SelectionModel() = _NoopSelectionModelImpl<T>;

  /// Creates a new model with the given [selectedValues].
  ///
  /// [keyProvider] is used for equality checking by various other methods.
  /// For example, [select] will only alter the set of selected values if the
  /// key of the new value is not among the keys of the already selected values.
  /// [allowMulti] is whether to allow more than one selection at a time.
  /// When false, selecting a new value automatically deselects the old value.
  factory SelectionModel.withList(
      {List<T> selectedValues: const [],
      KeyProvider<T> keyProvider: _defaultKeyProvider,
      bool allowMulti: false}) {
    if (selectedValues == null) {
      throw new ArgumentError.notNull('selectedValues');
    }
    if (allowMulti) {
      return new _MultiSelectionModelImpl(selectedValues, keyProvider);
    } else {
      return new _SingleSelectionModelImpl(
          selectedValues.isNotEmpty ? selectedValues.last : null, keyProvider);
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
}

abstract class MultiSelectionModel<T> extends SelectionModel<T> {
  factory MultiSelectionModel(
      {List<T> selectedValues: const [],
      KeyProvider<T> keyProvider: _defaultKeyProvider}) {
    return new SelectionModel<T>.withList(
        selectedValues: selectedValues,
        keyProvider: keyProvider,
        allowMulti: true);
  }

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

/// A change record for [SelectionModel.selectableChanges].
abstract class SelectableChangeRecord<T> extends ChangeRecord {
  const factory SelectableChangeRecord() = _SelectableChangeRecordImpl<T>;
}
