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

import 'dart:async';

import 'package:observe/observe.dart';
import 'package:observable/transitional.dart' show ChangeRecordPayload;

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

  // Delegate to ChangeNotifier.

  @override
  Stream<List<ChangeRecord>> get changes => _delegateModel.changes;

  @override
  bool deliverChanges() => _delegateModel.deliverChanges();

  @override
  void notifyChange(ChangeRecord changeRecord) {
    _delegateModel.notifyChange(changeRecord);
  }

  @override
  /*=T*/ notifyPropertyChange/*<T>*/(
      Symbol field, /*=T*/ oldValue, /*=T*/ newValue) {
    _delegateModel.notifyPropertyChange(field, oldValue, newValue);
    return newValue;
  }

  @override
  bool get hasObservers => _delegateModel.hasObservers;

  @override
  void observed() => _delegateModel.observed();

  @override
  void unobserved() => _delegateModel.unobserved();

  @override
  void postProcessChangeRecords(ChangeRecordPayload payload) =>
      _delegateModel.postProcessChangeRecords(payload);

  @override
  bool get deliverOnNotify => _delegateModel.deliverOnNotify;

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
      : super(delegateModel) {}

  @override
  void selectAll(Iterable<T> values) {
    (_delegateModel as MultiSelectionModel<T>).selectAll(values);
  }
}