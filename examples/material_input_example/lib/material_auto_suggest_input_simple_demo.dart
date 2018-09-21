// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_input/material_auto_suggest_input.dart';

@Component(
  selector: 'material-auto-suggest-input-simple-demo',
  directives: [MaterialAutoSuggestInputComponent],
  templateUrl: 'material_auto_suggest_input_simple_demo.html',
  styleUrls: ['material_auto_suggest_input_demo.scss.css'],
)
class MaterialAutoSuggestInputSimpleDemoComponent {
  final values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int selectedValue = 1;
}
