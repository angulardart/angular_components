// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

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
    throw new ArgumentError('type ${event.runtimeType} is not supported');
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

        var lastEvent = null;

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
