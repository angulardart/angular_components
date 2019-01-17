// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_menu/affix/base_affix.dart';
import 'package:angular_components/material_menu/affix/icon_affix_model.dart';
import 'package:angular_components/material_menu/common/menu_root.dart';
import 'package:angular_components/model/ui/icon.dart';

/// Icon affix component - if the icon has an action attached to it, then
/// clicking/triggering the icon will also run the action.
@Component(
    selector: 'icon-affix',
    directives: [
      ButtonDirective,
      MaterialIconComponent,
      NgClass,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: ['icon_affix.scss.css'],
    template: r'''
      <material-icon
          baseline
          buttonDecorator
          class="secondary-icon"
          [attr.aria-label]="actionIconAriaLabel"
          [ngClass]="affix.cssClass"
          [class.action-icon]="false"
          [class.disabled]="!isActionIconAffix"
          [class.hover-icon]="affix.isVisibleOnHover"
          [disabled]="!isActionIconAffix"
          [icon]="icon"
          (trigger)="handleActionIconTrigger($event)">
      </material-icon>
    ''')
class IconAffixComponent implements BaseAffixComponent<IconAffix> {
  /// The top most menu node.
  ///
  /// Used in order to close the whole hierarchy.
  final MenuRoot _menuRoot;

  final ChangeDetectorRef _cdRef;

  IconAffix _viewModel;

  var _disabled = false;

  IconAffixComponent(this._cdRef, @Optional() this._menuRoot);

  @visibleForTemplate
  Icon get icon => _viewModel.icon;

  @visibleForTemplate
  bool get isActionIconAffix => affix.hasAction;

  @visibleForTemplate
  String get actionIconAriaLabel => _viewModel.ariaLabel;

  @visibleForTemplate
  IconAffix get affix => _viewModel;

  @override
  IconAffix get value => _viewModel;

  @override
  set value(IconAffix newValue) {
    _viewModel = newValue;
    _cdRef.markForCheck();
  }

  @override
  bool get disabled => _disabled;

  @override
  set disabled(value) {
    _disabled = value;
    _cdRef.markForCheck();
  }

  @visibleForTemplate
  void handleActionIconTrigger(Event event) {
    if (disabled) return;

    if (_viewModel.hasAction) {
      _viewModel.triggerShortcutAction();
      event.stopPropagation();

      if (_viewModel.shouldCloseMenuOnTrigger) _menuRoot?.closeHierarchy();
    }
  }
}
