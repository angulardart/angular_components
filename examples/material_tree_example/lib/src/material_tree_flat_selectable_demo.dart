// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with flat options.
///
/// Options are selected and managed by [singleSelection].
@Component(
  selector: 'material-tree-flat-selectable-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Flat (no hierarchy) with single selection</h1>
      <pre>
  final SelectionOptions simpleFlatOptions = new SelectionOptions.fromList([
    'Pinocchio',
    'Fantasia',
    'The Reluctant Dragon',
    'Dumbo',
    'Bambi',
    'Saludos Amigos',
    'Victory Through Air Power',
    'The Three Caballeros',
    'Make Mine Music',
    'Song of the South',
    'Fun and Fancy Free',
    'Melody Time',
    'So Dear to My Heart',
    'The Adventures of Ichabod and Mr. Toad'
  ]);

  final SelectionModel singleSelection = new SelectionModel.single();
      </pre>
      <pre>
  &lt;material-tree
    [options]="simpleFlatOptions"
    [selection]="singleSelection"&gt;
  &lt;/material-tree&gt;
      </pre>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <div style="padding: 8px">
          <strong>Selected:</strong> {{singleSelection.selectedValues}}
        </div>
      </div>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree
          [options]="simpleFlatOptions"
          [selection]="singleSelection">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeFlatSelectableDemoComponent {
  final SelectionOptions simpleFlatOptions = data.simpleFlatOptions;
  final SelectionModel singleSelection = SelectionModel.single();
}
