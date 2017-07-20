// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:observable/observable.dart';

import '../selection_model.dart';

/// A delegating implementation of [SelectionModel].
class DelegatingSelectionModel<T> implements SelectionModel<T> {
  final SelectionModel<T> _delegateModel;

  DelegatingSelectionModel(this._delegateModel);

  // Delegate to SelectionModel.

  @override
  void clear() {
    _delegateModel.clear();
  }

  @override
  bool select(T value) => _delegateModel.select(value);

  @override
  bool deselect(T value) => _delegateModel.deselect(value);

  @override
  bool isSelected(T value) => _delegateModel.isSelected(value);

  @override
  bool get isEmpty => _delegateModel.isEmpty;

  @override
  bool get isNotEmpty => _delegateModel.isNotEmpty;

  @override
  Iterable<T> get selectedValues => _delegateModel.selectedValues;

  // Delegate to Observable.

  @override
  Stream<List<ChangeRecord>> get changes => _delegateModel.changes;

  @override
  bool deliverChanges() => _delegateModel.deliverChanges();

  @override
  void notifyChange([ChangeRecord changeRecord]) {
    _delegateModel.notifyChange(changeRecord);
  }

  @override
  T notifyPropertyChange<T>(Symbol field, T oldValue, T newValue) {
    _delegateModel.notifyPropertyChange(field, oldValue, newValue);
    return newValue;
  }

  @override
  bool get hasObservers => _delegateModel.hasObservers;

  @override
  void observed() => _delegateModel.observed();

  @override
  void unobserved() => _delegateModel.unobserved();

  // Delegate to SelectionChangeNotifier.

  @override
  bool deliverSelectionChanges() => _delegateModel.deliverSelectionChanges();

  @override
  void notifySelectionChange(
      {Iterable<T> added: const [], Iterable<T> removed: const []}) {
    _delegateModel.notifySelectionChange(added: added, removed: removed);
  }

  @override
  bool get hasSelectionObservers => _delegateModel.hasSelectionObservers;

  @override
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges {
    return _delegateModel.selectionChanges;
  }
}

/// a delegating implementation of [MultiSelectionModel]
class DelegatingMultiSelectionModel<T> extends DelegatingSelectionModel<T>
    implements MultiSelectionModel<T> {
  DelegatingMultiSelectionModel(MultiSelectionModel<T> delegateModel)
      : super(delegateModel);

  @override
  void selectAll(Iterable<T> values) {
    (_delegateModel as MultiSelectionModel<T>).selectAll(values);
  }

  @override
  void deselectAll(Iterable<T> values) {
    (_delegateModel as MultiSelectionModel<T>).deselectAll(values);
  }
}
