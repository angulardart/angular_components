// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A highlighted range in a calendar period. There should be one of these
/// per block of color. E.g. if a week contains only one range, there'll be one
/// highlight; if it has two ranges, it'll have two highlights if the ranges
/// don't overlap, or three if they do.
///
/// This class is used both for date highlights within weeks, and for month
/// highlights within years.
///
/// The start and end indices don't exactly correspond to the day of the
/// week / the month of the year ("N" means the number of points in the time
/// period such as days in a week or months in a year):
/// - 0 means "coming in from last period (week/year)"
/// - 1..N mean point I in the period (day I in the week or month I in the year)
/// - (N+1) means "going into next period (week/year)"
class Highlight {
  final int start;
  final int end;
  final List<CalendarSelection> containedRanges;

  /// Offset applied to start and end when assigning CSS classes. This is used
  /// for cases where highlights are wrapped around a line break (such as
  /// grouping months within a year into 2 rows of 6 months).
  final int classIndexOffset;

  final int group;

  List<String> _classes;

  Highlight(this.start, this.end, this.containedRanges,
      {this.classIndexOffset = 0, this.group = 0});

  List<String> get classes => _classes ?? _initClasses();

  List<String> _initClasses() {
    _classes = ['highlight']
      ..addAll(_positionClasses())
      ..addAll(_colorClasses());
    return _classes;
  }

  List<String> _positionClasses() =>
      ['start-${start + classIndexOffset}', 'end-${end + classIndexOffset}'];
  Iterable<String> _colorClasses() =>
      containedRanges.map((r) => 'highlight-${r.id}');

  @override
  String toString() => 'Highlight on $containedRanges ($start - $end)';
}

/// Base class for calendar time periods that can contain [Highlight]s, such as
/// [CalendarWeek] and [CalendarYear].
abstract class _HasHighlights {
  static final Function _setEq = UnorderedIterableEquality().equals;

  /// `true` if the two highlights are for the same set of calendar selections.
  static bool _matchingRangesEq(Highlight a, Highlight b) => _setEq(
      a.containedRanges.map((r) => r.id), b.containedRanges.map((r) => r.id));

  CalendarState _state;
  List<Highlight> _highlights;

  _HasHighlights(this._state);

  List<Highlight> get highlights => _highlights;

  Iterable<Highlight> highlightsInGroup(int group) {
    return highlights.where((h) => h.group == group);
  }

  /// Rebuilds the highlights in the time period based on the
  /// [CalendarSelection] instances present in the associated [CalendarState]
  /// which are at least partially within the time period.
  void _updateHighlights() {
    _highlights = _mergedHighlights().toList();

    // Force initialize highlights' classes
    _highlights.forEach((h) => h.classes);
  }

  /// Gets the selected ranges which contain both given dates.
  List<CalendarSelection> _matching(Date a, Date b) {
    List<CalendarSelection> selections = _state?.selections ?? [];
    return selections
        .where(
            (r) => _state.highlighted(r.id, a) && _state.highlighted(r.id, b))
        .toList();
  }

  /// Gets a series of [Highlight] instances that cover each consecutive pair of
  /// points within the time period (days within a week or months within a
  /// year).
  Iterable<Highlight> _generateHighlights();

  /// Takes the output of `_generateHighlights` and merges together equivalent
  /// adjacent highlights to minimize the number of highlight divs required.
  /// Also drops any empty highlights.
  ///
  /// The idea is to turn this (for weeks):
  ///
  ///     |       Mon      Tue      Wed       Thu       Fri       Sat Sun |
  ///     |        2        3        4         5         6         7   8  |
  ///     | (blue)   (blue)   (blue)   (green)   (green)   (green) 7   8  |
  ///
  /// Into this:
  ///
  ///     |       Mon      Tue      Wed       Thu       Fri       Sat Sun |
  ///     |        2        3        4         5         6         7   8  |
  ///     | (         blue         )   (          green          ) 7   8  |
  Iterable<Highlight> _mergedHighlights() sync* {
    var current = Highlight(0, 0, []);
    for (var h in _generateHighlights()) {
      if (_matchingRangesEq(h, current)) {
        // This range matches the same set of selections as the last; merge them
        // into one larger range
        current = Highlight(current.start, h.end, h.containedRanges);
      } else {
        // This range matches a different set of selections; yield the last one
        // and start keeping track of this one
        if (current.containedRanges.isNotEmpty) {
          yield current;
        }
        current = h;
      }
    }
    // yield whatever's left
    if (current.containedRanges.isNotEmpty) {
      yield current;
    }
  }
}
