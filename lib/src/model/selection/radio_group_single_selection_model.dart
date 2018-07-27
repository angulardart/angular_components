// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/selection/selection_model.dart';

import 'delegating_selection_model.dart';

/// Single selection model that always has a value selected
class RadioGroupSingleSelectionModel<T>
    extends DelegatingSingleSelectionModel<T> {
  RadioGroupSingleSelectionModel([T initialValue])
      : super(SelectionModel<T>.single(
            selected: initialValue == null ? null : initialValue));

  @override
  void clear() {}

  @override
  bool deselect(T value) => false;
}
