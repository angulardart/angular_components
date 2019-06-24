// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library events;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart';

/// Determines if the space key was pressed in a [KeyboardEvent].
///
/// Use this utility because `keyCode` is deprecated in Firefox (and doesn't
/// work for &lt;space&gt;) and `key` is not yet implemented in Chrome.
bool isSpaceKey(KeyboardEvent event) {
  // NB: keyCode does not work on Firefox, returning `0` for the space key.
  return event.keyCode != 0 ? event.keyCode == KeyCode.SPACE : event.key == ' ';
}

bool isKeyboardTrigger(KeyboardEvent event) =>
    event.keyCode == KeyCode.ENTER || isSpaceKey(event);

/// Whether the [MouseEvent] was initiated with the primary mouse button and no
/// modifier keys were used.
bool isStandardMouseEvent(MouseEvent event) =>
    event.button == 0 &&
    !event.altKey &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.shiftKey;

/// Whether the [UIEvent] is a standard trigger event without modifier keys.
bool isStandardTriggerEvent(UIEvent event) {
  return event is MouseEvent && isStandardMouseEvent(event) ||
      event is KeyboardEvent && isKeyboardTrigger(event);
}

typedef Predicate<T> = bool Function(T value);

Predicate<T> not<T>(Predicate<T> predicate) => (value) => !predicate(value);

/// A stream of click, mouseup or focus events outside a given element.
Stream<Event> triggersOutside(dynamic /* Element | ElementRef */ element) {
  if (element is ElementRef) element = element.nativeElement;
  return triggersOutsideAny((node) => node == element);
}

/// A stream of click, mouseup or focus events of any node none of whose parents
/// pass the check inside function.
Stream<Event> triggersOutsideAny(Predicate<Node> checkNodeInside) {
  StreamController<Event> controller;
  StreamSubscription<MouseEvent> clickListener;
  StreamSubscription<MouseEvent> mouseDownListener;
  StreamSubscription<MouseEvent> mouseUpListener;
  EventListener listener;

  controller = StreamController.broadcast(
      sync: true,
      onListen: () {
        assert(clickListener == null);
        assert(mouseDownListener == null);
        assert(mouseUpListener == null);

        Event lastEvent;
        Event lastDownEvent;

        listener = (Event e) {
          lastEvent = e;
          var node = e.target as Node;
          while (node != null) {
            if (checkNodeInside(node)) {
              return;
            } else {
              node = node.parent;
            }
          }
          controller.add(e);
        };

        // Keep track of mousedown events so that we can filter mouseup events
        // that occurred on a different element than the mousedown.
        mouseDownListener = document.onMouseDown.listen((MouseEvent e) {
          lastDownEvent = e;
        });

        // Listen to mouseup to prevent scenarios where a single click event
        // both opens and closes an element.
        mouseUpListener = document.onMouseUp.listen((MouseEvent e) {
          // Allow for the event to be listened to if there was no down event
          // for example if it was canceled or if the target is the same as
          // where the 'click' started.
          if (lastDownEvent == null || e.target == lastDownEvent.target) {
            listener(e);
          }
          lastEvent = e;
        });

        clickListener = document.onClick.listen((MouseEvent e) {
          // Ignore the click if we just saw a mouseup on the same element... it
          // probably means that the mouseup was part of this same click.
          //
          // This prevents scenarios where clicking an element that displays
          // another element (e.g. a button to open a popup) inadvertently
          // triggers an "outside" event, immediately hiding the just-displayed
          // element.
          if (lastEvent?.type == 'mouseup' && e.target == lastEvent?.target) {
            return;
          }
          // Allow for the event to be listened to if there was no down event
          // for example if it was canceled or if the target is the same as
          // where the 'click' started.
          if (lastDownEvent == null || e.target == lastDownEvent.target) {
            listener(e);
          }
          lastDownEvent = null;
        });

        // Since 'focusin' event is not supported in Firefox, listen to 'focus'
        // event with useCapture set to true to implement event delegation and
        // capture changes to active element on document.
        document.addEventListener('focus', listener, true);

        // Handles touches outside of element for Safari on iOS devices since
        // touch events are not detected as clicks on iOS platforms.
        document.addEventListener('touchend', listener);
      },
      onCancel: () {
        clickListener.cancel();
        clickListener = null;
        mouseDownListener?.cancel();
        mouseDownListener = null;
        mouseUpListener.cancel();
        mouseUpListener = null;
        document.removeEventListener('focus', listener, true);
        document.removeEventListener('touchend', listener);
      });
  return controller.stream;
}

/// A stream of contect rects fired when [element] changes size.
///
/// A content rect is a [Rectangle] where [top] = padding-top, [left] =
/// padding-left, [width] = innerWidth, and [height] = innerHeight.
///
/// NOTE: This only works in browsers that support [ResizeObserver]. Check
/// [supportsResizeObserver] from feature_detector.dart before using this.
Stream<Rectangle> onResize(Element element) {
  assert(supportsResizeObserver, 'ResizeObserver support is required');
  StreamController<Rectangle> controller;
  ResizeObserver observer;
  controller = StreamController<Rectangle>.broadcast(
      sync: true,
      onListen: () {
        observer = ResizeObserver(allowInterop((entries, _) {
          for (var entry in entries) {
            controller.add(entry.contentRect);
          }
        }));
        observer.observe(element);
      },
      onCancel: () {
        observer.disconnect();
      });
  return controller.stream;
}

/// Return true if the element or any of its ancestors have an attribute.
///
/// It's used to handle lose focus (or blur) event for composite components.
/// For example, MaterialAutoSuggestInput need close suggest popup when
/// lose focus from the input, but not for the case when clicking the popup
/// itself.
bool anyParentHasAttribute(Element target, String attribute) {
  while (target != null) {
    if (target.attributes.containsKey(attribute)) {
      return true;
    }
    target = target.parent;
  }
  return false;
}

/// Return true if the element or any of its ancestors have the given tag.
///
/// It's used to handle lose focus (or blur) event for composite components.
/// For example, FilterBarComponent needs to enter summary mode when it loses
/// focus, unless the focus is moving to one of the components it spawned.
bool anyParentHasTag(Element target, String componentTag) {
  componentTag = componentTag.toLowerCase();
  while (target != null) {
    if (target.tagName.toLowerCase() == componentTag) {
      return true;
    }
    target = target.parent;
  }
  return false;
}

/// Return true if the element or any of its ancestors have the given class.
///
/// Among other use cases, this can be helpful for handling nested popup
/// scenarios.  For example, BaseLensEdit needs to ignore clicks on targets
/// that have ancestors of class material-popup-content when deciding whether
/// a click counts as a click out (for exiting the popup).
bool anyParentHasClass(Element target, String className) =>
    closestWithClass(target, className) != null;

/// This element or the closest of its ancestor with the given class.
Element closestWithClass(Element target, String className) {
  while (target != null) {
    if (target.attributes.containsKey("class") &&
        target.classes.contains(className)) {
      return target;
    }
    target = target.parent;
  }
  return null;
}

/// Whether [element] is a parent of [node] in the dom tree.
bool isParentOf(Element element, Node node) {
  while (node != null) {
    if (node == element) {
      return true;
    } else {
      node = node.parent;
    }
  }
  return false;
}

/// A [Comparator] for sorting [Node]s based on document order.
///
/// Example:
///
///     // [elements] is a List<Element>.
///     elements.sort(compareDocumentPosition);
///     // Now they're sorted according to their position in the document.
int compareDocumentPosition(Node a, Node b) {
  int bitmask = js_util.callMethod(a, 'compareDocumentPosition', [b]);
  if ((bitmask & 4) != 0 || (bitmask & 16) != 0) {
    // DOCUMENT_POSITION_FOLLOWING or DOCUMENT_POSITION_CONTAINED_BY
    return -1;
  } else if ((bitmask & 2) != 0 || (bitmask & 8) != 0) {
    // DOCUMENT_POSITION_PRECEDING or DOCUMENT_POSITION_CONTAINS
    return 1;
  } else {
    return 0;
  }
}
