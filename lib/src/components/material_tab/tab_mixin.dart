// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

/// A mixin for use by tab button component and tab dropdown menu component.
abstract class TabMixin {
  String _label;
  int _textWidth = 0;

  /// The host element.
  Element get nativeElement;

  /// The tab label.
  ///
  /// When it's being set, it also resets the text width for re-calculation
  /// subsequently.
  String get label => _label;
  @Input()
  set label(String label) {
    _textWidth = 0;
    _label = label;
  }

  // These getters should ideally be used inside dom_service schedule read.
  /// Returns offsetWidth of the host element .
  int get offsetWidth => nativeElement.offsetWidth;

  /// Returns offsetLeft of the host element .
  int get offsetLeft => nativeElement.offsetLeft;

  /// The width of the host element .
  String get width => nativeElement.style.width;
  set width(String width) => nativeElement.style.width = width;

  /// The width of the text without any constraints as if no width was set.
  int get textWidth => _textWidth;

  /// Updates the width of the label.
  ///
  /// Only if the label has changed.
  void updateTextWidth() {
    if (_textWidth == 0) {
      _textWidth = offsetWidth;
    }
  }

  /// Clear width if it's been set and the label has changed.
  ///
  /// This allows us to re-calculate an appropriate width and set it afterwards.
  void tryClearWidth() {
    if (_textWidth == 0 && width.isNotEmpty) {
      width = '';
    }
  }
}
