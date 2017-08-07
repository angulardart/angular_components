// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/browser/dom_service/dom_service.dart';

/// [KeyboardOnlyFocusIndicatorDirective] is a decorator that hides the outline
/// on an element when the element is focused with a mouse, and shows the
/// outline when focused with a keyboard.
@Directive(
    selector: "[keyboardOnlyFocusIndicator]",
    host: const {
      '(keyup)': 'resetOutline()',
      '(blur)': 'resetOutline()',
      '(mousedown)': 'hideOutline()',
      '(click)': 'hideOutline()'
    },
    exportAs: 'keyboardOnlyFocusIndicator')
class KeyboardOnlyFocusIndicatorDirective {
  final HtmlElement _element;
  final DomService _domService;

  KeyboardOnlyFocusIndicatorDirective(this._element, this._domService);

  void resetOutline() {
    _domService.scheduleWrite(() {
      _element.style.outline = '';
    });
  }

  void hideOutline() {
    _domService.scheduleWrite(() {
      _element.style.outline = 'none';
    });
  }

  /// Programmatically set focus on the underlying element, managing outline
  /// visibility depending on the type of `event`. The intended use case follows
  /// this general pattern:
  ///
  /// <some-focusable-element
  ///     keyboardOnlyFocusIndicator
  ///     #focusTarget="keyboardOnlyFocusIndicator">
  /// </some-focusable-element>
  /// ...
  /// <button (trigger)="focusTarget.focus($event)">Focus!</button>
  ///
  /// Calling focus() on the element directly would cause its outline to show in
  /// response to clicks on the button, which is undesirable. Using this
  /// function, the outline is hidden in response to button clicks but shown in
  /// response to keypresses on the button.
  void focus([UIEvent event]) {
    _domService.scheduleWrite(() {
      _element.focus();
    });
    if (event is MouseEvent) {
      hideOutline();
    } else {
      resetOutline();
    }
  }
}
