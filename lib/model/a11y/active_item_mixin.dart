// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as dom;

import 'package:angular/angular.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'active_item_directive.dart';

/// Mixin for elements able to be activated through mouse or keyboard, like
/// list elements.
@Deprecated('Use the ActiveItemDirective instead')
abstract class ActiveItemMixin {
  /// Dom element of the item, that will be scrolled to view on activate.
  dom.HtmlElement get element;

  /// An instance of DomService, used to coordinate scrolling.
  DomService get domService;

  /// An instance of the directive for migration.
  // This is only for migration to keep active in sync and will be removed soon.
  ActiveItemDirective get activeItemDirective;

  bool _active = false;

  /// Whether the element is active.
  @HostBinding('class.active')
  bool get active => _active || activeItemDirective?.active == true;

  /// Marks item as active from keyboard selection.
  @Input()
  set active(bool value) {
    if (value == _active) return;
    _active = value;
    if (_active && !_hasHover) {
      domService.scheduleWrite(() {
        try {
          var options = js_util.newObject();
          js_util.setProperty(options, 'block', 'nearest');
          js_util.setProperty(options, 'inline', 'nearest');
          js_util.callMethod(element, 'scrollIntoView', [options]);
        } catch (_) {
          element.scrollIntoView();
        }
      });
    }
  }

  /// Whether the element has hover.
  bool _hasHover = false;

  @HostListener('mouseenter')
  void onMouseEnter() {
    _hasHover = true;
  }

  @HostListener('mouseleave')
  void onMouseLeave() {
    _hasHover = false;
  }
}
