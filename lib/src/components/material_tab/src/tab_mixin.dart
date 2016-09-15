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

import 'dart:html';

/// A mixin for use by tab button component and tab dropdown menu component.
abstract class TabMixin {
  String _label;
  int _textWidth = 0;

  /// The host element.
  Element get nativeElement;

  /// Tha tab label.
  ///
  /// When it's being set, it also resets the text width for re-calculation
  /// subsequently.
  String get label => _label;
  set label(String label) {
    _textWidth = 0;
    _label = label;
  }

  // These getters should ideally be used inside dom_service schedule read.
  /// Returns offsetWidth of the host element .
  int get offsetWidth => nativeElement.offsetWidth;

  /// Returns offsetLeft of the host element .
  int get offsetLeft => nativeElement.offsetLeft;

  /// The width of the host element .
  String get width => nativeElement.style.width;
  set width(String width) => nativeElement.style.width = width;

  /// The width of the text without any constraints as if no width was set.
  int get textWidth => _textWidth;

  /// Updates the width of the label.
  ///
  /// Only if the label has changed.
  void updateTextWidth() {
    if (_textWidth == 0) {
      _textWidth = offsetWidth;
    }
  }

  /// Clear width if it's been set and the label has changed.
  ///
  /// This allows us to re-calculate an appropriate width and set it afterwards.
  void tryClearWidth() {
    if (_textWidth == 0 && !width.isEmpty) {
      width = '';
    }
  }
}
