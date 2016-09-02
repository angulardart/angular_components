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

library ads.acx2.model.collection.list_tracker;

import 'dart:async';
import 'dart:collection';

import 'package:observe/observe.dart';

import '../../utils/disposer/disposer.dart';

class LazyListTracker<S, T> extends Object
    with ListMixin<T>
    implements Disposable {
  List<S> _source;
  List<T> _target;

  _MapFunction<S, T> _mapSource;
  _MapFunction<T, S> _lookupSource;
  Function _onRemove;
  Function _onInsert;
  Function _onChange;

  StreamSubscription _subscription;

  LazyListTracker(List<S> source, T mapSource(int index, S object),
      S lookupSource(int index, T object),
      {List<T> target,
      void onRemove(int index, S source, T target),
      T onInsert(int index, S source, T target),
      void onChange()})
      : _source = source,
        _target = target,
        _mapSource = mapSource,
        _lookupSource = lookupSource,
        _onRemove = onRemove,
        _onInsert = onInsert,
        _onChange = onChange;

  bool get isEmpty => (_source == null) || _source.isEmpty;
  bool get isNotEmpty => (_source != null) && _source.isNotEmpty;
  int get length => (_source == null) ? 0 : _source.length;
  set length(int value) => throw new UnimplementedError();

  /// Forces the tracker to track the ObservableList source, otherwise it will
  /// be tracked only on the first index access.
  void startTracking() {
    _initIfRequired();
  }

  T operator [](int index) {
    _initIfRequired();
    T object = _target[index];
    if (object == null) {
      object = _mapSource(index, _source[index]);
      _target[index] = object;
    }
    assert(_lookupSource(index, object) == _source[index]);
    return object;
  }

  void operator []=(int index, T value) {
    _target[index] = value;
  }

  T clearAt(int index) {
    assert(index < length);
    T object = _target[index];
    _target[index] = null;
    return object;
  }

  void updateAll({bool force: false}) {
    if (force) {
      _target.clear();
      _target.length = _source.length;
    }
    for (int i = 0; i < length; i++) {
      this[i];
    }
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    if (_target != null) {
      for (int i = 0; i < length; i++) {
        T object = _target[i];
        if (object == null) continue;
        disposeMapped(object);
      }
      _target = null;
    }
  }

  void disposeMapped(T object) {
    if (object is Disposable) {
      var d = object;
      d.dispose();
    }
  }

  set source(List<S> value) {
    if (_source == value) return;
    dispose();
    _source = value;
    _initIfRequired();
  }

  /// clears the tracked values
  void clear() {
    dispose();
    _initIfRequired();
  }

  void _initIfRequired() {
    if (_target == null) {
      _target = new List();
      if (_source is ObservableList) {
        (_source as ObservableList).deliverListChanges();
        _subscription = (_source as ObservableList)
            .listChanges
            .listen((event) => _onSourceChanges(event));
      }
      _target.length = length;
    }
  }

  void _onSourceChanges(List<ListChangeRecord> event) {
    Map<S, T> removed;
    for (int eventIndex = 0; eventIndex < event.length; eventIndex++) {
      ListChangeRecord record = event[eventIndex];

      // removing records
      if (record.removed.isNotEmpty) {
        for (int removedIndex = record.removed.length - 1;
            removedIndex >= 0;
            removedIndex--) {
          int index = record.index + removedIndex;
          T object = _target[index];
          _onRemove?.call(index, record.removed[removedIndex], object);
          if (object == null) continue; // exit removedIndex loop
          removed ??= <S, T>{};
          assert(_lookupSource(index, object) != null);
          // making sure we don't have a duplicate entry
          assert(!removed.containsKey(_lookupSource(index, object)));
          removed[_lookupSource(index, object)] = object;
        }
        _target.removeRange(record.index, record.index + record.removed.length);
      }

      // nothing to add?
      if (record.addedCount == 0) continue;

      // If the change is only adding extra items to the end, we just extend the
      // length of the target list.
      if ((removed == null || removed.isEmpty) &&
          (record.index == _target.length)) {
        _target.length += record.addedCount;
        _notifyInsert(record);
        continue;
      }

      // inserting records and checking for target reuse
      if (record.addedCount > 0) {
        Iterable added = record.object
            .sublist(record.index, record.index + record.addedCount);
        // insertAll to hopefully make the array shift a one-time operation
        _target.insertAll(record.index, added.map((entity) {
          if (removed == null || removed.isEmpty) return null;
          return removed.remove(entity);
        }));
        _notifyInsert(record);
      }
    }
    assert(_assertInSync());
    // clearing removed entries
    if (removed != null) {
      removed.values.forEach(disposeMapped);
    }
    if (_onChange != null) {
      _onChange();
    }
  }

  void _notifyInsert(ListChangeRecord record) {
    if (_onInsert != null) {
      for (int i = 0; i < record.addedCount; i++) {
        int index = record.index + i;
        T object = _onInsert(index, record.object[index], _target[index]) as T;
        if (object != null) {
          _target[index] = object;
        }
      }
    }
  }

  bool _assertInSync() {
    if (_source.length != _target.length) return false;
    for (int i = 0; i < _target.length; i++) {
      T object = _target[i];
      if (object == null) continue;
      if (_lookupSource(i, object) != _source[i]) return false;
    }
    return true;
  }
}

typedef B _MapFunction<A, B>(int index, A object);