// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular_components.model.selection.selection_model;

class _MultiSelectionModelImpl<T> extends Observable<ChangeRecord>
    with SelectionChangeNotifier<T>, CastIterable<T>
    implements MultiSelectionModel<T> {
  @override
  final isSingleSelect = false;

  // Intentionally using a linked hash set so we can maintain selection order.
  @override
  final LinkedHashSet<T> selectedValues;

  _MultiSelectionModelImpl(
      Iterable<T> initialSelection, KeyProvider<T> keyProvider)
      : selectedValues = LinkedHashSet<T>(
            equals: (a, b) => keyProvider(a) == keyProvider(b),
            hashCode: (o) => keyProvider(o).hashCode)
          ..addAll(initialSelection);

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
      throw ArgumentError();
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
      throw ArgumentError();
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
      throw ArgumentError();
    }
    final toAdd = values.where((v) => !selectedValues.contains(v)).toList();
    if (toAdd.isEmpty) return;
    bool wasEmpty = isEmpty;
    selectedValues.addAll(toAdd);
    if (wasEmpty && isNotEmpty) {
      notifyPropertyChange(#isEmpty, true, false);
      notifyPropertyChange(#isNotEmpty, false, true);
    }
    notifySelectionChange(added: toAdd);
  }

  @override
  void deselectAll(Iterable<T> values) {
    if (values == null) {
      throw ArgumentError();
    }
    final toRemove = values.where((v) => selectedValues.contains(v)).toList();
    if (toRemove.isEmpty) return;
    final wasNotEmpty = isNotEmpty;
    selectedValues.removeAll(toRemove);
    if (wasNotEmpty && isEmpty) {
      notifyPropertyChange(#isEmpty, false, true);
      notifyPropertyChange(#isNotEmpty, true, false);
    }
    notifySelectionChange(removed: toRemove);
  }

  @override
  bool isSelected(T value) {
    if (value == null) {
      throw ArgumentError();
    }
    return selectedValues.contains(value);
  }

  @override
  bool get isEmpty => selectedValues.isEmpty;

  @override
  bool get isNotEmpty => selectedValues.isNotEmpty;
}
