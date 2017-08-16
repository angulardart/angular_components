// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/disposer/disposer.dart';
import './focus.dart';

/// `FocusListDirective`, used in conjunction with [FocusItemDirective] or
/// other directive implementing [FocusableItem], to provide a means to move
/// focus between a list of components (or elements) by way of keyboard
/// interaction. The arrow keys move focus forward and backward in the list.
///
/// Tab order: Focus list represents single interactible element in tab order,
/// tab will land to the first element in the list by default
/// and then will move out of the list.
///
/// If user moved focus in the list, then tabs out and then tabs in back again
/// the last focused element in the list will be focused.
///
/// This leads to better navigation both in and between the lists.
///
/// __Example Usage:__
///
///     <div focusList>
///       <div focusItem>Item 1</div>
///       <div focusItem>Item 2</div>
///       <div focusItem>Item 3</div>
///     </div>
///
@Directive(selector: '[focusList]', host: const {'[attr.role]': 'role'})
class FocusListDirective implements OnDestroy {
  final ManagedZone _managedZone;
  final String role;
  final _disposer = new Disposer.multi();
  final _children = <FocusableItem>[];
  int get _length => _children.length;

  FocusListDirective(this._managedZone, @Attribute('role') String role)
      : this.role = role ?? 'list';

  /// Whether focus movement loops from the end of the list to the beginning of
  /// the list. Default is `false`.
  @Input()
  bool loop = false;

  @ContentChildren(FocusableItem)
  set listItems(QueryList<FocusableItem> listItems) {
    _children.clear();
    _disposer.dispose();
    listItems.forEach((i) {
      _children.add(i);
      _disposer.addDisposable(i.focusmove.listen(_moveFocus));
    });
    // Since this is updating children that were already dirty-checked,
    // need to delay this change until next angular cycle.
    _managedZone.onTurnDone.first.then((_) {
      _children.forEach((c) {
        c.tabbable = false;
      });
      if (_children.isNotEmpty) {
        _children.first.tabbable = true;
      }
    });
  }

  void _moveFocus(FocusMoveEvent event) {
    var i = _children.indexOf(event.focusItem);
    if (i != -1) {
      focus(i + event.offset);
    }
    event.preventDefault();
  }

  void focus(int index) {
    if (_length == 0) return;
    var newIndex;
    if (loop) {
      newIndex = index % _length;
    } else {
      newIndex = index.clamp(0, _length - 1);
    }
    _children[newIndex].focus();
    _children.forEach((i) {
      i.tabbable = false;
    });
    _children[newIndex].tabbable = true;
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
