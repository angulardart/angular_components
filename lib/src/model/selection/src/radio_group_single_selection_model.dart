// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../selection_model.dart';
import 'delegating_selection_model.dart';

/// Single selection model that always has a value selected
class RadioGroupSingleSelectionModel<T> extends DelegatingSelectionModel<T> {
  RadioGroupSingleSelectionModel([T initialValue])
      : super(new SelectionModel<T>.withList(
            selectedValues: initialValue == null ? const [] : [initialValue]));

  @override
  void clear() {}

  @override
  bool deselect(T value) => false;

  /// The selected value, or null if no value has been selected.
  T get selectedValue => selectedValues.isEmpty ? null : selectedValues.first;
}
