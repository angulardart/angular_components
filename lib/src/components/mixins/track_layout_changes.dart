// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../utils/angular/properties/properties.dart';

/**
 * Mixin for trackLayoutChanges property pass through to material popup to
 * avoid duplicate code in multiple components.
 */
class TrackLayoutChangesMixin {
  bool _trackLayoutChanges = true;

  /// Sets whether the suggestion list scrolls with the input box.
  ///
  /// This is a pass through property, as defined in [PopupInterface].
  @Input()
  set trackLayoutChanges(dynamic value) {
    _trackLayoutChanges = getBool(value);
  }

  bool get trackLayoutChanges => _trackLayoutChanges;
}
