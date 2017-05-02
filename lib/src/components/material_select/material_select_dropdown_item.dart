// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../model/selection/selection_container.dart';
import '../../model/ui/has_renderer.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../dynamic_component/dynamic_component.dart';
import '../glyph/glyph.dart';
import '../mixins/material_dropdown_base.dart';
import './activation_handler.dart';
import './material_select_item.dart';

/// Container for a single item selected in a dropdown.
///
/// This should only be used in select dropdowns.
@Component(
    selector: 'material-select-dropdown-item',
    inputs: const [
      'active',
      'closeOnActivate',
      'componentRenderer',
      'disabled', // Is item disabled. Inherited from [ButtonDirective]
      'hideCheckbox',
      'itemRenderer',
      'selected',
      'selection',
      'value'
    ],
    outputs: const ['trigger'],
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
    directives: const [DynamicComponent, GlyphComponent, NgIf],
    templateUrl: 'material_select_dropdown_item.html')
class MaterialSelectDropdownItemComponent extends MaterialSelectItemComponent
    implements OnDestroy {
  MaterialSelectDropdownItemComponent(
      ElementRef element,
      DomService domService,
      @Optional() DropdownHandle dropdown,
      @Optional() ActivationHandler activationHandler)
      : super(element, domService, dropdown, activationHandler) {
    this.itemRenderer = defaultItemRenderer;
  }

  void preventTextSelectionIfShiftKey(MouseEvent e) {
    if (e.shiftKey) e.preventDefault();
  }
}
