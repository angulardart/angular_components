// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/material_time_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/model/date/date.dart';

/// A material-design-styled single date and time picker.
///
/// The selected [dateTime] is always in local time zone.
/// See `material-datepicker` if you want to choose date only.
/// See `material-time-picker` if you want to choose time only.
///
/// __Example usage:__
///
///     <material-date-time-picker [(dateTime)]="myDateTime">
///     </material-date-time-picker>
@Component(
  selector: 'material-date-time-picker',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'material_date_time_picker.html',
  styleUrls: ['material_date_time_picker.scss.css'],
  directives: [
    MaterialDatepickerComponent,
    MaterialTimePickerComponent,
    MaterialInputComponent,
  ],
  providers: [ExistingProvider(HasDisabled, MaterialDateTimePickerComponent)],
)
class MaterialDateTimePickerComponent implements HasDisabled {
  final Clock _clock;

  @visibleForTemplate
  @HostBinding('tabIndex')
  static const tabIndex = -1;

  /// The format used to format dates.
  ///
  /// Defaults to `yMMMd`, e.g. 'Jan 23, 2015'.
  @Input()
  DateFormat outputDateFormat = DateFormat.yMMMd();

  /// The format used to format time.
  ///
  /// Defaults to `jm`, e.g. '5:08 PM'.
  @Input()
  DateFormat outputTimeFormat = DateFormat.jm();

  /// Maximum date time that can be chosen by the user.
  ///
  /// Defaults to December 31 23:59, ten years in the future. Set this to the
  /// latest date time which makes sense in your domain context. e.g., for apps
  /// which analyse historical data, this could be the current date time.
  @Input()
  DateTime maxDateTime;
  Date get maxDate =>
      Date(maxDateTime.year, maxDateTime.month, maxDateTime.day);

  /// Returns maximum time for time picker when selected date is maximum date.
  DateTime get maxTime {
    if (_sameDate(_date, maxDateTime)) {
      return cloneDateTime(maxDateTime);
    }
    return null;
  }

  /// Minimum date time that can be chosen by the user.
  ///
  /// Defaults to January 1 00:00, ten years ago. Set this to the earliest date
  /// time which makes sense in your domain context. e.g., the earliest date
  /// time for which data is available for analysis.
  @Input()
  DateTime minDateTime;
  Date get minDate =>
      Date(minDateTime.year, minDateTime.month, minDateTime.day);

  /// Returns minimum time for time picker when selected date is minimum date.
  DateTime get minTime {
    if (_sameDate(_date, minDateTime)) {
      return cloneDateTime(minDateTime);
    }
    return null;
  }

  /// Increment of time dropdown options in minutes, passed on to time picker.
  @Input()
  int increment;

  /// Whether changing the selected date and time should be disabled.
  @Input()
  bool disabled = false;

  /// Whether the date and time entry is required.
  ///
  /// If true, the embedded text fields will display an error to the user if
  /// blank. If false, clearing the text fields will set [dateTime] to `null`.
  @Input()
  bool required = false;

  bool get utc => _utc;
  bool _utc = false;

  /// Whether the widget returns [dateTime] in the UTC time zone.
  ///
  /// In default, the widget returns time in the local time zone.
  @Input()
  set utc(bool value) {
    _utc = value;
    dateTime = _utc ? _dateTime?.toUtc() : _dateTime?.toLocal();
  }

  final _dateTimeController = StreamController<DateTime>.broadcast();

  /// Publishes events when the selected [dateTime] changes.
  @Output()
  Stream<DateTime> get dateTimeChange => _dateTimeController.stream;

  /// The [dateTime] setter, which is only called programmatically,
  /// propagates changes to the others.
  ///
  /// The [date] and [time] setters, which are only called via user input,
  /// propagate changes to [dateTime].  But the propagation is not transitive.
  /// For example, calling the [date] setter updates [dateTime] but not [time].
  /// Summary:
  ///        /-> [date] -> [dateTime]
  /// [dateTime]
  ///        \-> [time] -> [dateTime]
  /// (but don't follow the arrows transitively!)
  /// These weird choices allow the user to have 1 invalid field without
  /// the additional punishment of wiping out the other.  In fact, it is
  /// necessary for these values not to be perfectly in sync since otherwise,
  /// the first time the user entered invalid data, he would be trapped, unable
  /// to enter valid data in both pickers at once.
  DateTime _dateTime;

  DateTime get dateTime => _dateTime;

  /// The selected date time.
  @Input()
  set dateTime(DateTime value) {
    if (value != _dateTime) {
      _dateTime = value;
      _date = (_dateTime == null ? null : Date.fromTime(_dateTime));
      _time = cloneDateTime(_dateTime);
    }
  }

  MaterialDateTimePickerComponent(@Inject(datepickerClock) this._clock) {
    // Init minDateTime and maxDateTime to sensible defaults.
    int year = _clock.now().toUtc().year;
    minDateTime = DateTime(year - 10, DateTime.january, 1, 0, 0);
    maxDateTime = DateTime(year + 10, DateTime.december, 31, 23, 59);
  }

  Date _date;

  /// The selected date or null if the date picker has invalid input.
  Date get date => _date;
  set date(Date value) {
    if (value != _date) {
      _date = value;
      if (_date != null && _time == null) {
        // Set default time to minimum time if date is minimum date.
        if (_sameDate(_date, minDateTime)) {
          _time = cloneDateTime(minDateTime);
        } else {
          _time = _utc ? DateTime.utc(_date.year) : DateTime(_date.year);
        }
      }
      _updateDateTimeAndNotify();
    }
  }

  DateTime _time;

  /// The selected time or null if the user blanks it out.
  DateTime get time => _time;
  set time(DateTime value) {
    if (value != _time) {
      _time = value;
      _updateDateTimeAndNotify();
    }
  }

  /// Sets [dateTime] to now if it's null.
  void setTimeToNowIfUnset() {
    if (!disabled && _time == null) {
      DateTime now = _clock.now();
      _time = now;
      _date = Date(now.year, now.month, now.day);
      _updateDateTimeAndNotify();
    }
  }

  /// Updates [dateTime] to match the user's choice or null if either of the
  /// date or time values is invalid.
  void _updateDateTimeAndNotify() {
    _dateTime = _date != null && _time != null
        ? (utc
            ? DateTime.utc(
                _date.year, _date.month, _date.day, _time.hour, _time.minute)
            : DateTime(
                _date.year, _date.month, _date.day, _time.hour, _time.minute))
        : null;

    if (_dateTime != null || !required) {
      _dateTimeController.add(_dateTime);
    }
  }

  /// Checks whether [toCompare] has the same date as [date] ignoring the time.
  static bool _sameDate(Date date, DateTime toCompare) {
    if (date == null || toCompare == null) {
      return false;
    }
    return (date.year == toCompare.year &&
        date.month == toCompare.month &&
        date.day == toCompare.day);
  }

  static DateTime cloneDateTime(DateTime dateTime) {
    return dateTime != null
        ? DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch,
            isUtc: dateTime.isUtc)
        : null;
  }
}
