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

part of angular2_components.model.selection.selection_model;

class _SingleSelectionModelImpl<T> extends ChangeNotifier
    with SelectionChangeNotifier<T>
    implements SelectionModel<T> {
  final KeyProvider<T> _keyOf;
  final List<T> _selectedValues = [];

  var _selectedKey;

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
      throw new ArgumentError.notNull('value');
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
      throw new ArgumentError.notNull('value');
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
      throw new ArgumentError.notNull('value');
    }
    return _isKeySelected(value);
  }

  @override
  bool get isEmpty => _selectedValues.isEmpty;

  @override
  bool get isNotEmpty => _selectedValues.isNotEmpty;

  @override
  Iterable<T> get selectedValues => _selectedValues;
}