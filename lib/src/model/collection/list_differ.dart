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

library ads.acx2.model.collection.list_differ;

import 'dart:collection';

import 'package:observe/observe.dart';

/// Describes an entity and its previous location (or marking it as a new one).
class DiffEntry<T> {
  static const _DEFAULT_NEW_ENTRY_INDEX = -1;

  final T entity;
  final int prevIndex;
  bool get isNew => (prevIndex == _DEFAULT_NEW_ENTRY_INDEX);
  bool get isOld => !isNew;

  DiffEntry.oldEntry(this.entity, this.prevIndex) {
    assert(prevIndex >= 0);
  }

  DiffEntry.newEntry(this.entity) : prevIndex = _DEFAULT_NEW_ENTRY_INDEX;
}

/// Describes the difference of two lists.
abstract class ListDiff<T> {
  /// The entries in the current list.
  List<DiffEntry<T>> get entries;

  /// The deleted entries.
  List<DiffEntry<T>> get deleted;

  factory ListDiff.compare(List<T> prev, List<T> curr) =>
      new _ComparingListDiff(prev, curr);

  factory ListDiff.fromObservable(List<ListChangeRecord> event) =>
      new _ObservedListDiff(event);
}

class _ComparingListDiff<T> implements ListDiff<T> {
  List<DiffEntry<T>> entries = [];
  List<DiffEntry<T>> deleted = [];

  _ComparingListDiff(List<T> prev, List<T> curr) {
    _calculateEntries(prev, curr);
  }

  // TODO(isoos): make calculation of [entries] or the sorting of [deleted]
  // deferred to the time of the getter call
  void _calculateEntries(List<T> prev, List<T> curr) {
    var map = new LinkedHashMap<T, DiffEntry<T>>();
    for (int i = 0; i < prev.length; i++) {
      T entity = prev[i];
      assert(!map.containsKey(entity));
      map[entity] = new DiffEntry<T>.oldEntry(entity, i);
    }
    for (int i = 0; i < curr.length; i++) {
      T entity = curr[i];
      var entry = map.remove(entity);
      if (entry == null) {
        entry = new DiffEntry<T>.newEntry(entity);
      }
      entries.add(entry);
    }
    deleted.addAll(map.values);
  }
}

class _ObservedListDiff<T> implements ListDiff<T> {
  List<DiffEntry<T>> entries;
  List<DiffEntry<T>> deleted;

  _ObservedListDiff(List<ListChangeRecord> event) {
    _processEvent(event);
  }

  void _processEvent(List<ListChangeRecord> event) {
    var removed = <T, DiffEntry<T>>{};
    entries = <DiffEntry<T>>[];

    int offset = 0;
    for (int eventIndex = 0; eventIndex < event.length; eventIndex++) {
      ListChangeRecord record = event[eventIndex];
      for (int i = entries.length; i < record.index; i++) {
        entries
            .add(new DiffEntry<T>.oldEntry(record.object[i] as T, i + offset));
      }
      for (int i = 0; i < record.removed.length; i++) {
        var entity = record.removed[i] as T;
        assert(!removed.containsKey(entity));
        removed[entity] =
            new DiffEntry<T>.oldEntry(entity, record.index + offset + i);
      }
      offset += record.removed.length;
      for (int i = 0; i < record.addedCount; i++) {
        var entity = record.object[record.index + i] as T;
        var entry = removed.remove(entity);
        if (entry == null) {
          entry = new DiffEntry<T>.newEntry(entity);
        }
        entries.add(entry);
      }
      offset -= record.addedCount;
    }
    for (int i = entries.length; i < event.last.object.length; i++) {
      entries.add(
          new DiffEntry<T>.oldEntry(event.last.object[i] as T, i + offset));
    }
    if (removed.isNotEmpty) {
      for (int i = 0; i < entries.length; i++) {
        var entry = entries[i];
        if (entry.isNew) {
          var source = removed.remove(entry.entity);
          if (source != null) {
            entries[i] = source;
          }
        }
      }
    }
    deleted = removed.values.where((entry) => entry.isOld).toList();
    deleted.sort((a, b) => a.prevIndex.compareTo(b.prevIndex));
  }
}