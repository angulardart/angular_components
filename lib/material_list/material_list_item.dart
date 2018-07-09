// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as dom;

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/a11y/active_item_mixin.dart';
import 'package:angular_components/model/a11y/active_item_directive.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Material List Item is a block element intended for user interaction; it has
/// `:hover` styling and emits and `trigger` event when the user clicks or
/// presses `enter` or `space` keys.
///
/// See `MaterialListComponent` for item **grouping** and **labelling**.
///
/// Note: If the material-list-item has a [DropdownHandle] in its ancestry, the
/// dropdown will be closed on triggering (i.e. clicking or pressing enter/space
/// on) the list item if [closeOnActivate] is true.
// TODO(google): should activate/deactivate on mouse hover
@Component(
  selector: 'material-list-item',
  providers: const [
    const Provider(HasDisabled, useExisting: MaterialListItemComponent),
  ],
  styleUrls: const ['material_list_item.scss.css'],
  template: '<ng-content></ng-content>',
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialListItemComponent extends ButtonDirective
    with ActiveItemMixin
    implements OnDestroy {
  @HostBinding('class')
  static const hostClass = 'item';

  final _disposer = new Disposer.oneShot();
  final DropdownHandle _dropdown;

  final String _hostTabIndex;

  @override
  String get hostTabIndex => _hostTabIndex;

  @override
  dom.HtmlElement element;

  @override
  DomService domService;

  // Temporary for migration.
  @override
  final ActiveItemDirective activeItemDirective;

  MaterialListItemComponent(
      this.element,
      this.domService,
      @Optional() this._dropdown,
      @Optional() this.activeItemDirective,
      @Attribute('tabindex') this._hostTabIndex,
      @Attribute('role') String role)
      : super(element, role) {
    if (_dropdown != null) {
      _disposer.addDisposable(trigger.listen(handleActivate));
    }
  }

  @HostBinding('class.disabled')
  @override
  bool get disabled => super.disabled;

  /// Disables the trigger and gives item a disabled style.
  // Overridden just to give a better doc-comment;
  @override
  @Input()
  set disabled(bool value) => super.disabled = value;

  /// Whether the encompassing dropdown should close on selection of
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
