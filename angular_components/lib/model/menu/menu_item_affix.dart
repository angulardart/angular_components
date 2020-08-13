// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/ui/icon.dart';

/// Represents a menu item content affix.
///
/// For new affix component models, please extend BaseMenuItemAffixModel for
/// proper type safety. Do not extend this class directly.
abstract class MenuItemAffix<FactoryType /* =ComponentFactory */ > {
  const MenuItemAffix();

  IconVisibility get visibility;

  bool get isVisibleOnHover => visibility == IconVisibility.hover;
  bool get isVisible => visibility != IconVisibility.hidden;

  // Due to VM tests not supporting Angular, we cannot directly specify
  // ComponentFactory here.
  FactoryType get componentFactory;

  /// If true, close the menu upon triggering the [action].
  bool get shouldCloseMenuOnTrigger;

  /// Returns true if the [keyCode] should trigger the shortcut action.
  bool hasShortcutKeyCode(int keyCode);
  void triggerShortcutAction();

  String get cssClass;
}

typedef IconAction = void Function();

/// An icon that performs an action when the icon is triggered.
@Deprecated('Use the IconAffix.withAction directly')
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

/// Specifies the visibility state of an icon.
enum IconVisibility {
  hidden, // always hidden
  hover, // icon visible on mouse-hover
  visible // always visible
}
