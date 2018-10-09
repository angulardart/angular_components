// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_tree/material_tree.dart';
import 'material_tree_demo_options.dart' as data;
import 'package:angular_components/model/selection/selection_options.dart';

/// An example that renders a [MaterialTreeComponent] with flat options.
@Component(
  selector: 'material-tree-flat-readonly-demo',
  directives: [MaterialTreeComponent],
  template: r'''
      <h1>Flat options (no hierarchy) in readonly mode (no selection model)</h1>
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
      </pre>
      <pre>
  &lt;material-tree
    [options]="simpleFlatOptions"&gt;
  &lt;/material-tree&gt;
      </pre>
      <div class="shadow" style="width: 400px; margin: 24px;">
        <material-tree [options]="simpleFlatOptions"></material-tree>
      </div>
    ''',
  styleUrls: ['material_shadow.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTreeFlatReadonlyDemoComponent {
  final SelectionOptions simpleFlatOptions = data.simpleFlatOptions;
}
