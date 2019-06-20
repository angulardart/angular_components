// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/material_menu/affix/base_affix.dart';
import 'package:angular_components/material_menu/affix/icon_affix.template.dart'
    as ng;
import 'package:angular_components/model/menu/menu_item_affix.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Affix containing an icon.
class IconAffix extends BaseMenuItemAffixModel {
  @override
  final IconVisibility visibility;

  final Icon icon;

  @override
  final String cssClass;

  final String ariaLabel;
  final IconAction _action;
  final int _keyCode;

  @override
  final bool shouldCloseMenuOnTrigger;

  @Deprecated('Use IconAffix.simple and IconAffix.withAction instead')
  factory IconAffix(
      {@required Icon icon,
      IconVisibility visibility = IconVisibility.visible,
      String cssClass}) {
    if (icon is IconWithAction) {
      return IconAffix.withAction(
          icon: icon,
          action: icon.action,
          ariaLabel: icon.ariaLabel,
          shouldCloseMenuOnTrigger: icon.shouldCloseMenuOnTrigger,
          visibility: visibility,
          cssClass: cssClass);
    }

    return IconAffix.simple(
        icon: icon, visibility: visibility, cssClass: cssClass);
  }

  /// Creates a simple icon without any trigger action.
  const IconAffix.simple(
      {@required this.icon,
      this.visibility = IconVisibility.visible,
      this.cssClass})
      : _action = null,
        ariaLabel = null,
        _keyCode = null,
        shouldCloseMenuOnTrigger = false;

  /// Creates an icon that has a trigger action with a shortcut key.
  const IconAffix.withAction(
      {@required this.icon,
      @required IconAction action,
      @required this.ariaLabel,
      int keyCode,
      this.shouldCloseMenuOnTrigger = false,
      this.visibility = IconVisibility.visible,
      this.cssClass})
      : _action = action,
        _keyCode = keyCode;

  @override
  ComponentFactory<BaseAffixComponent> get componentFactory =>
      ng.IconAffixComponentNgFactory;

  bool get hasAction => _action != null;

  @override
  bool hasShortcutKeyCode(int keyCode) => _keyCode == keyCode;

  @override
  void triggerShortcutAction() {
    _action?.call();
  }
}
