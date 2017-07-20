// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../rate_limit_utils/rate_limit_utils.dart'
    show throttle, throttleGuaranteeLast;
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
/// In general, events that occur during the cooldown period are discarded. This
/// means that if you throttle a stream with a duration of 1s, an event
/// at t=0 will be triggered, but an event at 0.1s will not be
/// triggered. Subsequent events will not be triggered until t>=1.0s.
///
/// If [guaranteeLast] is set to true, there is an exception to the general rule
/// above: the last discarded event is saved, and will be triggered once the
/// throttling period expires.
StreamTransformer<S, T> throttleStream<S, T>(Duration duration,
        {bool guaranteeLast: true}) =>
    new RateLimitTransformer<S, T>(
        duration, guaranteeLast ? throttleGuaranteeLast : throttle);
