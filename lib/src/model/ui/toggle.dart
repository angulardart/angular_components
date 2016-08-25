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

library ads.acx2.model.ui.toggle;

/// Has a binary state that may be toggled on or off.
///
/// An example is a checkbox (isChecked) or an expansion panel (isExpanded).
abstract class Toggleable {
  bool _isOn = false;
  bool get isOn => _isOn;
  set isOn(bool value) {
    _isOn = value;
  }

  void toggle() {
    isOn = !isOn;
  }
}

/// Controls a [Toggleable], typically a Component or Directive.
abstract class Toggler {
  set toggleable(Toggleable toggleable);
}