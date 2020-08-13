// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:quiver/core.dart' as qc show Optional;
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/focus_activable_item.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/highlighted_text/highlighted_text.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/material_menu/menu_item_affix_list.dart';
import 'package:angular_components/material_menu/menu_root.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/a11y/active_item_directive.dart';
import 'package:angular_components/model/action/delayed_action.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/menu/selectable_menu.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/highlighted_text_model.dart';
import 'package:angular_components/utils/disposer/disposer.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// Renders list of menu items.
@Component(
  selector: 'menu-item-groups',
  directives: [
    ActiveItemDirective,
    AutoFocusDirective,
    ButtonDirective,
    DeferredContentDirective,
    FocusActivableItemDirective,
    FocusableDirective,
    FocusTrapComponent,
    HighlightedTextComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialMenuComponent,
    MaterialPopupComponent,
    MenuItemAffixListComponent,
    MenuItemGroupsComponent,
    MaterialTooltipDirective,
    MaterialSelectItemComponent,
    HighlightedTextComponent,
    NgClass,
    NgFor,
    NgIf,
    PopupSourceDirective
  ],
  templateUrl: 'menu_item_groups.html',
  styleUrls: ['menu_item_groups.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MenuItemGroupsComponent
    implements AfterViewInit, Focusable, OnInit, OnDestroy {
  final IdGenerator _idGenerator;
  final ChangeDetectorRef _changeDetector;
  final _disposer = Disposer.oneShot();

  static const _menuDelay = Duration(milliseconds: 400);

  /// The menu to display.
  ///
  /// IMPORTANT: The menu model must be immutable. This component won't reflect
  /// any changes to the model's internal state
  @Input()
  set menu(MenuModel menu) {
    _menu = menu;
    _updateItemsAriaCheckedState(menu);
    menu?.itemGroups?.forEach(_listenForSelectionChanges);
  }

  MenuModel get menu => _menu;
  MenuModel _menu;

  @ViewChildren(FocusableActivateItem)
  List<FocusableActivateItem> focusableItems;

  List<RelativePosition> get preferredSubMenuPositions =>
      _preferredSubMenuPositions;

  List<RelativePosition> get tooltipPositions => _tooltipPositions;

  int get width => menu?.width ?? 0;

  /// Whether the popup should be closed on left key press.
  ///
  /// Defaults to `false`.
  @Input()
  set preventCloseOnPressLeft(bool value) {
    _closeOnPressLeft = !value;
  }

  bool _closeOnPressLeft = true;

  /// Whether the mouse is driving the selection.
  ///
  /// This is set to true when mouse moved and is reset to false when a keyboard
  /// event captured or roughly [_menuDelay] after the last mouse move event
  /// triggered.
  @HostBinding('class.mouse-driven')
  bool get isMouseDriven => _isMouseDriven;
  bool _isMouseDriven = false;

  @HostBinding('class.keyboard-driven')
  bool get isKeyboardDriven => !isMouseDriven;

  /// Optional model that is used to track keyboard active item.
  ActiveItemModel _activeModel;
  StreamSubscription _activeModelChange;

  @Input()
  set activeModel(ActiveItemModel v) {
    _activeModel = v;
    _activeModelChange?.cancel();
    _activeModelChange = v.modelChanged.listen((_) {
      _changeDetector.markForCheck();
    });
  }

  ActiveItemModel get activeModel => _activeModel;

  /// Whether the first item of the activeModel should be selected on init.
  ///
  /// Defaults to `false`.
  /// This input must be set before the view loads as it does one-time item
  /// activation on initialization.
  @Input()
  bool activateFirstItemOnInit = false;

  /// Whether the last item of the activeModel should be selected on init.
  ///
  /// Defaults to `false`.
  /// This input must be set before the view loads as it does one-time item
  /// activation on initialization.
  @Input()
  bool activateLastItemOnInit = false;

  /// The top most menu node.
  ///
  /// Used in order to close the whole hierarchy.
  final MenuRoot _menuRoot;

  /// The parent popup handle if any.
  DropdownHandle _dropdownHandle;

  /// The delayed action to open the [_hoveredItem] submenu on mouse hover.
  DelayedAction _subMenuOpener;

  /// The last hovered item of this menu.
  MenuItem _hoveredItem;

  /// The parent of current or future visible submenu.
  MenuItem _submenuParent;

  /// Stores the item ID of the item that is initially selected in this menu
  /// group.
  ///
  /// If absent, then no item should be focused initially. This is used when
  /// opening a sub-menu by keyboard shortcut, and the first menu item of the
  /// sub-menu should be selected.
  qc.Optional<String> _autoFocusItemId = const qc.Optional.absent();

  bool isKeyboardOpenedSubmenu = false;

  /// Fires when user selects an item in the menu.
  @Output()
  Stream<MenuItem> get selected => _selected.stream;
  final _selected = StreamController<MenuItem>.broadcast();

  /// Highlighter to use, need to be to be provided if [highlight] is used.
  @Input()
  TextHighlighter highlighter;

  /// Part of the string to highlight.
  @Input()
  set highlight(String value) {
    _highlight = value;
    _highlightCache = {};
  }

  String _highlight;

  /// CSS classes to append onto the sub-menu popups.
  ///
  /// These CSS classes will be copied into the sub-menu popup overlays.
  /// Typically this will be set by the [MaterialMenuComponent] on the popup
  /// this component is rendered in and need to be propagated down to any
  /// sub-menus this component will open.
  @Input()
  String popupClass;

  bool get hasHighlight => _highlight?.isNotEmpty ?? false;

  var _highlightCache = <String, List<HighlightedTextSegment>>{};

  factory MenuItemGroupsComponent(
          MenuRoot menuRoot,
          ChangeDetectorRef changeDetector,
          @Optional() DropdownHandle dropdownHandle,
          @Optional() IdGenerator idGenerator) =>
      MenuItemGroupsComponent._(dropdownHandle, menuRoot, changeDetector,
          idGenerator ?? SequentialIdGenerator.fromUUID());

  MenuItemGroupsComponent._(this._dropdownHandle, this._menuRoot,
      this._changeDetector, this._idGenerator) {
    this._subMenuOpener = DelayedAction(_menuDelay, _openSubMenuOnHover);
  }

  /// Returns list of highlighted segments for a given input, using provided
  /// highlighter.
  List<HighlightedTextSegment> highlighted(String input) {
    if (_highlightCache.containsKey(input)) return _highlightCache[input];
    return _highlightCache[input] = highlighter.highlight(input, [_highlight]);
  }

  @HostListener('mouseover')
  void onMouseOver(MouseEvent event) {
    // If not triggered by mouse movement, don't handle it. This can happen when
    // the DOM moved but mouse didn't.
    if (!_isMouseDriven) return;

    var item = _itemForTarget(event.target);
    if (item == null) return;

    // Hovering on items clear the selection.
    activeModel.activate(null);

    _hoveredItem = item;
    _subMenuOpener.start();
  }

  @HostListener('mouseout')
  void onMouseOut(MouseEvent event) {
    // If not triggered by mouse movement, don't handle it. This can happen when
    // the DOM moved but mouse didn't.
    if (!_isMouseDriven) return;

    MenuItem item = _itemForTarget(event.target);
    if (item == null) return;

    if (item == _hoveredItem) {
      _hoveredItem = null;
    }
    _subMenuOpener.cancel();
  }

  @HostListener('mousemove')
  void onMouseMove(MouseEvent _) {
    _isMouseDriven = true;
  }

  void onSubMenuItemSelected(MenuItem item) {
    _selected.add(item);
  }

  void select(MenuItem item, MenuItemGroup group) {
    item.action?.call();

    // Fire the event for activating the menu item. This does not mean the item
    // is selected, but merely that it was triggered (by mouse, keyboard, w/e).
    _selected.add(item);

    // If the item is in a multi-select group, keep the menu open so the user
    // can select multiple items.
    if (group is! MenuItemGroupWithSelection ||
        (group as MenuItemGroupWithSelection).shouldCloseMenuOnSelection) {
      _menuRoot?.closeHierarchy();
    }
  }

  @HostListener('keydown', [r'$event'])
  void handleKeydown(KeyboardEvent event, {bool shouldPreventDefault = true}) {
    _isMouseDriven = false;

    if (event.keyCode == KeyCode.TAB) return;

    var keyCode = event.keyCode;
    var activeMenuItem = activeModel.activeItem as MenuItem;

    switch (keyCode) {
      case KeyCode.UP:
        _activeHoveredItemIfNone();
        activeModel.activatePrevious();
        _focusActiveItem();
        break;
      case KeyCode.DOWN:
        _activeHoveredItemIfNone();
        activeModel.activateNext();
        _focusActiveItem();
        break;
      case KeyCode.RIGHT:
        if (activeMenuItem?.hasSubMenu == true) {
          _openSubMenu(activeModel.activeItem as MenuItem,
              isOpenedByKeyboard: true);
        }
        break;
      case KeyCode.LEFT:
        if (_closeOnPressLeft) {
          _dropdownHandle.close();
        }
        break;
      default:
        // Try triggering any affix shortcut actions. If successful, then
        // prevent browser default behaviour for this key down action.
        if (!_triggerAffixShortcutActions(activeMenuItem, keyCode)) {
          shouldPreventDefault = false;
        }
        break;
    }

    if (shouldPreventDefault) event.preventDefault();
  }

  /// Opens the submenu linked to the selected element if any.
  ///
  ///   - isOpenedByKeyboard: set this to true if this sub-menu is opened via
  ///         keyboard shortcut; if true, the first element of the sub-menu is
  ///         automatically selected upon opening
  void _openSubMenu(MenuItem item, {bool isOpenedByKeyboard = false}) {
    // Do not open or activate the sub-menu if the menu is disabled.
    if (!item.enabled) return;

    if (!activeModel.isActive(item)) {
      activeModel.activate(item);
    }
    isKeyboardOpenedSubmenu = isOpenedByKeyboard;
    _submenuParent = item.hasSubMenu ? item : null;
  }

  MenuItem _itemForTarget(EventTarget target) {
    if (target is! Element) return null;
    Element element = target as Element;
    while (element != null) {
      if (element.attributes['role'] == 'menuitem') {
        MenuItemGroup group =
            menu.itemGroups[int.parse(element.attributes['data-group-index'])];
        MenuItem item = group[int.parse(element.attributes['data-item-index'])];
        return item;
      }
      element = element.parent;
    }
    return null;
  }

  @HostListener('focus')
  void onFocus(FocusEvent event) {
    MenuItem item = _itemForTarget(event.target);
    if (item == null) return;

    activeModel?.activate(item);
  }

  /// Called when a material select item is triggered, whether through keypress
  /// or through click.
  void handleSelectItemTrigger(
      MenuItem item, MenuItemGroup group, UIEvent event) {
    if (item == null || !item.enabled) return;

    if (item.hasSubMenu) {
      _openSubMenu(item, isOpenedByKeyboard: event is KeyboardEvent);
    } else {
      select(item, group);
    }
  }

  void onSubMenuVisibilityChanged(MenuItem item, bool visible) {
    if (!visible && (item == _submenuParent)) {
      _submenuParent = null;
      if (_isMouseDriven) return;

      // Refocus the previous active item if any as long as the whole menu
      // isn't closing.
      if (_menuRoot.visible) {
        _focusActiveItem();
      }
    }
  }

  /// Toggle the expansion of the group if it's collapsible.
  void toggleExpansionIfCollapsible(MenuItemGroup group) {
    if (group.isCollapsible) {
      group.isExpanded = !group.isExpanded;
    }
  }

  @override
  void ngOnInit() {
    _createActiveMenuModelIfNone();
  }

  @override
  void ngAfterViewInit() {
    // Focusing the active item happens after the view initializes to wait for
    // the `focusableItems` view children to be set.
    if (activateFirstItemOnInit || activateLastItemOnInit) _focusActiveItem();
  }

  @override
  void ngOnDestroy() {
    _activeModelChange?.cancel();
    _activeModelChange = null;
    _disposer.dispose();
  }

  SelectionModel getSelectionModel(MenuItemGroup group) =>
      group is MenuItemGroupWithSelection ? group.selectionModel : null;

  /// Returns the value for a menu item's `aria-checked` attribute value.
  @visibleForTemplate
  String itemAriaChecked(MenuItem item) =>
      (item is SelectableMenuItem) ? item.ariaChecked : null;

  dynamic getItemValue(MenuItem item) =>
      item is SelectableMenuItem ? item.value : null;

  bool shouldSelectItemOnClick(MenuItem item) =>
      item is SelectableMenuItem && item.shouldSelectOnItemClick;

  bool isItemVisible(MenuItem item) => item is SelectableMenuItem
      ? item.selectableState != SelectableOption.Hidden
      : true;

  bool isItemActive(MenuItem item) => activeModel?.activeItem == item;

  /// Returns true if the current item with ID [itemId] should be auto-focused
  /// on menu open.
  bool hasAutoFocus(String itemId) =>
      _autoFocusItemId.transform((id) => id == itemId).or(false);

  /// Whether the subMenu of [item] is visible.
  bool isSubMenuVisible(MenuItem item) => item == _submenuParent;

  /// Activates [_hoveredItem] if there is no active item.
  void _activeHoveredItemIfNone() {
    if ((activeModel.activeItem == null) && (_hoveredItem != null)) {
      activeModel.activate(_hoveredItem);
    }
  }

  /// Triggers the affix shortcut actions that map to the [keyCode].
  ///
  /// Returns `true` if any of the affix shortcut actions are triggered. If
  /// multiple shortcut keys match the given [keyCode], then all matching
  /// shortcut actions are triggered.
  bool _triggerAffixShortcutActions(MenuItem item, int keyCode) {
    if (item == null || !item.enabled) return false;

    final matching = item.itemSuffixes
        .where((suffix) => suffix.hasShortcutKeyCode(keyCode))
        .toList();

    for (final suffix in matching) {
      suffix.triggerShortcutAction();
    }

    if (matching.any((suffix) => suffix.shouldCloseMenuOnTrigger)) {
      _menuRoot.closeHierarchy();
    }

    return matching.isNotEmpty;
  }

  void _createActiveMenuModelIfNone() {
    if ((menu != null) && (activeModel == null)) {
      activeModel = ActiveMenuItemModel(_idGenerator,
          menu: menu, filterOutUnselectableItems: true);
      if (activateLastItemOnInit) {
        activeModel.activateLast();
        _autoFocusActiveItem();
      } else if (activateFirstItemOnInit) {
        _autoFocusActiveItem();
      } else {
        // Don't activate any item.
        activeModel.activate(null);
      }
    }
  }

  void _autoFocusActiveItem() {
    // Set auto-focus to the currently selected list item if this menu is
    // a sub-menu and was opened via keyboard shortcut.
    if (activeModel.activeItem != null) {
      _autoFocusItemId = qc.Optional.of(activeModel.id(activeModel.activeItem));
    }
  }

  /// Focus the active item if any.
  ///
  /// The order of the displayed item must be in the same order as in the
  /// [activeModel].
  void _focusActiveItem() {
    if (activeModel.activeItem == null) return;

    for (var item in focusableItems) {
      if (item.key == activeModel.activeId) {
        item.focus();
        break;
      }
    }

    // If the group containing the active item is collapsed, expand it.
    for (final group in menu.itemGroups) {
      if (group.contains(activeModel.activeItem) && group.isCollapsible) {
        group.isExpanded = true;
        break;
      }
    }
  }

  bool _isSelected(SelectionModel selectionModel, MenuItem item) {
    final itemValue = getItemValue(item);
    return itemValue != null &&
        (selectionModel?.isSelected(itemValue) ?? false);
  }

  @override
  void focus() {
    _focusActiveItem();
  }

  void _openSubMenuOnHover() {
    _openSubMenu(_hoveredItem);
    _changeDetector.markForCheck();
  }

  void _listenForSelectionChanges(MenuItemGroup group) {
    if (group is MenuItemGroupWithSelection) {
      _disposer.addStreamSubscription(
          group.selectionModel?.selectionChanges?.listen((_) {
        _updateItemsAriaCheckedState(_menu);
      }));
    }
  }

  /// Updates the `aria-checked` value for each menu item.
  ///
  /// A menu item with role='menuitem' cannot have an `aria-checked` attribute.
  /// "When a menuitemcheckbox or menuitemradio is checked, aria-checked is set
  /// to true" - https://www.w3.org/TR/wai-aria-practices/#menu
  ///
  /// "The aria-checked attribute of a menuitemcheckbox indicates whether the
  /// menu item is checked (true), unchecked (false), or represents a sub-level
  /// menu of other menu items that have a mixture of checked and unchecked
  /// values (mixed)." - https://www.w3.org/TR/wai-aria-1.1/#menuitemcheckbox
  void _updateItemsAriaCheckedState(MenuModel menu) {
    if (menu?.itemGroups?.isEmpty ?? true) return;

    for (final group in menu.itemGroups) {
      if (group is MenuItemGroupWithSelection) {
        for (final item in group) {
          // Update the submenu's items first.
          if (item.hasSubMenu) {
            _updateItemsAriaCheckedState(item.subMenu);
          }

          final isSelected = _isSelected(group.selectionModel, item);

          if (!item.hasSubMenu) {
            item.ariaChecked = isSelected.toString();
          } else if (group.selectionModel.isSingleSelect) {
            item.ariaChecked =
                (isSelected || _anyChildrenSelected(group, item)).toString();
          } else {
            if (_anyChildrenSelected(group, item)) {
              item.ariaChecked =
                  _everyChildrenSelected(group, item) ? 'true' : 'mixed';
            } else {
              item.ariaChecked = isSelected.toString();
            }
          }
        }
      }
    }
  }

  /// Whether any children in an item's submenu are selected.
  bool _anyChildrenSelected(MenuItemGroup group, MenuItem item) =>
      item.subMenu.itemGroups.any((g) =>
          g is MenuItemGroupWithSelection &&
          g.any((i) => _isSelected(g.selectionModel, i)));

  /// Whether all children in an item's submenu are selected.
  bool _everyChildrenSelected(MenuItemGroup group, MenuItem item) =>
      item.subMenu.itemGroups.every((g) =>
          g is MenuItemGroupWithSelection &&
          g.every((i) => _isSelected(g.selectionModel, i)));
}

const _preferredSubMenuPositions = [
  RelativePosition.AdjacentRightTop,
  RelativePosition.AdjacentRight,
  RelativePosition.AdjacentRightBottom,
  RelativePosition.AdjacentLeftTop,
  RelativePosition.AdjacentLeft,
  RelativePosition.AdjacentLeftBottom,
];

const _tooltipPositions = [
  RelativePosition.AdjacentRight,
  RelativePosition.AdjacentLeft,
];
