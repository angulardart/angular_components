// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Represents a menu item content affix.
abstract class MenuItemAffix {
  IconVisibility get visibility;

  bool get isVisibleOnHover => visibility == IconVisibility.hover;
  bool get isVisible => visibility != IconVisibility.hidden;

  bool get shouldCloseMenuOnTrigger;
  bool hasShortcutKeyCode(int keyCode);
  void triggerShortcutAction();

  String get cssClass;
}

typedef void IconAction();

/// An icon that performs an action when the icon is triggered.
class IconWithAction extends Icon {
  final IconAction action;
  final String ariaLabel;
  final int keyCode;

  /// If true, close the menu upon triggering the [action].
  final bool shouldCloseMenuOnTrigger;

  IconWithAction(String name, this.action, this.ariaLabel, this.keyCode,
      {this.shouldCloseMenuOnTrigger = false})
      : super(name);
}

/// Affix containing an icon.
class IconAffix extends MenuItemAffix {
  @override
  final IconVisibility visibility;

  final Icon icon;

  @override
  final String cssClass;

  IconAffix(
      {@required this.icon,
      this.visibility = IconVisibility.visible,
      this.cssClass});

  @override
  bool get shouldCloseMenuOnTrigger =>
      icon is IconWithAction &&
      (icon as IconWithAction).shouldCloseMenuOnTrigger;

  @override
  bool hasShortcutKeyCode(int keyCode) =>
      icon is IconWithAction && (icon as IconWithAction).keyCode == keyCode;

  @override
  void triggerShortcutAction() {
    if (icon is! IconWithAction) return;
    (icon as IconWithAction).action?.call();
  }
}

/// Affix containing text.
class CaptionAffix extends MenuItemAffix {
  @override
  final IconVisibility visibility;

  final String text;

  @override
  final String cssClass;

  CaptionAffix(
      {this.text, this.visibility = IconVisibility.visible, this.cssClass});

  @override
  bool get shouldCloseMenuOnTrigger => false;

  @override
  bool hasShortcutKeyCode(int keyCode) => false;

  @override
  void triggerShortcutAction() {}
}

/// Specifies the visibility state of an icon.
enum IconVisibility {
  hidden, // always hidden
  hover, // icon visible on mouse-hover
  visible // always visible
}
