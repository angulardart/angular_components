// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../model/ui/icon.dart';

/// Properties for a component which wants to expose typical options for a
/// button: `buttonText`, `buttonAriaLabel`, `disabled`, `icon` and `raised`.
class MaterialButtonWrapper {
  String buttonText;
  String buttonAriaLabel;
  bool disabled = false;
  Icon icon;
  String iconName;
  bool raised = false;

  Icon _buttonIcon;
  Icon get buttonIcon {
    if (icon != null) return icon;
    if (_buttonIcon == null && (iconName != null && !iconName.isEmpty)) {
      _buttonIcon = new Icon(iconName);
    }
    return _buttonIcon;
  }
}
