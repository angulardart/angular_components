// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_menu/menu_root.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/mixins/track_layout_changes.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/observable/observable.dart';

import 'menu_item_groups.dart';

/// A fab menu item with optional sub menu.
@Component(
  selector: 'material-fab-menu',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    AutoFocusDirective,
    DeferredContentDirective,
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
  styleUrls: const ['material_fab_menu.scss.css'],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MaterialFabMenuComponent extends Object
    with TrackLayoutChangesMixin
    implements OnDestroy {
  final ChangeDetectorRef _changeDetector;

  @Input()
  List<RelativePosition> preferredPopupPositions;

  StreamSubscription _viewModelStreamSub;

  MaterialFabMenuModel _viewModel;

  MaterialFabMenuComponent(this._changeDetector);

  /// Emits when fab is opened.
  @Output()
  Stream<Null> get onShow => _onShow.stream;
  final _onShow = new StreamController<Null>.broadcast();

  /// [MenuItem] that defines the appearance and behavior of this menu.
  ///
  /// If the item has sub menu with no empty item groups, a menu will be
  /// surfaced via clicking or hovering.
  @Input()
  set menuItem(MenuItem menuItem) {
    if (menuItem == null) return;

    viewModel = new MaterialFabMenuModel(menuItem, showPopup: showPopup);
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

  @ViewChild('content')
  HtmlElement contentElementRef;

  @override
  void ngOnDestroy() {
    _viewModelStreamSub?.cancel();
    _viewModelStreamSub = null;
    _onShow.close();
  }

  void onPopupOpened() {
    if (_menuVisible || contentElementRef == null) return;
    // Set the content wrapper large enough so as not to cut off any menu
    // contents. Menu contents are measured via scrolling dimensions.
    var e = contentElementRef;
    var scrollWidth = e.scrollWidth;
    var scrollHeight = e.scrollHeight;
    e.style.width = '${scrollWidth}px';
    e.style.height = '${scrollHeight}px';
    _menuVisible = true;
    _onShow.add(null);
  }

  void onPopupClosed() {
    _viewModel.closePopup();
    _hideMenuContent();
  }

  void trigger() {
    _viewModel.trigger();
  }

  void hideMenu() {
    _hideMenuContent();
    new Future.delayed(MaterialPopupComponent.SLIDE_DELAY, () {
      _viewModel.closePopup();
    });
  }

  void _hideMenuContent() {
    if (!_menuVisible) return;
    _menuVisible = false;
    if (contentElementRef == null) return;
    var e = contentElementRef;
    e.style.removeProperty('width');
    e.style.removeProperty('height');
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

  MaterialFabMenuModel(this.menuItem, {bool showPopup: false})
      : _showPopup = new ObservableReference<bool>(showPopup);

  Stream<Change<bool>> get onShowPopupChange => _showPopup.changes;

  /// True if the [menuItem] exists and has at least one item.
  bool get hasMenu => menuItem.subMenu?.itemGroups?.isNotEmpty ?? false;

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
