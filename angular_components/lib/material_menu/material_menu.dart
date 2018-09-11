// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_menu/menu_popup.dart';
import 'package:angular_components/material_menu/menu_popup_wrapper.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// The Material Menu renders a menu based on a [MenuModel] object. This menu
/// comprises a `material-list` in a `material-popup` and a
/// `material-button` whose text or icon can be specified by the caller.
///
/// The menu expands when the button is clicked and closes when either an item
/// is selected or a region outside the dropdown is clicked.
@Component(
    selector: 'material-menu',
    directives: [
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialTooltipDirective,
      MenuPopupComponent,
      NgIf,
      PopupSourceDirective
    ],
    providers: [
      Provider(HasDisabled, useExisting: MaterialMenuComponent),
    ],
    templateUrl: 'material_menu.html',
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialMenuComponent extends Object
    with FocusableMixin, MenuPopupWrapper
    implements AfterViewInit, HasDisabled, OnDestroy {
  final _onTrigger = StreamController<void>();
  final _disposer = Disposer.oneShot();

  /// CSS classes to append onto the menu popup.
  ///
  /// These CSS classes will be copied into the popup overlay. The classes can
  /// be used to select DOM elements within the overlay when the popup is open.
  @Input()
  String popupClass;

  /// Trigger button text. Ignored if the [MenuModel] has an icon.
  @Input()
  String buttonText;

  /// If true, the material menu will be closed if the trigger button is clicked
  /// while the menu is open.
  ///
  /// Otherwise, clicking the trigger button when the menu is already open will
  /// not do anything.
  @Input()
  bool closeMenuOnClick = false;

  /// Whether the menu is disabled or not.
  @Input()
  bool disabled = false;

  /// Aria label for button trigger.
  @Input()
  String ariaLabel;

  /// Outputs an event when the menu button is triggered.
  @Output('trigger')
  Stream<void> get onTrigger => _onTrigger.stream;

  String get tooltipText => menu?.tooltipText;

  bool get hasTooltip => menu?.hasTooltip ?? false;

  bool get hasSubmenu => menu?.itemGroups?.isNotEmpty ?? false;

  String get hasIcon => menu?.uiIcon != null ? 'true' : null;

  void handleButtonClick() {
    isExpanded = closeMenuOnClick ? !isExpanded : true;
    _onTrigger.add(null);
  }

  MaterialButtonComponent _button;

  @ViewChild(MaterialButtonComponent)
  set button(MaterialButtonComponent b) {
    _button = b;
  }

  MenuPopupComponent _menuPopup;

  @ViewChild(MenuPopupComponent)
  set menuPopup(MenuPopupComponent m) {
    _menuPopup = m;
  }

  Focusable get _focusTarget =>
      disabled ? null : (isExpanded ? _menuPopup : _button);

  @override
  void ngAfterViewInit() {
    focusable = _focusTarget;
    // Other listeners which call focus() on isExpandedChange may have to await
    // an extra cycle before the focusable is updated.
    _disposer.addStreamSubscription(isExpandedChange.listen((_) {
      focusable = _focusTarget;
    }));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
