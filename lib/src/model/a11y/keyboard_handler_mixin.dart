// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import '../../utils/browser/events/events.dart';

/// Base class for handling common key events implementing accessibility best
/// practices.
///
/// Add onKeyPress, onKeyDown and onKeyUp event handlers to the event
/// target and override the specific key handler methods in the view class.
///
/// Example:
///   <button (keypress)="onKeyPress($event)"
///           (keydown)="onKeyDown($event)"
///           (keyup)="onKeyUp($event)"></button>
///
/// Dart:
///   class ButtonComponent extends KeyboardHandlerMixin {
///     @override
///     handleEnterKey(KeyboardEvent event) {
///       submit();
///     }
///     @override
///     handleDownKey(KeyboardEvent event) {
///       next();
///     }
///     @override
///     handleEscapeKey(KeyboardEvent event) {
///       close();
///     }
///   }
class KeyboardHandlerMixin {
  /// Whether the direction of the component is RTL.
  ///
  /// When this value is true, the LEFT keycode is handled by handleRightKey,
  /// and the RIGHT keycode is handled by handleLeftKey.
  bool isRtl;

  /// Keypress callback used to handle enter and space keys.
  void onKeyPress(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER) {
      handleEnterKey(event);
    } else if (isSpaceKey(event)) {
      handleSpaceKey(event);
    } else if (event.charCode != 0) {
      handleCharCodeKey(event);
    }
  }

  /// Keydown callback used to handle arrow keys.
  void onKeyDown(KeyboardEvent event) {
    switch (event.keyCode) {
      case KeyCode.UP:
        handleUpKey(event);
        break;
      case KeyCode.DOWN:
        handleDownKey(event);
        break;
      case KeyCode.LEFT:
        if (isRtl == true) {
          handleRightKey(event);
        } else {
          handleLeftKey(event);
        }
        break;
      case KeyCode.RIGHT:
        if (isRtl == true) {
          handleLeftKey(event);
        } else {
          handleRightKey(event);
        }
        break;
      case KeyCode.PAGE_UP:
        handlePageUp(event);
        break;
      case KeyCode.PAGE_DOWN:
        handlePageDown(event);
        break;
      case KeyCode.HOME:
        handleHomeKey(event);
        break;
      case KeyCode.END:
        handleEndKey(event);
        break;
      case KeyCode.BACKSPACE:
        handleBackspaceKey(event);
        break;
      case KeyCode.DELETE:
        handleDeleteKey(event);
        break;
    }
  }

  /// Keyup callback used to handle escape keys.
  void onKeyUp(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      handleEscapeKey(event);
    }
  }

  // Methods to override to implement keyboard navigation features.

  void handleEnterKey(KeyboardEvent event) {}

  void handleSpaceKey(KeyboardEvent event) {}

  void handleEscapeKey(KeyboardEvent event) {}

  void handleUpKey(KeyboardEvent event) {}

  void handleDownKey(KeyboardEvent event) {}

  void handleLeftKey(KeyboardEvent event) {}

  void handleRightKey(KeyboardEvent event) {}

  void handlePageUp(KeyboardEvent event) {}

  void handlePageDown(KeyboardEvent event) {}

  void handleHomeKey(KeyboardEvent event) {}

  void handleEndKey(KeyboardEvent event) {}

  void handleBackspaceKey(KeyboardEvent event) {}

  void handleDeleteKey(KeyboardEvent event) {}

  void handleCharCodeKey(KeyboardEvent event) {}
}
