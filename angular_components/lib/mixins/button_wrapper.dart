// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Properties for a component which wants to expose typical options for a
/// button: `buttonText`, `buttonAriaLabel`, `disabled`, `icon` and `raised`.
class MaterialButtonWrapper implements HasDisabled {
  /// Text on the button.
  @Input()
  String buttonText;

  /// Aria label for the button.
  @Input()
  String buttonAriaLabel;

  /// Whether the button is disabled.
  @Input()
  bool disabled = false;

  /// Icon to be used with the button. (Optional)
  @Input()
  Icon icon;

  /// Icon to use for the button.
  ///
  /// See [MaterialIconComponent] for possible values.
  @Input()
  String iconName;

  /// Whether the button is raised.
  @Input()
  bool raised = false;

  Icon _buttonIcon;
  Icon get buttonIcon {
    if (icon != null) return icon;
    if (_buttonIcon == null && (iconName != null && iconName.isNotEmpty)) {
      _buttonIcon = Icon(iconName);
    }
    return _buttonIcon;
  }
}
