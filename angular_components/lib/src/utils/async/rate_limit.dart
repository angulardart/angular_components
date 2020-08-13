// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular_components/utils/rate_limit_utils/rate_limit_utils.dart'
    show RateLimitStrategy;

typedef _AddEventFn = void Function(dynamic event);

/// An [EventSink] that rate-limits [Stream] events with a given
/// [RateLimitStrategy] and [Duration].
///
/// The [RateLimitStrategy] is executed for each event in the stream,
/// and events are only added to the [_outputSink] if the
/// [RateLimitStrategy] executes its delegate function.
class _RateLimitSink implements EventSink<dynamic> {
  final EventSink<dynamic> _outputSink;
  final Duration _duration;
  final RateLimitStrategy<dynamic> _rateLimitStrategy;
  _AddEventFn _addEvent;

  _RateLimitSink(this._outputSink, this._duration, this._rateLimitStrategy) {
    _addEvent = _rateLimitStrategy(_outputSink.add, _duration);
  }

  @override
  void add(event) {
    _addEvent(event);
  }

  @override
  void addError(error, [StackTrace stackTrace]) {
    _outputSink.addError(error, stackTrace);
  }

  @override
  void close() {
    _outputSink.close();
  }
}

/// A [StreamTransformer] to rate-limit streams with a given
/// [RateLimitStrategy] and [Duration].
class RateLimitTransformer<S, T> extends StreamTransformerBase<S, T> {
  final Duration _duration;
  final RateLimitStrategy<dynamic> _rateLimitStrategy;

  RateLimitTransformer(this._duration, this._rateLimitStrategy);

  @override
  Stream<T> bind(Stream<S> stream) => Stream.eventTransformed(
      stream,
      (EventSink<dynamic> sink) =>
          _RateLimitSink(sink, _duration, _rateLimitStrategy));
}
