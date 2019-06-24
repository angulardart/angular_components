// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_select/material_select_dropdown_item.dart';
import 'package:angular_components/material_select/material_select_searchbox.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/has_factory.dart';

import 'material_dropdown_select_full_demo.template.dart' as demo;

@Component(
  selector: 'material-dropdown-select-full-demo',
  // popupBindings should ideally be in a top level or root component.
  // In demos, this is the top level/root component.
  providers: popupBindings,
  directives: [
    materialInputDirectives,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialSelectSearchboxComponent,
    DropdownSelectValueAccessor,
    MultiDropdownSelectValueAccessor,
    MaterialSelectDropdownItemComponent,
    NgModel,
    NgIf,
    NgFor,
    DropdownButtonComponent,
  ],
  templateUrl: 'material_dropdown_select_full_demo.html',
  styleUrls: ['material_dropdown_select_demo.scss.css'],
  preserveWhitespace: true,
)
class MaterialDropdownSelectFullDemoComponent {
  static const List<Language> _languagesList = <Language>[
    Language('en-US', 'US English'),
    Language('en-UK', 'UK English'),
    Language('fr-CA', 'Canadian English'),
    Language('af', 'Afrikaans'),
    Language('sq', 'Albanian'),
    Language('ar', 'Arabic'),
    Language('hy', 'Armenian'),
    Language('az', 'Azerbaijani'),
    Language('eu', 'Basque'),
    Language('be', 'Belarusian'),
    Language('bn', 'Bengali'),
    Language('bs', 'Bosnian'),
    Language('bg', 'Bulgarian'),
    Language('ca', 'Catalan'),
    Language('ceb', 'Cebuano'),
    Language('zh-CN', 'Chichewa'),
    Language('zh-TW', 'Chinese'),
    Language('ny', 'Chinese (Simplified)'),
    Language('zh', 'Chinese (Traditional)'),
    Language('hr', 'Croatian'),
    Language('cs', 'Czech'),
    Language('da', 'Danish'),
    Language('nl', 'Dutch'),
    Language('en', 'English'),
    Language('eo', 'Esperanto'),
    Language('et', 'Estonian'),
    Language('tl', 'Filipino'),
    Language('fi', 'Finnish'),
    Language('fr', 'French'),
    Language('gl', 'Galician'),
    Language('ka', 'Georgian'),
    Language('de', 'German')
  ];

  static final List<OptionGroup<Language>> _languagesGroups =
      <OptionGroup<Language>>[
    OptionGroup<Language>.withLabel(const <Language>[
      Language('en-US', 'US English'),
      Language('fr-CA', 'Canadian English'),
    ], 'North America'),
    OptionGroup<Language>.withLabel(const <Language>[
      Language('ny', 'Chinese (Simplified)'),
      Language('zh', 'Chinese (Traditional)')
    ], 'Asia'),
    OptionGroup<Language>.withLabel(const <Language>[
      Language('en-UK', 'UK English'),
      Language('de', 'German')
    ], 'Europe'),
    OptionGroup<Language>.withLabel(
        const <Language>[], 'Antarctica', 'No languages'),
    // This group will not be rendered.
    OptionGroup<Language>.withLabel(const <Language>[], 'Pangaea')
  ];

  static final List<RelativePosition> _popupPositionsAboveInput = const [
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];
  static final List<RelativePosition> _popupPositionsBelowInput = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  static final ItemRenderer _displayNameRenderer =
      (item) => (item as HasUIDisplayName).uiDisplayName;

  // Specifying an itemRenderer avoids the selected item from knowing how to
  // display itself.
  static final ItemRenderer _itemRenderer = newCachingItemRenderer<Language>(
      (language) => "${language.label} (${language.code})");

  bool useFactoryRenderer = false;
  bool useItemRenderer = false;
  bool useLabelFactory = false;
  bool useOptionGroup = false;
  bool withHeaderAndFooter = false;
  bool popupMatchInputWidth = true;
  bool visible = false;
  bool deselectOnActivate = true;
  String deselectLabel = 'None';

  /// Languages to choose from.
  ExampleSelectionOptions languageListOptions =
      ExampleSelectionOptions(_languagesList);

  ExampleSelectionOptions languageGroupedOptions =
      ExampleSelectionOptions.withOptionGroups(_languagesGroups);

  StringSelectionOptions<Language> get languageOptions =>
      useOptionGroup ? languageGroupedOptions : languageListOptions;

  /// Single Selection Model
  final SelectionModel<Language> singleSelectModel =
      SelectionModel.single(selected: _languagesList[1]);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.isNotEmpty
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Language';

  /// Multi Selection Model
  final SelectionModel<Language> multiSelectModel =
      SelectionModel<Language>.multi();

  final SelectionModel<int> widthSelection = SelectionModel<int>.multi();
  final SelectionOptions<int> widthOptions =
      SelectionOptions<int>.fromList([0, 1, 2, 3, 4, 5]);
  String get widthButtonText => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first.toString()
      : '0';

  final SelectionModel<String> popupPositionSelection =
      SelectionModel<String>.multi();
  final StringSelectionOptions popupPositionOptions =
      StringSelectionOptions<String>(['Auto', 'Above', 'Below']);
  String get popupPositionButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  final SelectionModel<String> slideSelection = SelectionModel<String>.multi();
  final StringSelectionOptions slideOptions =
      StringSelectionOptions<String>(['Default', 'x', 'y']);
  String get slideButtonText => slideSelection.selectedValues.isNotEmpty
      ? slideSelection.selectedValues.first
      : 'Default';

  int get width => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first
      : null;

  List<RelativePosition> get preferredPositions {
    switch (popupPositionButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return RelativePosition.overlapAlignments;
  }

  String get slide => slideSelection.selectedValues.isNotEmpty &&
          slideSelection.selectedValues.first != 'Default'
      ? slideSelection.selectedValues.first
      : null;

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;

  /// Currently selected language for the multi selection model
  String get multiSelectedLanguages =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(',');

  ItemRenderer<Language> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

  FactoryRenderer get factoryRenderer =>
      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;

  FactoryRenderer get labelFactory => useLabelFactory
      ? (_) => demo.ExampleLabelRendererComponentNgFactory
      : null;

  /// Label for the button for multi selection.
  String get multiSelectLanguageLabel {
    var selectedValues = multiSelectModel.selectedValues;
    if (selectedValues.isEmpty) {
      return "Select Languages";
    } else if (selectedValues.length == 1) {
      return itemRenderer(selectedValues.first);
    } else {
      return "${itemRenderer(selectedValues.first)} + ${selectedValues.length - 1} more";
    }
  }

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      // TODO(google): Avoid using Timer.run.
      Timer.run(() {
        searchbox.focus();
      });
    }
  }

  Language selectionValue;
  List<Language> selectionValues = [];
  String get selectionValuesLabel {
    final size = selectionValues.length;
    if (size == 0) {
      return 'Select Languages';
    } else if (size == 1) {
      return itemRenderer(selectionValues.first);
    } else {
      return "${itemRenderer(selectionValues.first)} + ${size - 1} more";
    }
  }

  String selectionOption;

  void alert(String message) => window.alert(message);

  String languageButtonLabel = 'Select Language';
  List<Language> get languagesList => _languagesList;
}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;

  @override
  String toString() => uiDisplayName;
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: ['material-icon { margin-right: 8px; }'],
  directives: [MaterialIconComponent],
)
class ExampleRendererComponent implements RendersValue<Language> {
  String displayName = '';

  @override
  set value(Language newValue) {
    displayName = newValue.uiDisplayName;
  }
}

@Component(
  selector: 'example-label-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: [
    ':host { margin-left: 16px}'
        'material-icon { margin-right: 8px}',
  ],
  directives: [MaterialIconComponent],
)
class ExampleLabelRendererComponent implements RendersValue<OptionGroup> {
  String displayName = '';

  @override
  set value(OptionGroup newValue) {
    displayName = newValue.uiDisplayName ?? 'Languages';
  }
}

/// If the option does not support toString() that shows the label, the
/// toFilterableString parameter must be passed to StringSelectionOptions.
class ExampleSelectionOptions extends StringSelectionOptions<Language>
    implements Selectable<Language> {
  ExampleSelectionOptions(List<Language> options)
      : super(options,
            toFilterableString: (Language option) => option.toString());
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
            toFilterableString: (Language option) => option.toString());
  @override
  SelectableOption getSelectable(Language item) =>
      item is Language && item.code.contains('en')
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}
