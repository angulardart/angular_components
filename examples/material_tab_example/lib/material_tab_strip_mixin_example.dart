// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/material_tab/fixed_material_tab_strip.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'material-tab-strip-mixin-example',
  providers: [
    windowBindings,
    domServiceBinding,
    rtlProvider,
  ],
  directives: [
    FixedMaterialTabStripComponent,
  ],
  templateUrl: 'material_tab_strip_mixin_example.html',
  styleUrls: ['material_tab_strip_mixin_example.scss.css'],
)
class MaterialTabStripMixinExample {
  final tabLabels = const <String>[
    'Tab 1',
    'Tab 2',
    'Tab 3 has a long label',
    'Tab 4'
  ];
}
