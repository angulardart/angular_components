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

library angular2_components.model.ui.accepts_width;

/// Interface for setting widgets programatically.
/// Preset width, 1 through 5. By default, width #2 is used.
/// Each width multiplies the base block width (64px on desktop and tablet) by
/// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
/// Set to 0 to have the list expand to fit its content.
/// Note: The spec clearly lays out predefined list sizes so use
/// the default, expanding size, sparingly.
abstract class AcceptsWidth {
  set width(dynamic val);
}
