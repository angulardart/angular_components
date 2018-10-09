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
/// Options are selected and managed by [multiSelection].
@Component(
  selector: 'material-tree-flat-multi-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Flat (no hierarchy) with multi selection</h1>
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

  final SelectionModel multiSelection = new SelectionModel.multi();
      </pre>
      <pre>
  &lt;material-tree
    [options]="simpleFlatOptions"
    [selection]="singleSelection"&gt;
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
          [options]="simpleFlatOptions"
          [selection]="multiSelection">
        </material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
)
class MaterialTreeFlatMultiDemoComponent {
  final multiSelection = SelectionModel.multi();
  final ChangeDetectorRef _changeDetector;

  MaterialTreeFlatMultiDemoComponent(this._changeDetector);

  SelectionOptions _simpleFlatOptions = data.simpleFlatOptions;
  SelectionOptions get simpleFlatOptions => _simpleFlatOptions;
  set simpleFlatOptions(SelectionOptions value) {
    _simpleFlatOptions = value;
    _changeDetector.markForCheck();
  }
}
