// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
