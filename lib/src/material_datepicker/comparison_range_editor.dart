// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/src/material_datepicker/date_range_editor_model.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/model/date/date.dart';

/// Component used to edit the `comparison` field of a [DateRangeComparison].
/// This is meant for use in the `material-date-range-picker`, and doesn't make
/// much sense outside of it.
///
/// __Example Usage:__
///
///     <comparison-range-editor [model]="model"></comparison-range-editor>
///
@Component(
  selector: 'comparison-range-editor',
  templateUrl: 'comparison_range_editor.html',
  styleUrls: const ['comparison_range_editor.scss.css'],
  directives: const [
    DateRangeInputComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialToggleComponent,
    NgIf,
    NgFor,
    MaterialDropdownSelectComponent,
    MaterialSelectItemComponent
  ],
)
class ComparisonRangeEditorComponent {
  /// A mutable model describing a comparison date range. The only expected
  /// non-test implementation is [DateRangeEditorModel].
  @Input()
  HasComparisonRange model;

  final List<ComparisonOption> options = [
    ComparisonOption.previousPeriod,
    ComparisonOption.samePeriodLastYear,
    ComparisonOption.custom
  ];

  String get comparisonHeaderMsg => Intl.message('Compare',
      name: 'comparisonHeaderMsg',
      desc: 'Label for a toggle that turns time comparison on/off.');

  String get previousPeriodMsg {
    // If we have a nice title ("3 weeks ago"), use that. Otherwise fall back
    // to "Previous period".
    var prev = model.prevRange;
    return prev?.isPredefined == true ? prev.title : _previousPeriodMsg;
  }

  String get _previousPeriodMsg => Intl.message('Previous period',
      name: '_previousPeriodMsg',
      meaning: 'Name for a time comparison option',
      desc: 'Setting to compare the selected date range with the previous '
          'period. E.g. if the selected range were May, this would be April.');

  String get samePeriodLastYearMsg => Intl.message('Previous year',
      name: 'samePeriodLastYearMsg',
      meaning: 'Name for a time comparison option',
      desc: 'Setting to compare the selected date range with the same range '
          'last year. E.g. if the selected range were May 2015, this would be '
          'May 2014.');

  String get customMsg => Intl.message('Custom',
      name: 'customMsg',
      meaning: 'Name for a time comparison option',
      desc: 'Setting to compare the selected date range with another arbitrary '
          'user-selected date range.');

  String comparisonOptionMsg(ComparisonOption option) {
    switch (option) {
      case ComparisonOption.previousPeriod:
        return previousPeriodMsg;
      case ComparisonOption.samePeriodLastYear:
        return samePeriodLastYearMsg;
      case ComparisonOption.custom:
        return customMsg;
      default:
        return '<unknown comparison option>';
    }
  }
}
