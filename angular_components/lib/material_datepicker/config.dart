// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Global configuration options for datepicker components.
class DatepickerConfig {
  /// For date range selection, whether clicking to move the start date should
  /// also move the end date (preserving the length of the selected range).
  ///
  /// Defaults to true. No effect on single-date calendars.
  final bool movingStartMaintainsLength;

  DatepickerConfig({this.movingStartMaintainsLength = true});
}
