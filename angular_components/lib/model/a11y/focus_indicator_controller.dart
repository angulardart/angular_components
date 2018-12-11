// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/di.dart';

const focusIndicatorProviders = [
  FactoryProvider(
      FocusIndicatorController, createFocusIndicatorControllerIfNotAvailable)
];

@Injectable()
FocusIndicatorController createFocusIndicatorControllerIfNotAvailable(
        @Optional() @SkipSelf() FocusIndicatorController controller) =>
    controller ?? FocusIndicatorController();

/// Utility that attaches an a focus indicator to the page when enabled.
///
/// Only used to improve a11y debugging experience. DO NOT USE IN PRODUCTION!
class FocusIndicatorController {
  Element _focusIndicator;
  int _repositionLoopId;

  Element _activeElement;
  Element get activeElement => _activeElement;

  bool _enabled = false;
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    if (_enabled) {
      _turnOnKeyNavMode();
    } else {
      _turnOffKeyNavMode();
    }
  }

  void _turnOnKeyNavMode() {
    window.addEventListener('focus', _onFocus, true);
    window.addEventListener('blur', _onBlur, true);

    _activeElement = document.activeElement;

    _focusIndicator = document.createElement('div');
    _focusIndicator.id = 'acx-focus-indicator';
    _focusIndicator.style.position = 'fixed';
    _focusIndicator.style.zIndex = '9999';
    _focusIndicator.style.outline = '2px solid #ff9800';
    _focusIndicator.style.pointerEvents = 'none';
    document.body.append(_focusIndicator);

    _startRepositionLoop();
  }

  void _turnOffKeyNavMode() {
    window.removeEventListener('focus', _onFocus, true);
    window.removeEventListener('blur', _onBlur, true);

    _activeElement = null;

    if (_focusIndicator != null) {
      _focusIndicator.remove();
      _focusIndicator = null;
    }

    _cancelRepositionLoop();
  }

  void _onFocus(Event event) {
    _updateActiveElement(event);
  }

  void _onBlur(Event event) {
    Timer.run(() {
      _updateActiveElement(event);
    });
  }

  void _updateActiveElement(Event event) {
    if (!_enabled || _activeElement == document.activeElement) return;

    if (_activeElement != null) {
      _activeElement.style.outline = '';
      if (_activeElement.getAttribute('style')?.isEmpty == true) {
        _activeElement.attributes.remove('style');
      }
    }

    _activeElement = document.activeElement;

    window.console.groupCollapsed('Active element '
        '[${_activeElement.tagName.toLowerCase()}] '
        'after "${event.type}"');
    window.console.log(_activeElement);
    window.console.log(event);
    window.console.groupEnd();

    _activeElement.style.outline = 'none';
  }

  void _startRepositionLoop() {
    _repositionLoopId = window.requestAnimationFrame(_reposition);
  }

  void _cancelRepositionLoop() {
    if (_repositionLoopId != null) {
      window.cancelAnimationFrame(_repositionLoopId);
      _repositionLoopId = null;
    }
  }

  void _reposition(_) {
    var rect = _activeElement.getBoundingClientRect();
    _focusIndicator.style.top = '${rect.top}px';
    _focusIndicator.style.left = '${rect.left}px';
    _focusIndicator.style.width = '${rect.width}px';
    _focusIndicator.style.height = '${rect.height}px';

    _startRepositionLoop();
  }
}
