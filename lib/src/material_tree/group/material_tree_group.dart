// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/src/material_tree/material_tree_node.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';

const materialTreeLeftPaddingToken = const OpaqueToken(
    'MaterialTreeGroupComponent_materialTreeLeftPaddingToken');

/// An internal component for rendering selection options.
///
/// It must be rendered as a child of a [MaterialTreeRoot] implementation.
///
/// __Example use__:
///     <material-tree-group [group]="group"></material-tree-group>
@Component(
    selector: 'material-tree-group',
    directives: const [
      ButtonDirective,
      DynamicComponent,
      MaterialIconComponent,
      KeyboardOnlyFocusIndicatorDirective,
      MaterialCheckboxComponent,
      MaterialTreeGroupComponent,
      NgFor,
      NgIf,
      NgClass
    ],
    host: const {'role': 'group'},
    templateUrl: 'material_tree_group.html',
    styleUrls: const ['material_tree_group.scss.css'])
class MaterialTreeGroupComponent extends MaterialTreeNode implements OnDestroy {
  static final defaultConstantLeftPadding = 24;
  static final baseGridStep = 8; // Based on $mat-grid
  static final rowIndentationStep =
      baseGridStep * 5; // DUPLICATION of _size.scss
  static final checkboxWidth = baseGridStep * 5; // DUPLICATION of _size.scss
  final DropdownHandle _dropdownHandle;
  @Input()
  int level = 0;
  @Input()
  bool parentHasCheckbox = false;
  final MaterialTreeRoot _root;

  /// The constant padding for every row.
  final String fixedPadding;

  MaterialTreeGroupComponent(
      this._root,
      ChangeDetectorRef changeDetector,
      [@Optional()
          this._dropdownHandle,
      @Optional()
      @Inject(materialTreeLeftPaddingToken)
          int constantLeftPadding])
      : fixedPadding = '${constantLeftPadding ?? defaultConstantLeftPadding}px',
        super(_root, changeDetector);

  @Input()
  @override
  set expandAll(bool value) {
    super.expandAll = value;
  }

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;

  bool showCheckbox(option) =>
      showSelectionState &&
      (isSelectable(option) || showDisabledCheckbox(option));

  // This returns the item identation based on it's level.
  // Level 0 means it's the higher parent in the hierarchy, and it gets
  // a constant definition.
  String getIndent(option) {
    int padding = 0;
    if (level > 0) {
      padding += (level - 1) * rowIndentationStep;
      if (!showCheckbox(option) || parentHasCheckbox) {
        padding += checkboxWidth;
      }
    }
    return '${padding}px';
  }

  void handleExpansion(Event e, Object option) {
    toggleExpansion(option);
    e.stopPropagation();
  }

  void handleSelectionOrExpansion(Event e, Object option) {
    if (!isExpandable(option) && isSelectable(option) ||
        (isMultiSelect && isSelectable(option))) {
      final previouslyToggledNode = _root.previouslyToggledNode;
      _root.previouslyToggledNode = option;

      setSelectionState(option, !isSelected(option));

      // Handle shift + select behavior for multi-selection.
      if (isMultiSelect &&
          previouslyToggledNode != null &&
          (e is MouseEvent && e.shiftKey)) {
        toggleSelectionRangeInclusive(
            previouslyToggledNode, option, isSelected(previouslyToggledNode));
      }

      // For single select, within a dropdown, close the dropdown on toggle.
      if (!isMultiSelect) {
        _dropdownHandle?.close();
      }
    } else {
      toggleExpansion(option);
    }
    e.stopPropagation();
  }

  @override
  ngOnDestroy() {
    onDestroy();
  }
}
