// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_menu/menu_popup.dart';
import 'package:angular_components/material_menu/menu_popup_wrapper.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';
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
  providers: [
    Provider(HasDisabled, useExisting: DropdownMenuComponent),
  ],
  templateUrl: 'dropdown_menu.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class DropdownMenuComponent extends Object
    with FocusableMixin, MenuPopupWrapper
    implements AfterViewInit, HasDisabled, OnDestroy {
  final _disposer = Disposer.oneShot();

  DropdownMenuComponent(ChangeDetectorRef _changeDetector) {
    // Let Angular pick up changes to [isExpanded] in [MenuPopupWrapper] when
    // it's toggled programatically, e.g. TabMenuComponent.
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

  bool get dropdownStyle => _dropdownStyle;
  bool _dropdownStyle = false;

  @ViewChild(DropdownButtonComponent)
  DropdownButtonComponent dropdownButton;

  @ViewChild(MenuPopupComponent)
  MenuPopupComponent menuPopup;

  Focusable get _focusTarget =>
      disabled ? null : (isExpanded ? menuPopup : dropdownButton);
}
