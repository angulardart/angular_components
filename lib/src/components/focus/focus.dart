// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' show KeyCode, KeyboardEvent, Element, HtmlElement;

import 'package:angular/angular.dart';

import '../../laminate/components/modal/modal.dart';
import '../../laminate/popup/popup.dart';
import '../../utils/browser/dom_service/dom_service.dart';
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
  Element _root;
  RootFocusable(this._root);

  @override
  void focus() {
    if (_root == null) return;
    // if element does not have positive tab index attribute already specified
    // or is native element.
    // NOTE: even for elements with tab index unspecified it will return
    // tabIndex as "-1" and we have to set it to "-1"
    // to actually make it focusable.
    if (_root.tabIndex < 0) {
      _root.tabIndex = -1;
    }
    _root.focus();
  }

  @override
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
      assert(delegate is Focusable || delegate is Element);
      if (delegate is Focusable) {
        _resolvedFocusable = delegate;
      } else {
        _resolvedFocusable = new _FocusableElement(delegate);
      }
      _resolvedFocusable.focus();
    });
  }
}

class _FocusableElement extends RootFocusable {
  _FocusableElement(HtmlElement element) : super(element);
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

/// The element will be focused as soon as directive is initialized.
///
/// Please put only on content that appears after user action and
/// requires focus to be changed to it.
@Directive(selector: '[autoFocus]', visibility: Visibility.none)
class AutoFocusDirective extends RootFocusable implements OnInit, OnDestroy {
  final _disposer = new Disposer.oneShot();

  bool _autoFocus;
  // These fields are not final to support nulling them out for easier memory
  // leak detection.
  Focusable _focusable;
  DomService _domService;
  ModalComponent _modal;
  PopupRef _popupRef;

  AutoFocusDirective(
      HtmlElement node,
      this._domService,
      @Optional() this._focusable,
      @Optional() this._modal,
      @Optional() this._popupRef)
      : super(node);

  @override
  void ngOnInit() {
    if (!_autoFocus) return;

    if (_modal != null || _popupRef != null) {
      var isVisible = _popupRef != null
          ? _popupRef.isVisible
          : _modal.resolvedOverlayRef.isVisible;
      _onModalOrPopupVisibleChanged(isVisible);

      var onVisibleChanged = _popupRef != null
          ? _popupRef.onVisibleChanged
          : _modal.resolvedOverlayRef.onVisibleChanged;
      _disposer.addStreamSubscription(
          onVisibleChanged.listen(_onModalOrPopupVisibleChanged));
    } else {
      _domService.scheduleWrite(focus);
    }
  }

  /// Enables the auto focus directive so that it can be conditionally applied.
  ///
  /// This value should not change during the component's life.
  @Input()
  set autoFocus(bool value) {
    assert(_autoFocus == null);
    _autoFocus = value;
  }

  @override
  void focus() {
    if (_focusable != null) {
      _focusable.focus();
    } else {
      super.focus();
    }
  }

  @override
  void ngOnDestroy() {
    super.dispose();
    _disposer.dispose();
    _focusable = null;
    _domService = null;
    _modal = null;
    _popupRef = null;
  }

  void _onModalOrPopupVisibleChanged(bool isVisible) {
    if (isVisible) _domService.scheduleWrite(focus);
  }
}

/// This directive is used to [ViewChild] focusable element in your view.
@Directive(selector: '[focusableElement]', exportAs: 'focusableElement')
class FocusableDirective extends RootFocusable {
  FocusableDirective(HtmlElement node) : super(node);
}
