// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:observable/observable.dart';
import './select.dart';

import 'selection_model.dart';

typedef bool IsIndeterminate(var entity);

/// Selection model interface that is meant to be used with the table view
/// component.
abstract class BaseTableSelectionModel<T> implements SelectionModel<T> {
  /// Total number of selectable entries for a given table, including all
  /// the pages.
  CountGetter totalEntitiesCount;

  /// Stream for [totalEntitiesCount] changes.
  ///
  /// If count getter does not always return the same value, the subclass
  /// should explicitly add the count getter to the stream when the value of the
  /// getter changes.
  Stream<CountGetter> get totalEntitiesCountChange;

  /// Number of selectable entries.
  CountGetter entitiesOnPageCount;

  /// Number of entries selected in the model.
  int get selectedCount;

  /// Called when an entity is removed from the table, so that this model can
  /// decide whether to deselect it.
  void onRemove(T entity);

  /// Predicate should return `true` if the selection state for the given entity
  /// is not determinable.
  ///
  /// If this predicate is `null`, its equivalent of always returning false.
  IsIndeterminate isIndeterminate;

  /// Creates a single-select table selection model.
  ///
  /// Using a single-selection model causes the table to use radio buttons as
  /// the tool cell for selecting table entries. Only a single table entry can
  /// be selected at a time and the select-all control is not available.
  factory BaseTableSelectionModel.single(
          {KeyProvider<T> keyProvider,
          SelectableGetter getSelectable,
          bool deselectOnRemove: true}) =>
      new _SingleTableSelectionModelImpl(
          keyProvider: keyProvider,
          getSelectable: getSelectable,
          deselectOnRemove: deselectOnRemove);

  /// Creates a multi-select table selection model.
  ///
  /// Using a multi-selection model causes the table to use checkboxes as the
  /// tool cell for selecting table entries.
  factory BaseTableSelectionModel.multi(
      {KeyProvider<T> keyProvider,
      SelectableGetter getSelectable,
      bool deselectOnRemove: true}) {
    return new _TableSelectionModelImpl(
        keyProvider: keyProvider,
        getSelectable: getSelectable,
        deselectOnRemove: deselectOnRemove);
  }
}

/// MultiSelection model that supports "All across pages" selection, that marks
/// user intent to do bulk action on all entries (even those not currently
/// visible in a given context).
abstract class TableSelectionModel<T> extends BaseTableSelectionModel<T>
    implements SelectableWithComposition, MultiSelectionModel<T> {
  factory TableSelectionModel(
      {KeyProvider<T> keyProvider,
      SelectableGetter getSelectable,
      bool deselectOnRemove: true}) {
    return new _TableSelectionModelImpl(
        keyProvider: keyProvider,
        getSelectable: getSelectable,
        deselectOnRemove: deselectOnRemove);
  }

  @override
  SelectableGetter getSelectable;

  /// If the table supports selection over multiple pages.
  bool supportsMultiplePageSelection;

  /// Selects all selectable entries across all the pages.
  void selectAllAcrossPages();

  /// True if the user explicitly chose to select ALL selectable entries, e.g.
  /// by checking "Select All", rather than selecting every entry individually.
  bool get allAcrossPagesExplicitlySelected => false;

  /// True if all selectable entries are selected.
  ///
  /// Differs from [allAcrossPagesExplicitlySelected] when the user has selected
  /// every entry individually.
  bool get allAcrossPagesSelected;

  /// True if all selectable entries on a page are selected.
  bool get isPageSelected;
}

/// Single-select implementation of table selection model.
class _SingleTableSelectionModelImpl<T> extends Observable<ChangeRecord>
    implements
        SelectableWithComposition<T>,
        BaseTableSelectionModel<T>,
        SelectionModel<T> {
  final SelectionModel<T> _backingModel;

  bool deselectOnRemove;

  CountGetter _totalEntitiesCount = () => -1;

  @override
  CountGetter get totalEntitiesCount => _totalEntitiesCount;

  @override
  set totalEntitiesCount(CountGetter value) {
    _totalEntitiesCount = value;
    _totalEntitiesCountController.add(value);
  }

  StreamController<CountGetter> _totalEntitiesCountController =
      new StreamController.broadcast();

  @override
  Stream<CountGetter> get totalEntitiesCountChange =>
      _totalEntitiesCountController.stream;

  @override
  CountGetter entitiesOnPageCount = () => -1;

  @override
  IsIndeterminate isIndeterminate;

  @override
  SelectableGetter getSelectable;

  _SingleTableSelectionModelImpl(
      {KeyProvider<T> keyProvider,
      this.getSelectable,
      this.deselectOnRemove: true})
      : _backingModel = (keyProvider == null)
            ? new SelectionModel<T>.withList()
            : new SelectionModel<T>.withList(keyProvider: keyProvider);

  @override
  int get selectedCount => _selectedCount;

  @override
  bool get isEmpty => _backingModel.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges =>
      _backingModel.selectionChanges;

  @override
  bool get hasSelectionObservers => _backingModel.hasSelectionObservers;

  @override
  Iterable<T> get selectedValues => _backingModel.selectedValues;

  /// Returns number of items selected in the model.
  int get _selectedCount => _backingModel.selectedValues.length;

  @override
  bool deselect(T value) => _backingModel.deselect(value);

  @override
  bool isSelected(T value) => _backingModel.isSelected(value);

  @override
  bool select(T value) => _backingModel.select(value);

  @override
  bool deliverSelectionChanges() => _backingModel.deliverSelectionChanges();

  @override
  void clear() {
    _backingModel.clear();
  }

  @override
  void notifySelectionChange(
      {Iterable<T> added: const [], Iterable<T> removed: const []}) {
    _backingModel.notifySelectionChange(added: added, removed: removed);
  }

  @override
  void onRemove(T entity) {
    if (deselectOnRemove) deselect(entity);
  }
}

/// Multi-select implementation of table selection model.
class _TableSelectionModelImpl<T> extends Observable<ChangeRecord>
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

  CountGetter _totalEntitiesCount = () => -1;

  @override
  CountGetter get totalEntitiesCount => _totalEntitiesCount;

  @override
  set totalEntitiesCount(CountGetter value) {
    _totalEntitiesCount = value;
    _totalEntitiesCountController.add(value);
  }

  StreamController<CountGetter> _totalEntitiesCountController =
      new StreamController.broadcast();

  @override
  Stream<CountGetter> get totalEntitiesCountChange =>
      _totalEntitiesCountController.stream;

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
  bool get allAcrossPagesExplicitlySelected => _allSelected;

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
  void deselectAll(Iterable<T> rows) => _backingModel.deselectAll(rows);

  @override
  Iterable<T> get selectedValues {
    // If we are selecting all across multiple pages, we don't actually know
    // the full set of selected entities.
    var totalCount = totalEntitiesCount();
    assert(
        !(supportsMultiplePageSelection &&
            allAcrossPagesSelected &&
            _selectedCount != totalCount),
        'AllAcrossPagesSelected. selectedCount is $_selectedCount and '
        'totalEntitiesCount() is $totalCount. _allSelected is $_allSelected');
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
