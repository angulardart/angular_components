// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular_components/utils/disposer/disposer.dart';

/// A future that is [disposable], which cancels the underlying operation, if
/// any. Even if the operation finishes, [then] will not be fired if [dispose]
/// is called first.
class DisposableFuture<T> implements Future<T>, Disposable {
  final Future<T> _delegateFuture;
  final DisposeFunction _disposeFn;

  bool _wasDisposed = false;

  /// Wraps a future and passes a function that should cancel the operation.
  DisposableFuture(this._delegateFuture, this._disposeFn);

  /// Returns a disposable version of [stream.first].
  factory DisposableFuture.first(Stream<T> stream) {
    final completer = Completer<T>.sync();
    StreamSubscription<Object> subscription;
    subscription = stream.listen((value) {
      subscription.cancel();
      completer.complete(value);
    }, onError: completer.completeError);
    return DisposableFuture<T>(completer.future, subscription.cancel);
  }

  /// Returns a disposable version of [stream.last].
  factory DisposableFuture.last(Stream<T> stream) {
    final completer = Completer<T>.sync();
    StreamSubscription<Object> subscription;
    T lastValue;
    subscription = stream.listen((value) {
      lastValue = value;
    }, onDone: () {
      completer.complete(lastValue);
    });
    return DisposableFuture<T>(completer.future, subscription.cancel);
  }

  /// Returns a disposable version of Future by converting it into a stream.
  factory DisposableFuture.fromFuture(Future<T> future) {
    return DisposableFuture<T>.first(future.asStream());
  }

  /// Returns a disposable version of Future by placing the value in a
  /// stream.
  factory DisposableFuture.fromValue(T value) {
    final completer = Completer<T>.sync();
    bool cancelled = false;
    scheduleMicrotask(() {
      if (!cancelled) {
        completer.complete(value);
      }
    });
    return DisposableFuture(completer.future, () {
      cancelled = true;
    });
  }

  @override
  void dispose() {
    _wasDisposed = true;
    _disposeFn();
  }

  @override
  DisposableFuture<S> then<S>(FutureOr<S> onValue(T value),
      {Function onError}) {
    return DisposableFuture(
        _delegateFuture.then<S>((v) {
          if (!_wasDisposed) {
            return onValue(v);
          }
          return null;
        }, onError: onError),
        _disposeFn);
  }

  @override
  Future<T> catchError(Function onError, {bool test(Object error)}) {
    return _delegateFuture.catchError(onError, test: test);
  }

  @override
  Future<T> whenComplete(action()) {
    return _delegateFuture.whenComplete(() {
      if (!_wasDisposed) {
        action();
      }
    });
  }

  @override
  Stream<T> asStream() => _delegateFuture.asStream();

  @override
  Future<T> timeout(Duration timeLimit, {onTimeout()}) {
    return _delegateFuture.timeout(timeLimit, onTimeout: onTimeout);
  }
}
