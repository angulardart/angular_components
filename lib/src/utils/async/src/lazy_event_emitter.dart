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

library ads.acx2.utils.async.src.lazy_event_emitter;

import 'dart:async';

/// Creates a stream controller.
typedef StreamController<T> LazyEventEmitterStreamControllerFactory<T>();

/// Lazy version of [EventEmitter], creates [StreamController] only when listen
/// is called.
///
/// Additionally the default version is creating non-broadcast,
/// sync [StreamController] that should be good enough for most cases.
// TODO(google): add tests.
class LazyEventEmitter<T> extends Stream<T> {
  final LazyEventEmitterStreamControllerFactory<T> _streamControllerFactory;

  LazyEventEmitter._(this._streamControllerFactory);

  /// Creates a new [LazyEventEmitter] that will use a non-broadcast
  /// controller.
  factory LazyEventEmitter(
      {void onListen(), void onCancel(), bool sync: true}) {
    return new LazyEventEmitter._(() => new StreamController<T>(
        onListen: onListen, onCancel: onCancel, sync: sync));
  }

  /// Creates a new [LazyEventEmitter] that will use a broadcast controller.
  factory LazyEventEmitter.broadcast(
      {void onListen(), void onCancel(), bool sync: true}) {
    return new LazyEventEmitter._(() => new StreamController<T>.broadcast(
        onListen: onListen, onCancel: onCancel, sync: sync));
  }

  StreamController<T> _streamController;

  StreamController<T> get _controller {
    if (_streamController == null) {
      _streamController = _streamControllerFactory();
    }
    return _streamController;
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    return _controller.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void add(T value) {
    _streamController?.add(value);
  }

  void addError(error) {
    _streamController?.addError(error);
  }

  void close() {
    _streamController?.close();
  }

  /// Native stream without [add] methods, so it doesn't leak control
  /// to the clients.
  Stream<T> get stream => _controller.stream;

  EventSink<T> _sink;

  /// Sink that allows clients to [add] events, but doesn't let listen to them.
  EventSink<T> get sink => _sink ??= _controller.sink;
}