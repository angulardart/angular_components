// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_datepicker/date_input.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_calendar_picker.dart';
import 'package:angular_components/material_datepicker/material_date_range_picker.dart';
import 'package:angular_components/material_datepicker/material_date_time_picker.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/material_month_picker.dart';
import 'package:angular_components/material_datepicker/material_time_picker.dart';
import 'date_input_demo.dart';
import 'date_range_input_demo.dart';
import 'material_calendar_picker_demo.dart';
import 'material_date_range_picker_demo.dart';
import 'material_date_time_picker_demo.dart';
import 'material_datepicker_demo.dart';
import 'material_month_picker_demo.dart';
import 'material_time_picker_demo.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Datepicker',
  docs: [
    MaterialDateRangePickerComponent,
    MaterialDatepickerComponent,
    MaterialCalendarPickerComponent,
    MaterialMonthPickerComponent,
    MaterialTimePickerComponent,
    MaterialDateTimePickerComponent,
    DateInputDirective,
    DateRangeInputComponent
  ],
  demos: [
    MaterialDateRangePickerDemoComponent,
    MaterialDatepickerDemoComponent,
    MaterialCalendarPickerDemoComponent,
    MaterialMonthPickerDemoComponent,
    MaterialTimePickerDemoComponent,
    MaterialDateTimePickerDemoComponent,
    DateInputDemoComponent,
    DateRangeInputDemoComponent
  ],
)
class CombinedDemoComponent {}
