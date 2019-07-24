// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:observable/observable.dart';
import 'package:quiver/core.dart' show Optional;
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

  /// The `role` attribute that all items should have.
  ///
  /// The `role` attribute is used for a11y purposes and should be the same for
  /// each menu item in a group. If the menu items are not selectable the role
  /// should be `menuitem`. https://www.w3.org/TR/wai-aria-1.1/#menuitem
  final itemsRole = 'menuitem';

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
class MenuItem<T> with MenuItemMixin implements HasUIDisplayName, HasIcon {
  final String label;
  final String secondaryLabel;
  final String tooltip;
  final String ariaLabel;

  /// A superscript annotation that is shown to the right of the label.
  ///
  /// Note that this annotation cannot be one of the [itemSuffixes] because
  /// [itemSuffixes] are right aligned in the menu, while this should be left
  /// aligned close to the label.
  final String labelAnnotation;
  final MenuModel<T> subMenu;

  // This should be final as all the other state in this class, but needs
  // to first migrate clients.
  ActionWithContext _actionWithContext;

  /// Action to perform when user select an item in the menu.
  ActionWithContext get actionWithContext => _actionWithContext;
  @Deprecated('This should be final.')
  set actionWithContext(ActionWithContext value) {
    _actionWithContext = value;
    _action = () => value(null);
  }

  MenuAction _action;

  @Deprecated('Use actionWithContext')
  MenuAction get action => _action;
  set action(MenuAction value) {
    _action = value;
    _actionWithContext = (_) => value();
  }

  final Icon icon;

  /// List of rendered suffixes for this menu item.
  final ObservableList<MenuItemAffix> itemSuffixes;

  /// Additional CSS classes to be attached to the root menu item element.
  final BuiltList<String> cssClasses;

  bool enabled;

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
  ///
  /// [itemSuffix] - singular item suffix to be rendered after the item content;
  ///     convenient way to pass a single item suffix in rather than
  ///     constructing an ObservableList and using [itemSuffixes]. If
  ///     [itemSuffixes] is also passed in, [itemSuffixes] takes precedence.
  MenuItem(this.label,
      {this.enabled = true,
      this.tooltip,
      @Deprecated('Use ActionWithContext') MenuAction action,
      ActionWithContext actionWithContext,
      this.icon,
      this.labelAnnotation,
      Iterable<String> cssClasses,
      MenuItemAffix itemSuffix,
      ObservableList<MenuItemAffix> itemSuffixes,
      this.subMenu,
      this.secondaryLabel,
      String ariaLabel})
      : itemSuffixes = itemSuffixes ??
            ObservableList<MenuItemAffix>.from(
                Optional.fromNullable(itemSuffix)),
        cssClasses = BuiltList<String>(cssClasses ?? const []),
        ariaLabel = ariaLabel ?? label {
    assert(itemSuffix == null || itemSuffixes == null,
        'Only one of itemSuffix or itemSuffixes should be provided');
    assert(action == null || actionWithContext == null,
        'Only one of action or actionWithContext should be provided');
    if (action != null) {
      this.action = action;
    } else if (actionWithContext != null) {
      this.actionWithContext = actionWithContext;
    }
  }

  @override
  String toString() => {
        'label': label,
        'secondaryLabel': secondaryLabel,
        'labelAnnotation': labelAnnotation,
        'enabled': enabled,
        'icon': icon,
        'suffixes': itemSuffixes.map((affix) => '$affix').join(','),
      }.toString();
}

/// Required members to use [MenuItemMixin].
abstract class _MenuItemBase {
  ActionWithContext get actionWithContext;
  Icon get icon;
  String get label;
  String get secondaryLabel;
  String get tooltip;
  MenuModel get subMenu;
}

/// Action triggered by interaction with the menu.
typedef MenuAction = void Function();

/// Action triggered by interaction with the menu.
///
/// For web menus `context` should be the UIEvent.
typedef ActionWithContext = void Function(dynamic context);

/// Mixin to implement trivial getters on [MenuItem].
abstract class MenuItemMixin implements _MenuItemBase {
  bool get hasIcon => icon != null;

  String get uiDisplayName => label;

  Icon get uiIcon => icon;

  bool get hasSubMenu => subMenu != null;

  bool get hasSecondaryLabel => secondaryLabel != null;

  bool get showTooltip => isNotEmpty(tooltip);
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
