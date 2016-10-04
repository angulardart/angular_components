// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:html';

import 'package:angular2/angular2.dart';

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
  final ElementRef _element;
  final Renderer _renderer;
  final DomService _domService;

  KeyboardOnlyFocusIndicatorDirective(
      this._element, this._renderer, this._domService);

  void resetOutline() {
    _domService.scheduleWrite(() {
      _renderer.setElementStyle(_element.nativeElement, 'outline', '');
    });
  }

  void hideOutline() {
    _domService.scheduleWrite(() {
      _renderer.setElementStyle(_element.nativeElement, 'outline', 'none');
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
      _element.nativeElement.focus();
    });
    if (event is MouseEvent) {
      hideOutline();
    } else {
      resetOutline();
    }
  }
}
