// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular2_components.model.selection.selection_model;

class _MultiSelectionModelImpl<T> extends Observable
    with SelectionChangeNotifier<T>
    implements MultiSelectionModel<T> {
  // Intentionally using a linked hash set so we can maintain selection order.
  @override
  final LinkedHashSet<T> selectedValues;

  _MultiSelectionModelImpl(
      Iterable<T> initialSelection, KeyProvider<T> keyProvider)
      : selectedValues = new LinkedHashSet<T>(
            equals: (a, b) => keyProvider(a) == keyProvider(b),
            hashCode: (o) => keyProvider(o).hashCode)..addAll(initialSelection);

  @override
  void clear() {
    if (selectedValues.isNotEmpty) {
      var removedItems = selectedValues.toList(growable: false);
      selectedValues.clear();
      notifyPropertyChange(#isEmpty, false, true);
      notifyPropertyChange(#isNotEmpty, true, false);
      notifySelectionChange(removed: removedItems);
    }
  }

  @override
  bool deselect(T value) {
    if (value == null) {
      throw new ArgumentError();
    }
    if (selectedValues.remove(value)) {
      if (isEmpty) {
        notifyPropertyChange(#isEmpty, false, true);
        notifyPropertyChange(#isNotEmpty, true, false);
      }
      notifySelectionChange(removed: [value]);
      return true;
    }
    return false;
  }

  @override
  bool select(T value) {
    if (value == null) {
      throw new ArgumentError();
    }
    if (selectedValues.add(value)) {
      if (selectedValues.length == 1) {
        notifyPropertyChange(#isEmpty, true, false);
        notifyPropertyChange(#isNotEmpty, false, true);
      }
      notifySelectionChange(added: [value]);
      return true;
    } else {
      return false;
    }
  }

  @override
  void selectAll(Iterable<T> values) {
    if (values == null) {
      throw new ArgumentError();
    }
    bool wasEmpty = isEmpty;
    selectedValues.addAll(values);
    if (wasEmpty && isNotEmpty) {
      notifyPropertyChange(#isEmpty, true, false);
      notifyPropertyChange(#isNotEmpty, false, true);
    }
    notifySelectionChange(added: values);
  }

  @override
  bool isSelected(T value) {
    if (value == null) {
      throw new ArgumentError();
    }
    return selectedValues.contains(value);
  }

  @override
  bool get isEmpty => selectedValues.isEmpty;

  @override
  bool get isNotEmpty => selectedValues.isNotEmpty;
}
