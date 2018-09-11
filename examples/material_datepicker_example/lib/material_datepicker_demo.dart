// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'material-datepicker-demo',
  providers: [windowBindings, datepickerBindings],
  directives: [MaterialDatepickerComponent, DateRangeInputComponent],
  templateUrl: 'material_datepicker_demo.html',
)
class MaterialDatepickerDemoComponent {
  Date date = Date.today();
  Date optionalDate;
  DateRange limitToRange = DateRange(Date.today().add(years: -5), Date.today());
  List<SingleDayRange> predefinedDates;

  MaterialDatepickerDemoComponent() {
    var clock = Clock();
    predefinedDates = <SingleDayRange>[
      today(clock),
      yesterday(clock),
    ];
  }
}
