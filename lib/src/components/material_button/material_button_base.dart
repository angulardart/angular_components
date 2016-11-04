// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import '../button_decorator/button_decorator.dart';
import '../../utils/angular/properties/properties.dart';
import 'package:angular2/angular2.dart';

// TODO(google): Right now we use is-raised and isDisabled for CSS styling.
// When Angular supports conditionally adding/removing an attribute, use.
// See https://github.com/angular/angular/issues/2869.

/// A base class from which to build buttons.
///
/// __Expected Properties:__
///
/// - `disabled: bool` -- Whether the button should not respond to events, and
///   have a style that suggests that interaction is not allowed.
/// - `raised: bool` -- Whether to have a box-shadow that makes the button look
///   raised.
///
/// __Expected Events:__
///
/// - `trigger: Event` -- Published when the button is activated via click or
///   keypress.
class MaterialButtonBase extends ButtonDirective {
  static const lowElevation = 1;
  static const mediumElevation = 2;

  bool _raised = false;
  bool _focused = false;
  bool _clickFocused = false;
  bool _isMouseDown = false;

  /// Whether the button should be raised.
  bool get raised => _raised;
  set raised(value) {
    _raised = getBool(value);
  }

  /// Whether button is focused right now.
  bool get focused => _focused || _clickFocused;

  /// Whether button appears focused right now.
  bool get visualFocus => _focused;

  /// The elevation the material-shadow component should show.
  ///
  /// When a button is pressed, this is increased.
  int get zElevation =>
      _isMouseDown || _focused ? mediumElevation : lowElevation;

  MaterialButtonBase(ElementRef element) : super(element);

  // Set _focused in a microtask to avoid triggering changes during a change
  // detection cycle, which is illegal. This avoids 'AST has changed' errors.
  void _setFocused(bool newValue) {
    scheduleMicrotask(() {
      if (_focused != newValue) {
        _focused = newValue;
        focusedStateChanged();
      }
    });
  }

  /// Overridable method for subclasses that implement push change detection.
  void focusedStateChanged() {}

  /// Triggered on a mouse press.
  void onMouseDown(_) {
    _clickFocused = true;
    _isMouseDown = true;
  }

  /// Triggered on a mouse release.
  void onMouseUp(_) {
    _isMouseDown = false;
  }

  /// Triggered on focus.
  void onFocus(UIEvent event) {
    if (_clickFocused) return;
    _setFocused(true);
  }

  /// Triggered on blur.
  void onBlur(UIEvent event) {
    if (_clickFocused) _clickFocused = false;
    // Always ensure that focused is false.
    _setFocused(false);
  }
}
