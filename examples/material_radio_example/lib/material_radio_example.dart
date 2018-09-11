// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Radio',
  docs: [MaterialRadioComponent, MaterialRadioGroupComponent],
  demos: [MaterialRadioExample],
)
@Component(
  selector: 'material-radio-example',
  directives: [
    NgFor,
    NgFormControl,
    NgModel,
    MaterialIconComponent,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
  ],
  templateUrl: 'material_radio_example.html',
  styleUrls: ['material_radio_example.scss.css'],
)
class MaterialRadioExample {
  /// Example without a group
  bool custom = false;
  bool unselected = false;
  bool preselected = true;
  bool impossible = false;
  bool always = true;

  /// Example 1 using group
  List<Option> ex1Options = [
    Option("fast", false, false),
    Option("cheap", false, false),
    Option("good", false, false)
  ];
  final SelectionModel ex1SelectionModel = SelectionModel.single();
  String get ex1SelectedValue => ex1SelectionModel.selectedValues.isEmpty
      ? 'unknown'
      : ex1SelectionModel.selectedValues.first;

  /// Example 2 using group
  List<Option> ex2Options = [
    Option("poor", false, false),
    Option("fair", true, false), // pre-selected
    Option("good", false, true), // disabled
    Option("awesome", false, false)
  ];
  Option selected;
  String get ex2SelectedValue => selected.label;

  MaterialRadioExample() {
    selected = ex2Options.firstWhere((o) => o.selected);
  }
}

class Option {
  final String label;
  bool selected;
  bool disabled;

  Option(this.label, this.selected, this.disabled);
}
