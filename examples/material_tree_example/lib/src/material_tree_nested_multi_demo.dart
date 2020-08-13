// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with nested options.
///
/// Options are selected and managed by [multiSelection].
@Component(
  selector: 'material-tree-nested-multi-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Nested with multi selection</h1>
      <pre>
  // See material_tree_nested_single_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptions;

  final SelectionModel multiSelection = new SelectionModel.multi();
      </pre>
      <pre>
  &lt;material-tree
    [options]="nestedOptions"
    [selection]="multiSelection"&gt;
  &lt;/material-tree&gt;
      </pre>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong>
          {{multiSelection.selectedValues.length}} items
        </div>
      </div>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree
          [options]="nestedOptions"
          [selection]="multiSelection"
          [allowParentMultiSelection]="allowParentMultiSelection">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
)
class MaterialTreeNestedMultiDemoComponent {
  final SelectionOptions nestedOptions = data.nestedOptions;
  final SelectionModel multiSelection = SelectionModel.multi();
  var allowParentMultiSelection = true;

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;
}
