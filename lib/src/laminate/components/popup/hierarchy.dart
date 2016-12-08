// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import '../../../utils/browser/events/events.dart' as events;
import 'package:angular2/angular2.dart';

/// Tracks a hierarchy of visible popup and provides it closing logic.
@Injectable()
class PopupHierarchy {
  final _visiblePopupStack = <PopupHierarchyElement>[];

  StreamSubscription _dismissListener;

  /// Closes every popup element present in the hierarchy.
  void closeHierarchy() {
    for (var popup in _visiblePopupStack) {
      popup.onDismiss();
    }

    _visiblePopupStack.clear();
    _disposeDismissListener();
  }

  void _attach(PopupHierarchyElement child) {
    _visiblePopupStack.add(child);

    if (_dismissListener == null) {
      // Passing null to triggersOutside listens to triggers on any elements.
      _dismissListener =
          events.triggersOutside(null).listen(_onTriggersOutside);
    }
  }

  void _disposeDismissListener() {
    _dismissListener.cancel();
    _dismissListener = null;
  }

  void _detach(PopupHierarchyElement child) {
    if (_visiblePopupStack.remove(child) && _visiblePopupStack.isEmpty) {
      _disposeDismissListener();
    }
  }

  void _onTriggersOutside(Event event) {
    for (int i = _visiblePopupStack.length - 1; i >= 0; i--) {
      final current = _visiblePopupStack[i];

      if (events.isParentOf(current.container, event.target)) return;

      for (var blockerElement in current.autoDismissBlockers) {
        if (events.isParentOf(blockerElement, event.target)) return;
      }

      if (current.autoDismiss) current.onDismiss();
    }
  }
}

/// An electable element for the [PopupHierarchy].
abstract class PopupHierarchyElement {
  PopupHierarchy get hierarchy;
  bool get autoDismiss;

  /// The html element corresponding to the popup.
  Element get container;

  /// The outer element which should prevent the auto dismiss logic.
  List<Element> get autoDismissBlockers;

  /// Attach this element to the hierarchy.
  ///
  /// This should only be done when the element is getting visibility.
  void attachToVisibleHierarchy() {
    hierarchy._attach(this);
  }

  void detachFromVisibleHierarchy() {
    hierarchy._detach(this);
  }

  void onDismiss();
}
