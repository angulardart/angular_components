// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_menu/menu_root.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/mixins/track_layout_changes.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/observable/observable.dart';

import 'menu_item_groups.dart';

/// A fab menu item with optional sub menu.
@Component(
  selector: 'material-fab-menu',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    AutoFocusDirective,
    DeferredContentDirective,
    FocusTrapComponent,
    NgFor,
    NgIf,
    MaterialFabComponent,
    MaterialIconComponent,
    MaterialListItemComponent,
    MaterialPopupComponent,
    MaterialTooltipDirective,
    MenuItemGroupsComponent,
    MenuRootDirective,
    PopupSourceDirective,
  ],
  templateUrl: 'material_fab_menu.html',
  styleUrls: ['material_fab_menu.scss.css'],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MaterialFabMenuComponent extends Object
    with KeyboardHandlerMixin, TrackLayoutChangesMixin
    implements OnDestroy {
  final ChangeDetectorRef _changeDetector;
  bool _activateFirstItemOnInit = false;
  bool _activateLastItemOnInit = false;

  /// Popup positions for the menu popup to show up in.
  @Input()
  List<RelativePosition> preferredPopupPositions;

  StreamSubscription _viewModelStreamSub;

  MaterialFabMenuModel _viewModel;

  MaterialFabMenuComponent(this._changeDetector);

  /// Emits when fab is opened.
  @Output()
  Stream<void> get onShow => _onShow.stream;
  final _onShow = StreamController<void>.broadcast();

  /// [MenuItem] that defines the appearance and behavior of this menu.
  ///
  /// If the item has sub menu with no empty item groups, a menu will be
  /// surfaced via clicking or hovering.
  @Input()
  set menuItem(MenuItem menuItem) {
    if (menuItem == null) return;

    viewModel = MaterialFabMenuModel(menuItem, showPopup: showPopup);
  }

  /// Sets the view model for this component.
  @Input()
  set viewModel(MaterialFabMenuModel value) {
    if (value == null) return;

    _viewModel = value;
    _viewModelStreamSub?.cancel();
    _viewModelStreamSub = _viewModel.onShowPopupChange.listen((_) {
      _changeDetector.markForCheck();
    });
  }

  /// Id used internally.
  // TODO(google): See if we can remove this input now that we are open
  // sourced.
  @Input()
  String naviId;

  MenuItem get menuItem => _viewModel?.menuItem;

  bool get isFabEnabled => _viewModel?.isFabEnabled ?? false;

  String get glyph => _viewModel?.glyph;

  String get ariaLabel => _viewModel?.ariaLabel;

  String get tooltip => _viewModel?.tooltip;

  bool get hasTooltip => tooltip?.isNotEmpty ?? false;

  bool get hasMenu => _viewModel?.hasMenu ?? false;

  bool get isFabHidden => _viewModel?.isFabHidden ?? false;

  bool get showPopup => _viewModel?.showPopup ?? false;

  bool get closing => showPopup && !menuVisible;

  bool _menuVisible = false;

  bool get menuVisible => _menuVisible;

  bool get hasIcons => _viewModel.hasIcons;

  @visibleForTemplate
  bool get activateFirstItemOnInit => _activateFirstItemOnInit;

  @visibleForTemplate
  bool get activateLastItemOnInit => _activateLastItemOnInit;

  /// Keypress callback is used to handle UP and DOWN keys.
  @override
  void handleUpKey(KeyboardEvent event) {
    _trigger(activateLastItem: true);
  }

  @override
  void handleDownKey(KeyboardEvent event) {
    _trigger(activateFirstItem: true);
  }

  @override
  void ngOnDestroy() {
    _viewModelStreamSub?.cancel();
    _viewModelStreamSub = null;
    _onShow.close();
  }

  void onPopupOpened() {
    if (_menuVisible) return;
    _menuVisible = true;
    _onShow.add(null);
  }

  void onPopupClosed() {
    _viewModel.closePopup();
    _hideMenuContent();
  }

  void trigger(Event event) {
    _trigger(
        activateFirstItem:
            event is KeyboardEvent || _isLikelyScreenReader(event));
  }

  void hideMenu() {
    _hideMenuContent();
    Future.delayed(MaterialPopupComponent.SLIDE_DELAY, () {
      _viewModel.closePopup();
    });
  }

  void _trigger(
      {bool activateFirstItem = false, bool activateLastItem = false}) {
    _activateFirstItemOnInit = activateFirstItem;
    _activateLastItemOnInit = activateLastItem;
    _viewModel.trigger();
  }

  void _hideMenuContent() {
    if (!_menuVisible) return;
    _menuVisible = false;
  }

  /// Check to see if an event was likely triggered by a screen reader.
  ///
  /// Screen readers interact with an accessibility API which may trigger
  /// events. Even if the user hits `Enter` or `Space` on a button, the event
  /// that's dispatched may be a MouseEvent. This method tries to see if the
  /// mouse event was triggered by the accessibility api.
  bool _isLikelyScreenReader(Event event) {
    return event is MouseEvent && event.client.x == 0 && event.client.y == 0;
  }

  final tooltipPositions = const <RelativePosition>[
    RelativePosition.AdjacentRight,
    RelativePosition.AdjacentLeft,
  ];
}

/// View model for [MaterialFabMenu].
///
/// The primary use case of this view model is to expose an interface for a
/// parent component to change the visibility of the menu popup without using
/// a @ViewChild directive. This is due to popup visibility being dependent on
/// whether a sub-menu is actually available.
class MaterialFabMenuModel {
  /// Menu item model used to render the FAB and its sub-menus.
  final MenuItem menuItem;

  final ObservableReference<bool> _showPopup;

  MaterialFabMenuModel(this.menuItem, {bool showPopup = false})
      : _showPopup = ObservableReference<bool>(showPopup);

  Stream<Change<bool>> get onShowPopupChange => _showPopup.changes;

  /// True if the [menuItem] exists and has at least one item.
  bool get hasMenu => menuItem.subMenu?.itemGroups?.isNotEmpty ?? false;

  /// True if the FAB has a menu and at least one menu item has an icon.
  bool get hasIcons =>
      hasMenu &&
      menuItem.subMenu.itemGroups
          .any((itemGroup) => itemGroup.any((item) => item.hasIcon));

  /// True if the FAB menu should be shown.
  bool get showPopup => _showPopup.value;

  /// True if FAB is in an enabled state - can be clicked and triggered.
  bool get isFabEnabled => menuItem.enabled ?? false;

  /// Name of glyph displayed within FAB circle.
  String get glyph => menuItem.icon?.name;

  String get ariaLabel => menuItem.label;

  String get tooltip => menuItem.tooltip ?? menuItem.label;

  bool get isFabHidden => hasMenu ? _showPopup.value : false;

  /// If the FAB has a sub-menu, then open the sub-menu popup, otherwise only
  /// trigger the action callback on the FAB menu item model.
  void trigger() {
    if (hasMenu) {
      _showPopup.value = true;
    } else if (menuItem.action != null) {
      menuItem.action();
    }
  }

  /// Close the sub-menu, if it is open.
  void closePopup() {
    _showPopup.value = false;
  }
}
