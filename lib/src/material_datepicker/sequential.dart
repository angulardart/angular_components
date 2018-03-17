// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/observable/observable.dart';

/// Something that can move to a next/previous element.
///
/// This is used instead of [BidirectionalIterator] because we need to know
/// whether or not there is a next/prev element, without necessarily moving to
/// the next/prev element.
abstract class Sequential<T> {
  /// `true` if there's a next item to advance to.
  ObservableView<bool> get hasNext;

  /// `true` if there's a previous item to revert to.
  ObservableView<bool> get hasPrev;

  /// Tries to advance to the next item, and returns it if possible.
  T next();

  /// Tries to revert to the previous item, and returns it if possible.
  T prev();
}
