// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Properties for a component which wants to expose typical options for a
/// button: `buttonText`, `buttonAriaLabel`, `disabled`, `icon` and `raised`.
// TODO(google): Add doc comments for inputs.
class MaterialButtonWrapper {
  @Input()
  String buttonText;
  @Input()
  String buttonAriaLabel;
  @Input()
  bool disabled = false;
  @Input()
  Icon icon;
  @Input()
  String iconName;
  @Input()
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
