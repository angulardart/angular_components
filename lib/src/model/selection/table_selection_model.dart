// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import './select.dart';
import 'package:observable/observable.dart';

import 'selection_model.dart';

typedef bool IsIndeterminate(var entity);

/// MultiSelection model that supports "All across pages" selection, that marks
/// user intent to do bulk action on all entries (even those not currently
/// visible in a given context).
abstract class TableSelectionModel<T> extends MultiSelectionModel<T>
    implements SelectableWithComposition {
  factory TableSelectionModel(
      {KeyProvider<T> keyProvider,
      SelectableGetter getSelectable,
      bool deselectOnRemove: true}) {
    return new _TableSelectionModelImpl(
        keyProvider: keyProvider,
        getSelectable: getSelectable,
        deselectOnRemove: deselectOnRemove);
  }

  /// Total number of selectable entries for a given table, including all
  /// the pages.
  CountGetter totalEntitiesCount;

  /// Number of selectable entries.
  CountGetter entitiesOnPageCount;

  @override
  SelectableGetter getSelectable;

  /// If the table supports selection over multiple pages.
  bool supportsMultiplePageSelection;

  /// Selects all selectable entries across all the pages.
  void selectAllAcrossPages();

  /// True if all selectable entries are selected.
  bool get allAcrossPagesSelected;

  /// True if all selectable entries on a page are selected.
  bool get isPageSelected;

  /// Number of entries selected in the model.
  int get selectedCount;

  /// Called when an entity is removed from the table, so that this model can
  /// decide whether to deselect it.
  void onRemove(T entity);

  /// Predicate should return `true` if the selection state for the given entity
  /// is not determinable.
  ///
  /// If this predidcate is `null`, its equivalent of always returning false.
  IsIndeterminate isIndeterminate;
}

class _TableSelectionModelImpl<T> extends Observable
    implements TableSelectionModel<T> {
  _TableSelectionModelImpl(
      {KeyProvider<T> keyProvider, this.getSelectable, this.deselectOnRemove})
      : _backingModel = (keyProvider == null)
            ? new SelectionModel<T>.withList(allowMulti: true)
            : new SelectionModel<T>.withList(
                keyProvider: keyProvider, allowMulti: true);

  bool deselectOnRemove;

  final MultiSelectionModel<T> _backingModel;

  bool _allSelected = false;

  @override
  CountGetter totalEntitiesCount = () => -1;

  @override
  CountGetter entitiesOnPageCount = () => -1;

  @override
  bool supportsMultiplePageSelection = true;

  @override
  SelectableGetter getSelectable;

  /// Returns number of items selected in the model.
  int get _selectedCount => _backingModel.selectedValues.length;

  @override
  int get selectedCount => _allSelected ? totalEntitiesCount() : _selectedCount;

  @override
  // TODO(google): This tries to consolidate two cases, i.e.
  // allOnPageSelected and allAcrossPagesSelected, but it turns out to be
  // ambiguous and does more bad than good.
  bool get allAcrossPagesSelected =>
      _allSelected ||
      (_selectedCount > 0 && totalEntitiesCount() == _selectedCount);

  @override
  void selectAllAcrossPages() {
    if (_allSelected) return;
    assert(supportsMultiplePageSelection);
    bool wasEmpty = isEmpty;
    _allSelected = true;
    if (wasEmpty) {
      notifyPropertyChange(#isEmpty, true, false);
      notifyPropertyChange(#isNotEmpty, false, true);
    }
    notifyPropertyChange(#allAcrossPagesSelected, false, true);
    notifySelectionChange();
  }

  @override
  void clear() {
    _allSelected = false;
    _backingModel.clear();
  }

  @override
  bool deselect(T value) {
    bool wasAllSelected = _allSelected;
    if (wasAllSelected) {
      _allSelected = false;
      notifyPropertyChange(#allAcrossPagesSelected, true, false);
    }
    return _backingModel.deselect(value) || wasAllSelected;
  }

  @override
  bool get isEmpty => !_allSelected && _backingModel.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  bool isSelected(T value) {
    if (_allSelected) return true;
    return _backingModel.isSelected(value);
  }

  @override
  bool select(T value) => _backingModel.select(value);

  @override
  void selectAll(Iterable<T> rows) => _backingModel.selectAll(rows);

  @override
  Iterable<T> get selectedValues {
    if (supportsMultiplePageSelection &&
        allAcrossPagesSelected &&
        _selectedCount != totalEntitiesCount()) {
      // If we are selecting all across multiple pages, we don't actually know
      // the full set of selected entities.
      throw new StateError("AllAcrossPagesSelected");
    }
    return _backingModel.selectedValues;
  }

  @override
  bool deliverSelectionChanges() => _backingModel.deliverSelectionChanges();

  @override
  void notifySelectionChange(
      {Iterable<T> added: const [], Iterable<T> removed: const []}) {
    _backingModel.notifySelectionChange(added: added, removed: removed);
  }

  @override
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges =>
      _backingModel.selectionChanges;

  @override
  bool get hasSelectionObservers => _backingModel.hasSelectionObservers;

  @override
  bool get isPageSelected =>
      selectedCount > 0 && selectedCount == entitiesOnPageCount();

  @override
  void onRemove(T entity) {
    if (deselectOnRemove) {
      deselect(entity);
    }
  }

  @override
  IsIndeterminate isIndeterminate;
}
