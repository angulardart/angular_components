// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_auto_suggest_input.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';

import 'material_auto_suggest_input_full_demo.template.dart' as demo;

List<String> _numberNames = <String>[
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen'
];

// TODO(google) Change dynamic to List<int> once Angular can retain the type
// information. https://github.com/dart-lang/angular/issues/68
ItemRenderer<dynamic /* List<int>*/ > _numberNameRenderer =
    (dynamic /* List<int>*/ list) =>
        list.map((n) => _numberNames[n - 1]).join(', ');

List<OptionGroup<List<int>>> _optionGroups = <OptionGroup<List<int>>>[
  OptionGroup<List<int>>.withLabel(const <List<int>>[
    [1, 2, 3, 5],
    [7],
    [13],
    [17]
  ], "Primes less than 20"),
  OptionGroup<List<int>>.withLabel(const <List<int>>[
    [2, 4, 6],
    [8, 10],
    [12, 14],
    [16, 18]
  ], "Even less than 20")
];

@Component(
  selector: 'material-auto-suggest-input-full-demo',
  directives: [
    formDirectives,
    MaterialAutoSuggestInputComponent,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  templateUrl: 'material_auto_suggest_input_full_demo.html',
  styleUrls: ['material_auto_suggest_input_demo.scss.css'],
  preserveWhitespace: true,
)
class MaterialAutoSuggestInputFullDemoComponent {
  static const _popupPositionsAboveInput = [
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight,
  ];
  static const _popupPositionsBelowInput = [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight,
  ];

  final singleModel = SelectionModel<List>.single();
  final multiModel = SelectionModel<List>.multi();

  final suggestionOptions =
      ExampleSelectionOptions.withOptionGroups(_optionGroups);
  final suggestionOptionsWithItemRenderer =
      ExampleSelectionOptions.withOptionGroups(_optionGroups,
          toFilterableString: _numberNameRenderer);

  final emptySuggestionOptions = StringSelectionOptions(const <String>[]);

  final popupPositionSelection = SelectionModel<String>.single();
  final popupPositionOptions =
      StringSelectionOptions<String>(['Auto', 'Above', 'Below']);

  Control formControl = Control('');
  String inputText = '';

  bool filterSuggestions = true;
  bool popupMatchInputWidth = true;
  bool showClearIcon = false;
  bool showClearIconTooltip = false;
  bool hideCheckbox = false;
  bool shouldClearInputOnSelection = false;
  bool shouldClearSelectionOnInput = true;
  bool useLabelFactory = false;
  bool useFactoryRenderer = false;
  bool disabled = false;
  bool showHeaderAndFooter = false;
  bool showPopup = false;
  String label = 'Search...';
  String emptyPlaceholder = 'No matches';
  String leadingGlyph = 'search';
  String tooltip = 'Clear';
  int limit = 10;

  String get limitInput => '$limit';
  set limitInput(String val) {
    try {
      limit = int.parse(val);
    } catch (_) {
      limit = 0;
    }
  }

  SelectionOptions get options => suggestionOptionsWithItemRenderer;

  // TODO(google) Change dynamic to List<int> once Angular can retain the type
  // information. https://github.com/dart-lang/angular/issues/68
  ItemRenderer<dynamic /* List<int>*/ > get itemRenderer => _numberNameRenderer;

  FactoryRenderer get factoryRenderer =>
      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;

  FactoryRenderer get labelFactory => useLabelFactory
      ? (_) => demo.ExampleLabelRendererComponentNgFactory
      : null;

  String get popupPositionSelectButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  List<RelativePosition> get popupPositions {
    switch (popupPositionSelectButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return [];
  }

  String get clearIconTooltip => showClearIconTooltip ? tooltip : '';
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <material-icon icon="experiment" baseline></material-icon>
        {{displayValue}}
    ''',
  styles: ['material-icon { margin-right: 8px; }'],
  directives: [MaterialIconComponent],
)
class ExampleRendererComponent implements RendersValue {
  String displayValue = '';

  @override
  @Input()
  set value(newValue) {
    displayValue = _numberNameRenderer(newValue);
  }
}

@Component(
  selector: 'example-label-renderer',
  template: r'''
        <span>
          <material-icon icon="experiment" baseline></material-icon>
          {{displayValue}}
        </span>
    ''',
  styles: [
    'span { color: #9e9e9e; font-size: 12px;} material-icon {margin: 0 8px;}'
  ],
  directives: [MaterialIconComponent],
)
class ExampleLabelRendererComponent implements RendersValue {
  String displayValue = '';

  @override
  @Input()
  set value(newValue) {
    displayValue = newValue.uiDisplayName;
  }
}

class ExampleSelectionOptions extends StringSelectionOptions<List<int>>
    implements Selectable<List<int>> {
  ExampleSelectionOptions(List<List<int>> options) : super(options);
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups,
      {ItemRenderer<List<int>> toFilterableString})
      : super.withOptionGroups(optionGroups,
            toFilterableString: toFilterableString);
  @override
  SelectableOption getSelectable(List<int> item) {
    if (item.contains(13)) {
      return SelectableOption.Disabled;
    }
    return SelectableOption.Selectable;
  }
}
