// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

/// Directive to listen to the escape key globally.
///
/// Useful for things like having a dialog close when the escape key is pressed
/// even when the dialog is not focused.
///
/// WARNING: If listeners to the onEscape stream are on the page but hidden,
/// they will still be registered to the stream. To avoid that situation, use
/// this directive only within a deferredContent directive.
@Directive(selector: '[globalEscape]')
class GlobalEscapeDirective {
  final Window _window;

  /// Event triggered when the escape key is pressed.
  @Output()
  Stream<KeyboardEvent> get globalEscape =>
      _window.onKeyUp.where((event) => event.keyCode == KeyCode.ESC);

  GlobalEscapeDirective(this._window);
}
