// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/src/material_tree/group/material_tree_group.dart';
import 'package:angular_components/src/material_tree/group/material_tree_group_flat.dart';
import 'package:angular_components/src/material_tree/material_tree_rendering_options.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';

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
  viewProviders: const [
    const Provider(MaterialTreeRoot, useExisting: MaterialTreeComponent)
  ],
  templateUrl: 'material_tree_impl.html',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialTreeComponent extends SelectionContainer with MaterialTreeRoot {
  @Input()
  @override
  bool optimizeForDropdown;

  final MaterialTreeRenderingOptions renderingOptions;

  MaterialTreeComponent(@Optional() @SkipSelf() MaterialTreeRoot parentTreeRoot,
      @Optional() @Self() this.renderingOptions)
      : optimizeForDropdown = parentTreeRoot?.optimizeForDropdown == true {
    selection = const SelectionModel();
  }

  @Input()
  @override
  set componentRenderer(ComponentRenderer value) {
    super.componentRenderer = value;
  }

  @Input()
  @override
  set factoryRenderer(FactoryRenderer value) {
    super.factoryRenderer = value;
  }

  @Input()
  @override
  set itemRenderer(ItemRenderer value) {
    super.itemRenderer = value;
  }

  @Input()
  @override
  set options(SelectionOptions value) {
    super.options = value;
  }

  @Input()
  @override
  set selection(SelectionModel value) {
    super.selection = value;
  }

  @Input()
  bool expandAll = false;

  @Input()
  @override
  bool allowParentSingleSelection = false;

  /// Whether to expand a given option group.
  ///
  /// When [expandAll] is true, always expand an option group, otherwise
  /// [renderingOptions] can decide whether to expand an option group.
  bool shouldExpand(OptionGroup group, int index) {
    if (renderingOptions == null) return expandAll;

    return expandAll || renderingOptions.shouldExpand(group, index);
  }

  /// How many items to show initially under a given option group.
  ///
  /// Returns null when there's no limit, otherwise show the returned number of
  /// items initially and hides the rest behind a "View more" link.
  int maxInitialOptionsShown(OptionGroup group, int index) {
    if (renderingOptions == null) return null;

    return renderingOptions.maxInitialOptionsShown(group, index);
  }

  @ViewChildren(MaterialTreeGroupComponent)
  List<MaterialTreeGroupComponent> treeGroupNodes;

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
