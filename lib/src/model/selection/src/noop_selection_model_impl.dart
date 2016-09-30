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

/// Returned internally as a blank selection model.
class _NoopSelectionModelImpl<T> implements SelectionModel<T> {
  const _NoopSelectionModelImpl();

  // Selection observable.

  @override
  bool deliverSelectionChanges() => false;

  @override
  final bool hasSelectionObservers = false;

  @override
  void notifySelectionChange({added, removed}) {}

  // Observable.

  @override
  Stream<List<ChangeRecord>> get changes => new Stream.fromIterable(const []);

  @override
  bool deliverChanges() => false;

  @override
  final bool hasObservers = false;

  @override
  void notifyChange(_) {}

  @override
  /*=T*/ notifyPropertyChange/*<T>*/(
          Symbol field, /*=T*/ oldValue, /*=T*/ newValue) =>
      null;

  @override
  void observed() {}

  @override
  void unobserved() {}

  // Selection model.

  @override
  void clear() {}

  @override
  bool select(_) => false;

  @override
  bool deselect(_) => false;

  @override
  bool isSelected(_) => false;

  @override
  final bool isEmpty = true;

  @override
  final bool isNotEmpty = false;

  @override
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges =>
      new Stream.fromIterable(const []);

  @override
  final List<T> selectedValues = const [];
}