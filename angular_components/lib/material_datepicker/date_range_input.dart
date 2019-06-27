// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/date_input.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';

/// A date-range-input is two date inputs glued together.
///
/// When a user types in a date, dates with 2-digit years are handled specially.
/// E.g. 7/7/77 is interpreted as July 7, 1977, not July 7, 77. This logic looks
/// 20 years into the future: right now (August 2015), "35" is interpreted as
/// 2035 but "36" is interpreted as "1936". Next year, "36" will start to be
/// interpreted as 2036.
// TODO(google): Do the start/end date inputs need to be reversed in RTL
// locales?
@Component(
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'date-range-input',
  template: r'''
<material-input dateParsing
                [dateFormat]="startDateFormat"
                [maxDate]="startMaxDate"
                [minDate]="minDate"
                [required]="isDateInputRequired"
                [label]="startDateMsg"
                [class.active]="isStartActive"
                [(date)]="start"
                (focus)="onStartFocused()"
                [disabled]="disabled"
                class="start date-input">
</material-input>
<span class="separator">—</span>
<material-input dateParsing
                [dateFormat]="endDateFormat"
                [maxDate]="maxDate"
                [minDate]="endMinDate"
                [required]="isDateInputRequired"
                [label]="endDateMsg"
                [class.active]="isEndActive"
                [(date)]="end"
                [rangeEnd]="true"
                (focus)="onEndFocused()"
                [disabled]="disabled"
                class="end date-input">
</material-input>
''',
  styleUrls: ['date_range_input.scss.css'],
  directives: [DateInputDirective, materialInputDirectives],
)
class DateRangeInputComponent implements OnInit, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  StreamSubscription _calendarStream;

  DateRangeInputComponent(this._changeDetector);

  /// Whether the input field is disabled.
  ///
  /// If true, the component disable both start and end input field.
  @Input()
  bool disabled = false;

  @override
  void ngOnInit() {
    _calendarStream = _model.stream.listen(_onCalendarChange);
  }

  @override
  void ngOnDestroy() {
    _calendarStream?.cancel();
  }

  void _onCalendarChange(CalendarState state) {
    _changeDetector.markForCheck();
  }

  void onStartFocused() {
    if (disabled) {
      return;
    }
    if (state.currentSelection == rangeId && !state.previewAnchoredAtStart) {
      return;
    }
    _model.value = state.select(rangeId, previewAnchoredAtStart: false);
  }

  void onEndFocused() {
    if (disabled) {
      return;
    }
    if (state.currentSelection == rangeId && state.previewAnchoredAtStart) {
      return;
    }
    _model.value = state.select(rangeId, previewAnchoredAtStart: true);
  }

  bool get isStartActive =>
      state.currentSelection == rangeId &&
      state.selections.isNotEmpty &&
      !state.previewAnchoredAtStart;

  bool get isEndActive =>
      state.currentSelection == rangeId &&
      state.selections.isNotEmpty &&
      state.previewAnchoredAtStart;

  /// Fired when the selected date range changes. Text input only triggers this
  /// if both inputs are valid dates
  @Output()
  Stream<DateRange> get rangeChange => _controller.stream;
  final _controller = StreamController<DateRange>.broadcast();

  /// The selected date range.
  @Input()
  set range(DateRange range) {
    if (range != _range && range?.start != null && range?.end != null) {
      // Publish changes, if both endpoints are set
      _controller.add(range);
    }
    _range = range ?? DateRange(null, null);
  }

  bool _isClearRangeSelected = false;

  /// __Internal use only.__
  ///
  /// Used by material_date_range_editor.
  @Input()
  set isClearRangeSelected(bool value) {
    _isClearRangeSelected = value;
  }

  /// Whether date input is required. Since the input date is null, after
  /// clearing date range, [isDateInputRequired] should be false when
  /// [_isClearRangeSelected] is true to avoid unnecessary input error check.
  bool get isDateInputRequired => !_isClearRangeSelected;

  DateRange _range = DateRange(null, null);
  DateRange get range => _range;

  /// An object describing the entire state of the calendar -- what's selected
  /// on the calendar, and whether or not the selection is currently "active".
  @Input()
  set state(CalendarState state) {
    _model.value = state;
    if (_calendarStream == null) _onCalendarChange(state);
  }

  CalendarState get state => _model.value;
  final ObservableReference<CalendarState> _model =
      ObservableReference(CalendarState.empty(), coalesce: true);

  /// Fired when the calendar state changes -- e.g. when the user starts
  /// dragging the selected date range.
  @Output()
  Stream<CalendarState> get stateChange => _model.stream;

  /// ID of the range this date-range-input controls.
  @Input()
  String rangeId;

  Date get start => range.start;
  set start(Date date) {
    if (range.start != date) {
      range = DateRange(date, range.end);
    }
  }

  Date get end => range.end;
  set end(Date date) {
    if (range.end != date) {
      range = DateRange(range.start, date);
    }
  }

  // In order to validate that the end date is not earlier than the start date,
  // set the start date's maximum to the end date
  // and set the end date's minimum to the start date.
  // If either endpoint is not set, fall back to the entire range's min/maxDate.
  Date get startMaxDate => end ?? maxDate;
  Date get endMinDate => start ?? minDate;

  /// The [DateFormat] used to format dates. Defaults to `yMMMd`,
  /// e.g. "Jul 31, 2015".
  @Input()
  DateFormat dateFormat = DateFormat.yMMMd();

  /// The [DateFormat] used to format dates when the input is active.
  ///
  /// Defaults to `yMd`, e.g. "7/31/15".
  @Input()
  DateFormat activeDateFormat = DateFormat.yMd();

  DateFormat get startDateFormat =>
      isStartActive ? activeDateFormat : dateFormat;

  DateFormat get endDateFormat => isEndActive ? activeDateFormat : dateFormat;

  /// The latest recognized date, inclusive.
  /// Defaults to Dec 31, 9999 -- i.e., limited to 4-digit years.
  @Input()
  Date maxDate = Date(9999, DateTime.december, 31);

  /// The earliest recognized date, inclusive.
  /// Defaults to Jan 1, 1000 -- i.e., limited to 4-digit years.
  @Input()
  Date minDate = Date(1000, DateTime.january, 1);

  final startDateMsg = Intl.message('Start date',
      name: 'DateRangeInputComponent_startDateMsg',
      desc: 'ARIA label for the input specifying the start of the date range');

  final endDateMsg = Intl.message('End date',
      name: 'DateRangeInputComponent_endDateMsg',
      desc: 'ARIA label for the input specifying the end of the date range');
}
