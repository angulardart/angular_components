// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as dom;

import 'package:angular/angular.dart';

import '../../model/a11y/active_item_mixin.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/disposer/disposer.dart';
import '../button_decorator/button_decorator.dart';
import '../mixins/material_dropdown_base.dart';

/// Material List Item is a block element intended for user interaction; it has
/// `:hover` styling and emits and `trigger` event when the user clicks or
/// presses `enter` or `space` keys.
///
/// See [MaterialListComponent] for item **grouping** and **labelling**.
///
/// Note: If the material-list-item has a [DropdownHandle] in its ancestry, the
/// dropdown will be closed on triggering (i.e. clicking or pressing enter/space
/// on) the list item if [closeOnActivate] is true.
///
/// __Example usage:__
///
///     <material-list>
///       <material-list-item (trigger)="select(1)">Item 1</material-list-item>
///       <material-list-item (trigger)="select(2)">Item 2</material-list-item>
///     </material-list>
///
/// __Properties:__
///
/// - `disabled:bool` -- disables the trigger and gives item a disabled style.
/// - `active:bool` -- marks item as active from keyboard selection.
/// - `closeOnActivate:bool` -- causes dropdown to be closed on activation.
///   True by default.
///
/// __Events:__
///
/// - `trigger:MouseEvent|KeyboardEvent` -- fired when either mouse is clicked
///   or __enter__ or __space__ keys are pressed.
///
// TODO(google): should activate/deactivate on mouse hover
@Component(
    selector: 'material-list-item',
    host: const {
      'class': 'item',
      '[class.disabled]': 'disabled',
      '[attr.role]': 'role',
    },
    styleUrls: const ['material_list_item.scss.css'],
    template: '<ng-content></ng-content>',
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialListItemComponent extends ButtonDirective
    with ActiveItemMixin
    implements OnDestroy {
  final _disposer = new Disposer.oneShot();
  final DropdownHandle _dropdown;
  final String role;

  final String _hostTabIndex;

  @override
  String get hostTabIndex => _hostTabIndex;

  @override
  dom.HtmlElement element;

  @override
  DomService domService;

  MaterialListItemComponent(
      this.element,
      this.domService,
      @Optional() this._dropdown,
      @Attribute('tabindex') this._hostTabIndex,
      @Attribute('role') String role)
      : this.role = role ?? 'button',
        super(element) {
    if (_dropdown != null) {
      _disposer.addDisposable(trigger.listen(handleActivate));
    }
  }

  /// Whether the encompassing dropdown should be close on selecting
  /// this item.
  @Input()
  bool closeOnActivate = true;

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  void handleActivate(dom.UIEvent _) {
    if (closeOnActivate) _dropdown?.close();
  }
}
