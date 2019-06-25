// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular_components.model.selection.selection_model;

class _SingleSelectionModelImpl<T> extends Observable<ChangeRecord>
    with SelectionChangeNotifier<T>, CastIterable<T>
    implements SingleSelectionModel<T> {
  final KeyProvider<T> _keyOf;
  final List<T> _selectedValues = [];
  @override
  final isSingleSelect = true;

  Object _selectedKey;

  _SingleSelectionModelImpl(T selectedValue, this._keyOf) {
    if (selectedValue != null) {
      _selectedKey = _keyOf(selectedValue);
      _selectedValues.add(selectedValue);
    }
  }

  @override
  void clear() {
    if (_selectedValues.isNotEmpty) {
      deselect(_selectedValues.first);
    }
  }

  @override
  bool select(T value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    var newKey = _keyOf(value);
    if (newKey == _selectedKey) {
      return false;
    }
    var previousValue = _selectedValues.isEmpty ? null : _selectedValues.first;
    List<T> removedItems = const [];
    _selectedKey = newKey;
    _selectedValues
      ..clear()
      ..add(value);
    if (previousValue == null) {
      notifyPropertyChange(#isEmpty, true, false);
      notifyPropertyChange(#isNotEmpty, false, true);
    } else {
      removedItems = [previousValue];
    }
    notifySelectionChange(added: [value], removed: removedItems);
    return true;
  }

  @override
  bool deselect(T value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    if (_selectedValues.isEmpty || !_isKeySelected(value)) {
      return false;
    }
    var previousValue = _selectedValues.isEmpty ? null : _selectedValues.first;
    List<T> removedItems = const [];
    _selectedKey = null;
    _selectedValues.clear();
    if (previousValue != null) {
      notifyPropertyChange(#isEmpty, false, true);
      notifyPropertyChange(#isNotEmpty, true, false);
      removedItems = [previousValue];
    }
    notifySelectionChange(added: [], removed: removedItems);
    return true;
  }

  /// Internal, converts [value] with [_keyProvider] and compares.
  bool _isKeySelected(T value) => _keyOf(value) == _selectedKey;

  @override
  bool isSelected(T value) {
    if (value == null) {
      throw ArgumentError.notNull('value');
    }
    return _isKeySelected(value);
  }

  @override
  bool get isEmpty => _selectedValues.isEmpty;

  @override
  bool get isNotEmpty => _selectedValues.isNotEmpty;

  @override
  Iterable<T> get selectedValues => _selectedValues;

  @override
  T get selectedValue =>
      _selectedValues.isEmpty ? null : _selectedValues.single;
}
