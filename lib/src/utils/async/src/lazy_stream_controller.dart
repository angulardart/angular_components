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

library angular2_components.utils.async.src.lazy_stream_controller;

import 'dart:async';

/// Creates a stream controller.
typedef StreamController<T> StreamControllerFactory<T>();

/// An implementation of [StreamController] that only actually creates the
/// underlying [StreamController] when the [stream] getter is called for the
/// first time.
///
/// **NOTE**: To simplify the implementation, the controller is also created
/// when a few other methods are called - such as [done], [addStream], [sink].
/// If these end up being common use cases, it may make sense to make them lazy
/// as well.
class LazyStreamController<T> implements StreamController<T> {
  final StreamControllerFactory<T> _streamControllerFactory;

  StreamController<T> _streamController;

  /// Creates a new [LazyStreamController] that will be a non-broadcast
  /// controller.
  factory LazyStreamController(
      {void onListen(), void onCancel(), bool sync: false}) {
    return new LazyStreamController._(() => new StreamController<T>(
        onListen: onListen, onCancel: onCancel, sync: sync));
  }

  /// Creates a new [LazyStreamController] that will be a broadcast controller.
  factory LazyStreamController.broadcast(
      {void onListen(), void onCancel(), bool sync: false}) {
    return new LazyStreamController._(() => new StreamController<T>.broadcast(
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
  Future addStream(Stream<T> source, {bool cancelOnError: true}) {
    return _initializeLazy().addStream(source, cancelOnError: cancelOnError);
  }

  @override
  Future close() {
    if (_streamController != null) {
      return _streamController.close();
    }
    return new Future.value();
  }

  @override
  Future get done => _initializeLazy().done;

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