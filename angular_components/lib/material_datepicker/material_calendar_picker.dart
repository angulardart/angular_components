// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:js_util';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart'
    show isEdge, isFirefox;

import '../src/material_datepicker/calendar_listener.dart';
import '../src/material_datepicker/enum_parsing.dart';

const _dayOfWeekTable = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];

/// Returns the day of the week for the given date [0 = Sun, 6 = Sat].
int _dayOfWeek(int year, int month, int day) {
  // https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week
  if (month < 3) {
    year -= 1;
  }
  // Constrain year to unsigned int, so dart2js can compile year ~/ 4 to
  // (year / 4) | 0 (for optimal performance).
  // Note: it's important for this to come after year -= 1. Otherwise year
  // could still be < 0.
  year = 0xffff & year;
  return (year +
          year ~/ 4 -
          year ~/ 100 +
          year ~/ 400 +
          _dayOfWeekTable[month - 1] +
          day)
      .remainder(7);
}

/// An infinitely-scrolling material-styled calendar which supports selecting
/// single dates or date ranges.
///
/// You probably want to use `material-datepicker` or
/// `material-date-range-picker` instead of this.
///
/// __Attributes:__
///
/// - `mode` -- What sort of interaction this calendar supports. Valid values
///   are "none", "single-date", or "date-range". Defaults to "none".
///
/// __Styling:__
///
/// Calendar selections are blue by default. The color of selections can be
/// customized using the `calendar-highlights` SCSS mixin.
///
/// Selected ranges have IDs, which are used to pick the right style out of the
/// mixin. For example, the standard date range picker uses this styling:
///
/// ``` Scss
///  @include calendar-highlights('.calendar', (
///    range: $mat-blue-map,
///    comparison: $mat-google-yellow-map,
///    range comparison: $mat-green-map,
///  ));
/// ```
///
/// This sets the primary date range (which has the ID "range") to blue, the
/// comparison date range to yellow, and the overlap to green. The overlap color
/// has to be specified manually; the calendar doesn't try to blend the colors
/// automatically.
///
@Component(
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [NgFor],
  selector: 'material-calendar-picker',
  styleUrls: ['material_calendar_picker.scss.css'],
  templateUrl: 'material_calendar_picker.html',
)
class MaterialCalendarPickerComponent
    implements OnInit, AfterChanges, AfterViewInit, OnDestroy {
  /// The height of the each calendar date, in pixels.
  static const DATE_HEIGHT_PX = 48; // DUPLICATED in _constants.scss
  static const DATE_COMPACT_HEIGHT_PX = 36; // DUPLICATED in _constants.scss

  /// Months can have up to 6 partial weeks. We also may need space for a
  /// title, but a 6-week month will always have an inline title.
  /// (Proof: Longest month is 31 days. 28 of those days will appear in the
  /// middle 4 weeks, leaving 3 days. To reach 6 weeks, there must be at least
  /// 1 day before and after the middle 4 weeks. Therefore there can be at
  /// most 2 days in the first week, giving enough space for an inline title.)
  static const WEEK_ROWS_IN_MONTH = 6; // DUPLICATED in _constants.scss

  /// How many extra months to draw in either direction.
  static const _overdraw = 2;

  /// The portion of a month that should be visible for it to be considered
  /// "in view".
  static const _inViewThreshold = 0.5;

  /// The number of slots to reserve for the month titles.
  static const _monthTitleWidth = 3;

  static const _dateAttribute = 'data-date';
  static const _dateSeparator = '-';

  static int _rotateDayOfWeek(int numDays, int dayOfWeek) =>
      (dayOfWeek + numDays).remainder(7);

  /// Index of the first day of the week [0 = Sun, 6 = Sat].
  static final int _firstDayOfWeek =
      _rotateDayOfWeek(1, DateFormat().dateSymbols.FIRSTDAYOFWEEK);

  /// Maps [dayOfWeek] from [0 = Sun, 6 = Sat] to
  /// [0 = first day of week, 6 = last day of week].
  static int _dayOfWeekIndex(int dayOfWeek) =>
      _rotateDayOfWeek(-_firstDayOfWeek, dayOfWeek);

  static final _defaultDayNames =
      DateFormat().dateSymbols.STANDALONENARROWWEEKDAYS;
  // Shift so that the first element is the first day of the week.
  static final _dayNames = _defaultDayNames.sublist(_firstDayOfWeek)
    ..addAll(_defaultDayNames.sublist(0, _firstDayOfWeek));

  static final DocumentFragment _monthTemplate = _createMonthTemplate();

  static DocumentFragment _createMonthTemplate() {
    final template = DocumentFragment();

    // Create the month container element.
    final container = DivElement()..className = 'month';
    template.append(container);

    // Create the title element.
    final title = HeadingElement.h2()
      ..className = 'month-title'
      ..appendText('');
    container.append(title);

    // Add 6 rows of 7 slots.
    final slotTemplate = DivElement()
      ..className = 'day-slot'
      ..appendText('');
    DivElement slot;
    for (var i = 0; i < WEEK_ROWS_IN_MONTH * 7; i++) {
      slot = slotTemplate.clone(true);
      container.append(slot);
    }

    return template;
  }

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

  /// Fired when the visible month changes -- e.g. when a new month scrolls into
  /// view.
  @Output()
  Stream<Date> get visibleMonth => _visibleMonthController.stream;
  final _visibleMonthController = StreamController<Date>.broadcast();

  /// Set this to false to temporarily suppress updates to the calendar's range
  /// highlights.
  ///
  /// Defaults to true.
  @Input()
  set allowHighlightUpdates(bool value) {
    var nowAllowed = value;
    if (_allowHighlightUpdates != nowAllowed) {
      _allowHighlightUpdates = nowAllowed;
      if (nowAllowed) _onCalendarChange(_model.value);
    }
  }

  bool get allowHighlightUpdates => _allowHighlightUpdates;
  bool _allowHighlightUpdates = true;

  /// Dates earlier than `minDate` cannot be clicked on or scrolled to.
  ///
  /// The calendar will display the entire month containing this date, but days
  /// before `minDate` will be disabled (greyed out). Note that disabled dates
  /// can still be selected programmatically, e.g. if the parent component
  /// specifies presets which extend past minDate/maxDate. Defaults to January
  /// 1, ten years ago. Set this to the earliest date which makes sense in your
  /// domain context. e.g. The earliest date for which data is available for
  /// analysis.
  @Input()
  set minDate(Date newDate) {
    if (newDate == _minDate) return;
    _minDate = newDate;
    _minMonth = _Month.fromDate(_minDate);
    _isResetNeeded = true;
  }

  Date get minDate => _minDate;
  Date _minDate;
  _Month _minMonth;

  /// Dates later than `maxDate` cannot be clicked on or scrolled to.
  ///
  /// The calendar will display the entire month containing this date, but days
  /// after `maxDate` will be disabled (greyed out). Note that disabled dates
  /// can still be selected programmatically, e.g. if the parent component
  /// specifies presets which extend past minDate/maxDate. Defaults to December
  /// 31, ten years in the future. Set this to the latest date which makes sense
  /// in your domain context. e.g. For apps which analyse historical data, this
  /// could be the current day.
  @Input()
  set maxDate(Date newDate) {
    if (newDate == _maxDate) return;
    _maxDate = newDate;
    _maxMonth = _Month.fromDate(_maxDate);
    _isResetNeeded = true;
  }

  Date get maxDate => _maxDate;
  Date _maxDate;
  _Month _maxMonth;

  /// Whether to enable compact calendar styles.
  @Input()
  set compact(bool value) {
    _compact = value;
    _isResetNeeded = true;
  }

  @HostBinding('class.compact')
  bool get compact => _compact;
  bool _compact = false;

  /// For date range selection, whether clicking to move the start date should
  /// also move the end date (preserving the length of the selected range).
  ///
  /// Defaults to true, unless an enclosing component has a different default.
  @Input()
  set movingStartMaintainsLength(bool value) {
    _movingStartMaintainsLength = value;

    // Must recreate the input listener when this changes. If it wasn't already
    // created, we must be executing before [ngOnInit], so defer to later.
    if (_inputListener != null) {
      _initInputListener();
    }
  }

  bool _movingStartMaintainsLength = true;

  /// What sort of interaction this calendar supports.
  CalendarSelectionMode get mode => _mode;
  CalendarSelectionMode _mode = CalendarSelectionMode.NONE;

  /// Names of each day of the week.
  List<String> get dayNames => _dayNames;

  /// The height of each calendar row, in pixels.
  int get _rowHeightPx => compact ? DATE_COMPACT_HEIGHT_PX : DATE_HEIGHT_PX;

  int _monthHeight(_Month month) {
    int startOffset = _dayOfWeekIndex(month.startDay);
    if (startOffset < _monthTitleWidth) startOffset += 7;
    int slots = startOffset + month.days;
    int rows = (slots / 7).ceil();
    return rows * _rowHeightPx;
  }

  int _rangeHeight(_Month start, _Month end) {
    if (end < start) return -_rangeHeight(end, start);
    int total = 0;
    for (var month = start.copy(); month < end; month.next()) {
      total += _monthHeight(month);
    }
    return total;
  }

  _Month _monthAtOffset(int offset) {
    _Month month;
    int total = 0;
    for (month = _minMonth.copy();
        total < offset && month < _maxMonth;
        month.next()) {
      total += _monthHeight(month);
    }
    // Use the previous month if it's mostly in view.
    int previousMonthVisiblePx = total - offset;
    if (previousMonthVisiblePx / _monthHeight(month.add(-1)) >
        _inViewThreshold) {
      month.prev();
    }
    return month;
  }

  bool _canSelectDate(Date date) {
    if (date == null) return false;
    return date >= minDate && date <= maxDate;
  }

  Date _extractDate(Event event) {
    final slot = event.target;
    if (slot is! HtmlElement) return null;

    final dateText = (slot as HtmlElement).getAttribute(_dateAttribute);
    if (dateText == null) return null;

    final parts = dateText.split(_dateSeparator);
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    return Date(year, month, day);
  }

  List<_Month> _monthsSurrounding(_Month baseline) {
    final start = baseline.add(-_overdraw);
    final end = baseline.add(_overdraw);
    final result = <_Month>[];
    for (var month = start; month <= end; month.next()) {
      result.add(month.copy());
    }
    return result;
  }

  void _resetContainerHeight() {
    int totalHeight =
        _rangeHeight(_minMonth, _maxMonth) + _monthHeight(_maxMonth);
    _container.style.height = '${totalHeight}px';
  }

  void _scrollToMonth(_Month month) {
    _container.parent.scrollTop = _rangeHeight(_minMonth, month);
  }

  /// Scroll the calendar so that [date] becomes visible.
  void scrollToDate(Date date) {
    _scrollToMonth(_Month.fromDate(date));
  }

  void _setText(HtmlElement slot, String text) {
    // This is much faster than the obvious slot.text = text. It reuses the
    // existing TextNode instead of creating a new one every time. It's also
    // faster than slot.firstChild.text = text (which also reuses the TextNode),
    // because TextNode.nodeValue doesn't trigger a layout in Firefox (which is
    // important because Firefox doesn't support CSS containment). However, in
    // Edge, reusing the TextNode doesn't trigger a repaint, so we have to
    // create a new TextNode instead.
    if (isEdge) {
      slot.text = text;
    } else {
      setProperty(slot.firstChild, 'nodeValue', text);
    }
  }

  void _renderMonth(_Month month, HtmlElement container) {
    int startIndex = _dayOfWeekIndex(month.startDay);
    if (startIndex < _monthTitleWidth) startIndex += 7;
    final daysInMonth = month.days;

    // The month container consists of a title element followed by 42 day slots.
    HtmlElement title = container.firstChild;
    _setText(title, month.title);

    // Render the days.
    bool isFirstMonth = month == _minMonth;
    bool isLastMonth = month == _maxMonth;
    HtmlElement slot = title.nextElementSibling;
    for (var i = 1; i <= 7 * WEEK_ROWS_IN_MONTH; i++) {
      final day = i - startIndex;
      if (day <= 0 || day > daysInMonth) {
        slot.className = 'day-slot invisible';
      } else if ((isFirstMonth && day < _minDate.day) ||
          (isLastMonth && day > _maxDate.day)) {
        slot.className = 'day-slot disabled';
        if (isFirefox) {
          _setText(slot, day.toString());
        }
      } else {
        slot.className = 'day-slot visible';
        slot.setAttribute(
            _dateAttribute, _dateAttributeValue(month.year, month.month, day));
        // Firefox is much slower than other browsers when using CSS counters
        // (because they trigger layout in Firefox). However, setting the text
        // directly is fast in Firefox (because it doesn't trigger layout in
        // Firefox!).
        if (isFirefox) {
          _setText(slot, day.toString());
        }
      }
      slot = slot.nextElementSibling;
    }
  }

  void _renderVisible() {
    // Determine which months are visible (+/- overdraw).
    _Month baseline;
    int offset;
    if (_renderedMonths.isEmpty) {
      baseline = _monthAtOffset(_scrollTop);
      offset = _rangeHeight(_minMonth, baseline.add(-_overdraw));
    } else {
      offset = _renderedOffsets[_overdraw];

      // If the previous middle month is below the current viewport, rewind
      // until it's before the viewport.
      if (offset >= _scrollTop) {
        baseline = _renderedMonths[_overdraw].copy();
        while (offset >= _scrollTop && baseline >= _minMonth) {
          baseline.prev();
          offset -= _monthHeight(baseline);
        }
      }

      // Iterate until we find the middle month.
      for (baseline ??= _renderedMonths[_overdraw].copy();
          offset < _scrollTop && baseline < _maxMonth;
          baseline.next()) {
        offset += _monthHeight(baseline);
      }

      // Use the previous month if it's mostly in view.
      int previousMonthVisiblePx = offset - _scrollTop;
      int previousMonthHeight = _monthHeight(baseline.add(-1));
      if (previousMonthVisiblePx / previousMonthHeight > _inViewThreshold) {
        offset -= previousMonthHeight;
        baseline.prev();
      }

      // Subtract the distance between the middle month and the first month to
      // get the y-offset of the first month.
      offset += _rangeHeight(baseline, baseline.add(-_overdraw));
    }
    final visibleMonths = _monthsSurrounding(baseline);
    final neededMonths =
        visibleMonths.where((m) => !_renderedMonths.contains(m));
    if (neededMonths.isEmpty) return;

    // Render the missing months (reusing existing ones).
    _renderedOffsets.clear();
    HtmlElement panel = _container.firstChild;
    for (var month in visibleMonths) {
      _renderMonth(month, panel);
      panel.style.cssText = 'transform: translateY(${offset}px)';
      _renderedOffsets.add(offset);
      panel = panel.nextElementSibling;
      offset += _monthHeight(month);
    }

    // Edge shows some issues with CSS counters not getting reset properly when
    // reusing DOM nodes as above. So as a workaround, we move everything into a
    // fragment, then reappend it to the container. This is still faster than
    // setting textContent for each slot.
    if (isEdge) {
      var fragment = DocumentFragment();
      for (HtmlElement month = _container.firstChild;
          month != null;
          month = _container.firstChild) {
        fragment.append(month);
      }
      _container.append(fragment);
    }

    _renderedMonths = visibleMonths;
    _renderHighlights();
    _renderToday();
    _renderHover();

    _visibleMonthController.add(baseline.start);
  }

  String _slotSelector(Date date) {
    final value = _dateAttributeValue(date.year, date.month, date.day);
    return '.day-slot.visible[$_dateAttribute="$value"]';
  }

  // This is inlined and compiles to concatenation with + (faster than using
  // List.join - avoids constructing a list and calling a loop each time).
  String _dateAttributeValue(int year, int month, int day) =>
      '$year$_dateSeparator$month$_dateSeparator$day';

  void _renderRange(CalendarSelection selection) {
    if (selection.start > selection.end) return;

    HtmlElement start;
    HtmlElement end;
    final startMonth = _Month.fromDate(selection.start);
    final endMonth = _Month.fromDate(selection.end);
    final highlightClass = 'highlight-${selection.id}';
    final boundaryClass = 'boundary-${selection.id}';

    if (startMonth >= _renderedMonths.first &&
        startMonth <= _renderedMonths.last) {
      start = _container.querySelector(_slotSelector(selection.start));
      if (start == null) return;
      start.classes.add('boundary');
      start.classes.add(boundaryClass);
      start.classes.add('start');
    } else if (startMonth < _renderedMonths.first &&
        endMonth >= _renderedMonths.first) {
      start = _container
          .querySelector('.month:first-of-type .day-slot:first-of-type');
    }

    if (endMonth >= _renderedMonths.first && endMonth <= _renderedMonths.last) {
      end = _container.querySelector(_slotSelector(selection.end));
      if (end == null) return;
      end.classes.add('boundary');
      end.classes.add(boundaryClass);
      end.classes.add('end');
    } else if (startMonth <= _renderedMonths.last &&
        endMonth > _renderedMonths.last) {
      end = _container
          .querySelector('.month:last-of-type .day-slot:last-of-type');
    }

    // If it's out of view, we're done.
    if (start == null && end == null) return;

    // Highlight the active endpoint in bold.
    if (selection.id == state.currentSelection) {
      if (state.previewAnchoredAtStart && end != null) {
        end.classes.add('active');
      } else if (start != null) {
        start.classes.add('active');
      }
    }

    var range = Range()
      ..setStartBefore(start)
      ..setEndAfter(end);

    // Fill in the range in the starting month.
    _highlightElements(start, end.nextElementSibling, highlightClass);

    // Fill in any remaining months.
    HtmlElement startContainer = range.startContainer;
    HtmlElement endContainer = range.endContainer;
    for (HtmlElement month = startContainer.nextElementSibling;
        month != null && month != endContainer.nextElementSibling;
        month = month.nextElementSibling) {
      _highlightElements(
          month.firstChild, end.nextElementSibling, highlightClass);
    }
  }

  void _highlightElements(
      HtmlElement start, HtmlElement end, String highlightClass) {
    for (HtmlElement current = start;
        current != null && current != end;
        current = current.nextElementSibling) {
      _highlightElement(current, highlightClass);
    }
  }

  void _highlightElement(HtmlElement el, String highlightClass) {
    el.classes.add('highlight');
    el.classes.add(highlightClass);
  }

  void _resetHighlights() {
    // Remove all highlight classes.
    final classes = ['visible', 'invisible', 'hidden'];
    for (var className in classes) {
      final selector = '.day-slot.$className';
      for (HtmlElement el in _container.querySelectorAll(selector)) {
        el.className = 'day-slot $className';
      }
    }
  }

  void _renderHighlights() {
    var selections = <CalendarSelection>[];
    for (var selection in state.selections) {
      selections.add(selection.clamp(min: minDate, max: maxDate));
    }

    // If applicable, render the preview style for the previewed range.
    if (state.preview != null && state.has(state.currentSelection)) {
      // Simulate applying the selection to get the [CalendarSelection] that
      // would be created if it were actually applied. Since [CalendarState] is
      // immutable, this doesn't modify any state.
      var previewState = state.confirmPreview(
          movingStartMaintainsLength: _movingStartMaintainsLength);
      var previewRange = previewState
          .selection(previewState.currentSelection)
          .clamp(min: minDate, max: maxDate);
      selections.add(
          CalendarSelection('preview', previewRange.start, previewRange.end));
    }

    // Add the new highlight classes.
    for (var selection in selections) {
      _renderRange(selection);
    }

    // Fix overlapping highlight boundaries (if applicable).
    if (selections.length <= 1) return;
    for (var i = 0; i < selections.length; i++) {
      for (var j = 0; j < selections.length; j++) {
        if (i == j) continue;
        var a = selections[i];
        var b = selections[j];
        if (a.contains(b.start) && a.start < b.start) {
          HtmlElement start = _container.querySelector(_slotSelector(b.start));
          if (start != null) {
            start.classes.add('left');
            start.classes.add('left-${a.id}');
          }
        }
        if (a.contains(b.end) && a.end > b.end) {
          HtmlElement end = _container.querySelector(_slotSelector(b.end));
          if (end != null) {
            end.classes.add('right');
            end.classes.add('right-${a.id}');
          }
        }
      }
    }
  }

  void _renderToday() {
    HtmlElement el = _container.querySelector('.day-slot.today');
    if (el != null) el.classes.remove('today');
    el = _container.querySelector(_slotSelector(_today));
    if (el != null) el.classes.add('today');
  }

  void _renderHover() {
    HtmlElement el = _container.querySelector('.day-slot.hover');
    if (el != null) el.classes.remove('hover');
    if (_model.value.preview != null) {
      el = _container.querySelector(_slotSelector(_model.value.preview));
      if (el != null) el.classes.add('hover');
    }
  }

  void _ensureSelectionIsVisible() {
    if (_renderedMonths.isEmpty) return;
    if (state.selections.isEmpty) return;

    final currentSelection = state.selections
        .firstWhere((s) => s.id == state.currentSelection, orElse: () => null);
    if (currentSelection == null) return;

    final startMonth = _Month.fromDate(currentSelection.start);
    final endMonth = _Month.fromDate(currentSelection.end);
    final middleMonth = _renderedMonths[_overdraw];

    if (startMonth > middleMonth || endMonth < middleMonth) {
      _scrollToMonth(state.previewAnchoredAtStart ? endMonth : startMonth);
    }
  }

  void _onCalendarChange(CalendarState state) {
    if (allowHighlightUpdates) {
      if (state.cause == CausedBy.external) {
        _ensureSelectionIsVisible();
      }
      if (!_isRenderScheduled) {
        window.requestAnimationFrame((_) {
          _resetHighlights();
          _renderHighlights();
          _renderToday();
          _renderHover();
        });
      }
    }
  }

  Date get _initialDate =>
      state.selections.isEmpty ? _today : state.selections[0].start;

  // Needed so we can circle the current date.
  Date _today;

  // Whether a render operation is currently pending.
  bool _isRenderScheduled = true;

  // Whether to completely reset (redraw) the view at the end of the change
  // detection cycle.
  bool _isResetNeeded = false;

  // Whether the component has finished the initial render.
  bool _isInitialized = false;

  // Months which are currently in the DOM.
  List<_Month> _renderedMonths = [];

  // Y-offsets corresponding to each rendered month.
  final List<int> _renderedOffsets = [];

  // The .scroll-container element.
  HtmlElement _scroller;

  // The .calendar-container element.
  HtmlElement _container;

  // Cached _scroller.scrollTop (to separate DOM reads from writes).
  int _scrollTop = 0;

  CalendarListener _inputListener = CalendarListener.noop();
  StreamSubscription _calendarStream;

  MaterialCalendarPickerComponent(
      @Optional() @Inject(datepickerClock) Clock clock,
      Clock legacyClock,
      @Attribute('mode') String mode) {
    // TODO(google): Migrate to use only datepickerClock
    clock ??= legacyClock;

    _today = Date.today(clock);

    // Init minDate and maxDate to sensible defaults
    var now = clock.now();
    minDate = Date(now.year - 10, DateTime.january, 1);
    maxDate = Date(now.year + 10, DateTime.december, 31);

    if (mode != null && mode.isNotEmpty) {
      _mode = fuzzyParseEnum(CalendarSelectionMode.values, mode);
    }
  }

  @ViewChild('container')
  set container(HtmlElement container) {
    _container = container;
    _scroller = container.parent;
  }

  @override
  void ngOnInit() {
    _calendarStream = _model.stream.listen(_onCalendarChange);

    _initInputListener();
  }

  void _initInputListener() {
    if (_mode == CalendarSelectionMode.SINGLE_DATE) {
      _inputListener = CalendarListener.singleDate(_model);
    }
    if (_mode == CalendarSelectionMode.DATE_RANGE) {
      _inputListener = CalendarListener.dateRange(_model,
          movingStartMaintainsLength: _movingStartMaintainsLength);
    }
  }

  @override
  void ngAfterChanges() {
    if (_isInitialized && _isResetNeeded) {
      _resetView();
    }

    _isResetNeeded = false;
  }

  @override
  void ngAfterViewInit() {
    _initializeEvents();
    _resetView();
    _isInitialized = true;
  }

  @override
  void ngOnDestroy() {
    _calendarStream?.cancel();
    _scroller.removeEventListener('scroll', _scrollListener);
    _container
      ..removeEventListener('click', _clickListener)
      ..removeEventListener('mousedown', _mouseDownListener)
      ..removeEventListener('mousemove', _mouseMoveListener)
      ..removeEventListener('mouseout', _mouseOutListener);
  }

  void _initializePanels() {
    if (!isFirefox) {
      _container.classes.add('not-firefox');
    }

    // Create the blank month containers.
    _container.children.clear();
    _renderedMonths.clear();
    _renderedOffsets.clear();

    for (var i = -_overdraw; i <= _overdraw; i++) {
      _container.append(_monthTemplate.clone(true));
    }

    _renderVisible();
  }

  void _resetView() {
    _isRenderScheduled = true;
    _resetContainerHeight();
    _scrollToMonth(_Month.fromDate(_initialDate));

    // Wait to render until after the initial scroll.
    window.requestAnimationFrame((_) {
      _initializePanels();
      _isRenderScheduled = false;
    });
  }

  // Dart returns a separate instance every time a tearoff is accessed, so we
  // need to cache them for removeEventListener to work.
  EventListener _scrollListener;
  EventListener _clickListener;
  EventListener _mouseDownListener;
  EventListener _mouseMoveListener;
  EventListener _mouseOutListener;

  void _initializeEvents() {
    // Process the events outside of Angular for lower overhead.
    _scroller.addEventListener('scroll', _scrollListener = _onScroll);
    _container
      ..addEventListener('click', _clickListener = _onClick)
      ..addEventListener('mousedown', _mouseDownListener = _onMouseDown)
      ..addEventListener('mousemove', _mouseMoveListener = _onMouseMove)
      ..addEventListener('mouseout', _mouseOutListener = _onMouseOut);
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

  void _onMouseOut(Event event) {
    var date = _extractDate(event);
    if (_canSelectDate(date)) {
      _inputListener.onMouseLeave(date);
    }
  }

  void _onScroll(Event event) {
    _scrollTop = _scroller.scrollTop;
    if (_isRenderScheduled) return;
    _isRenderScheduled = true;
    window.requestAnimationFrame((_) {
      _renderVisible();
      _isRenderScheduled = false;
    });
  }
}

/// A class for fast operations on months, such as the number of days in the
/// month or the day of week of the start of the month.
///
/// This class was created because [Date] and [DateTime] aren't fast enough to
/// be used in the material-calendar-picker inner loops, and if your code
/// doesn't require high performance you should use those instead (they're more
/// general and featureful).
class _Month {
  static const _yearPlaceholder = 9999;
  static final _monthFormatter = DateFormat.yMMM();
  static final _monthNames = List.generate(12, (i) => i + 1)
      .map((i) => _monthFormatter.format(DateTime(_yearPlaceholder, i)))
      .toList();

  int year;
  int month;

  _Month(this.year, this.month);

  _Month.fromDate(Date date)
      : this.year = date.year,
        this.month = date.month;

  void next() {
    if (++month > 12) {
      year++;
      month = 1;
    }
  }

  void prev() {
    if (--month < 1) {
      year--;
      month = 12;
    }
  }

  _Month copy() => _Month(year, month);

  _Month add(int months) {
    final result = copy();
    var increment = result.next;
    if (months < 0) {
      months = -months;
      increment = result.prev;
    }
    for (var i = 0; i < months; i++) {
      increment();
    }
    return result;
  }

  String get title =>
      _monthNames[month - 1].replaceFirst('$_yearPlaceholder', '$year');

  /// 0-indexed day of week of the start of the month [0 = Sun, 6 = Sat].
  int get startDay => _dayOfWeek(year, month, 1);

  /// Number of days in the month.
  int get days {
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    } else if (month == 2) {
      var isLeapYear = (year.remainder(4) == 0 && year.remainder(100) != 0) ||
          (year.remainder(400) == 0);
      return isLeapYear ? 29 : 28;
    } else {
      return 31;
    }
  }

  /// The [Date] corresponding to the first day of this month.
  Date get start => Date(year, month, 1);

  /// The [Date] corresponding to the last day of this month.
  Date get end => Date(year, month, days);

  bool operator ==(o) => year == o.year && month == o.month;

  bool operator <(o) => year < o.year || (year == o.year && month < o.month);

  bool operator >(o) => year > o.year || (year == o.year && month > o.month);

  bool operator <=(o) => this == o || this < o;

  bool operator >=(o) => this == o || this > o;

  String toString() => '$year-$month';
}
