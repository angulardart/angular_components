// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../../model/selection/select.dart';
import '../../../model/selection/selection_container.dart';
import '../../../model/selection/selection_model.dart';
import '../../../model/selection/selection_options.dart';
import './material_tree_root.dart';
import 'group/material_tree_group.dart';
import 'group/material_tree_group_flat.dart';

/// A material selection component that supports a tree of options.
///
/// To use, simply pass in a minimum of [options] to see items:
///     <material-tree [options]="selectionOptions"></material-tree>
///
/// If [SelectionOptions] implements the [Parent] interface, a handle is shown
/// for each option that [Parent.hasChildren] is set for, and toggling the
/// handle will create an additional tree from the results of
/// [Parent.childrenOf].
///
/// If [SelectionOptions] implements the [Filterable] interface.
///
/// To receive feedback from the component, a [selection] model is required.
///     <material-tree
///       [options]="selectionOptions"
///       [selection]="selectionModel">
///     </material-tree>
///
/// To customize, specify an [itemRenderer] and/or [componentRenderer].
///
/// You may add an HTML attribute 'in-dropdown' to optimize use in a dropdown;
/// for example, this will hide checks in a single selection since the selection
/// state is already known:
///     <material-tree
///       dropdown
///       [options]="selectionOptions"
///       [selection]="selectionModel">
///     </material-tree>
///
/// ACUX spec: https://aw-next-spec.googleplex.com/#/pickers
///
/// __NOTE__: First time users should consult the examples/ directory and g3doc.
@Component(
    selector: 'material-tree',
    directives: const [
      MaterialTreeGroupComponent,
      MaterialTreeGroupFlatCheckComponent,
      MaterialTreeGroupFlatListComponent,
      MaterialTreeGroupFlatRadioComponent,
      NgFor,
      NgIf
    ],
    host: const {
      '[attr.role]': 'role',
      // Unable to use interpolation for aria-multiselectable and aria-readonly
      // due to https://github.com/angular/angular/issues/3583
      '[attr.aria-multiselectable]': 'showFlatCheck ? "true" : "false"',
      '[attr.aria-readonly]': 'showFlatList ? "true" : "false"',
    },
    // Inherit setters in HasComponentRenderer and SelectionContainer.
    inputs: const ['componentRenderer', 'itemRenderer', 'options', 'selection'],
    viewProviders: const [
      const Provider(MaterialTreeRoot, useExisting: MaterialTreeComponent)
    ],
    preserveWhitespace: false,
    templateUrl: 'material_tree_impl.html')
class MaterialTreeComponent extends SelectionContainer with MaterialTreeRoot {
  @override
  final bool optimizeForDropdown;

  MaterialTreeComponent(@Optional() @SkipSelf() MaterialTreeRoot parentTreeRoot)
      : optimizeForDropdown = parentTreeRoot?.optimizeForDropdown == true {
    selection = const SelectionModel();
  }

  @Input('expandAll')
  bool expandAll = false;

  @ViewChildren(MaterialTreeGroupComponent)
  QueryList<MaterialTreeGroupComponent> treeGroupNodes;

  /// Collapses all expanded tree groups.
  ///
  /// Remember to set expandAll to false in your component. This will not
  /// override that behavior.
  void collapseAllTreeGroups() {
    for (var tree in treeGroupNodes) {
      tree.clearExpansions();
    }
  }

  /// Whether to show a flat list of items with multi-selection.
  bool get showFlatCheck => selection is MultiSelectionModel;

  /// Whether to show a flat list of items without any selection.
  bool get showFlatList => selection == const SelectionModel();

  /// Whether to show a flat list of items with single-selection.
  bool get showFlatRadio => !showFlatList && !showFlatCheck;

  /// The ARIA role to use for the host element.
  String get role {
    if (supportsHierarchy) {
      return "tree";
    } else if (showFlatCheck || showFlatRadio) {
      return "listbox";
    } else {
      return "list";
    }
  }
}
