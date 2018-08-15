// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:meta/meta.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Handles input events on the calendar.
class CalendarListener implements Disposable {
  void onClick(Date day) {}
  void onMouseDown(Date day) {}
  void onMouseMove(Date day) {}
  void onMouseLeave(Date day) {}
  void onKeypress() {}
  @override
  void dispose() {}

  const CalendarListener.noop();
  factory CalendarListener.singleDate(
      ObservableReference<CalendarState> model) = _DateListener;
  factory CalendarListener.dateRange(ObservableReference<CalendarState> model,
      {@required bool movingStartMaintainsLength}) = _RangeListener;
}

/// Listens for clicks on single dates, and selects those.
class _DateListener implements CalendarListener {
  final ObservableReference<CalendarState> model;
  _DateListener(this.model);

  @override
  void onClick(Date day) {
    model.value = model.value.setCurrentSelection(day, day);
  }

  @override
  void onMouseMove(Date day) {
    model.value = model.value.updateCurrentPreview(day);
  }

  @override
  void onKeypress() {
    // TODO(google): Keyboard interaction
  }

  @override
  void onMouseDown(Date day) {}
  @override
  void onMouseLeave(Date day) {}
  @override
  void dispose() {}
}

/// The current state of drag operations in the date-range picker.
///
/// `canPreview`: No drag. Preview selection on mouseover, dismiss on mouseleave
/// `dragging`: Currently dragging out a selection; will exit on mouseup.
///
/// The `pendingGrabOrClick` and `pendingDragOrClick` states wait to determine
/// whether the latest mousedown event was the start of a click or a drag.
enum _DragState { canPreview, pendingGrabOrClick, pendingDragOrClick, dragging }

/// Listens for date range selections.
class _RangeListener implements CalendarListener {
  final ObservableReference<CalendarState> model;
  final bool movingStartMaintainsLength;
  final _disposer = Disposer.multi();

  _RangeListener(this.model, {@required this.movingStartMaintainsLength}) {
    _initSelectionPreview();
    _disposer.addStreamSubscription(model.stream.listen((s) {
      if (s.currentSelection != previewedSelection) {
        // Reinit preview and reset click count whenever a different range
        // becomes selected
        _initSelectionPreview();
        _consecutiveClicks = 0;
      } else if (s.cause == CausedBy.external || s.cause == CausedBy.drag) {
        // Reset click count when the range's value is changed externally
        _consecutiveClicks = 0;
      }
    }));
  }

  _DragState state = _DragState.canPreview;

  // The first date selected during a drag.
  Date dragAnchor;

  // The ID of the CalendarSelection being previewed
  String previewedSelection;

  // The ID of the CalendarSelection relating to the pendingGrabOrClick state
  String selectionPendingGrab;

  // Clicking twice to set a range causes the next range to be selected
  int _consecutiveClicks = 0;

  bool _datesEqual(Date a, Date b) =>
      datesEqualAtResolution(a, b, model.value.resolution);

  void _initSelectionPreview() {
    previewedSelection = model.value.currentSelection;
    _consecutiveClicks = 0;
  }

  // If the given date is a boundary of an already-existing calendar range,
  // sets up a pending drag state for that range with the drag anchor set to
  // the other end of the range, and returns `true`. Otherwise returns `false`.
  //
  // This is to support "grabbing" one of the highlighted range boundaries and
  // dragging that, instead of blowing away the range and creating a new one.
  // This function does not change any actual selection state, since we don't
  // know yet whether this is actually a grab or just the beginning of a click.
  bool _grabExistingRange(Date d) {
    if (state != _DragState.canPreview) {
      return false;
    }

    for (var selection in model.value.selections) {
      if (selection.start == null || selection.end == null) {
        // For now, dragging open-ended ranges is not supported
        // TODO(google): Support dragging open-ended ranges, or deprecate them
        continue;
      }
      if (_datesEqual(d, selection.start)) {
        state = _DragState.pendingGrabOrClick;
        dragAnchor = selection.end;
        selectionPendingGrab = selection.id;
        return true;
      }
      if (_datesEqual(d, selection.end)) {
        state = _DragState.pendingGrabOrClick;
        dragAnchor = selection.start;
        selectionPendingGrab = selection.id;
        return true;
      }
    }
    return false;
  }

  // Modify the selection to match the current preview state.
  // This method should not make assumptions about which input event triggered
  // it.
  void confirmPreviewedSelection() {
    if (model.value.preview == null) return;

    // Switch to the next range every 2 clicks
    _consecutiveClicks++;
    model.value = model.value.confirmPreview(
        confirmRange: _consecutiveClicks >= 2,
        movingStartMaintainsLength: movingStartMaintainsLength);
  }

  // This might be the start of a drag or grab, or the start of a click.
  // Set up some pending state, but don't affect the actual ranges yet;
  // we can't touch the real data until we know for sure what the user's
  // intention is, and for that we need to wait for another mouse event.
  // Also, some tests call onClick() directly and never touch this function. So
  // avoid doing real work in onMouseDown(), and don't rely on it being called.
  @override
  void onMouseDown(Date day) {
    if (!_grabExistingRange(day)) {
      // It's possible that this mouse down is the start of a drag, so
      // track potential drag status.
      state = _DragState.pendingDragOrClick;
      dragAnchor = day;
    }

    // Terminate drags on mouseup, whether inside the calendar or not
    // TODO(google): Is this webworker-safe?
    _disposer.addStreamSubscription(document.onMouseUp.take(1).listen((_) {
      if (state == _DragState.dragging) {
        // If this was actually a drag, confirm current selection (set
        // previously by mousemove) and select the next range
        model.value = CalendarState(
            selections: model.value.selections,
            currentSelection: model.value.currentSelection,
            cause: CausedBy.rangeConfirm,
            resolution: model.value.resolution);
      }

      // Clear dragging state in any case
      state = _DragState.canPreview;
      dragAnchor = null;
    }));
  }

  @override
  void onClick(Date day) {
    if (model.value.has(model.value.currentSelection)) {
      updateActiveDragOrPreview(day); // in case onMouseMove() didn't fire
      confirmPreviewedSelection();
    } else {
      // Selection is null, so create a new selection here and make the
      // end date active.
      model.value = model.value.setCurrentSelection(day, day,
          cause: CausedBy.endpointConfirm, previewAnchoredAtStart: true);
      _consecutiveClicks = 1;
    }

    // Mouse has been released, so any drag state has ended
    state = _DragState.canPreview;
    dragAnchor = null;
  }

  @override
  void onMouseMove(Date day) {
    updateActiveDragOrPreview(day);
  }

  // When we're dragging, update the date range based on the new position.
  // Otherwise, update the preview.
  void updateActiveDragOrPreview(Date day) {
    // If we mouse over a date other than the anchor during a pending drag/grab,
    // then the drag is no longer pending, so begin dragging state.
    if (day != dragAnchor && state != _DragState.canPreview) {
      // If a grab is pending, ensure we select the right range before making
      // changes
      if (state == _DragState.pendingGrabOrClick &&
          model.value.has(model.value.currentSelection)) {
        assert(selectionPendingGrab != null);
        model.value = model.value.select(selectionPendingGrab);
        selectionPendingGrab = null;
      }
      state = _DragState.dragging;
    }

    model.value = (state == _DragState.dragging)
        ? model.value.updateDrag(day, dragAnchor)
        : model.value.updateCurrentPreview(day);
  }

  // When the mouse leaves a valid date, previewing should stop.
  // (NB: Dragging can continue. It's OK to leave the calendar during a drag.)
  @override
  void onMouseLeave(Date day) {
    if (state == _DragState.canPreview) {
      model.value = model.value.cancelCurrentPreview();
    }
  }

  @override
  void onKeypress() {
    // TODO(google): Keyboard interaction
  }

  @override
  void dispose() => _disposer.dispose();
}
