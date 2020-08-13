// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_datepicker/comparison.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_date_range_picker.dart';
import 'package:angular_components/material_datepicker/model.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/preset.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';

// Like [commonRanges], but longer, to test scrolling
List<DatepickerPreset> manyPresets(Clock clock) => [
      today(clock),
      yesterday(clock),
      SingleDayRange.daysAgo(clock, 2),
      SingleDayRange.daysAgo(clock, 3),
      SingleDayRange.daysAgo(clock, 4),
      SingleDayRange.daysAgo(clock, 5),
      thisWeek(clock),
      lastWeek(clock),
      last7Days(clock),
      last14Days(clock),
      thisMonth(clock),
      lastMonth(clock),
      thisBroadcastMonth(clock),
      lastBroadcastMonth(clock),
      last30Days(clock),
      thisQuarter(clock),
      lastQuarter(clock),
      thisYear(clock),
      lastYear(clock),
      allTime,
    ].map((range) => DatepickerPreset.fromRange(range)).toList();

@Component(
  selector: 'material-date-range-picker-demo',
  providers: [windowBindings, datepickerBindings],
  directives: [
    MaterialCheckboxComponent,
    MaterialDateRangePickerComponent,
    NgIf,
    DateRangeInputComponent,
    PopupSizeProviderDirective,
  ],
  styleUrls: ['material_date_range_picker_demo.scss.css'],
  templateUrl: 'material_date_range_picker_demo.html',
)
class MaterialDateRangePickerDemoComponent {
  bool supportsComparison = true;
  bool showNextPrevButtons = true;
  bool longPresetList = false;
  bool showMessageBar = false;
  bool isBasic = false;
  bool movingStartMaintainsLength = true;
  bool useMenuForPresets = false;
  List<DatepickerPreset> _defaultPresets;
  List<DatepickerPreset> _manyPresets;
  DatepickerComparison range;
  DatepickerComparison rangeSimplified;
  DatepickerComparison emptyRange;

  List<DatepickerPreset> get presets =>
      longPresetList ? _manyPresets : _defaultPresets;

  DateRangePickerConfiguration get configuration => isBasic
      ? DateRangePickerConfiguration.basic
      : DateRangePickerConfiguration.fullyLoaded;

  MaterialDateRangePickerDemoComponent() {
    var clock = Clock();
    _defaultPresets = defaultPresets(clock);
    _manyPresets = manyPresets(clock);

    range = DatepickerComparison.noComparison(_defaultPresets
        .singleWhere((preset) => preset.range.title == 'This week')
        .range);
    rangeSimplified = DatepickerComparison.noComparison(_defaultPresets
        .singleWhere((preset) => preset.range.title == 'This week')
        .range);
  }
  DateRange limitToRange = DateRange(Date.today().add(years: -5), Date.today());
}
