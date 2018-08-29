// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:observable/observable.dart';
import 'package:quiver/strings.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/model/ui/icon.dart';

/// A [MenuItemGroup] that contains a [SelectionModel].
///
/// When used in the MenuItemGroupsComponent, the component will allow both
/// single- and multi-select. A single-select group will have a left indicator,
/// while the multi-select group will have check marks.
class MenuItemGroupWithSelection<SelectionItemType>
    extends MenuItemGroup<SelectableMenuItem<SelectionItemType>>
    implements Selectable<SelectionItemType> {
  final SelectionModel<SelectionItemType> selectionModel;

  /// If true, the current menu should be closed when this item is selected.
  final bool shouldCloseMenuOnSelection;

  MenuItemGroupWithSelection(
      {@required List<SelectableMenuItem<SelectionItemType>> items,
      @required this.selectionModel,
      String label,
      bool shouldCloseMenuOnSelection})
      : shouldCloseMenuOnSelection = shouldCloseMenuOnSelection ??
            selectionModel is! MultiSelectionModel,
        super(items, label);

  /// True if the selection model is multi-select.
  ///
  /// If true, the menu group will use check marks to denote selected items,
  /// otherwise the menu group will use a single bar indicator to denote
  /// selection.
  bool get isMultiSelect => selectionModel is MultiSelectionModel;

  @override
  SelectableOption getSelectable(SelectionItemType item) {
    for (final menuItem in this) {
      if (menuItem.value == item) return menuItem.selectableState;
    }

    return SelectableOption.Selectable;
  }
}

/// A selectable [MenuItem].
class SelectableMenuItem<ItemType> extends PropertyChangeNotifier
    implements MenuItem {
  Function _action;
  IconVisibility _secondaryIconVisibility;
  SelectableOption _selectableState;

  /// Converts [ItemType] into a string.
  ///
  /// The output of the string is used as the label for the menu item.
  final ItemRenderer<ItemType> itemRenderer;

  /// Value of this item.
  ///
  /// This value is used for checking selection as well as for rendering the
  /// label.
  final ItemType value;

  /// If true, [value] is not selected when the menu item component is clicked.
  ///
  /// This is for menu items that have children. When a parent item is clicked,
  /// it should not be selected by default, unless that behavior is specifically
  /// required.
  final bool shouldSelectOnItemClick;

  @override
  final Icon icon;

  @override
  final Icon secondaryIcon;

  @override
  final MenuModel subMenu;

  @override
  final String tooltip;

  @override
  final ObservableList<MenuItemAffix> itemSuffixes;

  @override
  final BuiltList<String> cssClasses;

  SelectableMenuItem(
      {@required this.value,
      this.itemRenderer = defaultItemRenderer,
      this.icon,
      @Deprecated('Please use itemSuffixes instead') this.secondaryIcon,
      this.subMenu,
      this.tooltip,
      Iterable<String> cssClasses,
      Function action = _noOp,
      SelectableOption selectableState = SelectableOption.Selectable,
      bool shouldSelectOnItemClick,
      ObservableList<MenuItemAffix> itemSuffixes})
      : _action = action,
        _selectableState = selectableState,
        _secondaryIconVisibility = IconVisibility.visible,
        shouldSelectOnItemClick = shouldSelectOnItemClick ?? subMenu == null,
        itemSuffixes = itemSuffixes ?? ObservableList<MenuItemAffix>(),
        cssClasses = BuiltList<String>(cssClasses ?? const []) {
    if (secondaryIcon != null) {
      this.itemSuffixes.add(
          IconAffix(icon: secondaryIcon, visibility: _secondaryIconVisibility));
    }
  }

  @override
  String get label => itemRenderer(value);

  @override
  Function get nullAwareActionHandler => _action ?? _noOp;

  @override
  bool get hasIcon => icon != null;

  @override
  bool get hasSecondaryIcon => itemSuffixes.any((suffix) => suffix.isVisible);

  @override
  bool get hasSecondaryHoverIcon => uiHoverIcon != null;

  @override
  bool get hasSubMenu => subMenu != null;

  @override
  bool get showTooltip => isNotEmpty(tooltip);

  @override
  Icon get uiIcon => icon;

  @override
  Icon get uiHoverIcon {
    final suffix = itemSuffixes.firstWhere(
        (suffix) => suffix is IconAffix && suffix.isVisibleOnHover,
        orElse: () => null);
    return (suffix as IconAffix).icon;
  }

  @override
  String get uiDisplayName => label;

  @override
  bool get enabled => selectableState == SelectableOption.Selectable;

  @override
  set enabled(bool value) {
    selectableState =
        value ? SelectableOption.Selectable : SelectableOption.Disabled;
  }

  @override
  Function get action => _action;

  @override
  set action(Function value) {
    if (value == _action) return;

    _action = value;
    notifyPropertyChange(#action, _action, value);
  }

  /// Visibility state of the secondary icon.
  ///
  /// In a menu item, the secondary icon appears to the right of the text
  /// content.
  IconVisibility get secondaryIconVisibility => _secondaryIconVisibility;

  /// Display state of this menu item.
  SelectableOption get selectableState => _selectableState;

  set selectableState(SelectableOption value) {
    if (value == _selectableState) return;

    _selectableState = value;
    notifyPropertyChange(#selectableState, _selectableState, value);
  }
}

void _noOp() {}
