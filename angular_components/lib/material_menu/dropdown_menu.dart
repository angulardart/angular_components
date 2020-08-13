// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_menu/menu_popup.dart';
import 'package:angular_components/material_menu/menu_popup_wrapper.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/utils/angular/css/css.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// The [DropdownMenuComponent] combines a [DropdownButtonComponent] with a
/// [MenuPopup].
@Component(
  selector: 'dropdown-menu',
  directives: [
    DropdownButtonComponent,
    MenuPopupComponent,
    PopupSourceDirective
  ],
  providers: [ExistingProvider(HasDisabled, DropdownMenuComponent)],
  templateUrl: 'dropdown_menu.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class DropdownMenuComponent extends Object
    with
        FocusableMixin,
        KeyboardHandlerMixin,
        MenuPopupWrapper,
        MenuPopupTrigger
    implements AfterViewInit, HasDisabled, OnDestroy {
  final HtmlElement _root;
  final _disposer = Disposer.oneShot();

  DropdownMenuComponent(ChangeDetectorRef _changeDetector, this._root) {
    // Let Angular pick up changes to [isExpanded] in [MenuPopupWrapper] when
    // it's toggled programmatically, e.g. TabMenuComponent.
    _disposer.addStreamSubscription(isExpandedChange.listen((_) {
      focusable = _focusTarget;
      _changeDetector.markForCheck();
    }));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  @override
  void ngAfterViewInit() {
    focusable = _focusTarget;
  }

  /// Dropdown button text.
  @Input()
  String buttonText;

  bool _disabled = false;

  bool get disabled => _disabled;

  @Input()
  set disabled(bool d) {
    _disabled = d;
    focusable = _focusTarget;
  }

  /// The id of an element that describes the button for the drop down.
  @Input()
  String buttonAriaLabelledBy;

  /// One or more space-delimited ids of elements that provide additional
  /// description for the button for the drop down.
  @Input()
  String buttonAriaDescribedBy;

  /// Whether the menu is tabbable or not.
  @Input()
  bool tabbable = true;

  String _popupClass;
  String get popupClass => _popupClass;

  /// CSS classes to append onto the menu popup.
  ///
  /// These CSS classes will be copied into the popup overlay. The classes can
  /// be used to select DOM elements within the overlay when the popup is open.
  @Input()
  set popupClass(String className) {
    _popupClass = constructEncapsulatedCss(className, _root.classes);
  }

  bool get dropdownStyle => _dropdownStyle;
  final bool _dropdownStyle = false;

  @ViewChild(DropdownButtonComponent)
  DropdownButtonComponent dropdownButton;

  @ViewChild(MenuPopupComponent)
  MenuPopupComponent menuPopup;

  Focusable get _focusTarget =>
      disabled ? null : (isExpanded ? menuPopup : dropdownButton);
}
