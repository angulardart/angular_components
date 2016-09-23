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

library angular2_components.utils.async.src.throttle_stream;

import 'dart:async';

import '../../rate_limit_utils/rate_limit_utils.dart'
    show throttle;

import 'rate_limit.dart';

/// Throttles a stream, triggering events at most once per [duration].
///
/// For instance, if a stream is throttled with a duration of 1 second,
/// it will trigger at most ten times in ten seconds, regardless of how
/// many times the original stream triggers in those ten seconds.
///
/// This is useful if you have a high-frequency event stream (such as
/// a stream of mousemove events) that you want to deal with at a lower
/// frequency.
///
/// Events that occur during the cooldown period are discarded. This
/// means that if you throttle a stream with a duration of 1s, an event
/// at t=0 will be triggered, but an event at 0.1s will not be
/// triggered. Subsequent events will not be triggered until t>=1.0s.
StreamTransformer throttleStream(Duration duration) =>
    new RateLimitTransformer(duration, throttle);