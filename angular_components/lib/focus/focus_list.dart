// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Used in conjunction with [FocusItemDirective] or
/// other directive implementing [FocusableItem], to provide a means to move
/// focus between a list of components (or elements) by way of keyboard
/// interaction.
///
/// The arrow keys move focus forward and backward in the list.
///
/// Tab order: Focus list represents single interactible element in tab order,
/// tab will land to the first element in the list by default
/// and then will move out of the list.
///
/// If user moved focus in the list, then tabs out and then tabs in back again
/// the last focused element in the list will be focused.
///
/// This leads to better navigation both in and between the lists.
@Directive(
  selector: '[focusList]',
)
class FocusListDirective implements OnDestroy {
  final NgZone _ngZone;

  @HostBinding('attr.role')
  final String role;
  @HostBinding('attr.ignoreUpAndDown')
  final bool ignoreUpAndDown;
  final _disposer = Disposer.multi();
  final _children = <FocusableItem>[];
  int get _length => _children.length;

  FocusListDirective(this._ngZone, @Attribute('role') String role,
      @Attribute('ignoreUpAndDown') String ignoreUpAndDown)
      : this.role = role ?? 'list',
        this.ignoreUpAndDown = attributeToBool(ignoreUpAndDown);

  /// Whether focus movement loops from the end of the list to the beginning of
  /// the list. Default is `false`.
  @Input()
  bool loop = false;

  /// Index of the element to focus on when the list appears.
  ///
  /// If null, focus will not be changed automatically.
  @Input()
  int autoFocusIndex;

  @ContentChildren(FocusableItem)
  set listItems(List<FocusableItem> listItems) {
    _children.clear();
    _disposer.dispose();
    listItems.forEach((i) {
      _children.add(i);
      _disposer.addDisposable(i.focusmove.listen(_moveFocus));
    });
    // Since this is updating children that were already dirty-checked,
    // need to delay this change until next angular cycle.
    _ngZone.runAfterChangesObserved(() {
      _children.forEach((c) {
        c.tabbable = false;
      });
      if (_children.isNotEmpty) {
        if (autoFocusIndex != null) {
          focus(autoFocusIndex); // This will also make the item tabbable.
        } else {
          _children.first.tabbable = true;
        }
      }
    });
  }

  void _moveFocus(FocusMoveEvent event) {
    if (event.home) {
      focus(0);
    } else if (event.end) {
      focus(_length - 1);
    } else if (!ignoreUpAndDown || !event.upDown) {
      var i = _children.indexOf(event.focusItem);
      if (i != -1) {
        focus(i + event.offset);
      }
    }
    event.preventDefault();
  }

  void focus(int index) {
    if (_length == 0) return;
    int newIndex;
    if (loop) {
      newIndex = index % _length;
    } else {
      newIndex = index.clamp(0, _length - 1);
    }
    _children[newIndex].focus();
    setTabbable(newIndex);
  }

  /// Makes the [index] tab focusable and makes all other tabs unfocusable.
  void setTabbable(int index) {
    if (index < 0 || index >= _length) return;
    _children.forEach((i) {
      i.tabbable = false;
    });
    _children[index].tabbable = true;
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
