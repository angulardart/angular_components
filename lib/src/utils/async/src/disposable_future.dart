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

library angular2_components.utils.async.src.disposable_future;

import 'dart:async';

import '../../disposer/disposer.dart';

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
    final completer = new Completer<T>.sync();
    StreamSubscription subscription;
    subscription = stream.listen((value) {
      subscription.cancel();
      completer.complete(value);
    }, onError: completer.completeError);
    return new DisposableFuture<T>(completer.future, subscription.cancel);
  }

  /// Returns a disposable version of [stream.last].
  factory DisposableFuture.last(Stream<T> stream) {
    final completer = new Completer<T>.sync();
    StreamSubscription subscription;
    T lastValue;
    subscription = stream.listen((value) {
      lastValue = value;
    }, onDone: () {
      completer.complete(lastValue);
    });
    return new DisposableFuture<T>(completer.future, subscription.cancel);
  }

  /// Returns a disposable version of Future by converting it into a stream.
  factory DisposableFuture.fromFuture(Future<T> future) {
    return new DisposableFuture<T>.first(future.asStream());
  }

  /// Returns a disposable version of Future by placing the value in a
  /// stream.
  factory DisposableFuture.fromValue(T value) {
    final completer = new Completer<T>.sync();
    bool cancelled = false;
    scheduleMicrotask(() {
      if (!cancelled) {
        completer.complete(value);
      }
    });
    return new DisposableFuture(completer.future, () {
      cancelled = true;
    });
  }

  @override
  void dispose() {
    _wasDisposed = true;
    _disposeFn();
  }

  @override
  DisposableFuture/*<S>*/ then/*<S>*/(onValue(T value), {Function onError}) {
    return new DisposableFuture(
        _delegateFuture.then/*<S>*/((v) {
          if (!_wasDisposed) {
            return onValue(v);
          }
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