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

bool modifierKeyUsed(dynamic /* MouseEvent | KeyboardEvent */ event) {
  if (event is! KeyboardEvent && event is! MouseEvent) {
    throw new ArgumentError('$event is not supported');
  }
  return (event.ctrlKey || event.shiftKey);
}

/// Whether the [MouseEvent] was initiated with the primary mouse button and no
/// modifier keys were used.
bool isStandardMouseEvent(MouseEvent event) =>
    !(event.button != 0 || event.altKey || event.ctrlKey || event.metaKey);

typedef bool Predicate<T>(T value);

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
  StreamSubscription<MouseEvent> mouseUpListener;
  EventListener listener;

  controller = new StreamController.broadcast(
      sync: true,
      onListen: () {
        assert(clickListener == null);
        assert(mouseUpListener == null);

        Event lastEvent;

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

        // Handle cases where the mouse is down on one element, dragged, and
        // then released on another element. This catches clicks too, in real
        // browsers.
        mouseUpListener = document.onMouseUp.listen(listener);

        // In tests, we generally only see click events and not mouseups. So
        // listen to those too.
        clickListener = document.onClick.listen((MouseEvent e) {
          // Ignore the click if we just saw a mouseup on the same element... it
          // probably means that that mouseup was part of this same click
          if (lastEvent?.type == 'mouseup' && e.target == lastEvent?.target)
            return;
          listener(e);
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
        mouseUpListener.cancel();
        mouseUpListener = null;
        document.removeEventListener('focus', listener, true);
        document.removeEventListener('touchend', listener);
      });
  return controller.stream;
}

typedef void ResizeObserverCallback(Iterable<ResizeObserverEntry> entries);

/// The ResizeObserver API is an interface for observing changes to Element's
/// content rect’s width and height.
///
/// NOTE: ResizeObserver browser support is limited
/// (https://caniuse.com/resizeobserver). Check [supportsResizeObserver] from
/// feature_detector.dart before using.
@JS()
class ResizeObserver {
  /// Create a [ResizeObserver] with the given [callback].
  ///
  /// [callback] is invoked when one or more of the observed elements' size
  /// changes, after layout and before paint, making it the ideal time to apply
  /// style changes (you will only invalidate layout, not layout and paint).
  external ResizeObserver(ResizeObserverCallback callback);

  /// Adds [target] to the list of observed elements.
  external void observe(Element target);

  /// Removes [target] from the list of observed elements.
  external void unobserve(Element target);

  /// Clears the list of observed elements.
  external void disconnect();
}

@JS()
@anonymous
class ResizeObserverEntry {
  /// The Element whose size has changed.
  external Element get target;

  /// Element's content rect when ResizeObserverCallback is invoked.
  ///
  /// [top] and [left] correspond to padding-top and padding-left.
  /// [width] and [height] correspond to [innerWidth] and [innerHeight].
  external Rectangle get contentRect;
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
  controller = new StreamController<Rectangle>.broadcast(
      sync: true,
      onListen: () {
        observer = new ResizeObserver(allowInterop((entries) {
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
