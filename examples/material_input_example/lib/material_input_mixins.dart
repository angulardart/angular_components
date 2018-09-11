// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_input/material_input.dart';

@Component(
  selector: 'material-input-mixins',
  templateUrl: 'material_input_mixins.html',
  styleUrls: ['material_input_mixins.scss.css'],
  directives: [materialInputDirectives],
  preserveWhitespace: true,
)
class MaterialInputMixinDemoComponent {}
