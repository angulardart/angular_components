// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

/// An efficient way to combine multiple lists and expose it as a read-only
/// combined list.
class CombinedList<E> extends ListMixin<E> {
  final List<List<E>> _lists;
  CombinedList(this._lists);

  @override
  bool get isEmpty => _lists.every((List list) => list.isEmpty);

  @override
  bool get isNotEmpty => _lists.any((List list) => list.isNotEmpty);

  @override
  int get length => _lists.fold(0, (int sum, List list) => sum + list.length);

  @override
  E operator [](int index) {
    for (int i = 0; i < _lists.length; i++) {
      List<E> list = _lists[i];
      if (index < list.length) return list[index];
      index -= list.length;
    }
    throw new StateError('Index out of range: $index ($length)');
  }

  @override
  void operator []=(int index, E value) {
    for (int i = 0; i < _lists.length; i++) {
      List<E> list = _lists[i];
      if (index < list.length) {
        list[index] = value;
        return;
      }
      index -= list.length;
    }
    throw new StateError('Index out of range: $index ($length)');
  }

  @override
  set length(int newLength) => throw new UnimplementedError();
}
