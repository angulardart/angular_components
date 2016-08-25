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

library ads.acx2.utils.async.src.rate_limit;

import 'dart:async';

import '../../rate_limit_utils/rate_limit_utils.dart'
    show RateLimitStrategy;

typedef void _AddEventFn(event);

/// An [EventSink] that rate-limits [Stream] events with a given
/// [RateLimitStrategy] and [Duration].
///
/// The [RateLimitStrategy] is executed for each event in the stream,
/// and events are only added to the [_outputSink] if the
/// [RateLimitStrategy] executes its delegate function.
class _RateLimitSink implements EventSink {
  final EventSink _outputSink;
  final Duration _duration;
  final RateLimitStrategy _rateLimitStrategy;
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
class RateLimitTransformer implements StreamTransformer {
  final Duration _duration;
  final RateLimitStrategy _rateLimitStrategy;

  RateLimitTransformer(this._duration, this._rateLimitStrategy);

  Stream bind(Stream stream) => new Stream.eventTransformed(
      stream,
      (EventSink sink) =>
          new _RateLimitSink(sink, _duration, _rateLimitStrategy));
}