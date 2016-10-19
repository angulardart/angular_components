// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.utils.async.src.noop_stream;

import 'dart:async';

/// A noop implementation of [Stream], that functionally works the same as a
/// `Stream.fromIterable(const [])` without the const of creating and
/// maintaining a stream.
///
/// Major concerns:
///   [listen] never will result in data, though its `onDone` resolves
///   immediately - asynchronously by default - and synchronously if the
///   stream is created with `sync: true`.
class NoopStream<T> implements Stream<T> {
  final bool _isSync;

  const NoopStream({bool sync: false}) : this._isSync = sync;

  @override
  final isBroadcast = true;

  @override
  Stream<T> asBroadcastStream({onListen, onCancel}) => this;

  @override
  StreamSubscription<T> listen(onData, {onError, onDone, cancelOnError}) {
    if (onDone != null) {
      if (_isSync) {
        onDone();
      } else {
        scheduleMicrotask(onDone);
      }
    }
    return const NoopStreamSubscription();
  }

  @override
  Stream<T> where(test) => this;

  @override
  Stream/*<S>*/ map/*<S>*/(/*=S*/ convert(T value)) =>
      this as dynamic/*=Stream<S>*/;

  @override
  Stream/*<S>*/ asyncMap/*<S>*/(convert) => this as dynamic/*=Stream<S>*/;

  @override
  Stream/*<S>*/ asyncExpand/*<S>*/(convert) => this as dynamic/*=Stream<S>*/;

  @override
  Stream<T> handleError(onError, {test}) => this;

  @override
  Stream/*<S>*/ expand/*<S>*/(Iterable/*<S>*/ convert(T value)) =>
      this as dynamic/*=Stream<S>*/;

  @override
  Future pipe(streamConsumer) => new Future.value();

  @override
  Stream/*<S>*/ transform/*<S>*/(
          StreamTransformer/*<T, S>*/ streamTransformer) =>
      this as dynamic/*=Stream<S>*/;

  @override
  Future<T> reduce(combine) => new Future.value();

  @override
  Future/*<S>*/ fold/*<S>*/(
          /*=S*/ initialValue,
          /*=S*/ combine(/*=S*/ a, /*=T*/ b)) =>
      new Future/*<S>*/ .value();

  @override
  Future<String> join([separator = '']) => new Future.value('');

  @override
  Future<bool> contains(needle) => new Future.value(false);

  @override
  Future forEach(action) => new Future.value();

  @override
  Future<bool> every(test) => new Future.value(true);

  @override
  Future<bool> any(test) => new Future.value(false);

  @override
  Future<int> get length => new Future.value(0);

  @override
  Future<bool> get isEmpty => new Future.value(false);

  @override
  Future<List<T>> toList() => new Future.value(const []);

  @override
  Future<Set<T>> toSet() => new Future.value(new Set<T>());

  @override
  Future/*<S>*/ drain/*<S>*/([/*=S*/ futureValue]) =>
      new Future.value(futureValue);

  @override
  Stream<T> take(count) => this;

  @override
  Stream<T> takeWhile(test) => this;

  @override
  Stream<T> skip(count) => this;

  @override
  Stream<T> skipWhile(test) => this;

  @override
  Stream<T> distinct([equals]) => this;

  @override
  Future<T> get first => new Future.error(new StateError('No element'));

  @override
  Future<T> get last => new Future.error(new StateError('No element'));

  @override
  Future<T> get single => new Future.error(new StateError('No element'));

  @override
  Future<T> firstWhere(test, {defaultValue()}) {
    if (defaultValue != null) {
      return new Future.value(defaultValue());
    } else {
      return new Future.error(new StateError('No element'));
    }
  }

  @override
  Future<T> lastWhere(test, {defaultValue()}) {
    if (defaultValue != null) {
      return new Future.value(defaultValue());
    } else {
      return new Future.error(new StateError('No element'));
    }
  }

  @override
  Future<T> singleWhere(test, {defaultValue()}) {
    if (defaultValue != null) {
      return new Future.value(defaultValue());
    } else {
      return new Future.error(new StateError('No element'));
    }
  }

  @override
  Future<T> elementAt(index) {
    final error = new RangeError.index(index, this, 'index', null, 0);
    return new Future.error(error);
  }

  @override
  Stream<T> timeout(timeLimit, {onTimeout}) => this;
}

/// A noop implementation of [StreamSubscription].
///
/// Major concerns:
///   Using [onDone] causes it to be called immediately after setting -
///   asynchronously by default, and synchronously if the subscription is
///   created with sync: true.
///
///   Using [pause] is not supported.
///
///   [asFuture] immediately resolves.
class NoopStreamSubscription<T> implements StreamSubscription<T> {
  final bool _isSync;

  const NoopStreamSubscription({bool sync: false}) : _isSync = sync;

  @override
  Future cancel() => new Future.value();

  @override
  void onData(handleData) {}

  @override
  void onError(handleError) {}

  @override
  void onDone(handleDone) {
    if (_isSync) {
      handleDone();
    } else {
      scheduleMicrotask(handleDone);
    }
  }

  @override
  void pause([resumeSignal]) => throw new UnsupportedError('Not supported.');

  @override
  void resume() {}

  @override
  final isPaused = false;

  @override
  Future/*<S>*/ asFuture/*<S>*/([/*=S*/ futureValue]) =>
      new Future.value(futureValue);
}
