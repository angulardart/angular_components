// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

@Component(
  selector: 'material-tree-nested-filter-in-dropdown-demo',
  directives: [MaterialTreeDropdownComponent],
  template: r'''
      <h1>Dropdown with filtering inside popup(nested)</h1>
      <div class="shadow" elevation="1" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong> {{singleSelection.selectedValues}}
        </div>
      </div>
      <div class="shadow" style="width: 388px; margin: 24px; padding: 12px;">
        <material-tree-dropdown
          [showFilterInsidePopup]="true"
          [options]="filterableNestedOptions"
          [selection]="singleSelection">
        </material-tree-dropdown>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeDropdownNestedFilterInPopupDemoComponent {
  final SelectionOptions filterableNestedOptions = data.filterableNestedOptions;
  final SelectionModel singleSelection = SelectionModel.single();

  @ViewChild(MaterialTreeDropdownComponent)
  MaterialTreeDropdownComponent materialTreeDropdownComponent;
}
