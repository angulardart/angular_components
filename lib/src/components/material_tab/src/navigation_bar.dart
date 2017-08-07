// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import '../../../utils/browser/dom_service/dom_service.dart';

// Private directive that catches the navi bar element of the tab panel.
// Also provides convenient methods for handling scrolling on it.
@Directive(selector: '[naviBar]')
class NaviBarDirective {
  final HtmlElement _element;
  bool _isRtl = false;

  NaviBarDirective(this._element, @Optional() DomService domService) {
    if (domService != null) {
      domService.scheduleRead(() {
        _isRtl = _element.getComputedStyle().direction == 'rtl';
      });
    }
  }

  bool get isRtl => _isRtl;

  bool get atStart => _element.scrollLeft == 0;
  bool get atEnd =>
      _element.scrollLeft.abs() + _element.clientWidth == _element.scrollWidth;

  int get offsetWidth => _element.offsetWidth;
  int get scrollWidth => _element.scrollWidth;

  void scrollLeft() {
    var newValue = _element.scrollLeft.abs() - _element.clientWidth;
    if (newValue < 0) newValue = 0;
    _element.scrollLeft = isRtl ? -newValue : newValue;
  }

  void scrollRight() {
    var newValue = _element.scrollLeft.abs() + _element.clientWidth;
    _element.scrollLeft = isRtl ? -newValue : newValue;
  }
}
