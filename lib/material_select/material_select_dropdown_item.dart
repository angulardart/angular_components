// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_select/activation_handler.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// Container for a single item selected in a dropdown.
///
/// This should only be used in select dropdowns.
@Component(
  selector: 'material-select-dropdown-item',
  host: const {
    'class': 'item',
    '[class.disabled]': 'disabled',
    '[class.active]': 'active',
    '[class.selected]': 'isSelected',
    '[class.multiselect]': 'supportsMultiSelect',
    '(click)': r'handleClick($event)',
    '(keypress)': r'handleKeyPress($event)',
    '(mousedown)': r'preventTextSelectionIfShiftKey($event)',
    '(mouseenter)': 'onMouseEnter()',
    '(mouseleave)': 'onMouseLeave()',
    '[attr.aria-disabled]': 'disabledStr',
    'tabindex': '0',
    'role': 'button'
  },
  providers: const [
    const Provider(SelectionItem,
        useExisting: MaterialSelectDropdownItemComponent),
    const Provider(HasRenderer,
        useExisting: MaterialSelectDropdownItemComponent)
  ],
  styleUrls: const ['material_select_dropdown_item.scss.css'],
  directives: const [
    DynamicComponent,
    GlyphComponent,
    MaterialCheckboxComponent,
    NgIf
  ],
  templateUrl: 'material_select_item.html',
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MaterialSelectDropdownItemComponent extends MaterialSelectItemComponent
    implements OnDestroy {
  MaterialSelectDropdownItemComponent(
      HtmlElement element,
      DomService domService,
      @Optional() DropdownHandle dropdown,
      @Optional() ActivationHandler activationHandler,
      ChangeDetectorRef cdRef)
      : super(element, domService, dropdown, activationHandler, cdRef) {
    this.itemRenderer = defaultItemRenderer;
  }

  void preventTextSelectionIfShiftKey(MouseEvent e) {
    if (e.shiftKey) e.preventDefault();
  }
}
