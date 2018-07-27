// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:observable/observable.dart';
import 'package:quiver/strings.dart' show isNotEmpty;
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/collection/combined_list.dart';
import 'package:angular_components/model/collection/labeled_list.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/model/ui/accepts_width.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

import 'menu_item_affix.dart';

export 'menu_item_affix.dart';

/// A list of menu items with an optional name.
class MenuItemGroup<T> extends LabeledList<T> {
  final ObservableReference<bool> _isCollapsible;
  final ObservableReference<bool> _isExpanded;
  final ObservableReference<bool> _hasSeparator;

  MenuItemGroup(List<T> items,
      [String label,
      bool hasSeparator = true,
      bool isCollapsible = false,
      bool isExpanded = true])
      : _hasSeparator = ObservableReference(hasSeparator),
        _isCollapsible = ObservableReference(isCollapsible),
        _isExpanded = ObservableReference(isExpanded),
        super.withLabel(List<T>.unmodifiable(items), label);

  /// True when this component explicitly specifies a separator.
  bool get hasSeparator => _hasSeparator.value;

  set hasSeparator(bool value) {
    _hasSeparator.value = value;
  }

  /// True when this component can be collapsed.
  bool get isCollapsible => _isCollapsible.value;

  set isCollapsible(bool value) {
    _isCollapsible.value = value;
  }

  /// Change stream of collapsible changes.
  Stream<bool> get onCollapsibleChange => _isCollapsible.stream;

  /// True when the component is collapsed.
  bool get isExpanded => _isExpanded.value;

  set isExpanded(bool value) {
    _isExpanded.value = value;
  }

  /// Change stream of the expansion state.
  Stream<bool> get onExpandedChange => _isExpanded.stream;
}

/// Represents a tree-based collection of menu items.
///
/// The items are organized into [MenuItemGroup] instances.
/// IMPORTANT: menu model is immutable, since menu component are OnPush.
class MenuModel<T> implements HasIcon, AcceptsWidth {
  /// The groups of menu items.
  /// IMPORTANT this is immutable.
  final List<MenuItemGroup<T>> itemGroups;

  /// Icon for the menu, can be displayed in the element opening the menu.
  final Icon icon;
  @override
  Icon get uiIcon => icon;
  bool get hasIcon => icon != null;

  /// Tooltip for the menu, can be shown in the element opening the menu.
  final String tooltipText;

  /// True if the menu has a tooltip.
  bool get hasTooltip => isNotEmpty(tooltipText);

  int _width;

  /// Creates a menu model with the given menu groups list.
  ///
  /// If [icon] is given, it will appear on the button that opens the menu.
  MenuModel(List<MenuItemGroup<T>> itemGroups,
      {this.icon, int width, this.tooltipText})
      : itemGroups = List<MenuItemGroup<T>>.unmodifiable(itemGroups) {
    this.width = width;
  }

  /// Creates a simple menu model that contains no sub-menus.
  MenuModel.flat(List<T> items, {this.icon, width, this.tooltipText})
      : itemGroups = [MenuItemGroup<T>(items)] {
    this.width = width;
  }

  /// Selects 1 of 5 predefined width values.
  ///
  /// See [AcceptsWidth.width] for more details. Null by default.
  int get width => _width;

  @override
  set width(val) {
    if (val == null) {
      _width = null;
    } else {
      _width = getInt(val);
      assert(_width >= 0 && _width <= 5);
    }
  }
}

/// A menu item.
///
/// [T] is the type of [MenuItem]s present in the subMenu.
/// Can be left off to allow any subtype, or set to [NullMenuItem] to make
/// sure there are not subMenus for a given level.
/// Immutable save for secondary icon visibility.
///
/// Add tooltip on menu item
///
/// Example code for creating a menu item with tooltip
///     new MenuItem(label, tooltip: tooltip,
///                  action:action, icon:icon, subMenu:subMenu);
class MenuItem<T> implements HasUIDisplayName, HasIcon, HasHoverIcon {
  final String label;
  final String tooltip;
  final MenuModel<T> subMenu;

  Function action;

  final Icon icon;
  @override
  Icon get uiIcon => icon;

  final Icon secondaryIcon;
  final ObservableReference<IconVisibility> _secondaryIconVisibility;

  /// List of rendered suffixes for this menu item.
  final ObservableList<MenuItemAffix> itemSuffixes;

  /// Additional CSS classes to be attached to the root menu item element.
  final BuiltList<String> cssClasses;

  @override
  Icon get uiHoverIcon => _secondaryIconVisibility.value == IconVisibility.hover
      ? secondaryIcon
      : null;

  void _noop() {}
  Function get nullAwareActionHandler => action != null ? action : _noop;

  @virtual
  bool enabled;
  bool get hasIcon => icon != null;
  bool get hasSecondaryIcon =>
      secondaryIcon != null &&
      _secondaryIconVisibility.value != IconVisibility.hidden;
  bool get hasSecondaryHoverIcon => uiHoverIcon != null;
  bool get hasSubMenu => subMenu != null;
  bool get showTooltip => isNotEmpty(tooltip);
  @override
  String get uiDisplayName => label;

  /// The constructor for a [MenuItem] which displays [label].
  ///
  /// By default this [MenuItem] is [enabled], otherwise it will be faded.
  /// If [tooltip] is passed, the text is shown when this item is hovered.
  /// If [action] is passed, it is called when the item is triggered.
  /// If [icon] is passed, it is shown to the left of the [label].
  /// If [secondaryIcon] is passed, it is shown to the right of [label];
  ///   its visibility is defined by [secondaryIconVisibility].
  /// If [subMenu] is passed, this item will display an arrow to the right of
  ///   [label], and when this item is triggered it will open [subMenu].
  /// If [itemSuffixes] is passed, the list of suffixes will be rendered after
  ///   the item content.
  MenuItem(
      this.label,
      {this.enabled = true,
      this.tooltip,
      this.action,
      this.icon,
      Iterable<String> cssClasses,
      @Deprecated('Please use itemSuffixes instead')
          this.secondaryIcon,
      ObservableList<MenuItemAffix> itemSuffixes,
      @Deprecated('Please use itemSuffixes instead')
          ObservableReference<IconVisibility> secondaryIconVisibility,
      this.subMenu})
      : _secondaryIconVisibility = secondaryIconVisibility ??
            ObservableReference<IconVisibility>(IconVisibility.visible),
        itemSuffixes = itemSuffixes ?? ObservableList<MenuItemAffix>(),
        cssClasses = BuiltList<String>(cssClasses ?? const []) {
    if (secondaryIcon != null) {
      this.itemSuffixes.add(IconAffix(
          icon: secondaryIcon, visibility: _secondaryIconVisibility.value));
    }
  }

  @override
  String toString() => {
        'label': label,
        'enabled': enabled,
        'icon': icon,
        'secondaryIcon': secondaryIcon,
        'secondaryIconVisibility': _secondaryIconVisibility.value
      }.toString();
}

/// Type that can be specified to mark that there can be no subMenus for
/// a given [MenuItem].
abstract class NullMenuItem extends MenuItem<NullMenuItem> {
  factory NullMenuItem() {
    throw UnsupportedError('Should be never instantiatied');
  }
}

/// Subclass of [ActiveItemModel] which converts a [MenuModel] instance into a
/// list of [MenuItem] instances for use in the active list item management.
class ActiveMenuItemModel<T> extends ActiveItemModel<T> {
  /// If true, any menu items that are not enabled are filtered out of this
  /// active item model.
  ///
  /// This means the active item model will skip over any non-enabled items.
  final bool _filterOutUnselectableItems;

  ActiveMenuItemModel(IdGenerator idGenerator,
      {MenuModel<T> menu, bool filterOutUnselectableItems = false})
      : _filterOutUnselectableItems = filterOutUnselectableItems,
        super(idGenerator,
            items: _createEnabledItemGroupList(
                menu?.itemGroups, filterOutUnselectableItems),
            loop: true);

  set menu(MenuModel<T> menu) {
    super.items = _createEnabledItemGroupList(
        menu?.itemGroups, _filterOutUnselectableItems);
  }

  @override
  set items(_) {
    throw UnsupportedError('ActiveMenuItemModel items can only be updated'
        'by setting #menu');
  }

  static CombinedList<T> _createEnabledItemGroupList<T>(
      List<List<T>> menuGroups, bool filterOutUnselectableItems) {
    if (menuGroups == null) return CombinedList<T>([]);

    if (!filterOutUnselectableItems) return CombinedList<T>(menuGroups);

    return CombinedList<T>(menuGroups
        .map((group) => group
            .where((item) => item is MenuItem ? item.enabled : true)
            .toList())
        .toList());
  }
}
