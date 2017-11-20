// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:observable/observable.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Delegate menu item class so other classes can implement the [MenuItem]
/// interface without implementing all the members.
class DelegatingMenuItem<SubMenuType> implements MenuItem<SubMenuType> {
  final MenuItem<SubMenuType> _delegate;

  DelegatingMenuItem(this._delegate);

  @override
  Function get action => _delegate.action;

  @override
  set action(Function action) {
    _delegate.action = action;
  }

  @override
  bool get enabled => _delegate.enabled;

  @override
  set enabled(bool enabled) {
    _delegate.enabled = enabled;
  }

  @override
  bool get hasIcon => _delegate.hasIcon;

  @override
  bool get hasSecondaryHoverIcon => _delegate.hasSecondaryHoverIcon;

  @override
  bool get hasSecondaryIcon => _delegate.hasSecondaryIcon;

  @override
  bool get hasSubMenu => _delegate.hasSubMenu;

  @override
  Icon get icon => _delegate.icon;

  @override
  ObservableList<MenuItemAffix> get itemSuffixes => _delegate.itemSuffixes;

  @override
  String get label => _delegate.label;

  @override
  Function get nullAwareActionHandler => _delegate.nullAwareActionHandler;

  @override
  Icon get secondaryIcon => _delegate.secondaryIcon;

  @override
  bool get showTooltip => _delegate.showTooltip;

  @override
  MenuModel<SubMenuType> get subMenu => _delegate.subMenu;

  @override
  String get tooltip => _delegate.tooltip;

  @override
  String get uiDisplayName => _delegate.uiDisplayName;

  @override
  Icon get uiHoverIcon => _delegate.uiHoverIcon;

  @override
  Icon get uiIcon => _delegate.uiIcon;

  @override
  BuiltList<String> get cssClasses => _delegate.cssClasses;
}
