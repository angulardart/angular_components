// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library angular2_components.model.collection.combined_list;

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