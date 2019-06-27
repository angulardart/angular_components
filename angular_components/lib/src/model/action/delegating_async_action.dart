// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'async_action.dart';

/// A delegating mixin of the [AsyncAction] class.
abstract class DelegatingAsyncAction<V> implements AsyncAction<V> {
  AsyncAction<V> get delegate;

  @override
  bool get cancelled => delegate.cancelled;
  @override
  bool get isDone => delegate.isDone;
  @override
  Future<V> get onDone => delegate.onDone;
  @override
  Future<bool> get onDefer => delegate.onDefer;
  @override
  void cancelIf(Future<bool> whetherToCancel) =>
      delegate.cancelIf(whetherToCancel);
  @override
  void cancel() => delegate.cancel();
  @override
  void defer(Future<dynamic> executionDeferral) =>
      delegate.defer(executionDeferral);
}
