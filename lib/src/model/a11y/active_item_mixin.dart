// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as dom;

import '../../utils/angular/properties/properties.dart';
import '../../utils/browser/dom_service/dom_service.dart';

/// Mixin for elements able to be activated through mouse or keyboard, like
/// list elements.
///
/// Components including this mixin must subscribe to call onMouseEnter/Leave
/// based on events.
abstract class ActiveItemMixin {
  /// Dom element of the item, that will be scrolled to view on activate.
  dom.HtmlElement get element;

  /// An instance of DomService, used to coordinate scrolling.
  DomService get domService;

  bool _active;

  /// Whether the element is active.
  bool get active => _active ?? false;
  set active(value) {
    value = getBool(value);
    if (value == _active) return;
    _active = value;
    if (_active && !_hasHover) {
      domService.scheduleWrite(() {
        element.scrollIntoView();
      });
    }
  }

  /// Whether the element has hover.
  bool _hasHover = false;

  void onMouseEnter() {
    _hasHover = true;
  }

  void onMouseLeave() {
    _hasHover = false;
  }
}
