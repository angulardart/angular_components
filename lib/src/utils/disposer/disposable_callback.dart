// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import './disposer.dart';

typedef void CallbackNoParamFn();
typedef void CallbackSingleParamFn<T>(T value);

/// A Disposable Callback base that can be extended from or used as a mixin.
///
/// Disposable callbacks allow the developer to pass in a callback but still
/// maintain control over the lifecycle of the callback.  Ex: Pass a callback
/// to a future but the future completes after the object no longer needs the
/// result.
/// Being able to use noSuchMethod would simplify the need for multiple classes.
class DisposableCallbackBase implements Disposable {
  Function _callback;

  @override
  void dispose() {
    _callback = null;
  }
}

/// A disposable callback/function for a callback with no parameters.
///
/// It is assumed that the callback will return void.
class DisposableCallback extends DisposableCallbackBase {
  DisposableCallback(CallbackNoParamFn callback) {
    _callback = callback;
  }

  call() {
    if (_callback != null) {
      _callback();
    }
  }
}

/// A disposable callback/function for a callback with one parameters.
class SingleValueCallback<T> extends DisposableCallbackBase {
  SingleValueCallback(CallbackSingleParamFn<T> callback) {
    _callback = callback;
  }

  call(T value) {
    if (_callback != null) {
      _callback(value);
    }
  }
}
