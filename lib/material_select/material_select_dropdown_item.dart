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
import 'package:angular_components/model/a11y/active_item_directive.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// Container for a single item selected in a dropdown.
///
/// This should only be used in select dropdowns.
@Component(
  selector: 'material-select-dropdown-item',
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
)
class MaterialSelectDropdownItemComponent extends MaterialSelectItemComponent
    implements OnDestroy {
  @HostBinding('class')
  static const hostClass = 'item';

  // The qualified name is long because button_directive.dart uses hostTabIndex.
  @HostBinding('tabIndex')
  static const hostTabIndexForSelectDropdown = 0;

  final String _generatedId;

  String _id;

  /// The id of the element.
  @HostBinding('attr.id')
  String get id => _id ?? _generatedId;

  @Input()
  set id(String id) {
    _id = id;
  }

  MaterialSelectDropdownItemComponent(
      HtmlElement element,
      DomService domService,
      @Attribute('role') String role,
      @Optional() DropdownHandle dropdown,
      @Optional() ActivationHandler activationHandler,
      @Optional() IdGenerator idGenerator,
      @Optional() ActiveItemDirective activeItemDirective,
      ChangeDetectorRef cdRef)
      : _generatedId =
            (idGenerator ?? new SequentialIdGenerator.fromUUID()).nextId(),
        super(element, domService, dropdown, activationHandler,
            activeItemDirective, cdRef, role ?? 'option') {
    this.itemRenderer = defaultItemRenderer;
  }

  @HostBinding('attr.aria-selected')
  @override
  bool get isSelected => super.isSelected;

  @HostListener('mousedown')
  void preventTextSelectionIfShiftKey(MouseEvent e) {
    if (e.shiftKey) e.preventDefault();
  }
}
