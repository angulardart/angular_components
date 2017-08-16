// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../button_decorator/button_decorator.dart';

/// A base class from which to build buttons.
///
/// __Expected Properties:__
///
/// - `disabled: bool` -- Whether the button should not respond to events, and
///   have a style that suggests that interaction is not allowed. Note: only
///   stops the trigger event, not native events.
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

  bool _focused = false;
  bool _clickFocused = false;
  bool _isMouseDown = false;

  /// Whether the button should be raised.
  @Input()
  bool raised = false;

  /// Whether button is focused right now.
  bool get focused => _focused || _clickFocused;

  /// Whether button appears focused right now.
  bool get visualFocus => _focused;

  /// Whether the mouse is currently pressed on the button.
  bool get isMouseDown => _isMouseDown;

  /// The elevation the material-shadow component should show.
  ///
  /// When a button is pressed, this is increased.
  int get zElevation =>
      _isMouseDown || _focused ? mediumElevation : lowElevation;

  MaterialButtonBase(HtmlElement element) : super(element);

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
  @HostListener('mousedown', const [r'$event'])
  void onMouseDown(_) {
    _clickFocused = true;
    _isMouseDown = true;
  }

  /// Triggered on a mouse release.
  @HostListener('mouseup', const [r'$event'])
  void onMouseUp(_) {
    _isMouseDown = false;
  }

  /// Triggered on focus.
  @HostListener('focus', const [r'$event'])
  void onFocus(UIEvent event) {
    if (_clickFocused) return;
    _setFocused(true);
  }

  /// Triggered on blur.
  @HostListener('blur', const [r'$event'])
  void onBlur(UIEvent event) {
    if (_clickFocused) _clickFocused = false;
    // Always ensure that focused is false.
    _setFocused(false);
  }
}
