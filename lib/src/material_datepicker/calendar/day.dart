// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../../material_datepicker/calendar.dart';

/// A calendar day.
class CalendarDay {
  final Date date;

  List<String> _classes;

  CalendarDay(this.date, CalendarState state) {
    updateClasses(state);
  }

  void updateClasses(CalendarState state) {
    _classes = state != null ? _boundaryClasses(state).toList() : [];
  }

  int get day => date.day;

  List<String> get classes => _classes;

  Iterable<String> _boundaryClasses(CalendarState state) => state.selections
      .where((r) => r.start == date || r.end == date)
      .expand((r) => ['boundary', 'boundary-${r.id}']);
}
