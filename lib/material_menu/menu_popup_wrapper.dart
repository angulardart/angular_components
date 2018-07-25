// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/model/ui/accepts_width.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';

/// A mixin for classes that wrap a [MenuPopupComponent].
class MenuPopupWrapper implements AcceptsWidth {
  /// The displayed menu.
  @Input()
  MenuModel menu;

  /// Whether the menu is open.
  @Input()
  set isExpanded(value) {
    if (_expanded.value == value) return;
    _expanded.value = getBool(value);
  }

  bool get isExpanded => _expanded.value;

  /// Outputs an event when the menu is expanded.
  @Output()
  Stream<bool> get isExpandedChange => _expanded.stream;
  final _expanded = ObservableReference<bool>(false);

  /// Selects 1 of 5 predefined width values for the menu.
  ///
  /// Ignored if [menu] instance has a width set. See [AcceptsWidth.width] for
  /// more details.
  int get width => menu?.width ?? _width;

  /// Width of the menu.
  @override
  @Input()
  set width(val) {
    _width = getInt(val, defaultValue: 0);
    assert(_width >= 0 && _width <= 5);
  }

  int _width = 0;

  /// Preferred positions to pass to the material popup component.
  ///
  /// For the meaning of this parameter, see the PopupInterface documentation.
  @Input()
  Iterable preferredPositions;
}
