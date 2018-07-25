// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
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
import 'package:angular_components/utils/angular/properties/properties.dart';
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
class MenuItemGroupsComponent implements Focusable, OnInit, OnDestroy {
  final IdGenerator _idGenerator;
  final ChangeDetectorRef _changeDetector;

  static const _menuDelay = Duration(milliseconds: 400);

  /// The menu to display.
  ///
  /// IMPORTANT: The menu model must be immutable. This component won't reflect
  /// any changes to the model's internal state
  @Input()
  MenuModel menu;

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
  set preventCloseOnPressLeft(value) {
    _closeOnPressLeft = !getBool(value);
  }

  bool _closeOnPressLeft = true;

  /// Whether the mouse is driving the selection.
  bool get isMouseDriven => _isMouseDriven;
  bool _isMouseDriven = false;

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
  @Input()
  set activateFirstItemOnInit(activate) {
    _activateFirstItemOnInit = getBool(activate);
  }

  bool _activateFirstItemOnInit = false;

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
    _isMouseDriven = true;

    var item = _itemForTarget(event.target);
    if (item == null) return;

    // Hovering on items clear the selection.
    activeModel.activate(null);

    _hoveredItem = item;
    _subMenuOpener.start();
  }

  @HostListener('mouseout')
  void onMouseOut(MouseEvent event) {
    _isMouseDriven = false;

    MenuItem item = _itemForTarget(event.target);
    if (item == null) return;

    if (item == _hoveredItem) {
      _hoveredItem = null;
    }
    _subMenuOpener.cancel();
  }

  void onSubMenuItemSelected(MenuItem item) {
    _selected.add(item);
  }

  void select(MenuItem item, MenuItemGroup group) {
    item.nullAwareActionHandler();

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
      case KeyCode.ESC:
        _dropdownHandle.close();
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

      // Refocus the previous active item if any
      _focusActiveItem();
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
  void ngOnDestroy() {
    _activeModelChange?.cancel();
    _activeModelChange = null;
  }

  SelectionModel getSelectionModel(MenuItemGroup group) =>
      group is MenuItemGroupWithSelection ? group.selectionModel : null;

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

    for (final suffix in matching) suffix.triggerShortcutAction();

    if (matching.any((suffix) => suffix.shouldCloseMenuOnTrigger)) {
      _menuRoot.closeHierarchy();
    }

    return matching.isNotEmpty;
  }

  void _createActiveMenuModelIfNone() {
    if ((menu != null) && (activeModel == null)) {
      activeModel = ActiveMenuItemModel(_idGenerator,
          menu: menu, filterOutUnselectableItems: true);
      if (_activateFirstItemOnInit) {
        // Set auto-focus to the currently selected list item if this menu is
        // a sub-menu and was opened via keyboard shortcut.
        _autoFocusItemId =
            qc.Optional.of(activeModel.id(activeModel.activeItem));
      } else {
        // Don't activate any item.
        activeModel.activate(null);
      }
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
  }

  @override
  void focus() {
    _focusActiveItem();
  }

  void _openSubMenuOnHover() {
    _openSubMenu(_hoveredItem);
    _changeDetector.markForCheck();
  }
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
