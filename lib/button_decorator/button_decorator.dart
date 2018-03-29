// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/mixins/has_tab_index.dart';
import 'package:angular_components/utils/browser/events/events.dart';

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
@Directive(
  selector: '[buttonDecorator]',
  host: const {
    '(click)': r'handleClick($event)',
    '(keypress)': r'handleKeyPress($event)',
    '[attr.role]': 'role',
    '[attr.aria-disabled]': 'disabledStr',
    '[class.is-disabled]': 'disabled',
  },
  // Injected by [DisablePendingClickHandlerDirective].
  visibility: Visibility.all,
)
class ButtonDirective extends RootFocusable with HasTabIndex {
  /// Will emit Event on mouse click or keyboard activation.
  @Output()
  Stream<UIEvent> get trigger => _trigger.stream;

  final _trigger = new StreamController<UIEvent>.broadcast(sync: true);

  String _hostTabIndex;

  final String role;

  ButtonDirective(Element element, @Attribute('role') String role)
      : this.role = role ?? 'button',
        super(element);

  /// String value to be passed to aria-disabled.
  String get disabledStr => '$disabled';

  /// Is the button disabled.
  @Input()
  bool disabled = false;

  /// Is the button tabbable.
  @Input()
  bool tabbable = true;

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
    if (disabled) return;
    _trigger.add(mouseEvent);
  }

  /// Triggers on enter and space if not disabled.
  void handleKeyPress(KeyboardEvent keyboardEvent) {
    if (disabled) return;
    int keyCode = keyboardEvent.keyCode;
    if (keyCode == KeyCode.ENTER || isSpaceKey(keyboardEvent)) {
      _trigger.add(keyboardEvent);
      // Required to prevent window from scrolling.
      keyboardEvent.preventDefault();
    }
  }
}
