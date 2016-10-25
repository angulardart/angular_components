// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.model.ui.item_sorter;

import 'dart:collection';

import './has_renderer.dart';

/// Sorts a list of items using the ItemRenderer to obtain a string
/// representation.
List sortItems(ItemRenderer itemRenderer, Iterable entities,
    {bool ignoreCase: false}) {
  if (ignoreCase) {
    return new SplayTreeMap.fromIterable(entities,
        key: (Object c) => itemRenderer(c).toLowerCase()).values.toList();
  }
  return new SplayTreeMap.fromIterable(entities,
      key: (Object c) => itemRenderer(c)).values.toList();
}
