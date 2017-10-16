// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Runs [fn] within a zone.
typedef RunInZoneFn(fn());

/// Generic zone-running helper mixin.
abstract class _ZoneRunner {
  RunInZoneFn get _runInZoneFn;

  S _runInZone<S>(S fn()) => _runInZoneFn(fn) as S;
}

/// A wrapper around an existing [Future] that processes all events received
/// within a specific zone, *instead* of the default behavior of processing them
/// in the zone that the `then` originated.
///
/// This can be used to retain the [Future] API without causing frameworks like
/// Angular to capture events.
///
/// A simple example:
///     void example() {
///       var future = new Future.value(1);
///       var frameworkZone = Zone.current.fork();
///       frameworkZone.run(() {
///         expect(Zone.current, frameworkZone);
///       });
///       var outerZone = Zone.current;
///       future = ZonedFuture(future, outerZone.run);
///       frameworkZone.run(() {
///         future.then((_) {
///           expect(Zone.current, outerZone);
///         });
///       });
///     }
class ZonedFuture<T> extends _ZoneRunner implements Future<T> {
  final Future<T> _innerFuture;
  @override
  final RunInZoneFn _runInZoneFn;

  ZonedFuture(this._innerFuture, this._runInZoneFn);

  @override
  Stream<T> asStream() {
    return new ZonedStream(_innerFuture.asStream(), _runInZoneFn);
  }

  @override
  Future<T> catchError(Function onError, {bool test(Object error)}) {
    return _runInZone(() => _innerFuture.catchError(onError, test: test));
  }

  @override
  Future<S> then<S>(FutureOr<S> onValue(T value), {Function onError}) {
    return _runInZone(() => _innerFuture.then<S>(onValue, onError: onError));
  }

  @override
  Future<T> timeout(Duration timeLimit, {onTimeout()}) {
    return _runInZone(() {
      return _innerFuture.timeout(timeLimit, onTimeout: onTimeout);
    });
  }

  @override
  Future<T> whenComplete(action()) {
    return _runInZone(() => _innerFuture.whenComplete(action));
  }
}

/// A wrapper around an existing [Stream] that processes all events received
/// within a specific zone, *instead* of the default behavior of processing them
/// in the zone that the `listen` originated.
///
/// This can be used to retain the [Stream] API without causing frameworks like
/// Angular to capture events.
///
/// A simple example:
///     void example() {
///       var stream = new Stream.fromIterable([1]);
///       var frameworkZone = Zone.current.fork();
///       frameworkZone.run(() {
///         expect(Zone.current, frameworkZone);
///       });
///       var outerZone = Zone.current;
///       stream = new ZonedStream(stream, outerZone.run);
///       frameworkZone.run(() {
///         stream.listen((event) {
///           expect(Zone.current, outerZone);
///         });
///       });
///     }
class ZonedStream<T> extends Stream<T> with _ZoneRunner {
  final Stream<T> _innerStream;
  @override
  final RunInZoneFn _runInZoneFn;

  ZonedStream(this._innerStream, this._runInZoneFn);

  @override
  bool get isBroadcast => _innerStream.isBroadcast;

  @override
  Future<T> get first {
    return new ZonedFuture<T>(_innerStream.first, _runInZone);
  }

  @override
  Future<T> get last {
    return new ZonedFuture<T>(_innerStream.last, _runInZone);
  }

  @override
  StreamSubscription<T> listen(void onData(T value),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _runInZone(() {
      return _innerStream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    });
  }
}
