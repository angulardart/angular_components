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
    {bool ignoreCase: false}) {
  if (ignoreCase) {
    return new SplayTreeMap<String, T>.fromIterable(items,
        key: (T item) => itemRenderer(item).toLowerCase()).values.toList();
  }
  return new SplayTreeMap<String, T>.fromIterable(items,
      key: (T item) => itemRenderer(item)).values.toList();
}
