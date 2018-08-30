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
/// To use, simply pass in a minimum of [options] to see items.
///
/// If [SelectionOptions] implements the [Parent] interface, a handle is shown
/// for each option that [Parent.hasChildren] is set for, and toggling the
/// handle will create an additional tree from the results of
/// [Parent.childrenOf].
///
/// If [SelectionOptions] implements the [Filterable] interface.
///
/// To receive feedback from the component, a [selection] model is required.
///
/// To customize, specify an [itemRenderer] and/or [factoryRenderer].
@Component(
  selector: 'material-tree',
  directives: [
    MaterialTreeGroupComponent,
    MaterialTreeGroupFlatCheckComponent,
    MaterialTreeGroupFlatListComponent,
    MaterialTreeGroupFlatRadioComponent,
    NgFor,
    NgIf
  ],
  viewProviders: [
    Provider(MaterialTreeRoot, useExisting: MaterialTreeComponent)
  ],
  templateUrl: 'material_tree_impl.html',
)
class MaterialTreeComponent extends SelectionContainer with MaterialTreeRoot {
  /// Whether to hide check-marks in a single select dropdown
  @Input()
  @override
  bool optimizeForDropdown;

  final MaterialTreeRenderingOptions renderingOptions;

  MaterialTreeComponent(@Optional() @SkipSelf() MaterialTreeRoot parentTreeRoot,
      @Optional() @Self() this.renderingOptions)
      : optimizeForDropdown = parentTreeRoot?.optimizeForDropdown == true {
    selection = const SelectionModel.empty();
  }

  @Deprecated('Use [factoryRenderer] instead')
  @Input()
  @override
  set componentRenderer(ComponentRenderer value) {
    super.componentRenderer = value;
  }

  /// Specifies the factoryRenderer to use to determine the factory for
  /// rendering an item.
  @Input()
  @override
  set factoryRenderer(FactoryRenderer value) {
    super.factoryRenderer = value;
  }

  /// A simple function to render the item to string.
  @Input()
  @override
  set itemRenderer(ItemRenderer value) {
    super.itemRenderer = value;
  }

  /// The available options for this contianer.
  @Input()
  @override
  set options(SelectionOptions value) {
    super.options = value;
  }

  /// The selection model this container represents.
  @Input()
  @override
  set selection(SelectionModel value) {
    super.selection = value;
  }

  /// Whether to always expand an option group.
  @Input()
  bool expandAll = false;

  /// Whether the widgets supports the selection of non-leaf nodes
  ///
  /// When `false`, and the widget is using a single selection model clicking
  /// the widget should toggle expansion when a non-leaf node is clicked. When
  /// `true` the widget should select non-leaf nodes when clicked and only
  /// toggle expansion when the expansion icon is clicked.
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
  bool get showFlatList => selection == const SelectionModel.empty();

  /// Whether to show a flat list of items with single-selection.
  bool get showFlatRadio => !showFlatList && !showFlatCheck;

  /// The ARIA role to use for the host element.
  @HostBinding('attr.role')
  String get role {
    if (supportsHierarchy) {
      return "tree";
    } else if (showFlatCheck || showFlatRadio) {
      return "listbox";
    } else {
      return "list";
    }
  }

  @HostBinding('attr.aria-multiselectable')
  String get hostMultiselectable => '$showFlatCheck';

  @HostBinding('attr.aria-readonly')
  String get hostReadonly => '$showFlatList';
}
