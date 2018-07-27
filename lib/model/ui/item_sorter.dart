// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:angular_components/model/ui/has_renderer.dart';

/// Returns a new list of items sorted according to the string obtained from
/// [itemRenderer].
///
/// [itemRenderer] should return a unique string representation for each item.
List<T> sortItems<T>(ItemRenderer<T> itemRenderer, Iterable<T> items,
    {bool ignoreCase = false}) {
  // TODO(google): Use new SplayTreeMap<String, T>.fromIterable<T>(...) when
  // generic constructors becomes available.
  var itemsMap = SplayTreeMap<String, T>();
  if (ignoreCase) {
    for (T item in items) {
      itemsMap[itemRenderer(item).toLowerCase()] = item;
    }
  } else {
    for (T item in items) {
      itemsMap[itemRenderer(item)] = item;
    }
  }
  return itemsMap.values.toList();
}
