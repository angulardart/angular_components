// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_input/material_percent_directive.dart';

@Component(
  selector: 'material-percent-input-demo',
  styles: ['material-input[type=percent] { width: 120px; }'],
  templateUrl: 'material_percent_input_demo.html',
  directives: [
    formDirectives,
    materialNumberInputDirectives,
    MaterialPercentInputDirective,
    NgFor
  ],
  preserveWhitespace: true,
)
class MaterialPercentInputDemoComponent {
  num effort = 110;
  num initialValue = 87;
  List<num> changes = [];
  void recordChange(num change) {
    changes.add(change);
    if (changes.length > 5) changes.removeAt(0);
  }

  Control formControl = Control(44);
}
