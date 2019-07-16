// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' show min, max;

import 'package:angular_components/utils/angular/scroll_host/interface.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

class StickyControllerImpl implements StickyController {
  final DomService _domService;
  final ScrollHost _scrollHost;
  StreamController<Null> _onUpdateController;

  @override
  final bool usePositionSticky = false;

  StreamSubscription _layoutSubscription;

  final _rowMap = <Element, _StickyRow>{};
  final Set<Element> _floatingElements = {};

  /// The ordered list of rows, based on their position. The order will be
  /// cached between layout checks, unless there was a register or an unregister
  /// call.
  List<_StickyRow> _orderedRows;
  StickyContainerLayout<_StickyRow> _currentLayout;

  StickyControllerImpl(this._domService, this._scrollHost);

  @override
  void stick(Element element, StickyPosition position, Element range,
      {String stickyClass, String stickyKey}) {
    _StickyRow row = _rowMap[element];
    // if the definition's key fields are the same, assume that nothing changed
    if ((row != null) &&
        (row.position == position) &&
        (row.range == range) &&
        (row.stickyKey == stickyKey)) {
      return;
    }
    unstick(element);
    _rowMap[element] =
        _StickyRow(element, position, range, stickyClass, stickyKey);
    _startEventListeners();
  }

  @override
  void unstick(Element element) {
    // clearing ordered row cache for both register and unregister
    _orderedRows = null;
    _StickyRow row = _rowMap.remove(element);
    if (row == null) return;
    _currentLayout?.remove(row);
    row.resetTop();
    if (_rowMap.isEmpty) {
      _stopEventListeners();
    }
  }

  @override
  void syncOnScroll() {
    if (_rowMap.isNotEmpty) _checkAndUpdateLayout();
  }

  @override
  void trackFloating(Element element) {
    _floatingElements.add(element);
    _scheduleLayoutCheck();
  }

  @override
  void untrackFloating(Element element) {
    _floatingElements.remove(element);
    _scheduleLayoutCheck();
  }

  @override
  Stream<Null> get onUpdate {
    _onUpdateController ??= StreamController<Null>.broadcast(sync: true);
    return _onUpdateController.stream;
  }

  @override
  bool enableSmoothPushing = false;

  @override
  void dispose() {
    if (_rowMap.isNotEmpty) {
      List<Element> toRemove = List.from(_rowMap.keys);
      for (Element element in toRemove) {
        unstick(element);
      }
    }
    _onUpdateController?.close();
  }

  // Making sure that at least one layout observe will happen: a layout write
  // will trigger a subsequent layout check.
  void _scheduleLayoutCheck() {
    _domService.scheduleWrite(() {});
  }

  void _startEventListeners() {
    if (_layoutSubscription != null) return;
    _layoutSubscription = _domService.onLayoutChanged.listen((_) {
      _checkAndUpdateLayout();
    });
    // Make sure scroll host is listening for events that trigger scrolling.
    _scrollHost.startNativeScrollListener();

    _scheduleLayoutCheck();
  }

  void _stopEventListeners() {
    if (_layoutSubscription != null) {
      _layoutSubscription.cancel();
      _layoutSubscription = null;
    }
  }

  /// Gets the available area for the sticking elements.
  ///
  /// Starting from the scroll host's area, we subtract the regions of the
  /// already sticking elements (i.e tracked by [acxStickyFloating] directive).
  /// Each element is compared to the top or bottom border of the current area,
  /// and will be assumed to belong to the closer one. The area will be reduced
  /// to exclude the element's area on their respective border.
  Rectangle _getAvailableArea() {
    Rectangle hostRect = _scrollHost.calcViewportRect();
    // assuming that floating elements are either at the top or at the bottom
    for (Element element in _floatingElements) {
      Rectangle rect = element.getBoundingClientRect();
      num rectMiddle = rect.top + (rect.height / 2.0);
      num topDistance = (hostRect.top - rectMiddle).abs();
      num bottomDistance = (hostRect.bottom - rectMiddle).abs();
      if (topDistance < bottomDistance) {
        num newTop = max(hostRect.top, rect.bottom);
        num newHeight = hostRect.bottom - newTop;
        if ((newTop != hostRect.top) && (newHeight > 0)) {
          hostRect =
              Rectangle(hostRect.left, newTop, hostRect.width, newHeight);
        }
      } else {
        num newBottom = min(hostRect.bottom, rect.top);
        num newHeight = newBottom - hostRect.top;
        if ((newBottom != hostRect.bottom) && (newHeight > 0)) {
          hostRect =
              Rectangle(hostRect.left, hostRect.top, hostRect.width, newHeight);
        }
      }
    }
    return Rectangle(
        hostRect.left, hostRect.top, hostRect.width, hostRect.height);
  }

  StickyContainerLayout<_StickyRow> _getLayout() {
    _observeRowPositions();
    Rectangle hostPosition = _getAvailableArea();

    return StickyRowUtils.calculateLayout<_StickyRow>(
        hostPosition, _orderedRows,
        enableSmoothPushing: enableSmoothPushing);
  }

  /// Moves sticky rows back to their sticky locations after the host has moved.
  void _checkAndUpdateLayout() {
    StickyContainerLayout<_StickyRow> layout = _getLayout();
    if (layout != _currentLayout && _orderedRows != null) {
      _updateContainer(layout);
      if (_onUpdateController?.hasListener ?? false) {
        _onUpdateController.add(null);
      }
    }
  }

  void _observeRowPositions() {
    if (_orderedRows == null) {
      _orderedRows = _rowMap.values.toList();
    }
    for (int i = 0; i < _orderedRows.length; i++) {
      _orderedRows[i].readRowPositions();
    }
    // For rows that have StickyPosition.TOP, they are sorted from top down.
    // For rows that have StickyPosition.BOTTOM, they are sorted from bottom up.
    // Rows that have StickyPosition.TOP are stored before those have
    // StickyPosition.BOTTOM.
    _orderedRows.sort((a, b) {
      if (a.isTop != b.isTop) {
        return a.isTop ? -1 : 1;
      }
      return a.isTop
          ? a.rowPosition.top.compareTo(b.rowPosition.top)
          : b.rowPosition.top.compareTo(a.rowPosition.top);
    });
  }

  void _updateContainer(StickyContainerLayout<_StickyRow> layout) {
    if (layout.topRows != null) {
      num top = layout.hostPosition.top;
      for (int i = 0; i < layout.topRows.length; i++) {
        final data = layout.topRows[i];
        data.row.moveToTop(top + data.offsetY);
        top += data.row.rowPosition.height;
      }
    }
    if (layout.bottomRows != null) {
      num top = layout.hostPosition.bottom;
      for (int i = 0; i < layout.bottomRows.length; i++) {
        final data = layout.bottomRows[i];
        top -= data.row.rowPosition.height;
        data.row.moveToTop(top + data.offsetY);
      }
    }
    if (layout.hiddenRows != null) {
      for (int i = 0; i < layout.hiddenRows.length; i++) {
        layout.hiddenRows[i].softResetTop();
      }
    }
    _currentLayout = layout;
  }
}

/// Interface to make testing easier
abstract class StickyRowPosition {
  String get stickyKey;
  Rectangle get rowPosition;
  Rectangle get rangePosition;
  bool get isTop;
  bool get isBottom;
}

class _StickyRow implements StickyRowPosition {
  final Element element;
  final StickyPosition position;
  final Element range;
  final String stickyClass;
  final String _stickyKey;

  @override
  Rectangle rowPosition;
  @override
  Rectangle rangePosition;
  String _currentPosition = '';
  String _currentTransform = '';
  String _currentZIndex = '';

  /// The y-offset of the row.
  ///
  /// This value is always rounded to align to the pixel grid.
  set translateY(num value) {
    _translateY = value.round();
  }

  num get translateY => _translateY;
  num _translateY = 0;

  _StickyRow(this.element, this.position, this.range, this.stickyClass,
      this._stickyKey) {
    assert(isTop || isBottom);
  }

  @override
  String get stickyKey => _stickyKey;

  @override
  bool get isTop => (position == StickyPosition.TOP);

  @override
  bool get isBottom => (position == StickyPosition.BOTTOM);

  /// Observes the position of the row's Element and its range.
  void readRowPositions() {
    rowPosition = element.getBoundingClientRect();
    if (translateY != null) {
      rowPosition = Rectangle(rowPosition.left, rowPosition.top - translateY,
          rowPosition.width, rowPosition.height);
    }
    rangePosition = range?.getBoundingClientRect();
  }

  /// Sets the row back to its starting position and styling, but without
  /// resetting its positioning algorithm.
  void softResetTop() {
    if (translateY == 0) return;
    translateY = 0;
    if (_currentTransform != '' || _currentZIndex != '') {
      element.style
        ..transform = ''
        ..zIndex = '';
    }
    _currentTransform = '';
    _currentZIndex = '';
    if (stickyClass != null) element.classes.toggle(stickyClass, false);
  }

  /// Completely resets the row's position and styling (expensive in Firefox).
  void resetTop() {
    softResetTop();
    if (_currentPosition != '') {
      element.style.position = '';
      _currentPosition = '';
    }
  }

  /// Sets sticky styles and positions the row onto the given [top] coordinate.
  void moveToTop(num top) {
    num newY = top - rowPosition.top;
    if (translateY != newY) {
      translateY = newY;
      String newTransform = 'translate3d(0px, ${translateY}px, 0px)';
      String newZIndex = '${stickyControllerZIndex}';
      if (_currentPosition != 'relative' ||
          _currentTransform != newTransform ||
          _currentZIndex != newZIndex) {
        element.style
          ..position = 'relative'
          ..transform = newTransform
          ..zIndex = newZIndex;
        _currentPosition = 'relative';
        _currentTransform = newTransform;
        _currentZIndex = newZIndex;
      }
      if (stickyClass != null) element.classes.toggle(stickyClass, true);
    }
  }

  @override
  String toString() =>
      '_StickyRow ' +
      {
        'isBottom': isBottom,
        'isTop': isTop,
        'rowPosition': rowPosition,
        'rangePosition': rangePosition,
        'translateY': translateY,
        'stickyClass': stickyClass,
      }.toString();
}

/// Wraps a row of arbitrary type with additional data needed by the algorithm.
class _RowData<T> {
  T row;
  num offsetY;

  _RowData(this.row, {this.offsetY = 0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RowData &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          offsetY == other.offsetY;

  @override
  int get hashCode => row.hashCode ^ offsetY.hashCode;

  @override
  String toString() => '_RowData{row: $row, offsetY: $offsetY}';
}

/// The collection of rows the sticky container should put on the top, on the
/// bottom, or keep hidden.
class StickyContainerLayout<T> {
  /// The host's visible area
  Rectangle hostPosition;

  /// Rows that should stick to the top.
  List<_RowData<T>> topRows;

  /// Rows that should stick to the bottom.
  List<_RowData<T>> bottomRows;

  /// Rows that should not stick.
  List<T> hiddenRows;

  /// The offset we are using to move the row to the sticking position. Both
  /// the top and bottom rows are contained, and its use is only for checking
  /// whether any UI update needs to be done.
  List<num> _translateYs;

  @override
  bool operator ==(other) =>
      (other is StickyContainerLayout) &&
      (hostPosition == other.hostPosition) &&
      _listEquals(topRows, other.topRows) &&
      _listEquals(bottomRows, other.bottomRows) &&
      _listEquals(hiddenRows, other.hiddenRows) &&
      _listEquals(_translateYs, other._translateYs);

  bool _listEquals(List aList, List bList) {
    if ((aList == null) && (bList == null)) return true;
    if ((aList == null) || (bList == null)) return false;
    if (aList.length != bList.length) return false;
    for (int i = 0; i < aList.length; i++) {
      if (aList[i] != bList[i]) {
        if (aList[i] is double && bList[i] is double) {
          if (aList[i].floor() != bList[i].floor()) {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }

  void remove(T row) {
    topRows?.removeWhere((rowData) => rowData.row == row);
    bottomRows?.removeWhere((rowData) => rowData.row == row);
    hiddenRows?.remove(row);
  }

  @override
  String toString() =>
      'StickyContainerLayout ' +
      {
        'hostPosition': hostPosition,
        'topRows': topRows,
        'bottomRows': bottomRows,
        'hiddenRows': hiddenRows,
        '_translateYs': _translateYs
      }.toString();
}

/// Helper methods, separated for simpler testing.
abstract class StickyRowUtils {
  /// Arbitrary limit in order to prevent the sticky rows to cover too many
  /// content rows.
  static final int MIN_CONTENT_HEIGHT_PX = 100;

  /// Whether the row should stick or not, given the surrounding.
  static bool shouldStick(bool isTop, num hostTop, num hostBottom,
      Rectangle rowPosition, Rectangle rangePosition) {
    if (rowPosition.height == 0) {
      return false;
    }
    if (isTop) {
      // the range, if it exists, is still visible or below the bottom
      bool rangeVisible = rangePosition == null ||
          rangePosition.top > (hostTop + rowPosition.height);
      return
          // the row is above the top
          (rowPosition.top < hostTop) &&
              rangeVisible &&
              // arbitrary limit to prevent too thin display area
              ((hostBottom - hostTop - rowPosition.height) >
                  MIN_CONTENT_HEIGHT_PX);
    } else {
      // the range, if it exists, is still visible or above the top
      bool rangeVisible = rangePosition == null ||
          rangePosition.bottom < (hostBottom - rowPosition.height);
      return
          // the row is below the bottom
          (rowPosition.bottom > hostBottom) &&
              rangeVisible &&
              // arbitrary limit to prevent too thin display area
              ((hostBottom - hostTop - rowPosition.height) >
                  MIN_CONTENT_HEIGHT_PX);
    }
  }

  /// Decides what rows should be on top, on bottom, or be hidden (inlined),
  /// and computes an additional offset for top/bottom rows.
  static StickyContainerLayout<T> calculateLayout<T extends StickyRowPosition>(
      Rectangle hostPosition, List<T> rows,
      {bool enableSmoothPushing = false}) {
    num hostTop = hostPosition.top;
    num hostBottom = hostPosition.bottom;
    var layout = StickyContainerLayout<T>()
      ..hostPosition = hostPosition
      .._translateYs = [];

    // An eager, single-pass algorithm to decide which rows should stick or not.
    // The downside: importance of the rows are not accounted, and it may not
    // display a summary footer in certain conditions.
    Map<String, int> stickyKeyToRowIndex;
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      bool shouldStick = StickyRowUtils.shouldStick(
          row.isTop, hostTop, hostBottom, row.rowPosition, row.rangePosition);

      // Prevent sticky rows with duplicate sticky keys from showing. The set
      // of rows sharing the same sticky key are assumed to be the same height.
      // First check for existing stuck rows with duplicate sticky keys.
      bool hasStuckDuplicate = shouldStick &&
          row.stickyKey != null &&
          stickyKeyToRowIndex?.containsKey(row.stickyKey) == true;

      // Update [shouldStick] computation with hypothetical host dimensions that
      // does not contain the previously duplicate stuck row. For bottom rows,
      // as only the first instance is stuck, the re-computation is unnecessary
      // and skipped.
      if (hasStuckDuplicate && row.isTop) {
        var duplicateRow = layout.topRows[stickyKeyToRowIndex[row.stickyKey]];
        shouldStick = StickyRowUtils.shouldStick(
            row.isTop,
            hostTop - duplicateRow.row.rowPosition.height,
            hostBottom,
            row.rowPosition,
            row.rangePosition);
      }

      // Finally, add to layout:
      //
      // * Append a sticky row directly to layout if there are no previous rows
      //   with duplicate sticky keys.
      // * Otherwise, for top rows with an existing sticky duplicate, replace
      //   the duplicate row directly. Avoid adjusting layout dimensions, since
      //   all stuck rows are assumed to share the same height. No-op for bottom
      //   rows with an existing sticky duplicate, as only the first instance
      //   should be stuck.
      if (shouldStick && !hasStuckDuplicate) {
        if (row.isTop) {
          if (layout.topRows == null) {
            layout.topRows = [];
          }
          layout.topRows.add(_RowData(row, offsetY: 0));
          layout._translateYs.add(hostTop - row.rowPosition.top);
          hostTop += row.rowPosition.height;

          if (row.stickyKey != null) {
            stickyKeyToRowIndex ??= <String, int>{};
            stickyKeyToRowIndex[row.stickyKey] = layout.topRows.length - 1;
          }
        } else {
          assert(row.isBottom);
          if (layout.bottomRows == null) {
            layout.bottomRows = [];
          }
          layout.bottomRows.add(_RowData(row, offsetY: 0));
          layout._translateYs.add(hostBottom - row.rowPosition.bottom);
          hostBottom -= row.rowPosition.height;

          if (row.stickyKey != null) {
            stickyKeyToRowIndex ??= <String, int>{};
            stickyKeyToRowIndex[row.stickyKey] = layout.bottomRows.length - 1;
          }
        }
      } else {
        if (layout.hiddenRows == null) {
          layout.hiddenRows = [];
        }

        bool shouldReplace = shouldStick && hasStuckDuplicate && row.isTop;
        if (shouldReplace) {
          final duplicateRow =
              layout.topRows[stickyKeyToRowIndex[row.stickyKey]].row;
          layout.hiddenRows.add(duplicateRow);
          layout.topRows[stickyKeyToRowIndex[row.stickyKey]] =
              _RowData(row, offsetY: 0);

          // Partial support for replacing rows of different heights.
          // This still doesn't work correctly when interleaving elements with
          // different stickyKeys, but fixes a glitch in some cases.
          // As before, when interleaving stickyKeys, rows with the same
          // stickyKey must have the same height.
          hostTop += row.rowPosition.height - duplicateRow.rowPosition.height;
        } else {
          layout.hiddenRows.add(row);
        }
      }

      // Non-stuck (hidden) rows sharing a stickyKey with a stuck top row should
      // "push" that stuck top row to prevent overlapping.
      // This doesn't work correctly when interleaving elements with different
      // stickyKeys, so is disabled by default.
      // TODO(google): Relax this limitation.
      // TODO(google): Support this for bottom rows as well.
      if (enableSmoothPushing &&
          !shouldStick &&
          hasStuckDuplicate &&
          row.isTop) {
        var duplicateRowIdx = stickyKeyToRowIndex[row.stickyKey];
        var duplicateRow = layout.topRows[duplicateRowIdx];
        if (row.rowPosition.top < hostTop) {
          duplicateRow.offsetY = row.rowPosition.top - hostTop;
        }
      }
    }
    return layout;
  }
}
