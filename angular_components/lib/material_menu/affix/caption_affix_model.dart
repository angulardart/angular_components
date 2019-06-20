// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_menu/affix/base_affix.dart';
import 'package:angular_components/material_menu/affix/caption_affix.template.dart'
    as ng;
import 'package:angular_components/model/menu/menu_item_affix.dart';

/// Affix containing text.
class CaptionAffix extends BaseMenuItemAffixModel {
  @override
  final IconVisibility visibility;

  final String text;

  @override
  final String cssClass;

  @override
  ComponentFactory<BaseAffixComponent> get componentFactory =>
      ng.CaptionAffixComponentNgFactory;

  const CaptionAffix(
      {this.text, this.visibility = IconVisibility.visible, this.cssClass});

  const CaptionAffix.forShortcut(
      {String text, IconVisibility visibility = IconVisibility.visible})
      : this(text: text, visibility: visibility, cssClass: 'shortcut');

  @override
  bool get shouldCloseMenuOnTrigger => false;

  @override
  bool hasShortcutKeyCode(int keyCode) => false;

  @override
  void triggerShortcutAction() {}
}
