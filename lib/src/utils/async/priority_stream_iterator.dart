// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:collection/collection.dart';

/// A [StreamIterator] that accumulates the [Stream]'s values into a priority
/// queue and selects the one with the most priority (the least one by
/// comparison) of all accumulated values at each [moveNext] call.
class PriorityStreamIterator<T extends Comparable>
    implements StreamIterator<T> {
  final StreamIterator<T> _iterator;
  final PriorityQueue<T> _queue;

  T _current;
  Future<bool> _next;

  /// Create a [PriorityStreamIterator] on [stream] with an optional
  /// [comparison] function. If [comparison] is not provided, [T] must implement
  /// Comparable<T>.
  PriorityStreamIterator(Stream<T> stream, [int comparison(T a, T b)])
      : _iterator = new StreamIterator(stream),
        _queue = new _StablePriorityQueue<T>(comparison) {
    _accumulateValues();
  }

  // This function is not async to be synchronous for a synchronous
  // StreamIterator.
  @override
  Future<bool> moveNext() {
    if (_queue.isNotEmpty) {
      _current = _queue.removeFirst();
      return new Future.value(true);
    }
    _current = null;
    return _next.then((_) {
      if (_) {
        _current = _queue.removeFirst();
      }
      return _;
    });
  }

  @override
  T get current => _current;

  @override
  Future cancel() {
    _clear();
    return _iterator.cancel();
  }

  // This function is not async to be synchronous for a synchronous
  // StreamIterator.
  void _accumulateValues() {
    (_next = _getNextValue()).then((_) {
      if (_) {
        _accumulateValues();
      }
    });
  }

  // This function is not async to be synchronous for a synchronous
  // StreamIterator.
  Future<bool> _getNextValue() => _iterator.moveNext().then((_) {
        if (_) {
          _queue.add(_iterator.current);
        }
        return _;
      });

  void _clear() {
    _current = null;
    _queue.clear();
  }
}

/// A [PriorityQueue] that works like a normal queue for elements that compare
/// as equal, that is, returns them in the order they were added.
///
/// Takes an optional [Comparator] parameter that should be used instead of the
/// default [Comparable.compare].
class _StablePriorityQueue<T extends Comparable> extends HeapPriorityQueue<T> {
  _StablePriorityQueue([Comparator<T> comparison])
      : super(new _OrderedComparator(comparison ?? _defaultComparator<T>()));

  _OrderedComparator<T> get comparator => comparison as _OrderedComparator<T>;

  @override
  void add(T el) {
    comparator.add(el);
    super.add(el);
  }

  @override
  void addAll(Iterable<T> elements) {
    comparator.addAll(elements);
    super.addAll(elements);
  }

  @override
  bool remove(T el) {
    bool result = super.remove(el);
    comparator.remove(el);
    return result;
  }

  @override
  Iterable<T> removeAll() {
    Iterable<T> result = super.removeAll();
    comparator.clear();
    return result;
  }

  @override
  T removeFirst() {
    T el = super.removeFirst();
    comparator.remove(el);
    return el;
  }

  @override
  void clear() {
    super.clear();
    comparator.clear();
  }
}

Comparator<T> _defaultComparator<T extends Comparable>() =>
    (T a, T b) => a.compareTo(b);

/// A [Comparator] that allows registering elements and uses the order of
/// registration to resolve the cases when elements compare as equal.
class _OrderedComparator<T extends Comparable> implements Function {
  static const RENUMERATE_THRESHOLD = 1000000;

  final Comparator<T> _comparison;
  final Map<T, int> _ordinalByElement = {};

  int _nextOrdinal = 0;

  _OrderedComparator(this._comparison);

  /// Registers an element.
  void add(T el) {
    _ordinalByElement[el] = _nextOrdinal++;
  }

  /// Registers an [Iterable] of elements in a given order.
  void addAll(Iterable<T> elements) => elements.forEach(add);

  /// Clears all registered elements and resets the counter.
  void clear() {
    _ordinalByElement.clear();
    _nextOrdinal = 0;
  }

  /// Deregisters an element.
  void remove(T el) {
    _ordinalByElement.remove(el);
    _renumerate();
  }

  int call(T a, T b) {
    int result = _comparison(a, b);
    return result != 0 ? result : _compareOrder(a, b);
  }

  int _compareOrder(T a, T b) {
    if (!_ordinalByElement.containsKey(a) ||
        !_ordinalByElement.containsKey(b)) {
      throw new StateError(
          "Comparing elements that weren't registered with the comparator.");
    }
    return _ordinalByElement[a] - _ordinalByElement[b];
  }

  void _renumerate() {
    if (_ordinalByElement.isEmpty) {
      _nextOrdinal = 0;
    }
    if (_nextOrdinal > _ordinalByElement.length + RENUMERATE_THRESHOLD) {
      var orderedElements = _ordinalByElement.keys.toList(growable: false)
        ..sort(_compareOrder);
      clear();
      addAll(orderedElements);
    }
  }
}
