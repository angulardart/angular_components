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

library ads.acx2.utils.async.src.debounce_stream;

import 'dart:async';

import '../../rate_limit_utils/rate_limit_utils.dart'
    show debounce;

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
StreamTransformer debounceStream(Duration duration) =>
    new RateLimitTransformer(duration, debounce);