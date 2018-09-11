// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
  selector: 'buttons',
  templateUrl: 'buttons.html',
  directives: [MaterialButtonComponent, MaterialIconComponent],
)
class ButtonsExampleComponent {}
