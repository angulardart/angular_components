// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_renderer.dart';

/// An example that renders a [MaterialTreeComponent] with nested options.
///
/// Options are selected and managed by [multiSelection].
@Component(
  selector: 'material-tree-nested-expand-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Nested with multi selection preserving expansion state</h1>
      <pre>
  // See material_tree_nested_multi_demo.dart
  final SelectionOptions nestedOptions = data.expandStateOptions;

  final SelectionModel multiSelection = new SelectionModel.multi();
  final ItemRenderer&lt;data.CategoryTargetNode&gt; nameRenderer =
      (node) =&gt; node.name;
  String itemRenderer(item) =&gt; nameRenderer(item);
      </pre>
      <pre>
  &lt;material-tree
    [options]="nestedOptions"
    [selection]="multiSelection"
    [itemRenderer]="itemRenderer"&gt;
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
          [itemRenderer]="itemRenderer">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeNestedExpandDemoComponent {
  final SelectionOptions<data.CategoryNode> nestedOptions =
      data.expandStateOptions();
  final multiSelection = SelectionModel<data.CategoryNode>.multi();
  final ItemRenderer<data.CategoryNode> nameRenderer = (node) => node.name;

  String itemRenderer(item) => nameRenderer(item);

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;
}
