// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';

@Component(
  selector: 'material-list-demo',
  directives: [
    FocusItemDirective,
    FocusListDirective,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialSelectItemComponent,
    NgFor
  ],
  templateUrl: 'material_list_demo.html',
  styleUrls: ['material_list_demo.scss.css'],
)
class MaterialListDemoComponent {
  SelectionModel<String> colorSelection = SelectionModel.single();
  String get selectedColor => colorSelection.selectedValues.isEmpty
      ? 'red'
      : colorSelection.selectedValues.first;

  SelectionModel<dynamic> itemSelection = SelectionModel.multi();

  void toggleItem(key) {
    if (itemSelection.isSelected(key)) {
      itemSelection.deselect(key);
    } else {
      itemSelection.select(key);
    }
  }

  MaterialListDemoComponent() {
    itemSelection.select(2);
  }

  List<String> get sizes => MaterialListSize.values;

  void selectColor(String color) {
    colorSelection.select(color);
  }

  String growingItemLabel = "Growing item label";
}
