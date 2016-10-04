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

import 'dart:async';

/// A container which controls the visibility of its content via a Stream.
///
/// This allows content to defer its view creation until it is actually visible.
/// The `DeferredContentDirective` is a directive which looks for a parent
/// providing this stream and creates/clears its view based on the stream.
abstract class DeferredContentAware {
  /// Component publishes to this stream to control the visibility of contents.
  Stream<bool> get contentVisible;
}
