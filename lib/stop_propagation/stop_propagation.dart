// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/events/events.dart';

/// A directive that prevents button trigger events from propagating.
///
/// Events will trigger on the target component but will be prevented from
/// bubbling up to parent elements.
/// https://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-flow-bubbling
@Directive(selector: '[stopPropagation]', visibility: Visibility.local)
class StopPropagationDirective implements OnDestroy {
  StreamSubscription _clickSubscription, _keyDownSubscription;

  StopPropagationDirective(Element e) {
    _clickSubscription = e.onClick.listen(_handleClick);
    _keyDownSubscription = e.onKeyPress.listen(_handleKeyPress);
  }

  @override
  void ngOnDestroy() {
    _clickSubscription?.cancel();
    _keyDownSubscription?.cancel();
  }

  void _handleClick(MouseEvent e) {
    e.stopPropagation();
  }

  void _handleKeyPress(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER || isSpaceKey(e)) {
      e.stopPropagation();
    }
  }
}
