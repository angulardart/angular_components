// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Creates a stream controller.
typedef StreamController<T> LazyEventEmitterStreamControllerFactory<T>();

/// Lazy version of [EventEmitter], creates [StreamController] only when listen
/// is called.
///
/// Additionally the default version is creating non-broadcast,
/// sync [StreamController] that should be good enough for most cases.
@Deprecated('Use Stream/StreamController instead.')
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
