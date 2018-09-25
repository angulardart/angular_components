// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';

@Component(
  selector: 'material-dropdown-select-simple-demo',
  directives: [MaterialDropdownSelectComponent],
  templateUrl: 'material_dropdown_select_simple_demo.html',
  styleUrls: ['material_dropdown_select_demo.scss.css'],
)
class MaterialDropdownSelectSimpleDemoComponent {
  final values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int selectedValue = 1;
}
