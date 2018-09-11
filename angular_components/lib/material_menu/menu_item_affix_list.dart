// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:observable/observable.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_menu/menu_root.dart';
import 'package:angular_components/model/menu/menu_item_affix.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Renders the list of menu item affixes.
///
/// An affix can be a text or an icon component. This component also listens
/// on any affix list changes.
@Component(
  selector: 'menu-item-affix-list',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    ButtonDirective,
    MaterialIconComponent,
    NgFor,
    NgIf,
    NgClass,
  ],
  providers: [
    Provider(HasDisabled, useExisting: MenuItemAffixListComponent),
  ],
  templateUrl: 'menu_item_affix_list.html',
  styleUrls: ['menu_item_affix_list.scss.css'],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MenuItemAffixListComponent implements HasDisabled, OnDestroy {
  final ChangeDetectorRef _cdRef;

  StreamSubscription _itemChangeStreamSub;

  ObservableList<MenuItemAffix> _items;

  /// The top most menu node.
  ///
  /// Used in order to close the whole hierarchy.
  final MenuRoot _menuRoot;

  bool _disabled = false;

  MenuItemAffixListComponent(this._cdRef, @Optional() this._menuRoot);

  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;
  }

  bool get disabled => _disabled;

  /// Observable list of affix items.
  @Input()
  set items(ObservableList<MenuItemAffix> items) {
    this._items = items;

    _itemChangeStreamSub?.cancel();

    _itemChangeStreamSub = items?.listChanges?.listen((_) {
      _cdRef.markForCheck();
    });
  }

  bool get hasAffixes => _items?.isNotEmpty ?? false;

  Iterable<MenuItemAffix> get affixes => _items;

  @override
  void ngOnDestroy() {
    _itemChangeStreamSub?.cancel();
  }

  bool isIconAffix(MenuItemAffix item) => item is IconAffix;
  bool isActionIconAffix(MenuItemAffix item) =>
      item is IconAffix && item.icon is IconWithAction;

  bool isCaptionAffix(MenuItemAffix item) => item is CaptionAffix;

  String getActionIconAriaLabel(Icon icon) =>
      icon is IconWithAction ? icon.ariaLabel : null;

  void handleActionIconTrigger(Icon icon, Event event) {
    if (_disabled) return;

    if (icon is IconWithAction) {
      icon.action?.call();
      event.stopPropagation();

      if (icon.shouldCloseMenuOnTrigger) _menuRoot?.closeHierarchy();
    }
  }

  Icon getIcon(MenuItemAffix affix) {
    IconAffix iconAffix = affix;
    return iconAffix.icon;
  }

  String getText(MenuItemAffix affix) {
    CaptionAffix captionAffix = affix;
    return captionAffix.text;
  }
}
