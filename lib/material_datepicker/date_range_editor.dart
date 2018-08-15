// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_calendar_picker.dart';
import 'package:angular_components/material_datepicker/material_month_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/next_prev_buttons.dart';
import 'package:angular_components/material_datepicker/preset.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/src/material_datepicker/comparison_range_editor.dart';
import 'package:angular_components/src/material_datepicker/date_range_editor_model.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/date/date_formatter.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/angular/managed_zone/interface.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/showhide/showhide.dart';

export 'package:angular_components/src/material_datepicker/date_range_editor_model.dart';

/// Everything needed to edit a [DateRangeComparison]. Glues together the preset
/// list, the text boxes, the next/prev, and the calendar. This is meant to be
/// used in the `material-date-range-picker`, and doesn't make much sense
/// outside of that component.
///
/// __Example Usage:__
///
///     <date-range-editor [model]="model" [presets]="presets">
///     </date-range-editor>
///
@Component(
  selector: 'date-range-editor',
  templateUrl: 'date_range_editor.html',
  styleUrls: ['date_range_editor.scss.css'],
  directives: [
    ButtonDirective,
    ComparisonRangeEditorComponent,
    DateRangeInputComponent,
    GlyphComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialButtonComponent,
    MaterialCalendarPickerComponent,
    materialInputDirectives,
    MaterialMonthPickerComponent,
    MaterialPopupComponent,
    MaterialRippleComponent,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialTooltipDirective,
    NextPrevComponent,
    NgFor,
    NgIf,
    PopupSourceDirective,
    ShowHideDirective,
  ],
)
class DateRangeEditorComponent implements OnInit, AfterViewInit, Focusable {
  /// A mutable model which fully describes the selected date range and the
  /// state of the calendar.
  @Input()
  DateRangeEditorModel model;

  /// Set this to false to temporarily suppress updates to the calendar's range
  /// highlights.
  ///
  /// This is useful for reducing visual noise during popup open/close
  /// animations. Defaults to true.
  @Input()
  set allowHighlightUpdates(bool value) {
    _allowHighlightUpdates = value;
  }

  bool get allowHighlightUpdates => _allowHighlightUpdates;

  bool _allowHighlightUpdates = true;

  /// Whether or not this editor includes a section to edit a comparison date
  /// range.
  ///
  /// Defaults to `true`.
  @Input()
  set supportsComparison(bool value) {
    _supportsComparison = value;
  }

  bool get supportsComparison => _supportsComparison;

  bool _supportsComparison = true;

  /// Checks if custom comparison is a valid option.
  bool get isCustomComparisonValid => model.isCustomComparisonValid;

  static final comparisonHeaderMsg = Intl.message('Compare',
      name: 'comparisonHeaderMsg',
      desc: 'Label for a toggle that turns time comparison on/off.');

  /// Whether to enable compact calendar styles.
  @Input()
  set compact(bool value) {
    _compact = value;
  }

  @HostBinding('class.compact')
  bool get compact => _compact;

  bool _compact = false;

  /// For date range selection, whether clicking to move the start date should
  /// also move the end date (preserving the length of the selected range).
  ///
  /// Defaults to true, unless an enclosing component has a different default.
  @Input()
  bool movingStartMaintainsLength = true;

  /// Whether or not this editor includes a section to input 'N days up to
  /// today' and 'N days up to yesterday' ranges.
  ///
  /// Defaults to `true`.
  @Input()
  set supportsDaysInputs(bool value) {
    _supportsDaysInputs = value;
  }

  bool get supportsDaysInputs => _supportsDaysInputs;

  bool _supportsDaysInputs = true;

  /// A list of predefined date ranges which the user can choose from. These are
  /// subject to clamping by `minDate` and `maxDate`, and are excluded entirely
  /// if their end point is before `minDate` or their start point is after
  /// `maxDate`.
  @Deprecated('Use [presets] instead.')
  @Input()
  set ranges(List<DatepickerDateRange> ranges) {
    presets = ranges.map((range) => DatepickerPreset.fromRange(range)).toList();
  }

  /// A list of preset date ranges which the user can choose from.
  ///
  /// These are subject to clamping by `minDate` and `maxDate`, and are excluded
  /// entirely if their end point is before `minDate` or their start point is
  /// after `maxDate`.
  List<DatepickerPreset> get presets => _presets;

  @Input()
  set presets(List<DatepickerPreset> presets) {
    _presets = presets;
    _updateValidPresets();
  }

  List<DatepickerPreset> _presets = [];

  // The subset of _presets which fall within minDate/maxDate (at least partly).
  // Filtered version of presets, regenerated as needed.
  Set<DatepickerPreset> _validPresets = Set<DatepickerPreset>();

  /// If the editor's inside a popup, a handle on the popup. (This is needed
  /// because we can't initialize the calendar's scroll position until after it
  /// makes it into the DOM and has been laid out. Normally this is done
  /// automatically, but when the calendar is inside a popup it needs to wait
  /// until after the popup's been laid out.)
  @Input()
  PopupRef popupHandle;

  /// Dates earlier than `minDate` cannot be chosen. Defaults to Jan 1, 1000.
  @Input()
  set minDate(Date d) {
    _minDate = d;
    _updateValidPresets();
    nextPrevModel.update(_visibleMonth, minDate, maxDate);
  }

  Date _minDate = Date(1000, DateTime.january, 1);
  Date get minDate => _minDate;

  ///  Dates later than `maxDate` cannot be chosen. Defaults to Dec 31, 9999.
  @Input()
  set maxDate(Date d) {
    _maxDate = d;
    _updateValidPresets();
    nextPrevModel.update(_visibleMonth, minDate, maxDate);
  }

  Date _maxDate = Date(9999, DateTime.december, 31);
  Date get maxDate => _maxDate;

  final Element _elementRef;
  final DomService _domService;
  final ManagedZone _managedZone;

  // This controls when the calendar is created.
  // By default, this is null, and the calendar will be created shortly
  // after this component is initialized. However, when you specify
  // calendarCreated as an input, the calendar will be created (and
  // destroyed) when your input is true (or false).
  bool _isCalendarCreated;
  bool get isCalendarCreated => _isCalendarCreated ?? false;

  @Input('calendarCreated')
  set isCalendarCreated(bool value) {
    _isCalendarCreated = value;
  }

  /// Whether or not this date range picker supports clearing date range.
  ///
  /// Default to false.
  @Input('supportsClearRange')
  bool supportsClearRange = false;

  @ViewChild(MaterialCalendarPickerComponent)
  MaterialCalendarPickerComponent calendarPicker;

  @ViewChild(MaterialMonthPickerComponent)
  MaterialMonthPickerComponent monthSelector;

  /// Whether or not this date range picker supports choosing custom range.
  /// Calendar will be hidden when custom range is not supported.
  ///
  /// Defaults to true.
  @Input('supportsCustomRange')
  bool supportsCustomRange = true;

  /// Whether to display the month selector dropdown and next-prev-buttons.
  ///
  /// Defaults to true.
  @Input()
  bool supportsMonthSelector = true;

  /// Whether to use [LastNDaysToTodayRange] to represent "N days up to today".
  @Input('relativeDaysToToday')
  bool relativeDaysToToday = false;

  static const _defaultNumDays = 30;

  set daysToToday(String value) {
    int numDays = _parseDaysInput(value);
    if (numDays == null) return;
    _daysToToday = value;
    daysToTodayRange = _createDaysToTodayRange(numDays);
    model.selectRange(daysToTodayRange.clamp(min: minDate, max: maxDate));
  }

  String get daysToToday => _daysToToday;
  String _daysToToday = '$_defaultNumDays';

  /// A range corresponding to the 'days up to today' input.
  DatepickerDateRange daysToTodayRange;

  DatepickerDateRange _createDaysToTodayRange(int numDays) =>
      relativeDaysToToday
          ? LastNDaysToTodayRange.beforeToday(_clock, numDays)
          : DatepickerDateRange('$numDays $daysToTodayMsg',
              _today.add(days: -(numDays - 1)), _today,
              isPredefined: true);

  set daysToYesterday(String value) {
    int numDays = _parseDaysInput(value);
    if (numDays == null) return;
    _daysToYesterday = value;
    daysToYesterdayRange = _createDaysToYesterdayRange(numDays);
    model.selectRange(daysToYesterdayRange.clamp(min: minDate, max: maxDate));
  }

  String get daysToYesterday => _daysToYesterday;
  String _daysToYesterday = '$_defaultNumDays';

  bool get shouldShowCustomDateRangeColumn =>
      model.shouldShowCustomDateRangeColumn;
  bool get shouldShowPredefinedList => model.shouldShowPredefinedList;

  /// Whether or not this date range picker is basic.
  ///
  /// Under 'basic' configuration. Only show pre-defined list initially.
  /// When "Custom" date range is selected, .right-column will be shown and
  /// pre-defined list will be hidden.
  bool get isBasic => model.basic;

  /// A range corresponding to the 'days to yesterday' input.
  DatepickerDateRange daysToYesterdayRange;

  DatepickerDateRange _createDaysToYesterdayRange(int numDays) =>
      LastNDaysRange.beforeToday(_clock, numDays);

  // Dart doesn't support arbitrarily large DateTimes.
  static const int _maxDaysInputLength = 4;
  int get maxDaysInputLength => _maxDaysInputLength;
  static final int _maxDays = pow(10, _maxDaysInputLength) - 1;
  int _parseDaysInput(String value) {
    int numDays;
    try {
      numDays = int.parse(value);
    } on FormatException {
      return null;
    }
    if (numDays < 1 || numDays > _maxDays) return null;
    return numDays;
  }

  Clock _clock;
  Date _today;

  DateRangeEditorComponent(
      this._elementRef,
      this._domService,
      this._managedZone,
      @Optional() DateRangeEditorHost editorHost,
      @Optional() @Inject(datepickerClock) Clock clock,
      Clock legacyClock) {
    // TODO(google): Migrate to use only datepickerClock
    _clock ??= legacyClock;
    _today = Date.today(_clock);
    editorHost?.dateRangeEditorCreated(this);
    nextPrevModel = DateRangeEditorNextPrevModel(onNext: () {
      calendarPicker.scrollToDate(_visibleMonth.add(months: 1));
    }, onPrev: () {
      calendarPicker.scrollToDate(_visibleMonth.add(months: -1));
    });
  }

  @override
  void ngOnInit() {
    daysToTodayRange = _createDaysToTodayRange(_defaultNumDays);
    daysToYesterdayRange = _createDaysToYesterdayRange(_defaultNumDays);
    if (model.basic) {
      model.shouldShowPredefinedList = true;
      model.shouldShowCustomDateRangeColumn = false;
    }
  }

  @override
  void ngAfterViewInit() {
    if (_isCalendarCreated != null) return;

    // Give the browser a chance to do other work before creating the
    // calendar component (for a snappier UX)
    _domService.nextFrame.then((_) {
      _managedZone.runInside(() {
        if (_isCalendarCreated != null) return;
        _isCalendarCreated = true;
      });
    });
  }

  @override
  void focus() {
    // Although this focus() triggers a reflow, wrapping it with scheduleWrite()
    // adds 50-100 ms to latency because the animation frame doesn't get
    // triggered for a long time (since the main calendar init takes 100+ ms,
    // requestAnimationFrame() tries to render at 10 fps).
    if (_elementRef.querySelector('.preset-list') != null) {
      _elementRef
          .querySelector('.preset-list material-select-item.selected')
          ?.focus();
    } else {
      _elementRef.querySelector('material-input.active input')?.focus();
    }
  }

  /// Event which fires when one of the ranges is selected.
  @Output()
  Stream<UIEvent> get presetRangeSelected => _controller.stream;
  final _controller = StreamController<UIEvent>.broadcast(sync: true);

  void _updateValidPresets() {
    _validPresets = Set<DatepickerPreset>();
    for (var preset in _presets) {
      if (preset.range.clamp(min: minDate, max: maxDate) != null) {
        _validPresets.add(preset);
      }
      if (preset.alternatives != null) {
        for (var alternative in preset.alternatives) {
          if (alternative.range.clamp(min: minDate, max: maxDate) != null) {
            _validPresets.add(alternative);
          }
        }
      }
    }
  }

  void onRangeClicked(UIEvent event, DatepickerDateRange range) {
    model.selectRange(range.clamp(min: minDate, max: maxDate));
    _controller.add(event);
  }

  void onAlternativePresetClicked(
      UIEvent event, DatepickerPreset parent, DatepickerPreset alternative) {
    // Replace parent preset with alternative in main menu.
    for (var i = 0; i < _presets.length; i++) {
      if (_presets[i] == parent) {
        _presets[i] = alternative;
        break;
      }
    }
    onRangeClicked(event, alternative.range);
  }

  /// Clears existing range.
  void onClearRangeClicked(UIEvent event) {
    model.selectRange(null);
    _controller.add(event);
  }

  bool get isClearRangeSelected =>
      supportsClearRange &&
      model.value != null &&
      model.value.range == null &&
      model.value.comparison == null;

  /// Replace existing range with a Custom range having the same endpoints as
  /// the current selection
  void onCustomClicked() {
    var oldRange = model.value?.range;
    if (oldRange != null) {
      model.selectRange(DatepickerDateRange.custom(oldRange.start, oldRange.end)
          .clamp(min: minDate, max: maxDate));
    }
    if (model.basic) {
      model.shouldShowPredefinedList = false;
      model.shouldShowCustomDateRangeColumn = true;
    }
  }

  void disableCustomMode() {
    if (model.basic) {
      model.shouldShowPredefinedList = true;
      model.shouldShowCustomDateRangeColumn = false;
    }
  }

  void onMonthSelectorDropdownClicked() {
    showMonthSelector = !showMonthSelector;
    if (showMonthSelector) {
      _domService.scheduleWrite(() {
        monthSelector.scrollToYear(_visibleMonth.year);
      });
    }
  }

  set monthSelectorState(CalendarState state) {
    _monthSelectorState = state;
    if (state.has(state.currentSelection)) {
      // A month was selected - switch back to the calendar picker and scroll
      // the month into view.
      showMonthSelector = false;
      _monthSelectorState =
          CalendarState.empty(resolution: CalendarResolution.months);
      final selectedMonth = state.selection(state.currentSelection);
      _domService.scheduleWrite(() {
        calendarPicker.scrollToDate(selectedMonth.start);
      });
    }
  }

  CalendarState get monthSelectorState => _monthSelectorState;
  CalendarState _monthSelectorState =
      CalendarState.empty(resolution: CalendarResolution.months);

  static final _monthFormatter = DateFormat.yMMM();
  Date _visibleMonth;

  String get visibleMonthName => _visibleMonthName;
  String _visibleMonthName = '';

  void onVisibleMonthChange(Date month) {
    _visibleMonth = month;
    _visibleMonthName = _monthFormatter.format(month.asUtcTime());
    nextPrevModel.update(_visibleMonth, minDate, maxDate);
  }

  /// The model for scrolling to the next or previous month.
  DateRangeEditorNextPrevModel nextPrevModel;

  bool showMonthSelector = false;

  bool isSelected(range) => model.value?.range?.unclamped() == range;

  bool isValid(DatepickerPreset preset) => _validPresets.contains(preset);

  bool isAlternativePresetSelected(DatepickerPreset alternative) =>
      _presets.contains(alternative);

  bool get isPredefinedRangeSelected =>
      model.value?.range?.isPredefined ?? false;

  bool get isCustomRangeSelected =>
      !isClearRangeSelected && !isPredefinedRangeSelected;

  String get rangeTitle => model.value?.range?.title ?? '';

  String get customRangeDescription => formatRange(model.range.value);

  static final navigateBeforeMsg = Intl.message('Previous date range',
      name: 'navigateBeforeMsg',
      meaning: 'Update the calendar display to show the previous time period.',
      desc: 'Label for control button which changes the range of dates shown in'
          'the calendar to the previous range of dates.');

  static final navigateNextMsg = Intl.message('Next date range',
      name: 'navigateNextMsg',
      meaning: 'Update the calendar display to show the next time period',
      desc: 'Label for control button which changes the range of dates shown in'
          'the calendar to the next range of dates.');

  static final clearRangeMsg = Intl.message('Clear date range',
      name: 'DateRangeEditorComponent_clearRangeMsg',
      meaning: 'Clear the current range.',
      desc: 'Label for an option in the preset list at the left which '
          'clears the current selection.');

  static final customRangeMsg = Intl.message('Custom',
      name: 'DateRangeEditorComponent_customRangeMsg',
      meaning: 'Replace the current range with a Custom range that has the '
          'same endpoints.',
      desc: 'Label for an option in the preset list at the left which '
          'replaces the current selection with a "Custom" range.');

  // TODO(google): Check if some locales require text before the input.
  static final daysToTodayMsg = Intl.message('days up to today',
      name: 'daysToTodayMsg',
      desc: 'Label for number input which changes the range of dates shown in'
          ' the calendar to [today - number, today].');

  static final daysToYesterdayMsg = Intl.message('days up to yesterday',
      name: 'daysToYesterdayMsg',
      desc: 'Label for number input which changes the range of dates shown in'
          ' the calendar to [yesterday - number, yesterday].');

  static final rangeDisabledTooltip = Intl.message('No days available',
      name: 'DateRangeEditorComponent_rangeDisabledTooltip',
      desc: 'Message that explains why a date range is invalid.');
}

abstract class DateRangeEditorHost {
  void dateRangeEditorCreated(DateRangeEditorComponent editor);
}

typedef void NextPrevCallback();

class DateRangeEditorNextPrevModel implements Sequential {
  final NextPrevCallback onNext;
  final NextPrevCallback onPrev;

  DateRangeEditorNextPrevModel({this.onNext, this.onPrev});

  @override
  ObservableReference<bool> hasNext = ObservableReference<bool>(false);

  @override
  ObservableReference<bool> hasPrev = ObservableReference<bool>(false);

  @override
  void next() => onNext();

  @override
  void prev() => onPrev();

  void update(Date visibleMonth, Date minDate, Date maxDate) {
    if (visibleMonth == null) return;
    hasPrev.value = compareDatesAtResolution(
            visibleMonth, minDate, CalendarResolution.months) >
        0;
    hasNext.value = compareDatesAtResolution(
            visibleMonth, maxDate, CalendarResolution.months) <
        0;
  }
}
