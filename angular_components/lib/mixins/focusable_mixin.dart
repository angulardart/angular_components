// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';

/// Assistant for focusing an element.
class FocusableMixin implements Focusable {
  /// Event when the element is focused.
  @Output('focus')
  Stream<FocusEvent> get onFocus => _onFocus.stream;
  final StreamController<FocusEvent> _onFocus =
      StreamController<FocusEvent>.broadcast(sync: true);

  Focusable _focusable;
  bool _focusPending = false;

  set focusable(Focusable component) {
    _focusable = component;
    if (_focusPending && component != null) {
      _focusPending = false;
      _focusable.focus();
    }
  }

  @override
  void focus() {
    if (_focusable == null) {
      _focusPending = true;
    } else {
      _focusable.focus();
    }
  }

  void handleFocus(FocusEvent event) {
    _onFocus.add(event);
  }
}
