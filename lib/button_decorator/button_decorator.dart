// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/mixins/has_tab_index.dart';
import 'package:angular_components/utils/browser/events/events.dart';

/// ButtonDirective adds all basic required a11y functional for any element,
/// that are designed to work as a button (clickable icon, etc.)
///
/// This does NOT consume the triggering mouse event or keyboard event, so that
/// if a transitive parent wants to listen to all events in it's scope (ex.
/// click on anything to hide popup), it can do so.
///
/// Gives a common event `trigger` for keyboard, and click events.
@Directive(
  selector: '[buttonDecorator]',
  // Injected by [DisablePendingClickHandlerDirective].
  visibility: Visibility.all,
)
class ButtonDirective extends RootFocusable
    with HasTabIndex
    implements OnInit, HasDisabled {
  /// Fired when the button is activated via click, tap, or key press.
  @Output()
  Stream<UIEvent> get trigger => _trigger.stream;

  final _trigger = StreamController<UIEvent>.broadcast(sync: true);

  String _hostTabIndex;
  String _role;
  String _ariaRole;

  ButtonDirective(Element element, @Attribute('role') String role)
      : _role = role,
        super(element);

  /// Role of this component used for a11y.
  @Input()
  set role(String value) {
    assert(ariaRole == null, 'Role can only be set before initialization.');
    _role = value;
  }

  @HostBinding('attr.role')
  String get ariaRole => _ariaRole;

  @override
  void ngOnInit() {
    _ariaRole = _role ?? 'button';
  }

  /// String value to be passed to aria-disabled.
  @HostBinding('attr.aria-disabled')
  String get disabledStr => '$disabled';

  /// Is the component disabled.
  @HostBinding('class.is-disabled')
  @Input()
  bool disabled = false;

  /// Is the component tabbable.
  @Input()
  bool tabbable = true;

  String get hostTabIndex => tabbable && !disabled ? _hostTabIndex : '-1';

  /// The tab index of the component.
  ///
  /// The value is used if [tabbable] is `true` and [disabled] is `false`.
  @Input()
  set tabindex(String value) {
    _hostTabIndex = value;
  }

  /// Triggers if not disabled.
  @HostListener('click')
  void handleClick(MouseEvent mouseEvent) {
    if (disabled) return;
    _trigger.add(mouseEvent);
  }

  /// Triggers on enter and space if not disabled.
  @HostListener('keypress')
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
