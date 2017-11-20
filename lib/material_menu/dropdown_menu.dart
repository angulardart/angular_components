// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_menu/menu_popup.dart';
import 'package:angular_components/material_menu/menu_popup_wrapper.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// The [DropdownMenuComponent] combines a [DropdownButtonComponent] with a
/// [MenuPopup].
@Component(
  selector: 'dropdown-menu',
  directives: const [
    DropdownButtonComponent,
    MenuPopupComponent,
    PopupSourceDirective
  ],
  templateUrl: 'dropdown_menu.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class DropdownMenuComponent extends Object
    with MenuPopupWrapper
    implements OnDestroy {
  final _disposer = new Disposer.oneShot();

  DropdownMenuComponent(ChangeDetectorRef _changeDetector) {
    // Let Angular pick up changes to [isExpanded] in [MenuPopupWrapper] when
    // it's toggled programatically, e.g. TabMenuComponent.
    _disposer.addStreamSubscription(isExpandedChange.listen((_) {
      _changeDetector.markForCheck();
    }));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  /// Dropdown button text.
  @Input()
  String buttonText;

  @Input()
  bool disabled = false;

  bool get dropdownStyle => _dropdownStyle;
  bool _dropdownStyle = false;
}
