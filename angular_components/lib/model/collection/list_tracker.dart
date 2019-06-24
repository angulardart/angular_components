// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import 'package:observable/observable.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

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

  /// A callback function for performing a backward pass over inserted ranges
  /// of items.
  ///
  /// For an example on how this callback can be used to implement grouping,
  /// see the "LazyListTracker grouping" test group.
  Function _onInsertBackpass;

  StreamSubscription _subscription;

  LazyListTracker(List<S> source, T mapSource(int index, S object),
      S lookupSource(int index, T object),
      {List<T> target,
      void onRemove(int index, S source, T target),
      T onInsert(int index, S source, T target),
      T onInsertBackpass(int index, S source, T target),
      void onChange()})
      : _source = source,
        _target = target,
        _mapSource = mapSource,
        _lookupSource = lookupSource,
        _onRemove = onRemove,
        _onInsert = onInsert,
        _onInsertBackpass = onInsertBackpass,
        _onChange = onChange;

  @override
  bool get isEmpty => _target == null || _target.isEmpty;

  @override
  bool get isNotEmpty => _target != null && _target.isNotEmpty;

  @override
  int get length => _target == null ? 0 : _target.length;

  @override
  set length(int value) => throw UnimplementedError();

  /// Forces the tracker to track the ObservableList source, otherwise it
  /// will be tracked only on the first index access.
  void startTracking() {
    _initIfRequired();
  }

  /// Like the [] operator, but does not try to fill missing indices by
  /// deferring to [_mapSource], instead returning null.
  T softLookup(int index) => _target[index];

  @override
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

  @override
  void operator []=(int index, T value) {
    _target[index] = value;
  }

  T clearAt(int index) {
    assert(index < length);
    T object = _target[index];
    _target[index] = null;
    return object;
  }

  void updateAll({bool force = false}) {
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
  @override
  void clear() {
    dispose();
    _initIfRequired();
  }

  void _initIfRequired() {
    if (_target == null) {
      _target = [];
      if (_source is ObservableList) {
        (_source as ObservableList).deliverListChanges();
        _subscription = (_source as ObservableList)
            .listChanges
            .listen((event) => _onSourceChanges(event));
      }
      _target.length = _source?.length ?? 0;
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
      var end = record.addedCount - 1;

      // Consumers can optionally provide an [_onInsertBackpass] callback, which
      // will cause entities to be visited in reverse order until this callback
      // returns null. This can be useful for propagating information backward
      // from the mapped value that immediately follows the inserted range.
      if (_onInsertBackpass != null) {
        for (; end >= 0; end--) {
          int index = record.index + end;
          T object =
              _onInsertBackpass(index, record.object[index], _target[index])
                  as T;
          if (object == null) {
            break;
          } else {
            _target[index] = object;
          }
        }
      }

      for (int i = 0; i <= end; i++) {
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

typedef _MapFunction<A, B> = B Function(int index, A object);
