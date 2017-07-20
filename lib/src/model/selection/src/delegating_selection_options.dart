// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../selection_options.dart';

/// A [SelectionOptions] implementation that delegates.
class DelegatingSelectionOptions<T> implements SelectionOptions<T> {
  SelectionOptions<T> _options;

  DelegatingSelectionOptions(this._options);

  @override
  List<OptionGroup<T>> get optionGroups => _options.optionGroups;

  @override
  set optionGroups(List<OptionGroup<T>> groups) {
    _options.optionGroups = groups;
  }

  @override
  void dispose() {
    _options.dispose();
  }

  @override
  bool get isNotEmpty => _options.isNotEmpty;

  @override
  List<T> get optionsList => _options.optionsList;

  @override
  Stream<List<OptionGroup<T>>> get stream => _options.stream;
}
