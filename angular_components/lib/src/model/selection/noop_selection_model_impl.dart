// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular_components.model.selection.selection_model;

/// Returned internally as a blank selection model.
class _NoopSelectionModelImpl<T> implements NullSelectionModel<T> {
  const _NoopSelectionModelImpl();

  @override
  final bool isSingleSelect = null;

  // Selection observable.

  @override
  bool deliverSelectionChanges() => false;

  @override
  final bool hasSelectionObservers = false;

  @override
  void notifySelectionChange({added, removed}) {}

  // Observable.

  @override
  Stream<List<ChangeRecord>> get changes => Stream.fromIterable(const []);

  @override
  bool deliverChanges() => false;

  @override
  final bool hasObservers = false;

  @override
  void notifyChange([_]) {}

  @override
  S notifyPropertyChange<S>(Symbol field, S oldValue, S newValue) => null;

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
      Stream.fromIterable(const []);

  @override
  final T selectedValue = null;

  @override
  final List<T> selectedValues = const [];

  @override
  Iterable<T> castIterable(Iterable values) => values.cast<T>();
}
