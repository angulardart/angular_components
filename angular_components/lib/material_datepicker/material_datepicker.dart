// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/date_input.dart';
import 'package:angular_components/material_datepicker/material_calendar_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/mixins/focusable_mixin.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/angular/css/css.dart';

/// A material-design-styled single date picker -- a date parsing input and
/// calendar picker. Users can type in their own custom dates, or click on the
/// calendar to select a date.
///
/// When a user types in a date, dates with 2-digit years are handled specially.
/// E.g. 7/7/77 is interpreted as July 7, 1977, not July 7, 77. This logic looks
/// 20 years into the future: right now (August 2015), "35" is interpreted as
/// 2035 but "36" is interpreted as "1936". Next year, "36" will start to be
/// interpreted as 2036.
///
/// See also `material-date-range-picker` if you want to choose date ranges.
@Component(
  selector: 'material-datepicker',
  directives: [
    AutoFocusDirective,
    ButtonDirective,
    DateInputDirective,
    DeferredContentDirective,
    DropdownButtonComponent,
    FocusTrapComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialCalendarPickerComponent,
    materialInputDirectives,
    MaterialListItemComponent,
    MaterialPopupComponent,
    MaterialSelectItemComponent,
    NgClass,
    NgFor,
    NgIf,
    PopupSourceDirective,
  ],
  providers: [ExistingProvider(HasDisabled, MaterialDatepickerComponent)],
  styleUrls: ['material_datepicker.scss.css'],
  templateUrl: 'material_datepicker.html',
)
class MaterialDatepickerComponent
    with FocusableMixin, KeyboardHandlerMixin
    implements AfterViewInit, HasDisabled {
  /// CSS classes from the root element, passed to the popup to allow scoping of
  /// mixins.
  ///
  /// Only visible for the template.
  final String popupClassName;

  /// aria-label attached to the dropdown button that opens the date picker.
  @Input()
  String ariaLabelForDropdownButton;

  /// The format used to format dates.
  ///
  /// Defaults to `yMMMd`, e.g. 'Jan 23, 2015'.
  @Input()
  DateFormat outputFormat = DateFormat.yMMMd();

  /// Dates later than `maxDate` cannot be chosen.
  ///
  /// Defaults to December 31, ten years in the future. Set this to the latest
  /// date which makes sense in your domain context. e.g. For apps which analyse
  /// historical data, this could be the current day.
  @Input()
  Date maxDate;

  /// Dates earlier than `minDate` cannot be chosen.
  ///
  /// Defaults to January 1, ten years ago. Set this to the earliest date which
  /// makes sense in your domain context. e.g. The earliest date for which data
  /// is available for analysis.
  @Input()
  Date minDate;

  /// Whether to enable compact calendar styles.
  @Input()
  @HostBinding('class.compact')
  bool compact = !window.matchMedia("(pointer: coarse)").matches;

  /// False if null dates are allowed.
  ///
  /// If true, the embedded text field will display an error to the user if
  /// blank. If false, clearing the text field will set `date` to `null`.
  @Input()
  bool required = true;

  /// Preferred positions for alignment.
  List<RelativePosition> preferredPositions =
      RelativePosition.overlapAlignments;

  final _controller = StreamController<Date>.broadcast();

  /// Publishes events when the selected date changes.
  @Output()
  Stream<Date> get dateChange => _controller.stream;

  void _setDateInternal(Date date,
      {CausedBy cause = CausedBy.external, bool closePopup = true}) {
    if (date == _date) return;
    _controller.add(date);
    _date = date;
    _calendar = date != null
        ? _calendar.setCurrentSelection(date, date, cause: cause)
        : _calendar.clearCurrentSelection();
    _updateLabel();
    if (closePopup) {
      popupVisible = false;
    }
  }

  /// The selected date.
  @Input()
  set date(Date date) {
    _setDateInternal(date, closePopup: false);
  }

  Date _date;
  Date get date => _date;

  CalendarState _calendar = CalendarState.empty();
  CalendarState get calendar => _calendar;
  set calendar(CalendarState state) {
    _calendar = state;
    if (!state.has(state.currentSelection)) return;
    _setDateInternal(state.selection(state.currentSelection).start,
        cause: CausedBy.rangeConfirm);
  }

  /// Whether changing the selected date should be disabled.
  @Input()
  set disabled(bool value) {
    _disabled = value;
    // Hide popup if visible.
    _popupVisible = _popupVisible && !disabled;
  }

  bool _disabled = false;
  bool get disabled => _disabled;

  bool _popupVisible = false;
  bool get popupVisible => _popupVisible;

  final _popupVisibleController = StreamController<bool>.broadcast();

  /// Publishes events when the popupVisible changes.
  @Output()
  Stream<bool> get popupVisibleChange => _popupVisibleController.stream;

  /// Opens or closes the datepicker.
  @Input()
  set popupVisible(bool visible) {
    // Show popup only if not disabled
    _popupVisible = visible && !disabled;
    _popupVisibleController.add(_popupVisible);
    focusable = _focusTarget;
  }

  @override
  void ngAfterViewInit() {
    focusable = _focusTarget;
  }

  @override
  void handleEscapeKey(KeyboardEvent event) {
    dropdownButton.focus();
  }

  @ViewChild(DropdownButtonComponent)
  DropdownButtonComponent dropdownButton;

  @ViewChild(MaterialInputComponent)
  MaterialInputComponent textInput;

  Focusable get _focusTarget =>
      disabled ? null : (_popupVisible ? textInput : dropdownButton);

  /// Gets the i18n'ed "Select a date" placeholder text.
  @Input()
  String selectDatePlaceHolderMsg = Intl.message('Select a date',
      name: 'selectDatePlaceHolderMsg',
      desc: 'Placeholder text for datepicker with an empty date.');

  /// Gets the i18n'ed "Enter date" placeholder text.
  @Input()
  String placeholderMsg = Intl.message('Enter date',
      name: 'placeholderMsg',
      desc: 'Placeholder text for an empty date picker text box.');

  /// Gets the i18n'ed "Custom" label text.
  static final customDateMsg = Intl.message('Custom',
      name: 'customDateMsg',
      desc: 'Indicates that a single custom date is selected');

  String get formattedDate =>
      date != null ? date.format(outputFormat) : selectDatePlaceHolderMsg;

  /// Opens the calendar picker popup if not in a [disabled] state.
  void onTrigger() {
    popupVisible = !disabled;
  }

  List<SingleDayRange> get presetDates => _presetDates;
  List<SingleDayRange> _presetDates = [];

  /// A list of preset dates which the user can choose from.
  ///
  /// Defaults is empty so any list is shown.
  @Input('predefinedDates')
  set presetDates(List<SingleDayRange> preset) {
    _presetDates = preset;
    _updateLabel();
  }

  bool isPresetDateSelected(SingleDayRange presetDate) {
    return date == presetDate.start;
  }

  /// Label of the datepicker
  String labelMsg;

  /// Update the floating label. This feature is only enabled when there are
  /// preset dates defined.
  void _updateLabel() {
    if (presetDates.isEmpty) return;
    labelMsg = customDateMsg;
    for (var presetDate in presetDates) {
      if (date == presetDate.start) {
        labelMsg = presetDate.title;
        break;
      }
    }
  }

  void onPresetClicked(SingleDayRange selected) {
    _setDateInternal(selected.start);
  }

  // When a date is received from the input field, auto-close the popup.
  void setDateFromInput(Date newDate) {
    _setDateInternal(newDate);
  }

  int _numCalendarWeekRows;

  /// Sets the number of weeks the calendar should show.
  @Input()
  set numCalendarWeekRows(int value) {
    _numCalendarWeekRows = value;
  }

  String get calendarWeekRowsStyle =>
      _numCalendarWeekRows != null ? 'num-week-rows-$_numCalendarWeekRows' : '';

  /// An error displayed below the closed date picker.
  ///
  /// The picker also gets a red underline when this is set.
  @Input()
  String error;

  MaterialDatepickerComponent(
      HtmlElement element,
      @Attribute('popupClass') String popupClass,
      @Optional() @Inject(datepickerClock) Clock clock)
      : popupClassName = constructEncapsulatedCss(popupClass, element.classes) {
    clock ??= Clock();

    // Init minDate and maxDate to sensible defaults
    var now = clock.now();
    minDate = Date(now.year - 10, DateTime.january, 1);
    maxDate = Date(now.year + 10, DateTime.december, 31);
  }
}
