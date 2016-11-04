// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import '../focus/focus.dart';
import '../../utils/async/async.dart';

/// Assistant for focusing an element.
class FocusableMixin implements Focusable {
  final LazyEventEmitter<FocusEvent> onFocus =
      new LazyEventEmitter<FocusEvent>.broadcast();

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
    onFocus.add(event);
  }
}
