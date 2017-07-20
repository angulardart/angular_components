// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../rate_limit_utils/rate_limit_utils.dart' show debounce;
import 'rate_limit.dart';

/// Debounces a stream, preventing it from triggering until [duration]
/// has passed between events.
///
/// For example, if a stream of keypresses is debounced with
/// a duration of 250 milliseconds, an event will only be triggered
/// once the user has stopped typing for 250 milliseconds.
///
/// This is useful if you have a burst of events and only want to deal
/// with the last event in the burst. Let's say you have a search box,
/// and only want to fetch autocomplete suggestions after the user has
/// finished typing. That's a situation where you'd debounce the
/// keypress event stream.
///
/// Only the last event in a burst is triggered, and it will be
/// triggered after [duration] has elapsed. So if you debounce a
/// keypress stream with a duration of 1s, and there are three events
/// at t=0s, t=0.1s, at t=0.2s, the first two events will be discarded
/// and the last event will be triggered at t=1.2s.
StreamTransformer<S, T> debounceStream<S, T>(Duration duration) =>
    new RateLimitTransformer<S, T>(duration, debounce);
