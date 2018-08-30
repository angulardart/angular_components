// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_menu/material_fab_menu.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/ui/icon.dart';

@Component(
  selector: 'material-fab-menu-demo',
  directives: [MaterialFabMenuComponent],
  templateUrl: 'material_fab_menu_demo.html',
)
class MaterialFabMenuDemoComponent {
  final MenuItem menuItem = MenuItem('your label',
      icon: Icon('add'),
      subMenu: MenuModel([
        MenuItemGroup([
          MenuItem('item1-1', tooltip: 'your tooltip'),
          MenuItem('item1-2', tooltip: 'your second tooltip')
        ], 'group1'),
        MenuItemGroup([MenuItem('item2-1'), MenuItem('item2-2')], 'group2'),
      ]));
}
