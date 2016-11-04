// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import '../focus/focus.dart';
import '../mixins/has_tab_index.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/events/events.dart';
import 'package:angular2/angular2.dart';

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
  '[tabindex]': 'tabIndex',
  'role': 'button',
  '[attr.aria-disabled]': 'disabledStr',
  '[class.is-disabled]': 'disabled',
})
class ButtonDirective extends RootFocusable with HasTabIndex {
  /// Will emit Event on mouse click or keyboard activation.
  @Output()
  final LazyEventEmitter<UIEvent> trigger =
      new LazyEventEmitter<UIEvent>.broadcast();

  bool _disabled = false;
  bool _tabbable = true;

  String _hostTabIndex;

  ButtonDirective(ElementRef element) : super(element);

  /// String value to be passed to aria-disabled.
  String get disabledStr => '$_disabled';

  /// Is the button disabled.
  bool get disabled => _disabled;
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }

  /// Is the button tabbable.
  bool get tabbable => _tabbable;
  @Input()
  set tabbable(value) {
    _tabbable = getBool(value);
  }

  String get hostTabIndex => tabbable && !disabled ? _hostTabIndex : '-1';

  /// The tab index of the button.
  ///
  /// The value is used if [tabbable] is `true` and [disabled] is `false`.
  @Input()
  set tabindex(String value) {
    _hostTabIndex = value;
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
