// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/material_tab/fixed_material_tab_strip.dart';
import 'package:angular_components/material_tab/tab_change_event.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'material-tab-strip-example',
  providers: [
    domServiceBinding,
    rtlProvider,
    windowBindings,
  ],
  directives: [MaterialToggleComponent, FixedMaterialTabStripComponent, NgFor],
  templateUrl: 'material_tab_strip_example.html',
)
class MaterialTabStripExample {
  int tabIndex = 0;
  int tabIndex2 = 0;
  bool stopChange = false;

  void onTabChange(TabChangeEvent event) {
    tabIndex = event.newIndex;
  }

  void onBeforeTabChange(TabChangeEvent event) {
    if (stopChange) {
      event.preventDefault();
    }
  }

  final tabLabels = const <String>[
    'Users with access',
    'Managers with access',
    'Pending Invitations'
  ];
  final centeredTabLabels = const <String>['Tab 1 with a long name', 'Tab 2'];
}
