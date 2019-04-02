// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';

/// A base class from which to build buttons.
class MaterialButtonBase extends ButtonDirective {
  static const lowElevation = 1;
  static const mediumElevation = 4;

  bool _focused = false;
  bool _clickFocused = false;
  bool _isMouseDown = false;

  /// Is `true` if the button should have a box shadow that makes the button look
  /// raised.
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

  MaterialButtonBase(HtmlElement element, String role,
      {bool handleSpacePresses = true})
      : super(element, role, handleSpacePresses: handleSpacePresses);

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
  @HostListener('mousedown')
  void onMouseDown(_) {
    _clickFocused = true;
    _isMouseDown = true;
  }

  /// Triggered on a mouse release.
  @HostListener('mouseup')
  void onMouseUp(_) {
    _isMouseDown = false;
  }

  /// Triggered on focus.
  @HostListener('focus')
  void onFocus(UIEvent event) {
    if (_clickFocused) return;
    _setFocused(true);
  }

  /// Triggered on blur.
  @HostListener('blur')
  void onBlur(UIEvent event) {
    if (_clickFocused) _clickFocused = false;
    // Always ensure that focused is false.
    _setFocused(false);
  }
}
