// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/src/material_datepicker/calendar_listener.dart';
import 'package:angular_components/src/material_datepicker/enum_parsing.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// What sort of selections a calendar supports.
enum CalendarSelectionMode { NONE, SINGLE_DATE, DATE_RANGE }

@Deprecated('No longer used due to poor performance')
abstract class MaterialDateGridBase
    implements OnInit, OnDestroy, ForcedScrollDirectiveHost {
  /// The minimum amount of padding to keep around the content, to accommodate
  /// fast scrolling. (This makes sure that there is always something for larger
  /// scroll events to scroll into.)
  static final int MIN_BUFFER_SIZE_PX = 3000;

  /// The maximum height to give to the entire calendar scroller. If adding
  /// padding due to scrolling would cause the calendar to get taller than this,
  /// we'll trim some off the top or bottom to fit into this limit.
  ///
  /// This is an attempt to keep the scrollbar even a little bit useful... let's
  /// see if it helps any.
  static final int MAX_CALENDAR_SIZE_PX = 20000;

  /// How many calendar row groups to keep in the DOM at any time.
  int get rowsToRender;

  /// The height of each calendar row group, in pixels
  int get rowHeightPx;

  int paddingTop;
  int paddingBottom;
  int startingWeekday;

  /// The scroller div's `scroll-top` property, for setting during
  /// initialization.
  int _scrollTop;
  int get scrollTop => _scrollTop;
  set scrollTop(int scrollTop) {
    if (_scrollTop != scrollTop) forceScrollTop(scrollTop);
  }

  /// Sets scrollTop and forces the change on the scroller div.
  void forceScrollTop(int scrollTop) {
    _scrollTop = scrollTop;
    scroller?.forceScroll(scrollTop);
  }

  Date get minDate;
  Date get maxDate;

  bool canSelectDate(Date date) => date >= minDate && date <= maxDate;

  /// Where the top of the div lives, relative to the 'anchor' row. The idea is
  /// that `scrollTop + _startTop` gives you the position in pixels relative to
  /// a known point in the data set (in this case, `0`).
  int startTop;

  CalendarSelectionMode _mode = CalendarSelectionMode.NONE;
  CalendarSelectionMode get mode => _mode;
  bool get canGrabRangeBoundaries => _mode == CalendarSelectionMode.DATE_RANGE;

  /// Set this to false to temporarily suppress updates to the calendar's range
  /// highlights. Defaults to true.
  @Input()
  set allowHighlightUpdates(bool value) {
    var nowAllowed = value;
    if (_allowHighlightUpdates != nowAllowed) {
      _allowHighlightUpdates = nowAllowed;
      if (nowAllowed) onCalendarChange(model.value);
    }
  }

  bool get allowHighlightUpdates => _allowHighlightUpdates;

  bool _allowHighlightUpdates = true;

  // Forward mouse events to input listener, but only for enabled dates
  void onClick(Date date) {
    if (canSelectDate(date)) {
      _inputListener.onClick(date);
    }
  }

  void onMouseDown(Date date) {
    if (canSelectDate(date)) {
      _inputListener.onMouseDown(date);
    }
  }

  void onMouseMove(Date date) {
    if (canSelectDate(date)) {
      _inputListener.onMouseMove(date);
    }
  }

  void onMouseLeave(Date date) => _inputListener.onMouseLeave(date);

  CalendarListener _inputListener = CalendarListener.noop();

  ForcedScrollDirective scroller;

  @override
  void attachScroller(ForcedScrollDirective scroller) {
    this.scroller = scroller;
  }

  // Needed so we can circle the current date
  Date today;

  StreamSubscription _calendarStream;
  final _disposer = Disposer.oneShot();
  final ChangeDetectorRef changeDetector;
  final DomService _domService;

  MaterialDateGridBase(Clock clock, CalendarState initialState,
      this.changeDetector, this._domService, String mode)
      : paddingTop = MIN_BUFFER_SIZE_PX,
        paddingBottom = MIN_BUFFER_SIZE_PX,
        today = Date.today(clock),
        model =
            ObservableReference<CalendarState>(initialState, coalesce: true) {
    // Get the 1-indexed starting weekday for the current locale, and use that.
    startingWeekday = DateFormat().dateSymbols.FIRSTDAYOFWEEK + 1;

    if (mode != null && mode.isNotEmpty) {
      _mode = fuzzyParseEnum(CalendarSelectionMode.values, mode);
    }
  }

  @override
  void ngOnInit() {
    _disposer.addStreamSubscription(
        _calendarStream = model.stream.listen(onCalendarChange));

    if (mode == CalendarSelectionMode.SINGLE_DATE) {
      _inputListener = CalendarListener.singleDate(model);
    }
    if (mode == CalendarSelectionMode.DATE_RANGE) {
      _inputListener =
          CalendarListener.dateRange(model, movingStartMaintainsLength: true);
    }
    _disposer.addDisposable(_inputListener);

    createRender();
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  final ObservableReference<CalendarState> model;

  /// Fired when the calendar state changes -- e.g. when the user starts
  /// dragging the selected date range.
  @Output()
  Stream<CalendarState> get stateChange => model.stream;

  /// An object describing the entire state of the calendar -- what's selected
  /// on the calendar, and whether or not the selection is currently "active".
  @Input()
  set state(CalendarState state) {
    model.value = state;
    if (_calendarStream == null) onCalendarChange(state);
  }

  CalendarState get state => model.value;

  /// Whether to enable compact calendar styles.
  @Input()
  bool compact = false;

  void onCalendarChange(CalendarState state);

  void createRender();

  // This splits .scroller element rendering from component
  // init, spreading the initial render over several frames.
  bool _isScrollerCreated = false;
  bool get isScrollerCreated => _isScrollerCreated;

  void initScroll() {
    assert(_isScrollerCreated == false);

    // Create the .scroller div
    _isScrollerCreated = true;
    changeDetector.markForCheck();

    // Deferred so that the .scroller is created before scrollTop is changed
    _domService.scheduleWrite(() {
      forceScrollTop(-startTop);
    });
  }

  /// Moves the 'view' by adjusting the heights of the top and bottom padding
  /// divs. Returns the value that scrollTop should be set to.
  int moveView(
      int scrollTop, int diffPx, int maxPaddingTop, int maxPaddingBottom) {
    var newPaddingTop = paddingTop + diffPx;
    var newPaddingBottom = paddingBottom - diffPx;

    int minPaddingTop = min(MIN_BUFFER_SIZE_PX, maxPaddingTop);
    int minPaddingBottom = min(MIN_BUFFER_SIZE_PX, maxPaddingBottom);

    // If we're approaching the top of the div, we need to add more padding
    // there, and adjust scrollTop / startTop to compensate.
    if (newPaddingTop < minPaddingTop) {
      startTop -= (minPaddingTop - newPaddingTop);
      scrollTop += (minPaddingTop - newPaddingTop);
      newPaddingTop = minPaddingTop;

      var excessHeightPx =
          _totalHeight(newPaddingTop, newPaddingBottom) - MAX_CALENDAR_SIZE_PX;
      if (excessHeightPx > 0) {
        newPaddingBottom -= excessHeightPx;
      }
    }
    // If we're approaching the bottom of the div, we need to add more padding
    // there.
    if (newPaddingBottom < minPaddingBottom) {
      newPaddingBottom = minPaddingBottom;

      var excessHeightPx =
          _totalHeight(newPaddingTop, newPaddingBottom) - MAX_CALENDAR_SIZE_PX;
      if (excessHeightPx > 0) {
        startTop += excessHeightPx;
        scrollTop -= excessHeightPx;
        newPaddingTop -= excessHeightPx;
      }
    }

    // Ensure there's no whitespace before the first month or after the last
    // month, by enforcing maxPaddingTop/maxPaddingBottom.
    if (newPaddingTop > maxPaddingTop) {
      // Changing the top padding means we have to adjust the scroll position
      int delta = newPaddingTop - maxPaddingTop;
      newPaddingTop = maxPaddingTop;
      startTop += delta;
      scrollTop -= delta;
    }
    if (newPaddingBottom > maxPaddingBottom) {
      // Changing the bottom padding doesn't affect the scroll position
      newPaddingBottom = maxPaddingBottom;
    }

    paddingTop = newPaddingTop;
    paddingBottom = newPaddingBottom;
    changeDetector.markForCheck();
    return scrollTop;
  }

  /// The total height the calendar would have, if it had the given top and
  /// bottom paddings.
  int _totalHeight(int paddingTop, int paddingBottom) =>
      paddingTop + paddingBottom + (rowsToRender * rowHeightPx);

  int rowFromPos(heightPx) => (heightPx / rowHeightPx).floor();
}

abstract class ForcedScrollDirectiveHost {
  void attachScroller(ForcedScrollDirective scroller);
}

/// A directive which forces an element's scrollTop property to have the
/// specified value, even if the value hasn't changed since the last change
/// detection cycle. (It's a bit of a hack)
@Directive(
  selector: '[imperativelyScrollable]',
)
class ForcedScrollDirective {
  final HtmlElement _element;
  final DomService _domService;

  ForcedScrollDirective(
    this._element,
    this._domService,
    ForcedScrollDirectiveHost calendar,
  ) {
    // Trying to inject this directive into the calendar using @ViewQuery causes
    // the tests' tearDown to fail... so do this nastiness instead.
    // TODO(google): It didn't look like the test bed was doing anything
    // special here, so there may be a bug in how angular2 handles ViewQueries
    // in its RootTestComponent. Dig into it a bit and file a bug against
    // Angular if that's the case.
    calendar.attachScroller(this);
  }

  int get height => _element.clientHeight;

  void forceScroll(int scrollTop) {
    _domService.scheduleWrite(() {
      _element.scrollTop = scrollTop;
    });
  }
}
