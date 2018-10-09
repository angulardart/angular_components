// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_renderer.dart';

/// An example that renders a [MaterialTreeComponent] with nested options.
///
/// All options are formatted by [sampleItemRenderer].
@Component(
  selector: 'material-tree-nested-item-rendering-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Nested with item renderer</h1>
      <pre>
  // See material_tree_nested_single_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptions;

  ItemRenderer&lt;String&gt; sampleItemRenderer =
      (String movieTitle) =&gt; movieTitle.toUpperCase();
  String itemRenderer(item) =&gt; sampleItemRenderer(item);
      </pre>
      <pre>
  &lt;material-tree
    [options]="nestedOptions"
    [itemRenderer]="itemRenderer"&gt;
  &lt;/material-tree&gt;
      </pre>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree
          [options]="nestedOptions"
          [itemRenderer]="itemRenderer">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeNestedItemRenderingComponent {
  final SelectionOptions nestedOptions = data.nestedOptions;
  ItemRenderer<String> sampleItemRenderer =
      (String movieTitle) => movieTitle.toUpperCase();

  String itemRenderer(item) => sampleItemRenderer(item);

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;
}
