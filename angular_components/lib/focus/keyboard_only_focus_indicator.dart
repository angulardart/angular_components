// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// [KeyboardOnlyFocusIndicatorDirective] is a decorator that hides the outline
/// on an element when the element is focused with a mouse, and shows the
/// outline when focused with a keyboard.
@Directive(
  selector: "[keyboardOnlyFocusIndicator]",
  exportAs: 'keyboardOnlyFocusIndicator',
)
class KeyboardOnlyFocusIndicatorDirective {
  final HtmlElement _element;
  final DomService _domService;
  _InteractionType _lastInteraction = _InteractionType.none;

  KeyboardOnlyFocusIndicatorDirective(this._element, this._domService);

  @visibleForTemplate
  @HostListener('keydown')
  void keydown(KeyboardEvent e) {
    _lastInteraction = _InteractionType.keyboard;
    resetOutline();
  }

  @visibleForTemplate
  @HostListener('blur')
  void resetOutline() {
    if (_element.style.outline != '') {
      _domService.scheduleWrite(() {
        _element.style.outline = '';
      });
    }
  }

  @visibleForTemplate
  @HostListener('mousedown')
  @HostListener('click')
  void onMouseInteraction() {
    _lastInteraction = _InteractionType.mouse;
    hideOutline();
  }

  @protected
  void hideOutline() {
    if (_element.style.outline != 'none') {
      _domService.scheduleWrite(() {
        _element.style.outline = 'none';
      });
    }
  }

  @visibleForTemplate
  @HostListener('focus')
  void onFocus(Event event) {
    // Use the focus event to style the element so that when the element is
    // styled programmatically it will obey the last known state of the
    // directive.
    if (_lastInteraction == _InteractionType.mouse) {
      hideOutline();
    } else {
      resetOutline();
    }
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

enum _InteractionType { mouse, keyboard, none }
