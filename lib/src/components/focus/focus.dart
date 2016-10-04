// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:html' show KeyCode, KeyboardEvent, Element;

import 'package:angular2/angular2.dart';

import '../../utils/disposer/disposer.dart';

/// A component or directive that can be programmatically focused.
/// Directive can manage if it means to put focus on root of itself
/// or meaningful component inside.
abstract class Focusable {
  /// Item/component focuses itself
  void focus();
}

/// An abstract class for components to extend if their programmatic focus
/// should simply put focus on root element.
abstract class RootFocusable implements Focusable, Disposable {
  ElementRef _root;
  RootFocusable(this._root);

  @override
  void focus() {
    if (_root == null) return;
    Element element = _root.nativeElement;
    // if element does not have positive tab index attribute already specified
    // or is native element.
    // NOTE: even for elements with tab index unspecified it will return
    // tabIndex as "-1" and we have to set it to "-1"
    // to actually make it focusable.
    if (element.tabIndex < 0) {
      element.tabIndex = -1;
    }
    element.focus();
  }

  void dispose() {
    _root = null;
  }
}

abstract class ProjectedFocus implements Focusable {
  Future< /* Focusable | ElementRef */ dynamic> get focusDelegate;
  Focusable _resolvedFocusable;

  @override
  void focus() {
    if (_resolvedFocusable != null) {
      _resolvedFocusable.focus();
      return;
    }
    focusDelegate.then((delegate) {
      assert(delegate is Focusable || delegate is ElementRef);
      if (delegate is Focusable) {
        _resolvedFocusable = delegate;
      } else {
        _resolvedFocusable = new _FocusableElement(delegate as ElementRef);
      }
      _resolvedFocusable.focus();
    });
  }
}

class _FocusableElement extends RootFocusable {
  _FocusableElement(ElementRef element) : super(element);
}

/// A focusable component that can publish to the
/// `focusmove` stream in order to move focus to another element in the list.
abstract class FocusableItem implements Focusable {
  /// Moves focus item into (tabIndex='0') or out of (tabIndex='-1') tab order.
  set tabbable(bool value);

  /// The item publishes to this stream in order to move focus to another item.
  Stream<FocusMoveEvent> get focusmove;
}

/// An event to trigger moving focus to another item in a list.
class FocusMoveEvent {
  /// The component which published this event.
  final FocusableItem focusItem;

  /// The position, relative the item, of where to set focus.
  final int offset;

  /// Prevent Default action for occuring. When the `FocusMoveEvent` is created
  /// from a KeyboardEvent, this method delegates to the `preventDefault` method
  /// of the `KeyboardEvent`, allowing consumers of this event to control the
  /// underlying DOM event.
  void preventDefault() {
    if (_preventDefaultDelegate != null) _preventDefaultDelegate();
  }

  final Function _preventDefaultDelegate;

  FocusMoveEvent(this.focusItem, this.offset, [this._preventDefaultDelegate]);

  /// Builds a `FocusMoveEvent` instance from a keyboard event, iff the keycode
  /// is a next or previous key (i.e. up/down/left/right).
  factory FocusMoveEvent.fromKeyboardEvent(
      FocusableItem item, KeyboardEvent kbEvent) {
    int keyCode = kbEvent.keyCode;
    if (!_isNextKey(keyCode) && !_isPrevKey(keyCode)) return null;
    int offset = _isNextKey(keyCode) ? 1 : -1;
    return new FocusMoveEvent(item, offset, () {
      kbEvent.preventDefault();
    });
  }

  // TODO(google): account for RTL.
  static bool _isNextKey(int keyCode) =>
      keyCode == KeyCode.RIGHT || keyCode == KeyCode.DOWN;
  static bool _isPrevKey(int keyCode) =>
      keyCode == KeyCode.LEFT || keyCode == KeyCode.UP;
}


/// This directive is used to [ViewChild] focusable element in your view.
@Directive(selector: '[focusableElement]', exportAs: 'focusableElement')
class FocusableDirective extends RootFocusable {
  FocusableDirective(ElementRef node) : super(node);
}
