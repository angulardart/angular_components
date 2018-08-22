// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/utils/browser/dom_iterator/dom_iterator.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Focus trap designed for usage in popups and modals.
///
/// After focus enters components it ensures that focus will not leave it.
@Component(
  selector: 'focus-trap',
  templateUrl: 'focus_trap.html',
  styleUrls: ['focus_trap.scss.css'],
  directives: [FocusContentWrapper, AutoFocusDirective],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class FocusTrapComponent implements OnDestroy {
  final _disposer = Disposer.oneShot();

  AutoFocusDirective _autoFocusDirective;
  @ContentChild(AutoFocusDirective)
  set autoFocus(AutoFocusDirective value) {
    _autoFocusDirective = value;
  }

  FocusContentWrapper _content;
  @ViewChild(FocusContentWrapper)
  set content(FocusContentWrapper value) {
    _content = value;
    if (_content != null && _autoFocusDirective == null) {
      _content._element.focus();
    }
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  void focusFirst() {
    _focusFirstInOrder(
        DomTreeIterator(_content.element, scope: _content.element));
  }

  void focusLast() {
    _focusFirstInOrder(DomTreeIterator(_content.element,
        scope: _content.element, reverse: true, wraps: true));
  }

  void _focusFirstInOrder(Iterator<Element> iterator) {
    while (iterator.moveNext()) {
      if (iterator.current.tabIndex == 0 && _visible(iterator.current)) {
        iterator.current.focus();
        return;
      }
    }
    _focusDefault();
  }

  bool _visible(Element element) {
    return (element.offsetWidth != 0 && element.offsetHeight != 0);
  }

  void _focusDefault() {
    if (_autoFocusDirective != null) {
      _autoFocusDirective.focus();
    } else if (_content != null) {
      _content.element.focus();
    }
  }
}

@Directive(
  selector: '[focusContentWrapper]',
)
class FocusContentWrapper extends FocusableDirective {
  Element _element;
  FocusContentWrapper(HtmlElement element)
      : _element = element,
        super(element);

  Element get element => _element;
}
