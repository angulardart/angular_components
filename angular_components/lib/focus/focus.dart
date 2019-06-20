// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' show KeyCode, KeyboardEvent, Element, HtmlElement;

import 'package:angular/angular.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'focus_interface.dart';

export 'focus_interface.dart';

/// A class for components to extend if their programmatic focus
/// should simply put focus on root element.
class RootFocusable implements Focusable, Disposable {
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
        _resolvedFocusable = RootFocusable(delegate);
      }
      _resolvedFocusable.focus();
    });
  }
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

  /// Home key was pressed.
  final bool home;

  /// End key was pressed.
  final bool end;

  /// Up or down arrow key was pressed.
  final bool upDown;

  /// Prevent Default action for occuring. When the `FocusMoveEvent` is created
  /// from a KeyboardEvent, this method delegates to the `preventDefault` method
  /// of the `KeyboardEvent`, allowing consumers of this event to control the
  /// underlying DOM event.
  void preventDefault() {
    if (_preventDefaultDelegate != null) _preventDefaultDelegate();
  }

  final Function _preventDefaultDelegate;

  @visibleForTesting
  FocusMoveEvent(this.focusItem, this.offset, [this._preventDefaultDelegate])
      : home = false,
        end = false,
        upDown = false;

  @visibleForTesting
  FocusMoveEvent.homeKey(this.focusItem, [this._preventDefaultDelegate])
      : offset = 0,
        home = true,
        end = false,
        upDown = false;

  @visibleForTesting
  FocusMoveEvent.endKey(this.focusItem, [this._preventDefaultDelegate])
      : offset = 0,
        home = false,
        end = true,
        upDown = false;

  @visibleForTesting
  FocusMoveEvent.upDownKey(this.focusItem, this.offset,
      [this._preventDefaultDelegate])
      : home = false,
        end = false,
        upDown = true;

  /// Builds a `FocusMoveEvent` instance from a keyboard event, iff the keycode
  /// is a next, previous, home or end key (i.e. up/down/left/right/home/end).
  factory FocusMoveEvent.fromKeyboardEvent(
      FocusableItem item, KeyboardEvent kbEvent) {
    int keyCode = kbEvent.keyCode;
    final preventDefaultFn = () {
      kbEvent.preventDefault();
    };
    if (_isHomeKey(keyCode)) {
      return FocusMoveEvent.homeKey(item, preventDefaultFn);
    }
    if (_isEndKey(keyCode)) {
      return FocusMoveEvent.endKey(item, preventDefaultFn);
    }
    if (!_isNextKey(keyCode) && !_isPrevKey(keyCode)) return null;

    int offset = _isNextKey(keyCode) ? 1 : -1;
    if (keyCode == KeyCode.UP || keyCode == KeyCode.DOWN) {
      return FocusMoveEvent.upDownKey(item, offset, preventDefaultFn);
    }

    return FocusMoveEvent(item, offset, preventDefaultFn);
  }

  // TODO(google): account for RTL.
  static bool _isNextKey(int keyCode) =>
      keyCode == KeyCode.RIGHT || keyCode == KeyCode.DOWN;
  static bool _isPrevKey(int keyCode) =>
      keyCode == KeyCode.LEFT || keyCode == KeyCode.UP;
  static bool _isHomeKey(int keyCode) => keyCode == KeyCode.HOME;
  static bool _isEndKey(int keyCode) => keyCode == KeyCode.END;
}

/// The element will be focused as soon as directive is initialized.
///
/// Please put only on content that appears after user action and
/// requires focus to be changed to it.
@Directive(
  selector: '[autoFocus]',
)
class AutoFocusDirective extends RootFocusable implements OnInit, OnDestroy {
  final _disposer = Disposer.oneShot();

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
      @Self() @Optional() this._focusable,
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
  // TODO(google): Change to an attribute.
  @Input()
  set autoFocus(bool value) {
    _autoFocus = value;
  }

  @override
  void focus() {
    if (!_autoFocus) return;

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

/// Tags an element as being [Focusable].
///
/// Tagging elements as [Focusable] allows other components to easily access
/// which elements can be focused and perform actions on them.
@Directive(
    selector: '[focusableElement]',
    exportAs: 'focusableElement',
    providers: [ExistingProvider(Focusable, FocusableDirective)])
class FocusableDirective extends RootFocusable {
  FocusableDirective(HtmlElement node) : super(node);
}
