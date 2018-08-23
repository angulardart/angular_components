// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' as dom;

import 'package:angular/angular.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// Directive for elements able to be activated through mouse or keyboard, like
/// list elements.
///
/// Will scroll the item into view as long as it was made active when mouse is
/// not hovering over it.
@Directive(selector: '[itemActive]')
class ActiveItemDirective implements AfterViewInit, OnDestroy {
  /// Dom element of the item, that will be scrolled to view on activate.
  final dom.HtmlElement _element;

  /// An instance of DomService, used to coordinate scrolling.
  final DomService _domService;

  /// Parent modal if any.
  final Modal _modal;

  /// Parent popup if any.
  final PopupRef _popupRef;

  bool _active = false;

  bool _initialized = false;

  StreamSubscription _visibilitySubscription;

  /// Whether the element is active.
  @HostBinding('class.active')
  bool get active => _active;

  ActiveItemDirective(this._element, this._domService, @Optional() this._modal,
      @Optional() this._popupRef);

  @override
  void ngOnDestroy() {
    _visibilitySubscription?.cancel();
    _visibilitySubscription = null;
  }

  @override
  void ngAfterViewInit() {
    _initialized = true;
    _scrollIntoViewIfNecessary();
  }

  /// Marks item as active from keyboard selection.
  @Input()
  set itemActive(bool value) {
    if (value == _active) return;
    _active = value;
    _scrollIntoViewIfNecessary();
  }

  bool get _shouldScrollIntoView => _initialized && _active && !_hasHover;

  void _scrollIntoViewIfNecessary() {
    _visibilitySubscription?.cancel();

    if (_shouldScrollIntoView) {
      var isVisible = _popupRef != null
          ? _popupRef.isVisible
          : _modal != null ? _modal.visible : true;
      if (isVisible) {
        _scrollIntoView();
      } else {
        var onVisibleChanged = _popupRef != null
            ? _popupRef.onVisibleChanged
            : _modal.onVisibleChanged;
        _visibilitySubscription = onVisibleChanged.listen((isVisible) {
          if (isVisible) {
            _visibilitySubscription?.cancel();
            if (_shouldScrollIntoView) {
              _scrollIntoView();
            }
          }
        });
      }
    }
  }

  void _scrollIntoView() {
    _domService.scheduleWrite(() {
      try {
        var options = js_util.newObject();
        js_util.setProperty(options, 'block', 'nearest');
        js_util.setProperty(options, 'inline', 'nearest');
        js_util.callMethod(_element, 'scrollIntoView', [options]);
      } catch (_) {
        _element.scrollIntoView();
      }
    });
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
