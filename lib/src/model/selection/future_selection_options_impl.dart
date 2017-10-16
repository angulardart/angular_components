// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular_components.model.selection.selection_options;

class _FutureSelectionOptions<T> extends SelectionOptions<T> {
  _FutureSelectionOptions(Future<List<OptionGroup<T>>> optionGroupListFuture)
      : super([]) {
    optionGroupListFuture.then(_setOptions);
  }
}
