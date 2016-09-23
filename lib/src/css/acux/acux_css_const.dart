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

library angular2_components.css.shared.acux_css_const;

/// Global registry for z-index values used by various components.
/// A z-index creates a new stacking context and you can go back to using
/// low local and menu z-index values if they are contained in the correct
/// element.
/// Please update the related values in ../asset/const/_settings.scss
abstract class AcuxZIndexConsts {

  /// Send the element to the back.
  static const int minus1 = -1;

  /// Local z-index values: 1-9
  static const int local = 1;

  /// Menu z-index values: 10-49
  static const int menu = 10;

  /// Modal z-index values: 50-99
  static const int modal = 50;

  /// Sticky controller may use values from 100-110, as with animated rows,
  /// one row will be above of the other.
  static const int stickyController = 100;

  /// The tooltip's bubble.
  static const int tooltipBubble = 900;

  /// The layout tools will monotonically increment the zIndex for hoverable
  /// elements.
  static const int hoverableAutoIncrement = 1000;

  static const int particleRelativeElementsContainer = 999;
}