// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_select/activation_handler.dart';
import 'package:angular_components/material_select/handles_aria.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// Container for a single item selected in a dropdown.
///
/// This should only be used in select dropdowns.
@Component(
  selector: 'material-select-dropdown-item',
  providers: [
    ExistingProvider(SelectionItem, MaterialSelectDropdownItemComponent),
    ExistingProvider(HasRenderer, MaterialSelectDropdownItemComponent)
  ],
  styleUrls: ['material_select_dropdown_item.scss.css'],
  directives: [
    DynamicComponent,
    GlyphComponent,
    MaterialCheckboxComponent,
    NgIf
  ],
  templateUrl: 'material_select_item.html',
)
class MaterialSelectDropdownItemComponent<T>
    extends MaterialSelectItemComponent<T> implements OnDestroy {
  @HostBinding('class')
  static const hostClass = 'item';

  final String _generatedId;

  String _id;

  /// The id of the element.
  @HostBinding('attr.id')
  String get id => _customAriaHandling ? null : (_id ?? _generatedId);

  @Input()
  set id(String id) {
    _id = id;
  }

  bool _customAriaHandling = false;

  MaterialSelectDropdownItemComponent(
      HtmlElement element,
      @Attribute('role') String role,
      @Optional() DropdownHandle dropdown,
      @Optional() ActivationHandler activationHandler,
      @Optional() IdGenerator idGenerator,
      ChangeDetectorRef cdRef)
      : _generatedId =
            (idGenerator ?? SequentialIdGenerator.fromUUID()).nextId(),
        super(element, dropdown, activationHandler, cdRef, role ?? 'option') {
    this.itemRenderer = defaultItemRenderer;
  }

  @HostBinding('attr.aria-selected')
  @override
  bool get isSelected => super.isSelected;

  @HostListener('mousedown')
  void preventTextSelectionIfShiftKey(MouseEvent e) {
    if (e.shiftKey) e.preventDefault();
  }

  @override
  void onLoadCustomComponent(ComponentRef ref) {
    _customAriaHandling = ref?.instance is HandlesAria;
    if (_customAriaHandling) role = null;
  }
}
