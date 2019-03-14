// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';

@Component(
  selector: 'material-select-demo',
  directives: [
    displayNameRendererDirective,
    FocusItemDirective,
    FocusListDirective,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    NgFor,
  ],
  templateUrl: 'material_select_demo.html',
  styleUrls: ['material_select_demo.scss.css'],
)
class MaterialSelectDemoComponent {
  final SelectionModel<String> defaultLanguageSelection =
      SelectionModel.single();

  final SelectionModel<Language> targetLanguageSelection =
      SelectionModel.multi();

  String proto;
  static const languagesList = [
    Language('en-US', 'US English'),
    Language('en-UK', 'UK English'),
    Language('fr-CA', 'Canadian French')
  ];

  List<Language> get languages => languagesList;

  final SelectionOptions<Language> languageOptions =
      SelectionOptions.fromList(languagesList);

  final languageOptionsGrouped = SelectionOptions([
    OptionGroup<Language>.withLabel(languagesList, 'North America'),
    OptionGroup<Language>.withLabel(
        [Language('ja', 'Japanese'), Language('ko', 'Korean')], 'Asia')
  ]);
}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;
}
