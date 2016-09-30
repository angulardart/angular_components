// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library angular2_components.model.selection.table_selection_model;

import 'dart:async';

import 'package:observable/observable.dart';

import './select.dart';

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

  CountGetter totalEntitiesCount = () => -1;

  CountGetter entitiesOnPageCount = () => -1;

  bool supportsMultiplePageSelection = true;

  SelectableGetter getSelectable;

  /// Returns number of items selected in the model.
  int get _selectedCount => _backingModel.selectedValues.length;

  @override
  int get selectedCount => _allSelected ? totalEntitiesCount() : _selectedCount;

  @override
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
    if (supportsMultiplePageSelection && allAcrossPagesSelected) {
      // If it's cross-page, we don't actually know the full set of selected
      // entities.
      throw new StateError("AllAcrossPagesSelected");

      // (Strictly speaking, this isn't true if there is only one page worth of
      // stuff. But it's easier to reason about if we throw anyway -- users of
      // the selection model don't have any easy way of distinguishing those two
      // cases. If we only throw sometimes, it's easy to get code that seems
      // correct but then breaks down in more complicated cases; see b/28634713
      // for instance.)
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