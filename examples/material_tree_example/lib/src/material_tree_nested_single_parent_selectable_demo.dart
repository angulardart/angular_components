// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with nested options and
/// parent selectable.
///
/// Options are selected and managed by [singleSelection].
@Component(
  selector: 'material-tree-nested-single-parent-selectable-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Nested with single selection and parents selectable</h1>
      <pre>
  // See material_tree_nested_single_parent_selectable_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptions;

  final SelectionModel singleSelection = new SelectionModel.single();
      </pre>
      <pre>
  &lt;material-tree
    [options]="nestedOptions"
    [selection]="singleSelection"
    [allowParentSingleSelection]="true"&gt;
  &lt;/material-tree&gt;
      </pre>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong> {{singleSelection.selectedValues}}
        </div>
      </div>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree
          [options]="nestedOptions"
          [expandAll]="expandAll"
          [selection]="singleSelection"
          [allowParentSingleSelection]="true">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeNestedSingleParentSelectableDemoComponent {
  final SelectionOptions nestedOptions = data.nestedOptions;
  final SelectionModel singleSelection = SelectionModel.single();
  final ChangeDetectorRef _changeDetector;

  MaterialTreeNestedSingleParentSelectableDemoComponent(this._changeDetector);

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;

  bool _expandAll = false;
  bool get expandAll => _expandAll;
  set expandAll(bool value) {
    _expandAll = value;
    _changeDetector.markForCheck();
  }
}
