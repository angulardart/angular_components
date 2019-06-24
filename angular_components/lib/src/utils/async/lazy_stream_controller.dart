// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Creates a stream controller.
typedef StreamControllerFactory<T> = StreamController<T> Function();

/// An implementation of [StreamController] that only actually creates the
/// underlying [StreamController] when the [stream] getter is called for the
/// first time.
///
/// **NOTE**: To simplify the implementation, the controller is also created
/// when a few other methods are called - such as [done], [addStream], [sink].
/// If these end up being common use cases, it may make sense to make them lazy
/// as well.
@Deprecated('Use StreamController instead. Which is more performant.')
class LazyStreamController<T> implements StreamController<T> {
  final StreamControllerFactory<T> _streamControllerFactory;

  StreamController<T> _streamController;

  /// Creates a new [LazyStreamController] that will be a non-broadcast
  /// controller.
  factory LazyStreamController(
      {void onListen(), void onCancel(), bool sync = false}) {
    return LazyStreamController._(() => StreamController<T>(
        onListen: onListen, onCancel: onCancel, sync: sync));
  }

  /// Creates a new [LazyStreamController] that will be a broadcast controller.
  factory LazyStreamController.broadcast(
      {void onListen(), void onCancel(), bool sync = false}) {
    return LazyStreamController._(() => StreamController<T>.broadcast(
        onListen: onListen, onCancel: onCancel, sync: sync));
  }

  LazyStreamController._(this._streamControllerFactory);

  StreamController<T> _initializeLazy() {
    if (_streamController == null) {
      _streamController = _streamControllerFactory();
    }
    return _streamController;
  }

  @override
  bool get isClosed {
    return _streamController != null ? _streamController.isClosed : false;
  }

  @override
  bool get hasListener {
    return _streamController != null ? _streamController.hasListener : false;
  }

  @override
  bool get isPaused {
    return _streamController != null ? _streamController.isPaused : false;
  }

  @override
  void add(T event) {
    if (_streamController != null) {
      _streamController.add(event);
    }
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    if (_streamController != null) {
      _streamController.addError(error, stackTrace);
    }
  }

  @override
  Future<Object> addStream(Stream<T> source, {bool cancelOnError = true}) {
    return _initializeLazy().addStream(source, cancelOnError: cancelOnError);
  }

  @override
  Future<dynamic> close() {
    if (_streamController != null) {
      return _streamController.close();
    }
    return Future<dynamic>.value();
  }

  @override
  Future<Object> get done => _initializeLazy().done;

  @override
  StreamSink<T> get sink => _initializeLazy().sink;

  @override
  Stream<T> get stream => _initializeLazy().stream;

  @override
  set onListen(void onListenHandler()) {
    _initializeLazy().onListen = onListenHandler;
  }

  @override
  ControllerCallback get onListen => _initializeLazy().onListen;

  @override
  set onPause(void onPauseHandler()) {
    _initializeLazy().onPause = onPauseHandler;
  }

  @override
  ControllerCallback get onPause => _initializeLazy().onPause;

  @override
  set onResume(void onResumeHandler()) {
    _initializeLazy().onResume = onResumeHandler;
  }

  @override
  ControllerCallback get onResume => _initializeLazy().onResume;

  @override
  set onCancel(void onCancelHandler()) {
    _initializeLazy().onCancel = onCancelHandler;
  }

  @override
  ControllerCallback get onCancel => _initializeLazy().onCancel;
}
