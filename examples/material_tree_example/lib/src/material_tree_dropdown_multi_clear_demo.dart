// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

@Component(
  selector: 'material-tree-dropdown-multi-clear-demo',
  directives: [MaterialButtonComponent, MaterialTreeDropdownComponent],
  template: r'''
      <h1>Multi selection dropdown with clear all option</h1>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong>
          {{multiSelection.selectedValues.length}} items
        </div>
      </div>
      <div class="shadow" style="width: 388px; margin: 24px; padding: 12px;">
        <material-tree-dropdown [options]="nestedOptions"
                                [selection]="multiSelection">
          <material-button post-header
                           raised
                           (trigger)="onClearAllButtonClicked()"
                           [disabled]="multiSelection.selectedValues.isEmpty">
            CLEAR ALL
          </material-button>
        </material-tree-dropdown>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeDropdownMultiClearDemoComponent {
  final SelectionOptions nestedOptions = data.nestedOptions;
  final SelectionModel multiSelection = SelectionModel.multi();

  void onClearAllButtonClicked() {
    multiSelection.clear();
  }
}
