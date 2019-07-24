// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:observable/observable.dart';
import 'package:quiver/core.dart' show Optional;
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

  /// The `role` attribute each menu item should apply.
  ///
  /// The `role` attribute is used for a11y purposes and should be the same for
  /// each menu item in a group. For selectable menu items the possible roles
  /// are `menuitemcheckbox` or `menuitemradio`.
  /// https://www.w3.org/TR/wai-aria-1.1/#menuitemradio
  /// https://www.w3.org/TR/wai-aria-1.1/#menuitemcheckbox
  @override
  final String itemsRole;

  /// If true, the current menu should be closed when this item is selected.
  final bool shouldCloseMenuOnSelection;

  MenuItemGroupWithSelection(
      {@required List<SelectableMenuItem<SelectionItemType>> items,
      @required this.selectionModel,
      String label,
      bool shouldCloseMenuOnSelection})
      : shouldCloseMenuOnSelection = shouldCloseMenuOnSelection ??
            selectionModel is! MultiSelectionModel,
        itemsRole = (selectionModel?.isSingleSelect ?? true)
            ? 'menuitemradio'
            : 'menuitemcheckbox',
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
  MenuAction _action;
  ActionWithContext _actionWithContext;
  SelectableOption _selectableState;
  String ariaChecked;

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
  final MenuModel subMenu;

  @override
  final String tooltip;

  @override
  final String labelAnnotation;

  @override
  final ObservableList<MenuItemAffix> itemSuffixes;

  @override
  final BuiltList<String> cssClasses;

  @override
  final String secondaryLabel;

  /// The constructor for a selectable [MenuItem].
  ///
  /// Selectable menu items can be managed with a [SelectionModel] from within
  /// [MenuItemGroupWithSelection]. Selected menu items are marked in the UI and
  /// can change the selection via user interactions.
  ///
  /// [itemSuffixes] - the list of suffixes rendered after the item content.
  ///
  /// [itemSuffix] - singular item suffix to be rendered after the item content;
  ///     convenient way to pass a single item suffix in rather than
  ///     constructing an ObservableList and using [itemSuffixes]. If
  ///     [itemSuffixes] is also passed in, [itemSuffixes] takes precedence.
  SelectableMenuItem(
      {@required this.value,
      this.itemRenderer = defaultItemRenderer,
      this.icon,
      this.subMenu,
      this.tooltip,
      this.secondaryLabel,
      this.labelAnnotation,
      Iterable<String> cssClasses,
      MenuAction action,
      ActionWithContext actionWithContext,
      SelectableOption selectableState = SelectableOption.Selectable,
      bool shouldSelectOnItemClick,
      MenuItemAffix itemSuffix,
      ObservableList<MenuItemAffix> itemSuffixes})
      : _selectableState = selectableState,
        shouldSelectOnItemClick = shouldSelectOnItemClick ?? subMenu == null,
        itemSuffixes = itemSuffixes ??
            ObservableList<MenuItemAffix>.from(
                Optional.fromNullable(itemSuffix)),
        cssClasses = BuiltList<String>(cssClasses ?? const []) {
    assert(itemSuffix == null || itemSuffixes == null,
        'Only one of itemSuffix or itemSuffixes should be provided');
    assert(action == null || actionWithContext == null,
        'Only one of action or actionWithContext should be provided');
    if (action != null) {
      _action = action;
      _actionWithContext = (_) => action();
    } else if (actionWithContext != null) {
      _action = () => actionWithContext(null);
      _actionWithContext = actionWithContext;
    } else {
      _action = _noOp;
      _actionWithContext = _noOp2;
    }
  }

  @override
  String get label => itemRenderer(value);

  @override
  String get ariaLabel => label;

  @override
  bool get hasIcon => icon != null;

  @override
  bool get hasSubMenu => subMenu != null;

  @override
  bool get showTooltip => isNotEmpty(tooltip);

  @override
  Icon get uiIcon => icon;

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
  MenuAction get action => _action;

  @override
  set action(MenuAction value) {
    if (value == _action) return;

    _action = value;
    _actionWithContext = (_) => value();
    notifyPropertyChange(#action, _action, value);
  }

  @override
  ActionWithContext get actionWithContext => _actionWithContext;

  @override
  set actionWithContext(ActionWithContext value) {
    if (value == _actionWithContext) return;

    _actionWithContext = value;
    _action = () => value(null);
    notifyPropertyChange(#actionWithContext, _actionWithContext, value);
  }

  @override
  bool get hasSecondaryLabel => secondaryLabel != null;

  /// Display state of this menu item.
  SelectableOption get selectableState => _selectableState;

  set selectableState(SelectableOption value) {
    if (value == _selectableState) return;

    _selectableState = value;
    notifyPropertyChange(#selectableState, _selectableState, value);
  }
}

void _noOp() {}
void _noOp2(_) {}
