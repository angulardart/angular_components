// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with first group expanded
/// and a "View more" link.
@Component(
  selector: 'material-tree-section-demo',
  directives: [
    MaterialTreeComponent,
    ViewMoreDemoRenderingOptions,
  ],
  template: r'''
    <h1>Nested with "View more" link</h1>
    <pre>
  // See material_tree_view_more_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptionsVariation;

  final SelectionModel singleSelection = new SelectionModel.single();
    </pre>
    <pre>
  &lt;material-tree
    [options]="nestedOptions"
    [selection]="singleSelection"
    [optimizeForDropdown]="true"
    [expandFirstRoot]="true"
    [firstRootMaxInitialOptionsShown]="2"&gt;
  &lt;/material-tree&gt;
    </pre>
    <div style="width: 400px; margin: 24px;">
      <div class="shadow" style="margin-bottom: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong> {{singleSelection.selectedValues}}
        </div>
      </div>
      <div class="shadow">
        <material-tree
          [options]="nestedOptions"
          [selection]="singleSelection"
          [optimizeForDropdown]="true"
          renderingOptions>
        </material-tree>
      </div>
    </div>''',
  styleUrls: ['material_shadow.scss.css'],
)
class MaterialTreeViewMoreDemoComponent {
  final SelectionOptions nestedOptions = data.nestedOptionsVariation;
  final SelectionModel singleSelection = SelectionModel.single();

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;
}

@Injectable()
class ExpandFirstRootRenderingOptions extends MaterialTreeRenderingOptions {
  @override
  bool shouldExpand(OptionGroup optionGroup, int index) => index == 0;

  @override
  int maxInitialOptionsShown(OptionGroup optionGroup, int index) =>
      index == 0 ? 2 : null;
}

@Directive(
  selector: '[renderingOptions]',
  providers: [
    ClassProvider(MaterialTreeRenderingOptions,
        useClass: ExpandFirstRootRenderingOptions),
  ],
)
class ViewMoreDemoRenderingOptions {}
