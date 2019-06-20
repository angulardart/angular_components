// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/src/material_tree/material_tree_node.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/selection/selection_model.dart';

/// A variant of [MaterialTreeGroupComponent] without hierarchy or selection.
///
/// This exists primarily to allow graceful degrading in places where hierarchy
/// is *sometimes* used but sometimes not.
@Component(
  selector: 'material-tree-group-flat-list',
  directives: [DynamicComponent, NgFor, NgIf],
  templateUrl: 'material_tree_group_flat_list.html',
  styleUrls: ['material_tree_group_flat_list.scss.css'],
)
class MaterialTreeGroupFlatListComponent<T> extends MaterialTreeNode<T> {
  MaterialTreeGroupFlatListComponent(
      MaterialTreeRoot<T> root, ChangeDetectorRef changeDetector)
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
  directives: [
    ButtonDirective,
    DynamicComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    NgFor,
    NgIf
  ],
  templateUrl: 'material_tree_group_flat_radio.html',
  styleUrls: ['material_tree_group_flat_radio.scss.css'],
)
class MaterialTreeGroupFlatRadioComponent<T> extends MaterialTreeNode<T> {
  final DropdownHandle _dropdownHandle;

  /// Exposed for [MaterialRadioGroupComponent].
  final SelectionModel selectionModel;

  MaterialTreeGroupFlatRadioComponent(
      MaterialTreeRoot<T> root, ChangeDetectorRef changeDetector,
      [@Optional() this._dropdownHandle])
      : this.selectionModel = root.selection,
        super(root, changeDetector);

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;

  @override
  bool setSelectionState(option, bool state) {
    var retVal = super.setSelectionState(option, state);
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
  directives: [
    ButtonDirective,
    DynamicComponent,
    MaterialCheckboxComponent,
    NgFor,
    NgIf
  ],
  templateUrl: 'material_tree_group_flat_check.html',
  styleUrls: ['material_tree_group_flat_check.scss.css'],
)
class MaterialTreeGroupFlatCheckComponent<T> extends MaterialTreeNode<T> {
  final DropdownHandle _dropdownHandle;

  MaterialTreeGroupFlatCheckComponent(
      MaterialTreeRoot<T> root, ChangeDetectorRef changeDetector,
      [@Optional() this._dropdownHandle])
      : super(root, changeDetector);

  // This is only used to standardize all the different group components.
  @HostBinding('class.material-tree-group')
  final bool isMaterialTreeGroup = true;
}
