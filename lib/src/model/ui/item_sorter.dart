// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import './has_renderer.dart';

/// Sorts a list of items using the ItemRenderer to obtain a string
/// representation.
List<String> sortItems(ItemRenderer itemRenderer, Iterable entities,
    {bool ignoreCase: false}) {
  if (ignoreCase) {
    return new SplayTreeMap<dynamic, String>.fromIterable(entities,
        key: (Object c) => itemRenderer(c).toLowerCase()).values.toList();
  }
  return new SplayTreeMap<dynamic, String>.fromIterable(entities,
      key: (Object c) => itemRenderer(c)).values.toList();
}
