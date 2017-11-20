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
  bool get isExpanded => _expanded.value;
  @Input()
  set isExpanded(value) {
    if (_expanded.value == value) return;
    _expanded.value = getBool(value);
  }

  @Output()
  Stream<bool> get isExpandedChange => _expanded.stream;
  final _expanded = new ObservableReference<bool>(false);

  /// Width of the menu.
  ///
  /// Ignored if [menu] instance has a width set.
  /// Preset width, 1 through 5. By default, the material list will expand to
  /// its content. Note: The spec clearly lays out predefined list sizes so use
  /// the default, expanding size, sparingly.
  /// Each width multiplies the base block width (64px on desktop and tablet) by
  /// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
  /// Set to 0 to have the list expand to fit its content.
  int get width => menu?.width ?? _width;

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
