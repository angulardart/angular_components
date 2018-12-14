// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A material-design-styled time input component.
@Component(
  selector: 'material-time-picker',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    MaterialDropdownSelectComponent,
    materialInputDirectives,
    NgStyle,
  ],
  providers: [
    Provider(HasDisabled, useExisting: MaterialTimePickerComponent),
  ],
  templateUrl: 'material_time_picker.html',
  styleUrls: ['material_time_picker.scss.css'],
)
class MaterialTimePickerComponent extends KeyboardHandlerMixin
    implements HasDisabled, OnInit, OnDestroy {
  static DateTime _utcTime(int hour, [int minute = 0]) => DateTime.utc(
      _unixEpoch.year, _unixEpoch.month, _unixEpoch.day, hour, minute);

  static DateTime _localTime(int hour, [int minute = 0]) =>
      DateTime(_unixEpoch.year, _unixEpoch.month, _unixEpoch.day, hour, minute);

  static DateTime _withEpochDate(DateTime input) {
    if (input == null) return null;
    return input.isUtc
        ? _utcTime(input.hour, input.minute)
        : _localTime(input.hour, input.minute);
  }

  static final _unixEpoch = DateTime(1970, DateTime.january, 1, 0, 0);
  static final _supportedTimeFormats = [
    DateFormat.jm(),
    DateFormat.Hm(),
    DateFormat.jms(),
    DateFormat.Hms()
  ];

  final Clock _clock;
  final _disposer = Disposer.oneShot();
  final _timeChangeController = StreamController<DateTime>.broadcast();
  DateTime _time;
  bool displayErrorPanel;
  String inputError;

  /// The format used to format time.
  ///
  /// Defaults to `jm`, e.g. '5:08 PM'.
  @Input()
  DateFormat outputFormat = DateFormat.jm();

  /// The selected time.
  ///
  /// Date part sets to epoch(1970-1-1).
  @Input()
  set time(DateTime value) {
    value = utc ? value?.toUtc() : value?.toLocal();
    if ((value?.hour != _time?.hour ||
        value?.minute != _time?.minute ||
        value?.isUtc != _time?.isUtc)) {
      _time = value;
      selectedTime.clear();
      _timeChangeController.add(time);
    }
    setInputErrorText(_validateTime(time));
    timeInputText = time == null ? "" : renderTime(time);
  }

  /// An error displayed below the closed date picker.
  ///
  /// The picker also gets a red underline when this is set.
  @Input()
  String error;

  DateTime get time => _withEpochDate(_time);

  bool get disabled => _disabled;
  bool _disabled = false;

  /// Whether changing the selected time should be disabled.
  @Input()
  set disabled(bool value) => _disabled = value;

  bool _required = false;
  bool get required => _required;

  /// Whether the time entry is required.
  ///
  /// If true, the embedded text field will display an error to the user if
  /// blank. If false, clearing the text field will set `time` to `null`.
  @Input()
  set required(bool value) => _required = value;

  bool get utc => _utc;
  bool _utc = false;

  /// Whether the widget returns time in the UTC time zone.
  ///
  /// By default, the widget returns time in the local time zone.
  @Input()
  set utc(bool value) {
    _utc = value;

    timeOptions = TimeSelectionOptions(
        List<DateTime>.generate(24, _utc ? _utcTime : _localTime));

    time = _time;
  }

  final _popupVisibleController = StreamController<bool>.broadcast();

  /// Publishes events when the [popupVisible] changes.
  @Output()
  Stream<bool> get popupVisibleChange => _popupVisibleController.stream;

  bool _popupVisible = false;
  bool get popupVisible => _popupVisible;

  /// Make the dropdown visibility accessible so it can be opened
  /// from outside the component.
  @Input()
  set popupVisible(bool visible) {
    // Show popup only if not disabled
    _popupVisible = visible && !disabled;
    _popupVisibleController.add(_popupVisible);
  }

  DateTime _maxTime;
  DateTime get maxTime => _withEpochDate(_maxTime);

  /// Maximum date time that can be chosen by the user.
  @Input()
  set maxTime(DateTime value) {
    _maxTime = value;
    timeOptions.maxTime = _maxTime;

    // Validates selected time again since it may becomes invalid.
    if (_validateTime(time) != null) {
      time = null;
    }
  }

  DateTime _minTime;
  DateTime get minTime => _withEpochDate(_minTime);

  /// Minimum date time that can be chosen by the user.
  @Input()
  set minTime(DateTime value) {
    _minTime = _withEpochDate(value);
    timeOptions.minTime = _minTime;

    // Validates selected time again since it may becomes invalid.
    if (_validateTime(time) != null) {
      time = null;
    }
  }

  /// Publishes events when the selected time changes.
  ///
  /// Date is set to epoch(1970-1-1) and time set to [time]
  @Output()
  Stream<DateTime> get timeChange => _timeChangeController.stream;

  String get dropdownText =>
      time != null ? renderTime(time) : dropdownPlaceholderMsg;
  TimeSelectionOptions timeOptions;
  SelectionModel<DateTime> selectedTime = SelectionModel.single();
  String timeInputText = "";
  String renderTime(DateTime time) => outputFormat.format(time);

  MaterialTimePickerComponent(@Inject(datepickerClock) this._clock) {
    timeOptions = TimeSelectionOptions(List<DateTime>.generate(24, _localTime));
  }

  @override
  void ngOnInit() {
    _disposer
        .addStreamSubscription(selectedTime.selectionChanges.listen((change) {
      /// Triggers _trySetTime only when user selects/changes selection.
      /// Deselect or clear the selection will not trigger _trySetTime.
      if (change.last.added.isNotEmpty) {
        time = selectedTime.selectedValues.first;
      }
    }));
  }

  /// Sets [time] to now if it's null.
  void setTimeToNowIfUnset() {
    if (!disabled && time == null) {
      time = _withEpochDate(_clock.now());
    }
  }

  /// Triggered when time input box text changes.
  void onTextChange(String text) {
    _parseAndTrySetTime(text);
    selectedTime.clear();
  }

  /// Triggered when blur time input box.
  void onBlur() {
    _parseAndTrySetTime(timeInputText.trim(), setAsCurrent: true);
  }

  void setInputErrorText(String errorText) {
    displayErrorPanel = (errorText != null);
    inputError = errorText;
  }

  /// Given a text, checks its validity and optionally sets it
  /// as the current value if valid, reverts to previous value if not valid.
  DateTime _parseAndTrySetTime(String timeText, {bool setAsCurrent = false}) {
    final parsed = _parseTime(timeText);
    if (setAsCurrent) {
      time = inputError == null ? parsed : _time;
    }
    return time;
  }

  /// Parses time in various type of formats and returns a [DateTime] object
  /// with date set to epoch(1970-1-1) and time set to [time].
  ///
  /// Error message in the input box will be updated is there's any parsing
  /// error.
  DateTime _parseTime(String timeText) {
    if (timeText.trim().isEmpty) {
      setInputErrorText(required ? inputPlaceholderMsg : null);
      return null;
    }

    final formatsToParse = [outputFormat];
    formatsToParse.addAll(_supportedTimeFormats
        .where((DateFormat f) => outputFormat.pattern != f.pattern));

    DateTime parsed = _parseTimeOfFormats(timeText, formatsToParse);
    if (parsed == null) {
      setInputErrorText(inputPlaceholderMsg);
    } else {
      setInputErrorText(_validateTime(parsed));
    }
    return parsed;
  }

  /// Parses time in various type of formats and returns a [DateTime] object
  /// with date set to epoch(1970-1-1) and time set to [time].
  ///
  /// Returns null if fail to parse.
  DateTime _parseTimeOfFormats(String timeText, List<DateFormat> formats) {
    final trimmed = timeText.trim();
    for (final format in formats) {
      try {
        final parsed = format.parseLoose(trimmed, utc);
        if (parsed != null) {
          return _withEpochDate(parsed);
        }
      } on FormatException {
        // Ignores error, try different format.
      }
    }
    return null;
  }

  /// Validates whether the given time is within selected time range.
  ///
  /// Returns null on success, or a localized error string on failure.
  String _validateTime(DateTime value) {
    if (value == null) {
      return required ? inputPlaceholderMsg : null;
    }

    if (minTime != null && value.isBefore(minTime)) {
      return timeIsTooEarlyMsg(renderTime(minTime));
    } else if (maxTime != null && value.isAfter(maxTime)) {
      return timeIsTooLateMsg(renderTime(maxTime));
    }
    return null;
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  /// Stops propagating arrow key action from time input box to
  /// material-dropdown-select.
  void onInputBoxKeyDown(KeyboardEvent event) {
    event.stopPropagation();
  }

  /// Stops material-dropdown-select from closing popup when user type space in
  /// the input field.
  @override
  void handleSpaceKey(KeyboardEvent event) {
    event.stopPropagation();
  }

  /// Stops material-dropdown-select from selecting dropdown item when user
  /// press enter key in the input field.
  @override
  void handleEnterKey(KeyboardEvent event) {
    popupVisible = false;
    event.stopPropagation();
  }

  static final dropdownPlaceholderMsg = Intl.message('Select time',
      name: 'MaterialTimePickerComponent_dropdownPlaceholderMsg',
      desc: 'Placeholder text for an empty time picker dropdown button.');

  static final inputPlaceholderMsg = Intl.message('Enter time',
      name: 'MaterialTimePickerComponent_inputPlaceholderMsg',
      desc: 'Placeholder text for an empty time picker input box.');

  String timeIsTooEarlyMsg(String minimumTime) => Intl.message(
      'Enter $minimumTime or later',
      name: 'timeIsTooEarlyMsg',
      args: [minimumTime],
      examples: const {'minimumTime': '13:35'},
      meaning: 'Error message',
      desc: 'Displayed when the user enters a valid time, but it\'s before the '
          'minimum time accepted by the time input field.');

  String timeIsTooLateMsg(String maximumTime) => Intl.message(
      'Enter $maximumTime or earlier',
      name: 'timeIsTooLateMsg',
      args: [maximumTime],
      examples: const {'maximumTime': '23:59'},
      meaning: 'Error message',
      desc: 'Displayed when the user enters a valid time, but it\'s after the '
          'maximum time accepted by the time input field.');
}

/// [StringSelectionOptions] for DateTime dropdown selector.
///
/// Only options between [minTime] and [maxTime] are selectable.
class TimeSelectionOptions extends StringSelectionOptions<DateTime>
    implements Selectable {
  DateTime _minTime;
  DateTime _maxTime;

  TimeSelectionOptions(List<DateTime> options) : super(options);

  set minTime(DateTime time) => _minTime = time;
  set maxTime(DateTime time) => _maxTime = time;

  @override
  SelectableOption getSelectable(item) {
    return item is DateTime &&
            ((_minTime != null && item.isBefore(_minTime)) ||
                (_maxTime != null && item.isAfter(_maxTime)))
        ? SelectableOption.Disabled
        : SelectableOption.Selectable;
  }
}
