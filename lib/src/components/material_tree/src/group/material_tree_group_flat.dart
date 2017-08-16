// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../../../model/selection/selection_model.dart';
import '../../../button_decorator/button_decorator.dart';
import '../../../dynamic_component/dynamic_component.dart';
import '../../../material_checkbox/material_checkbox.dart';
import '../../../material_radio/material_radio.dart';
import '../../../material_radio/material_radio_group.dart';
import '../../../mixins/material_dropdown_base.dart';
import '../material_tree_node.dart';
import '../material_tree_root.dart';

/// A variant of [MaterialTreeGroupComponent] without hierarchy or selection.
///
/// This exists primarily to allow graceful degrading in places where hierarchy
/// is *sometimes* used but sometimes not.
@Component(
    selector: 'material-tree-group-flat-list',
    directives: const [DynamicComponent, NgFor, NgIf],
    inputs: const ['group'],
    preserveWhitespace: false,
    templateUrl: 'material_tree_group_flat_list.html',
    styleUrls: const ['material_tree_group_flat_list.scss.css'])
class MaterialTreeGroupFlatListComponent extends MaterialTreeNode {
  MaterialTreeGroupFlatListComponent(
      MaterialTreeRoot root, ChangeDetectorRef changeDetector)
      : super(root, changeDetector);

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;
}

/// A variant of [MaterialTreeGroupComponent] without hierarchy or multi-select.
///
/// This exists primarily to allow graceful degrading in places where hierarchy
/// is *sometimes* used but sometimes not.
@Component(
    selector: 'material-tree-group-flat-radio',
    directives: const [
      ButtonDirective,
      DynamicComponent,
      MaterialRadioComponent,
      MaterialRadioGroupComponent,
      NgFor,
      NgIf
    ],
    inputs: const ['group'],
    preserveWhitespace: false,
    templateUrl: 'material_tree_group_flat_radio.html',
    styleUrls: const ['material_tree_group_flat_radio.scss.css'])
class MaterialTreeGroupFlatRadioComponent extends MaterialTreeNode {
  final DropdownHandle _dropdownHandle;

  /// Exposed for [MaterialRadioGroupComponent].
  final SelectionModel selectionModel;

  MaterialTreeGroupFlatRadioComponent(
      MaterialTreeRoot root, ChangeDetectorRef changeDetector,
      [@Optional() this._dropdownHandle])
      : this.selectionModel = root.selection,
        super(root, changeDetector);

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;

  @override
  bool toggleSelection(option) {
    var retVal = super.toggleSelection(option);
    _dropdownHandle?.close();
    return retVal;
  }
}

/// A variant of [MaterialTreeGroupComponent] without hierarchy.
///
/// This exists primarily to allow graceful degrading in places where hierarchy
/// is *sometimes* used but sometimes not.
@Component(
    selector: 'material-tree-group-flat-check',
    directives: const [
      ButtonDirective,
      DynamicComponent,
      MaterialCheckboxComponent,
      NgFor,
      NgIf
    ],
    inputs: const ['group'],
    preserveWhitespace: false,
    templateUrl: 'material_tree_group_flat_check.html',
    styleUrls: const ['material_tree_group_flat_check.scss.css'])
class MaterialTreeGroupFlatCheckComponent extends MaterialTreeNode {
  final DropdownHandle _dropdownHandle;

  MaterialTreeGroupFlatCheckComponent(
      MaterialTreeRoot root, ChangeDetectorRef changeDetector,
      [@Optional() this._dropdownHandle])
      : super(root, changeDetector);

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;
}
