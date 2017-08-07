// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' show KeyboardEvent, HtmlElement;

import 'package:angular/angular.dart';

import '../../utils/async/async.dart';
import './focus.dart';

/// `FocusItemDirective`, used in conjunction with [FocusListDirective],
/// provides a means to move focus between a list of components (or elements)
/// by way of keyboard interaction.
///
/// __Example Usage:__
///
///     <div focusList>
///       <div focusItem>Item 1</div>
///       <div focusItem>Item 2</div>
///       <div focusItem>Item 3</div>
///     </div>
///
@Directive(selector: '[focusItem]', host: const {
  '[attr.tabindex]': 'tabIndex',
  '[attr.role]': 'role',
  '(keydown)': r'keydown($event)',
}, providers: const [
  const Provider(FocusableItem, useExisting: FocusItemDirective)
])
class FocusItemDirective extends RootFocusable implements FocusableItem {
  final String role;

  FocusItemDirective(HtmlElement element, @Attribute('role') String role)
      : this.role = role ?? 'listitem',
        super(element);

  String tabIndex = '0';

  final _focusMoveCtrl =
      new LazyStreamController<FocusMoveEvent>.broadcast(sync: true);
  @override
  Stream<FocusMoveEvent> get focusmove => _focusMoveCtrl.stream;

  void keydown(KeyboardEvent event) {
    var focusEvent = new FocusMoveEvent.fromKeyboardEvent(this, event);
    if (focusEvent != null) {
      _focusMoveCtrl.add(focusEvent);
    }
  }

  @override
  set tabbable(bool value) {
    tabIndex = value ? '0' : '-1';
  }
}
