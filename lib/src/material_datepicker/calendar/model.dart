// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A minimum relevant time unit for a calendar.
///
/// These values must be in order of decreasing specificity.
enum CalendarResolution { days, weeks, months, years }

/// What sort of selections a calendar supports.
enum CalendarSelectionMode { NONE, SINGLE_DATE, DATE_RANGE }

bool datesEqualAtResolution(Date a, Date b, CalendarResolution resolution) {
  switch (resolution) {
    case CalendarResolution.years:
      return a.year == b.year;
    case CalendarResolution.months:
      return a.year == b.year && a.month == b.month;
    case CalendarResolution.days:
      return a == b;
    case CalendarResolution.weeks:
    default:
      throw ArgumentError('Equality not supported at resolution: $resolution');
  }
}

int compareDatesAtResolution(Date a, Date b, CalendarResolution resolution) {
  switch (resolution) {
    case CalendarResolution.years:
      return a.year.compareTo(b.year);
    case CalendarResolution.months:
      if (a.year == b.year) return a.month.compareTo(b.month);
      return a.year.compareTo(b.year);
    case CalendarResolution.days:
      return a.compareTo(b);
    case CalendarResolution.weeks:
    default:
      throw ArgumentError(
          'Comparison not supported at resolution: $resolution');
  }
}

/// A selected range on the calendar.
class CalendarSelection {
  final String id;
  final Date start;
  final Date end;

  /// Creates a calendar selection. `null` dates are interpreted as open-ended
  /// ranges.
  CalendarSelection(this.id, this.start, this.end);

  /// Tries to infer the start and end dates from the two given dates. Doesn't
  /// support null dates.
  CalendarSelection.guessOrder(String id, Date a, Date b)
      : this(id, earlierOf(a, b), laterOf(a, b));

  /// Checks whether this selection's confirmed range contains the given time.
  /// If this selection's start or end are null, that's interpreted as an
  /// open-ended range.
  bool contains(Date date) =>
      date != null &&
      (start == null || !date.isBefore(start)) &&
      (end == null || !date.isAfter(end));

  /// Returns a copy of this [CalendarSelection] clamped to [min, max].
  ///
  /// If [min] is null, the start date won't be clamped. Likewise for [max].
  /// Start and end dates can be null to represent unbounded ranges.
  CalendarSelection clamp({Date min, Date max}) {
    // If min/max is null, default to start/end.
    min = min ?? start;
    max = max ?? end;

    // If they're still null, use as-is; otherwise clamp the range.
    if (min != null) {
      min = laterOf(min, start ?? min);
    }
    if (max != null) {
      max = earlierOf(max, end ?? max);
    }

    return CalendarSelection(id, min, max);
  }

  @override
  String toString() => '$id ($start - $end)';

  @override
  int get hashCode => id.hashCode ^ start.hashCode ^ end.hashCode;

  @override
  bool operator ==(o) =>
      o is CalendarSelection && o.id == id && o.start == start && o.end == end;
}

Date firstDayOfMonth(Date date) =>
    date == null ? null : Date(date.year, date.month, 1);

Date lastDayOfMonth(Date date) =>
    date == null ? null : Date(date.year, date.month + 1, 1).add(days: -1);

/// Describes the interaction state arising directly from the most recent user
/// action that produced any particular CalendarState.
/// `external` - State arose programmatically / by default / from a user action
///              outside of the calendar widget itself.
/// `preview` - User is previewing a possible selection change.
/// `drag` - User is dragging on the calendar widget and has not finished yet.
/// `endpointConfirm` - The previous preview has now confirmed a single endpoint
/// `rangeConfirm` - The previous preview/drag is now confirmed/finished.
enum CausedBy { external, preview, drag, endpointConfirm, rangeConfirm }

/// The (immutable) state of selections on the calendar.
class CalendarState {
  static final Function _setEq = UnorderedIterableEquality().equals;

  /// The smallest relevant unit of time in the context of the calendar.
  ///
  /// Typically this is days, but may be months in the case of a month picker
  /// component or a year/month view mode.
  final CalendarResolution resolution;

  /// The current set of selections.
  final List<CalendarSelection> selections;

  /// The ID of the selection to update when the calendar is interacted with.
  final String currentSelection;

  /// Describes the user action that produced this state
  final CausedBy cause;

  /// If non-null, the user is currently previewing a modification to the
  /// current selection, and this is the date the user is interacting with to
  /// produce this preview.
  final Date preview;

  /// A preview highlights a range with two endpoints - one is `preview`,
  /// and the other is either the start (if `previewAnchoredAtStart` is true) or
  /// the end (if `previewAnchoredAtStart` is false) of the `currentSelection`.
  /// This variable is still relevant even if `preview` is null, because it
  /// specifies which endpoint will become the anchor if previewing begins.
  final bool previewAnchoredAtStart;

  bool has(String id) => selections.any((s) => s.id == id);
  CalendarSelection selection(String id) =>
      selections.singleWhere((s) => s.id == id);

  /// Return true if the given date is highlighted by the given selection,
  /// or by a preview of the given selection.
  bool highlighted(String id, Date date) {
    assert(date != null);
    if (preview != null && currentSelection == id) {
      var current = selection(currentSelection);
      var anchor = previewAnchoredAtStart ? current.start : current.end;
      var previewStart = earlierOf(preview, anchor);
      var previewEnd = laterOf(preview, anchor);
      return !date.isBefore(previewStart) && !date.isAfter(previewEnd);
    } else {
      return selection(id).contains(date);
    }
  }

  static List<CalendarSelection> _adaptSelections(
      List<CalendarSelection> selections, CalendarResolution resolution) {
    if (resolution.index < CalendarResolution.months.index) {
      return selections;
    }
    return selections
        .map((selection) => CalendarSelection(selection.id,
            firstDayOfMonth(selection.start), lastDayOfMonth(selection.end)))
        .toList();
  }

  CalendarState(
      {List<CalendarSelection> selections,
      this.currentSelection,
      this.cause,
      this.preview,
      this.previewAnchoredAtStart = false,
      resolution = CalendarResolution.days})
      : selections = _adaptSelections(selections ?? [], resolution),
        resolution = resolution;

  CalendarState.empty(
      {String currentSelection = 'default',
      resolution = CalendarResolution.days})
      : this(
            selections: [],
            currentSelection: currentSelection,
            cause: CausedBy.external,
            resolution: resolution);

  /// Creates a calendar state initialized with the given selections.
  /// The first element in the list is set as the current selection.
  CalendarState.selected(List<CalendarSelection> selections,
      {resolution = CalendarResolution.days, cause = CausedBy.external})
      : this(
            cause: cause,
            selections: selections,
            currentSelection: selections.first.id,
            resolution: resolution);

  /// Sets the range with the given ID as the "current selection" -- the range
  /// that'll get updated when the user clicks on the calendar.
  CalendarState select(String id, {bool previewAnchoredAtStart = false}) =>
      CalendarState(
          selections: selections,
          currentSelection: id,
          cause: CausedBy.external,
          previewAnchoredAtStart: previewAnchoredAtStart,
          resolution: resolution);

  /// Updates the value for the given selection. Creates it if it's not in the
  /// list of selections already.
  CalendarState setSelection(CalendarSelection val,
      {CausedBy cause = CausedBy.external,
      bool previewAnchoredAtStart = false}) {
    var newSelections = [val]..addAll(selections.where((s) => s.id != val.id));
    return CalendarState(
        selections: newSelections,
        currentSelection: currentSelection,
        cause: cause,
        previewAnchoredAtStart: previewAnchoredAtStart,
        resolution: resolution);
  }

  /// Updates the "current" selection's endpoints, with "dragging" as the cause
  /// (the user is still dragging the current selection).
  CalendarState updateDrag(Date a, Date b) =>
      setSelection(CalendarSelection.guessOrder(currentSelection, a, b),
          cause: CausedBy.drag);

  /// Updates the preview endpoint and sets `cause` to `previewing`.
  CalendarState updateCurrentPreview(Date newPreviewTarget) {
    assert(newPreviewTarget != null);
    return CalendarState(
        selections: selections,
        currentSelection: currentSelection,
        cause: CausedBy.preview,
        preview: newPreviewTarget,
        previewAnchoredAtStart: previewAnchoredAtStart,
        resolution: resolution);
  }

  /// Ends preview mode, if applicable.
  /// This only changes the preview state. The `cause` is still `preview`.
  CalendarState cancelCurrentPreview() => preview == null
      ? this
      : CalendarState(
          selections: selections,
          currentSelection: currentSelection,
          cause: CausedBy.preview,
          preview: null,
          previewAnchoredAtStart: previewAnchoredAtStart,
          resolution: resolution);

  /// Sets both endpoints of the "current" selection
  CalendarState setCurrentSelection(Date a, Date b,
          {CausedBy cause = CausedBy.rangeConfirm,
          bool previewAnchoredAtStart = false}) =>
      setSelection(CalendarSelection.guessOrder(currentSelection, a, b),
          cause: cause, previewAnchoredAtStart: previewAnchoredAtStart);

  /// Delete the "current" selection. Note this is different from creating a
  /// selection with null endpoints, which for the date-range-picker means
  /// "All Time". After this call, no dates will be selected.
  CalendarState clearCurrentSelection() => clearSelection(currentSelection);

  /// Updates one endpoint of the "current" selection to match the preview
  /// `confirmRange` - If true, this the last endpoint to be set for the current
  ///                  range. This information is not used by CalendarState
  ///                  directly, but clients of CalendarState may need it.
  CalendarState confirmPreview(
      {bool confirmRange = false, @required bool movingStartMaintainsLength}) {
    var current = selection(currentSelection);
    var anchor = previewAnchoredAtStart ? current.start : current.end;
    assert(preview != null && anchor != null);

    var cause = confirmRange ? CausedBy.rangeConfirm : CausedBy.endpointConfirm;

    if (previewAnchoredAtStart) {
      // Selecting end date.

      if (preview <= anchor) {
        // End date was moved before (or onto) the start date. Collapse to a
        // single-day range and keep the end date active.
        return setSelection(
            CalendarSelection(currentSelection, preview, preview),
            cause: cause,
            previewAnchoredAtStart: true);
      } else {
        // Modify end date.
        return setSelection(
            CalendarSelection(currentSelection, anchor, preview),
            cause: cause,
            previewAnchoredAtStart: false);
      }
    } else {
      // Selecting start date.

      if (movingStartMaintainsLength) {
        // Preserve the length of the range, and make the end date active.
        var rangeLengthInDays =
            daysSpanned(current.start, current.end, inclusive: false);
        return setSelection(
            CalendarSelection(currentSelection, preview,
                preview.add(days: rangeLengthInDays)),
            cause: cause,
            previewAnchoredAtStart: true);
      } else if (preview >= anchor) {
        // Move only the start date.
        //
        // Start date was moved after the end date. Collapse to a single-day
        // range and activate the end date.
        return setSelection(
            CalendarSelection(currentSelection, preview, preview),
            cause: cause,
            previewAnchoredAtStart: true);
      } else {
        // Move only the start date.
        return setSelection(
            CalendarSelection(currentSelection, preview, anchor),
            cause: cause,
            previewAnchoredAtStart: true);
      }
    }
  }

  /// Removes the identified selection from the list of selections.
  /// If the identified selection does not exist, has no effect.
  CalendarState clearSelection(String id) => has(id)
      ? CalendarState(
          selections: selections.where((s) => s.id != id).toList(),
          currentSelection: currentSelection,
          cause: CausedBy.external,
          resolution: resolution)
      : this;

  bool _resolutionAtLeast(CalendarResolution minimumResolution) =>
      resolution.index >= minimumResolution.index;

  @override
  String toString() =>
      'ranges: $selections / current: $currentSelection / cause: $cause / '
      'resolution: $resolution / '
      'preview ${previewAnchoredAtStart ? "start" : "end"} - $preview';

  @override
  bool operator ==(o) =>
      o is CalendarState &&
      currentSelection == o.currentSelection &&
      cause == o.cause &&
      preview == o.preview &&
      previewAnchoredAtStart == o.previewAnchoredAtStart &&
      resolution == o.resolution &&
      _setEq(selections, o.selections);
}
