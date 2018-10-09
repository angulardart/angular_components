// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with divider lines.
///
/// Options are selected and managed by [singleSelection].
@Component(
  selector: 'material-tree-nested-single-divider-demo',
  directives: [
    MaterialTreeComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    NgFor,
    NgClass
  ],
  template: r'''
      <h1>Nested single selection with expansion dividers</h1>
      <pre>
  // See material_tree_nested_single_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptions;

  final SelectionModel singleSelection = new SelectionModel.single();
      </pre>
      <pre>
  &lt;material-tree [ngClass]="selected"
    [options]="nestedOptions"
    [selection]="singleSelection"&gt;
  &lt;/material-tree&gt;
      </pre>
      <material-radio-group [selected]="selected" (selectedChange)="selected = $event">
        <material-radio *ngFor="let option of dividerOptions"
                        [value]="option.className">{{option.label}}
        </material-radio>
      </material-radio-group><br>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong> {{singleSelection.selectedValues}}
        </div>
      </div>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree [ngClass]="selected"
          [options]="nestedOptions"
          [selection]="singleSelection">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css', 'dividers.scss.css'],
)
class MaterialTreeNestedSingleDividerDemoComponent {
  final SelectionOptions nestedOptions = data.nestedOptions;
  final SelectionModel singleSelection = SelectionModel.single();
  final List<Option> dividerOptions = [
    Option('', "Hidden"),
    Option('tree-border-expanded', "Expanded nodes"),
    Option('tree-border-parent', "Parent nodes"),
    Option('tree-border-all', "All rows"),
  ];
  String selected = 'tree-border-expanded';

  @ViewChild(MaterialTreeComponent)
  MaterialTreeComponent materialTree;
}

class Option {
  String className;
  String label;
  Option(this.className, this.label);
}
