// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/comparison.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/src/material_datepicker/sequential.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Possible comparison options.
enum ComparisonOption { previousPeriod, samePeriodLastYear, custom }

/// The cause of the most recent change to the date range.
enum Action {
  dragStart,
  drag,
  dragEnd,
  button,
  textEntry,
  click,
  preview,
  cancel
}

/// Possible date range picker configurations.
enum DateRangePickerConfiguration {
  /// Basic configuration. Only show pre-defined list initially.
  ///
  /// When "Custom" date range is selected, .right-column will be shown and
  /// pre-defined list will be hidden.
  basic,

  /// Only a dropdown of pre-defined ranges will be shown.
  predefinedRangesOnly,

  /// Custom date range picker will be shown along with pre-defined ranges.
  fullyLoaded
}

/// Info needed to edit comparison ranges.
abstract class HasComparisonRange {
  /// The previous date range (used to generate comparison title).
  DatepickerDateRange get prevRange;

  /// `true` if time comparison is turned on.
  bool comparisonEnabled;

  /// List of [ComparisonOption]s which fall within minDate/maxDate.
  List<ComparisonOption> get validComparisonOptions;

  /// Which time comparison option is selected.
  ComparisonOption comparisonOption;

  /// `true` if this date range type supports comparison
  bool get comparisonSupported;

  /// An observable handle on the comparison range.
  ObservableReference<DateRange> get comparison;

  /// The earliest date that can be chosen for comparison.
  Date get minDate;

  /// The latest date that can be chosen for comparison.
  Date get maxDate;
}

/// Bundles up the currently-selected date range, along with the kind of user
/// interaction that caused the change. E.g. we might (and do) want to ignore
/// all dates selected via drag.
class DateRangeChange {
  final DatepickerComparison date;
  final Action cause;
  DateRangeChange(this.date, this.cause);

  String toString() => '[$date] with cause $cause';
}

/// A snapshot of the state of the [_Model].
class ModelState {
  final DatepickerComparison value;
  final CalendarState calendarState;
  final bool comparisonEnabled;
  final ComparisonOption comparisonOption;
  ModelState(this.value, this.calendarState, this.comparisonEnabled,
      this.comparisonOption);
}

const _rangeId = 'range';
const _comparisonId = 'comparison';

/// Models the datepicker state.
// TODO(google): Might make sense to have some vm tests that test this
// outside of the datepicker component
class DateRangeEditorModel
    implements Sequential<DatepickerDateRange>, HasComparisonRange {
  final rangeId = _rangeId;
  final comparisonId = _comparisonId;

  /// The actual datepicker value.
  final ObservableReference<DatepickerComparison> _ref;

  final calendar = new ObservableReference<CalendarState>(
      new CalendarState.empty(currentSelection: _rangeId),
      coalesce: true);

  final range = new ObservableReference<DateRange>(new DateRange(null, null),
      coalesce: true);

  @override
  final comparison = new ObservableReference<DateRange>(
      new DateRange(null, null),
      coalesce: true);

  final _changes = new StreamController<DateRangeChange>.broadcast(sync: true);
  final Disposer _disposer = new Disposer.oneShot();

  /// List of [ComparisonOption]s which fall within minDate/maxDate.
  ///
  /// Rebuilt as needed via calls to _updateValidComparisonOptions().
  List<ComparisonOption> get validComparisonOptions => _validComparisonOptions;
  List<ComparisonOption> _validComparisonOptions = [];

  Date minDate;
  Date maxDate;
  bool requireFullPeriods;
  bool _comparisonEnabled = false;
  bool basic;
  bool shouldShowPredefinedList = true;
  bool shouldShowCustomDateRangeColumn = true;
  ComparisonOption _comparisonOption = ComparisonOption.previousPeriod;
  DatepickerDateRange _customComparisonRange;
  String _comparisonTitle = '';
  Action _lastCause;

  DateRangeEditorModel(
      {DatepickerComparison initialValue,
      this.minDate,
      this.maxDate,
      this.requireFullPeriods = false,
      this.basic = false})
      : _ref = new ObservableReference(initialValue) {
    _updateHasNextPrev(initialValue);
    _updateValidComparisonOptions();
    _disposer
      ..addFunction(_changes.close)
      ..addStreamSubscription(_ref.stream.listen(_setEverything))
      ..addStreamSubscription(range.stream.listen(_setPrimaryRange))
      ..addStreamSubscription(comparison.stream.listen(_setComparisonRange))
      ..addStreamSubscription(calendar.changes.listen(_onCalendarChange));
  }

  /// The currently-selected datepicker value.
  DatepickerComparison get value => _ref.value;
  set value(DatepickerComparison val) {
    _ref.value = val;
    if (_comparisonEnabled) {
      _updateValidComparisonOptions();
    }
  }

  /// A sync, broadcast stream of changes caused by the user poking at the
  /// datepicker.
  Stream<DateRangeChange> get changes => _changes.stream;

  @override
  DatepickerDateRange get prevRange => value?.range?.prev;

  /// Whether or not time comparison is enabled.
  @override
  bool get comparisonEnabled => _comparisonEnabled;
  set comparisonEnabled(bool enabled) {
    _comparisonEnabled = enabled;
    calendar.value = calendar.value.select(rangeId,
        previewAnchoredAtStart: calendar.value.previewAnchoredAtStart);
    if (value?.range != null) {
      _changeValue(_withComparison(value.range), Action.button);
    }
  }

  /// What time comparison setting is chosen.
  @override
  ComparisonOption get comparisonOption => _comparisonOption;
  set comparisonOption(ComparisonOption option) {
    // Under "basic" mode, if user selects "custom" comparisonOption, show
    // calendar view and hide pre-defined view.
    if (basic && option == ComparisonOption.custom) {
      shouldShowCustomDateRangeColumn = true;
      shouldShowPredefinedList = false;
    }
    _setComparisonOption(option);
    calendar.value = calendar.value.select(rangeId,
        previewAnchoredAtStart: calendar.value.previewAnchoredAtStart);
  }

  /// Whether the currently selected range supports comparison
  @override
  bool get comparisonSupported => _rangeSupportsComparison(value?.range);

  /// The title of the selected date range.
  String get rangeTitle => value?.range?.title ?? '';

  /// The title of what the comparison date range would be.
  String get comparisonTitle => _comparisonTitle;

  /// Takes a snapshot of the model's current state.
  ModelState save() => new ModelState(
      value, calendar.value, comparisonEnabled, comparisonOption);

  /// Sets the model's state to a value from an earlier call to `save`.
  void restore(ModelState state) {
    if (state == null) return;
    // Reset value first to prevent setting calendar state from triggering a
    // change event.
    _changeValue(state.value, Action.cancel);
    calendar.value = state.calendarState;
    comparisonEnabled = state.comparisonEnabled;
    comparisonOption = state.comparisonOption;
  }

  /// Selects the given preset date range.
  void selectRange(DatepickerDateRange range) =>
      _changeValue(_withComparison(range), Action.button);

  @override
  ObservableReference<bool> hasNext = new ObservableReference<bool>(false);

  @override
  DatepickerDateRange next() {
    final next = value?.range?.next;
    if (next == null) return null;
    final amt = daysSpanned(value.range.start, next.start, inclusive: false);
    if (_customComparisonRange != null) {
      _customComparisonRange = new DatepickerDateRange.custom(
          _customComparisonRange.start.add(days: amt),
          _customComparisonRange.end.add(days: amt));
    }
    _changeValue(_withComparison(next), Action.button);
    return next;
  }

  @override
  ObservableReference<bool> hasPrev = new ObservableReference<bool>(false);

  @override
  DatepickerDateRange prev() {
    final prev = value?.range?.prev;
    if (prev == null) return null;
    final amt = daysSpanned(prev.start, value.range.start, inclusive: false);
    if (_customComparisonRange != null) {
      _customComparisonRange = new DatepickerDateRange.custom(
          _customComparisonRange.start.add(days: -amt),
          _customComparisonRange.end.add(days: -amt));
    }
    _changeValue(_withComparison(prev), Action.button);
    return prev;
  }

  /// Gets rid of all the streams and listeners and all that.
  void dispose() {
    _disposer.dispose();
    _ref.dispose();
    calendar.dispose();
    range.dispose();
    comparison.dispose();
  }

  /// Sets [value] to the given value (clamping if necessary), and publishes a
  /// [DateRangeChange] if it's interesting.
  ///
  /// "Interesting" here means that either the value has changed, or it's the
  /// same value but from a different cause. This is because listeners to the
  /// change stream might care about one cause but not the other -- for
  /// instance, the datepicker component wants to avoid publishing all `drag`
  /// changes, but does want to publish the value at `dragEnd`, even if it's the
  /// same value as the last `drag` change.
  void _changeValue(DatepickerComparison val, Action cause) {
    val = new DatepickerComparison.reclamp(val, minDate, maxDate);
    if (value == val && (cause == null || cause == _lastCause)) return;
    value = val;
    _lastCause = cause;
    _changes.add(new DateRangeChange(val, cause));
  }

  /// Update the next/prev buttons to reflect the main value changing.
  void _updateHasNextPrev(DatepickerComparison newValue) {
    final prevRange = newValue?.range?.prev;
    final nextRange = newValue?.range?.next;

    if (requireFullPeriods) {
      hasPrev.value = prevRange != null &&
          rangeContainsRange(
              new DateRange(minDate, maxDate), prevRange.unclamped());
      hasNext.value = nextRange != null &&
          rangeContainsRange(
              new DateRange(minDate, maxDate), nextRange.unclamped());
    } else {
      hasPrev.value = prevRange != null;
      hasNext.value = nextRange != null;
    }
  }

  /// When the main value changes, update everything else.
  void _setEverything(DatepickerComparison newValue) {
    // Always update the next/prev buttons, even if newValue is null.
    _updateHasNextPrev(newValue);

    // Early exits
    if (newValue == null) return;

    final range = newValue.range;
    if (range == null) {
      // Clears the main range's text input fields and calendar selection.
      this.range.value = null;
      calendar.value = calendar.value.clearCurrentSelection();
    } else {
      // Update the main range's text input fields
      this.range.value = range.asPlainRange();

      // Update the [CalendarState] (selection highlights)
      if (_selectionDifferent(calendar.value, rangeId, range) ||
          !calendar.value.has(rangeId)) {
        calendar.value = calendar.value.setSelection(
            new CalendarSelection(rangeId, range.start, range.end),
            previewAnchoredAtStart: calendar.value.previewAnchoredAtStart,
            cause: CausedBy.external);
      }
    }

    final comparison = newValue.comparison;
    if (comparison != null) {
      if (_selectionDifferent(calendar.value, comparisonId, comparison) ||
          !calendar.value.has(comparisonId)) {
        calendar.value = calendar.value.setSelection(
            new CalendarSelection(
                comparisonId, comparison.start, comparison.end),
            cause: CausedBy.external);
      }
    } else {
      calendar.value = calendar.value.clearSelection(comparisonId);
    }

    // Update the comparison UI (the toggle and the option dropdown)
    _comparisonEnabled = newValue.isComparisonEnabled;
    if (_comparisonEnabled) {
      if (newValue.comparesToPreviousPeriod()) {
        _comparisonOption = ComparisonOption.previousPeriod;
      } else if (newValue.comparesToSamePeriodLastYear()) {
        _comparisonOption = ComparisonOption.samePeriodLastYear;
      } else {
        _comparisonOption = ComparisonOption.custom;
      }

      _updateValidComparisonOptions();
    }

    // Update the comparison range's text input fields
    final hypotheticalComparison =
        (comparison != null) ? comparison : _buildComparison(range).comparison;
    if (hypotheticalComparison == null) return;
    this.comparison.value = hypotheticalComparison.asPlainRange();
    _customComparisonRange = new DatepickerDateRange.custom(
        hypotheticalComparison.start, hypotheticalComparison.end);
    _comparisonTitle = hypotheticalComparison.title;
  }

  /// When the date range changes (usually via text entry), handle that.
  void _setPrimaryRange(DateRange range) {
    if (value?.range?.asPlainRange() == range) return;
    _changeValue(
        _withComparison(new DatepickerDateRange.custom(range.start, range.end)),
        Action.textEntry);
  }

  /// When the comparison range changes (usually via text entry), handle that.
  void _setComparisonRange(DateRange range) {
    if (_customComparisonRange?.asPlainRange() == range) return;
    comparisonOption = ComparisonOption.custom;
    _customComparisonRange =
        new DatepickerDateRange.custom(range?.start, range?.end);
    _changeValue(_withComparison(value?.range), Action.textEntry);
  }

  /// Handle drag events on the calendar.
  void _onCalendarChange(Change<CalendarState> change) {
    final action = _selectionAction(change.previous.cause, change.next.cause);
    final newState = change.next;

    var selectedRange = value?.range;
    if (newState.currentSelection == rangeId &&
        _selectionDifferent(newState, rangeId, selectedRange)) {
      // If the user's dragging the primary range, keep track of that.
      selectedRange = new DatepickerDateRange.custom(
          newState.selection(rangeId).start, newState.selection(rangeId).end);
    } else if (newState.currentSelection == comparisonId &&
        _selectionDifferent(newState, comparisonId, _customComparisonRange)) {
      // If the user's dragging the comparison range, then we should turn
      // 'custom' comparison on (if it isn't already). (But use the internal
      // helper, so that we don't clobber the active range.)
      _setComparisonOption(ComparisonOption.custom);
      _customComparisonRange = new DatepickerDateRange.custom(
          newState.selection(comparisonId).start,
          newState.selection(comparisonId).end);
    }

    // Update the value to take into account the changes to `selectedRange` and
    // `_customComparisonRange`.
    if (selectedRange != null) {
      _changeValue(_withComparison(selectedRange), action);
    }

    // Select the other range when user is finished modifying the current range
    if (change.next.cause == CausedBy.rangeConfirm) {
      var selectId = _comparisonEnabled &&
              _comparisonOption == ComparisonOption.custom &&
              calendar.value.currentSelection == rangeId
          ? comparisonId
          : rangeId;
      calendar.value = calendar.value.select(selectId,
          previewAnchoredAtStart: calendar.value.previewAnchoredAtStart);
    }
  }

  /// Sets the comparison option, but doesn't reset the calendar's active
  /// selection.
  void _setComparisonOption(ComparisonOption option) {
    if (_comparisonOption == option) return;

    _comparisonOption = option;
    if (value?.range != null) {
      _changeValue(_withComparison(value.range), Action.button);

      if (!_comparisonEnabled) {
        // A bit dirty: If comparison is off, then the value of `value` didn't
        // actually change, so the listener didn't get triggered and the
        // comparison text boxes will be out of date. Trigger it manually.
        _setEverything(value);
      }
    }
  }

  /// Gets which action a selection change represents, given the change in
  /// cause.
  Action _selectionAction(CausedBy oldCause, CausedBy newCause) {
    if (newCause == CausedBy.preview) {
      return Action.preview;
    } else if (oldCause == CausedBy.drag && newCause == CausedBy.drag) {
      return Action.drag;
    } else if (oldCause == CausedBy.drag && newCause == CausedBy.rangeConfirm) {
      return Action.dragEnd;
    } else if (newCause == CausedBy.drag) {
      return Action.dragStart;
    } else if (newCause == CausedBy.endpointConfirm ||
        newCause == CausedBy.rangeConfirm) {
      return Action.click;
    }
    return null;
  }

  /// Returns `true` if the calendar has the given selection ID and that
  /// selection spans a different set of days than the given date range.
  bool _selectionDifferent(CalendarState state, String id, DateRange range) {
    if (!state.has(id)) return false;
    if (range == null) return true;
    return range.start != state.selection(id).start ||
        range.end != state.selection(id).end;
  }

  /// Builds a [DatepickerComparison] from the given [range], respecting whether
  /// or not time comparison is enabled.
  DatepickerComparison _withComparison(DatepickerDateRange range) =>
      _comparisonEnabled
          ? _buildComparison(range)
          : new DatepickerComparison.noComparison(range);

  /// Supports comparison only when [range] is not null and is not all time.
  static bool _rangeSupportsComparison(DatepickerDateRange range) =>
      range != null && !range.isAllTime;

  /// Builds a [DatepickerComparison] from the given [range], using the current
  /// time comparison option.
  ///
  /// If the current time comparison option is not valid for the given [range],
  /// then [ComparisonOption.custom] is used.
  DatepickerComparison _buildComparison(DatepickerDateRange range) {
    if (!_rangeSupportsComparison(range)) {
      return new DatepickerComparison.noComparison(range);
    }

    // If we're returning a Custom comparison range, but _customComparisonRange
    // hasn't been set up yet, use a default of the first day of the given
    // range. This should only be needed the first time the user enables
    // comparison mode, if previous period and previous year aren't valid for
    // their chosen range.
    final defaultCustomComparisonRange =
        new DatepickerDateRange.custom(range.start, range.start);

    // If the selected comparison option is invalid for this range, return a
    // "Custom" comparison, with the current comparison range.
    var validComparisonOptions = _getValidComparisonOptions(range);
    if (!validComparisonOptions.contains(_comparisonOption)) {
      return new DatepickerComparison.custom(
          range, _customComparisonRange ?? defaultCustomComparisonRange);
    }

    switch (_comparisonOption) {
      case ComparisonOption.previousPeriod:
        return new DatepickerComparison.previousPeriod(range);
      case ComparisonOption.samePeriodLastYear:
        return new DatepickerComparison.samePeriodLastYear(range);
      case ComparisonOption.custom:
        return new DatepickerComparison.custom(
            range, _customComparisonRange ?? defaultCustomComparisonRange);
    }
    throw new ArgumentError(_comparisonOption);
  }

  /// Updates [_validComparisonOptions] based on the current range, and whether
  /// the comparison options have any overlap with the [minDate] to [maxDate]
  /// range.
  void _updateValidComparisonOptions() {
    if (value?.range == null || !_rangeSupportsComparison(value?.range)) return;

    // Set valid comparison options.
    _validComparisonOptions = _getValidComparisonOptions(value?.range);

    // Make sure that the currently selected comparison option is still valid.
    if (!_validComparisonOptions.contains(_comparisonOption)) {
      _comparisonOption = ComparisonOption.custom;
    }
  }

  /// Returns the list of [ComparisonOption]s that have any overlap with the
  /// [minDate] to [maxDate] for the given [range].
  List<ComparisonOption> _getValidComparisonOptions(DatepickerDateRange range) {
    final options = <ComparisonOption>[];

    // Return empty list if range doesn't support comparison.
    if (range == null || !_rangeSupportsComparison(range)) {
      return options;
    }

    // See if the current range's "Previous period" has any overlap with the
    // minDate to maxDate range.
    var previousPeriod = new DatepickerComparison.previousPeriod(range);
    if (previousPeriod.comparison?.clamp(min: minDate, max: maxDate) != null) {
      options.add(ComparisonOption.previousPeriod);
    }

    // See if the current range's "Same period last year" has any overlap with
    // the minDate to maxDate range.
    var lastYear = new DatepickerComparison.samePeriodLastYear(range);
    if (lastYear.comparison?.clamp(min: minDate, max: maxDate) != null) {
      options.add(ComparisonOption.samePeriodLastYear);
    }

    // Custom is always valid.
    options.add(ComparisonOption.custom);

    return options;
  }
}
