// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/di.dart';
import 'package:angular_components/model/observable/observable.dart';

import 'comparison.dart';

export 'comparison.dart' show DatepickerComparison;
export 'range.dart' show DatepickerDateRange;

/// Represents the full state of externally-visible stuff selected by the
/// material date range picker component. This is mostly here to make dependency
/// injection easier.
@Injectable()
class DatepickerModel extends ObservableReference<DatepickerComparison> {
  DatepickerModel([DatepickerComparison value]) : super(value);
}
