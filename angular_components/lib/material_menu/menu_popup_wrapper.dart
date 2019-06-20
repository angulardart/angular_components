// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/model/ui/accepts_width.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';

/// Represents an intent to open the menu popup.
///
/// This data struct is used to pass parameters along with the intent, such as
/// which menu item to focus when the item is first opened.
class ExpandAction {
  final int _focusIndexOnExpand;

  const ExpandAction.withFirstItemFocused() : _focusIndexOnExpand = 0;

  const ExpandAction.withLastItemFocused() : _focusIndexOnExpand = -1;

  const ExpandAction.withNoFocus() : _focusIndexOnExpand = null;

  bool get activateFirstItemOnExpand => _focusIndexOnExpand == 0;
  bool get activateLastItemOnExpand => _focusIndexOnExpand == -1;
}

/// A mixin for classes that wrap a [MenuPopupComponent].
class MenuPopupWrapper implements AcceptsWidth {
  final _expandAction = ObservableReference<ExpandAction>(null);

  /// The displayed menu.
  @Input()
  MenuModel menu;

  /// Whether the menu is open.
  ///
  /// Sets the default expansion state when this input is used to control menu
  /// visibility. Default state means no menu items are focused when the menu
  /// popup is opened.
  @Input()
  set isExpanded(bool value) {
    if (isExpanded == value) return;

    if (value) {
      expandAction ??= const ExpandAction.withNoFocus();
    } else {
      expandAction = null;
    }
  }

  /// Expansion state of the menu popup.
  ///
  /// Null value means popup is closed, any other value means popup is open.
  /// This input is used to pass parameters with the open action. E.g. which
  /// element is selected when the popup is focused.
  @Input()
  set expandAction(ExpandAction value) {
    if (_expandAction.value == value) return;

    _expandAction.value = value;
  }

  /// True if the menu popup is expanded/open.
  bool get isExpanded => expandAction != null;

  ExpandAction get expandAction => _expandAction.value;

  /// True if the menu item group should select the first item when the popup
  /// is opened.
  bool get activateFirstItemOnExpand =>
      expandAction?.activateFirstItemOnExpand ?? false;

  /// True if the menu item group should select the first item when the popup
  /// is opened.
  bool get activateLastItemOnExpand =>
      expandAction?.activateLastItemOnExpand ?? false;

  /// Outputs an event when the menu is expanded.
  @Output()
  Stream<bool> get isExpandedChange =>
      _expandAction.stream.map((_) => isExpanded);

  /// Outputs an event when the menu expansion state is changed.
  ///
  ///
  @Output()
  Stream<ExpandAction> get expandActionChange => _expandAction.stream;

  /// Selects 1 of 5 predefined width values for the menu.
  ///
  /// Ignored if [menu] instance has a width set. See [AcceptsWidth.width] for
  /// more details.
  int get width => menu?.width ?? _width;

  /// Width of the menu.
  @override
  @Input()
  set width(val) {
    _width = getInt(val, defaultValue: 0);
    assert(_width >= 0 && _width <= 5);
  }

  int _width = 0;

  /// Preferred positions to pass to the material popup component.
  ///
  /// For the meaning of this parameter, see the PopupInterface documentation.
  @Input()
  Iterable preferredPositions;
}

/// Provides basic accessibility-friendly methods for showing and hiding the
/// menu popup described by [MenuPopupWrapper].
///
/// Basic usage:
/// <div
///     buttonDecorator
///     (keydown)="onKeyDown($event)"
///     (trigger)="handlePopupTriggerAction">
///   button
/// </div>
///
/// Should be a mixin, but cannot because of ACX gallery compilation limitation
/// See b/130170577 for details.
abstract class MenuPopupTrigger {
  final _onTriggerAction = StreamController<void>();

  /// If true, the menu popup will be closed if the trigger button is clicked
  /// while the menu is open.
  ///
  /// Otherwise, clicking the trigger button when the menu is already open will
  /// not do anything.
  @Input()
  bool closeMenuOnClick = false;

  /// Outputs an event when the menu button is triggered.
  @Output('trigger')
  Stream<void> get onTrigger => _onTriggerAction.stream;

  bool get isExpanded;

  set expandAction(ExpandAction value);

  // The following methods are for accessibility-friendly trigger actions.
  // See the 'Keyboard Interaction' section on this page:
  // https://www.w3.org/TR/wai-aria-practices/#menubutton
  void handlePopupTriggerAction(UIEvent event) {
    if (event is KeyboardEvent) {
      _trigger(const ExpandAction.withFirstItemFocused());
    } else {
      _trigger(const ExpandAction.withNoFocus());
    }
  }

  /// Provides the default implementation if parent class mixes
  /// in [KeyboardHandlerMixin].
  void handleUpKey(KeyboardEvent event) {
    _trigger(const ExpandAction.withLastItemFocused());
    // Prevent the scrolling associated with arrow keys.
    event.preventDefault();
  }

  /// Provides the default implementation if parent class mixes
  /// in [KeyboardHandlerMixin].
  void handleDownKey(KeyboardEvent event) {
    _trigger(const ExpandAction.withFirstItemFocused());
    // Prevent the scrolling associated with arrow keys.
    event.preventDefault();
  }

  void _trigger(ExpandAction action) {
    if (closeMenuOnClick && isExpanded) {
      expandAction = null;
    } else {
      expandAction = action;
    }
    _onTriggerAction.add(null);
  }
}
