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

import '../focus/focus.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/events/events.dart';

/// ButtonDirective adds all basic required a11y functional for any element,
/// that are designed to work as a button (clickable icon, etc.)
///
/// This does NOT consume the triggering mouse event or keyboard event, so that
/// if a transitive parent wants to listen to all events in it's scope (ex.
/// click on anything to hide popup), it can do so.
///
/// usage:
/// `<your-element buttonDecorator (trigger)="yourAction()"></your-element>`
/// instead of
/// `<your-element (click)="yourAction()"></your-element>`
@Directive(selector: '[buttonDecorator]', host: const {
  '(click)': r'handleClick($event)',
  '(keypress)': r'handleKeyPress($event)',
  'tabindex': '0',
  'role': 'button',
  '[attr.aria-disabled]': 'disabledStr',
  '[class.is-disabled]': 'disabled',
})
class ButtonDirective extends RootFocusable {
  /// Will emit Event on mouse click or keyboard activation.
  @Output()
  final LazyEventEmitter<UIEvent> trigger =
      new LazyEventEmitter<UIEvent>.broadcast();

  bool _disabled = false;

  ButtonDirective(ElementRef element) : super(element);

  /// String value to be passed to aria-disabled.
  String get disabledStr => '$_disabled';

  /// Is the button disabled.
  bool get disabled => _disabled;
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }


  /// Triggers if not disabled.
  void handleClick(MouseEvent mouseEvent) {
    if (_disabled) return;
    trigger.add(mouseEvent);
  }

  /// Triggers on enter and space if not disabled.
  void handleKeyPress(KeyboardEvent keyboardEvent) {
    if (_disabled) return;
    int keyCode = keyboardEvent.keyCode;
    if (keyCode == KeyCode.ENTER || isSpaceKey(keyboardEvent)) {
      trigger.add(keyboardEvent);
      // Required to prevent window from scrolling.
      keyboardEvent.preventDefault();
    }
  }

}
