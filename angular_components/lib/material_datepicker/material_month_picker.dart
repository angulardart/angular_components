// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';

import '../src/material_datepicker/calendar_listener.dart';
import '../src/material_datepicker/enum_parsing.dart';

/// An material-styled calendar which supports selecting single months or month
/// ranges.
///
/// __Attributes:__
///
/// - `mode` -- What sort of interaction this calendar supports. Valid values
///   are "none", "single-date", or "date-range". Defaults to "none".
@Component(
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'material-month-picker',
  styleUrls: ['material_month_picker.scss.css'],
  templateUrl: 'material_month_picker.html',
)
class MaterialMonthPickerComponent
    implements OnInit, AfterChanges, AfterViewInit, OnDestroy {
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

  /// Dates earlier than `minDate` cannot be clicked on or scrolled to.
  ///
  /// The calendar will display the entire year containing this date, but months
  /// before `minDate` will be disabled (greyed out). Note that disabled dates
  /// can still be selected programmatically, e.g. if the parent component
  /// specifies presets which extend past minDate/maxDate. Defaults to January,
  /// ten years ago. Set this to the earliest date which makes sense in your
  /// domain context. e.g. The earliest date for which data is available for
  /// analysis.
  @Input()
  set minDate(Date newDate) {
    if (newDate == _minDate) return;
    _minDate = newDate;
    _isResetNeeded = true;
  }

  Date get minDate => _minDate;
  Date _minDate;

  /// Dates later than `maxDate` cannot be clicked on or scrolled to.
  ///
  /// The calendar will display the entire year containing this date, but months
  /// after `maxDate` will be disabled (greyed out). Note that disabled dates
  /// can still be selected programmatically, e.g. if the parent component
  /// specifies presets which extend past minDate/maxDate. Defaults to December,
  /// ten years in the future. Set this to the latest date which makes sense in
  /// your domain context. e.g. For apps which analyse historical data, this
  /// could be the current month.
  @Input()
  set maxDate(Date newDate) {
    if (newDate == _maxDate) return;
    _maxDate = newDate;
    _isResetNeeded = true;
  }

  Date get maxDate => _maxDate;
  Date _maxDate;

  /// What sort of interaction this calendar supports.
  CalendarSelectionMode get mode => _mode;
  CalendarSelectionMode _mode = CalendarSelectionMode.NONE;

  static const int _monthHeight = 36;
  static const int _yearHeight = 4 * _monthHeight;

  static const _yearAttribute = 'data-year';
  static const _monthAttribute = 'data-month';

  static final _monthNames = DateFormat().dateSymbols.SHORTMONTHS;

  static final _yearTemplate = _createYearTemplate();
  static final _yearTemplateContainer = DivElement();
  static final _yearTemplateTitle = HeadingElement.h2();

  static DocumentFragment _createYearTemplate() {
    final template = DocumentFragment();

    // Create the year container element.
    _yearTemplateContainer.className = 'year';
    template.append(_yearTemplateContainer);

    // Create the year title element.
    _yearTemplateTitle.className = 'year-title';
    _yearTemplateContainer.append(_yearTemplateTitle);

    // Create the month elements.
    final monthTemplate = DivElement()..className = 'month';
    for (var i = 0; i < 12; i++) {
      HtmlElement month = monthTemplate.clone(true);
      month
        ..setAttribute(_monthAttribute, '${i + 1}')
        ..text = _monthNames[i];
      _yearTemplateContainer.append(month);
    }

    return template;
  }

  static DocumentFragment _renderYear(int year) {
    _yearTemplateContainer.setAttribute(_yearAttribute, year.toString());
    _yearTemplateTitle.text = year.toString();
    return _yearTemplate.clone(true);
  }

  void _scrollToSelection() {
    if (state.selections.isEmpty) return;

    final currentSelection = state.selections
        .firstWhere((s) => s.id == state.currentSelection, orElse: () => null);
    if (currentSelection == null) return;

    scrollToYear(state.previewAnchoredAtStart
        ? currentSelection.end.year
        : currentSelection.start.year);
  }

  void _onCalendarChange(CalendarState state) {
    if (state.cause == CausedBy.external) {
      _scrollToSelection();
    }
    _resetHighlights();
    _renderHighlights();
    _renderHover();
  }

  void _resetHighlights() {
    for (HtmlElement element in _container.querySelectorAll('.year-title')) {
      element.className = 'year-title';
    }
    for (HtmlElement element
        in _container.querySelectorAll('.month:not(.disabled)')) {
      element.className = 'month';
    }
  }

  void _renderRange(CalendarSelection selection) {
    HtmlElement start;
    HtmlElement end;

    start = _container.querySelector(_monthSelector(selection.start));
    if (start == null) return;
    start.classes.addAll(const ['boundary', 'start']);

    end = _container.querySelector(_monthSelector(selection.end));
    if (end == null) return;
    end.classes.addAll(const ['boundary', 'end']);

    // If it's a single month range, we're done.
    if (start == end) return;

    var range = Range()
      ..setStartBefore(start)
      ..setEndAfter(end);

    // Highlight the selected months in the starting year.
    _highlightElements(start, end.nextElementSibling);

    // Highlight any remaining months in subsequent years.
    // The outer loop iterates over the year containers; the inner loop
    // iterates over the months within each year.
    HtmlElement startContainer = range.startContainer;
    HtmlElement endContainer = range.endContainer;
    for (HtmlElement year = startContainer.nextElementSibling;
        year != null && year != endContainer.nextElementSibling;
        year = year.nextElementSibling) {
      _highlightElements(year.firstChild, end.nextElementSibling);
    }
  }

  void _highlightElements(HtmlElement start, HtmlElement end) {
    for (HtmlElement element = start;
        element != null && element != end;
        element = element.nextElementSibling) {
      element.classes.add('highlight');
    }
  }

  void _renderHighlights() {
    for (var selection in state.selections) {
      _renderRange(selection);
    }
  }

  void _renderHover() {
    HtmlElement element = _container.querySelector('.month.hover');
    if (element != null) element.classes.remove('hover');
    if (_model.value.preview != null) {
      element = _container.querySelector(_monthSelector(_model.value.preview));
      if (element != null) element.classes.add('hover');
    }
  }

  bool _canSelectDate(Date date) {
    if (date == null) return false;
    return compareDatesAtResolution(date, minDate, state.resolution) >= 0 &&
        compareDatesAtResolution(date, maxDate, state.resolution) <= 0;
  }

  String _monthSelector(Date date) => '.year[$_yearAttribute="${date.year}"] '
      '.month[$_monthAttribute="${date.month}"]';

  // Needed so we can circle the current date.
  Date _today;

  // The .scroll-container element.
  HtmlElement _scroller;

  // The .calendar-container element.
  HtmlElement _container;

  // Whether to completely reset (redraw) the view at the end of the change
  // detection cycle.
  bool _isResetNeeded = true;

  CalendarListener _inputListener = CalendarListener.noop();
  StreamSubscription _calendarStream;

  MaterialMonthPickerComponent(@Optional() @Inject(datepickerClock) Clock clock,
      @Attribute('mode') String mode) {
    clock ??= Clock();

    // Init minDate and maxDate to sensible defaults
    var now = clock.now();
    minDate = Date(now.year - 10, DateTime.january, 1);
    maxDate = Date(now.year + 10, DateTime.december, 31);

    _today = Date.today(clock);

    if (mode != null && mode.isNotEmpty) {
      _mode = fuzzyParseEnum(CalendarSelectionMode.values, mode);
    }
  }

  @ViewChild('container')
  set container(Element container) {
    _container = container;
    _scroller = container.parent;
  }

  @override
  void ngOnInit() {
    _calendarStream = _model.stream.listen(_onCalendarChange);

    if (_mode == CalendarSelectionMode.SINGLE_DATE) {
      _inputListener = CalendarListener.singleDate(_model);
    } else if (_mode == CalendarSelectionMode.DATE_RANGE) {
      // TODO(google): Add support for movingStartMaintainsLength==false if
      // we see use cases for month range picking.
      _inputListener =
          CalendarListener.dateRange(_model, movingStartMaintainsLength: true);
    }
  }

  @override
  void ngAfterChanges() {
    if (_isResetNeeded) {
      _resetView();
    }
    _isResetNeeded = false;
  }

  @override
  void ngAfterViewInit() {
    _addEventListeners();
  }

  @override
  void ngOnDestroy() {
    _calendarStream?.cancel();
    _removeEventListeners();
  }

  /// Scroll the view so that [year] becomes visible.
  void scrollToYear(int year) {
    _scroller.scrollTop = (year - minDate.year) * _yearHeight;
  }

  void _renderAllYears() {
    _container.children.clear();

    for (var i = minDate.year; i <= maxDate.year; i++) {
      _container.append(_renderYear(i));
    }

    // Disable all months before minDate.
    HtmlElement element;
    for (var i = 1; i < minDate.month; i++) {
      element =
          _container.querySelector(_monthSelector(Date(minDate.year, i, 1)));
      element.classes.add('disabled');
    }

    // Disable all months after maxDate.
    for (var i = maxDate.month + 1; i <= 12; i++) {
      element =
          _container.querySelector(_monthSelector(Date(maxDate.year, i, 1)));
      element.classes.add('disabled');
    }
  }

  void _resetView() {
    final initialDate =
        state.selections.isEmpty ? _today : state.selections.first.start;
    _renderAllYears();
    scrollToYear(initialDate.year);
    _renderHighlights();
    _renderHover();
  }

  // Dart returns a separate instance every time a tearoff is accessed, so we
  // need to cache them for removeEventListener to work.
  EventListener _clickListener;
  EventListener _mouseDownListener;
  EventListener _mouseMoveListener;
  EventListener _mouseLeaveListener;

  void _addEventListeners() {
    // Process the events outside of Angular for lower overhead.
    _container
      ..addEventListener('click', _clickListener = _onClick)
      ..addEventListener('mousedown', _mouseDownListener = _onMouseDown)
      ..addEventListener('mousemove', _mouseMoveListener = _onMouseMove)
      ..addEventListener('mouseleave', _mouseLeaveListener = _onMouseLeave);
  }

  void _removeEventListeners() {
    _container
      ..removeEventListener('click', _clickListener)
      ..removeEventListener('mousedown', _mouseDownListener)
      ..removeEventListener('mousemove', _mouseMoveListener)
      ..removeEventListener('mouseleave', _mouseLeaveListener);
  }

  Date _extractDate(Event event) {
    final target = event.target;
    if (target is! HtmlElement) return null;
    HtmlElement monthElement = target;

    final month = monthElement.getAttribute(_monthAttribute);
    if (month == null) return null;

    final year = monthElement.parent.getAttribute(_yearAttribute);
    if (year == null) return null;

    return Date(int.parse(year), int.parse(month), 1);
  }

  void _onClick(Event event) {
    var date = _extractDate(event);
    if (_canSelectDate(date)) {
      _inputListener.onClick(date);
    }
  }

  void _onMouseDown(Event event) {
    var date = _extractDate(event);
    if (_canSelectDate(date)) {
      _inputListener.onMouseDown(date);
    }
  }

  void _onMouseMove(Event event) {
    var date = _extractDate(event);
    if (_canSelectDate(date)) {
      _inputListener.onMouseMove(date);
    }
  }

  void _onMouseLeave(Event event) {
    var date = _extractDate(event);
    if (_canSelectDate(date)) {
      _inputListener.onMouseLeave(date);
    }
  }
}
