// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';

import 'material_icon.dart';

/// Adds a second icon to [MaterialIconComponent] that can be toggled on and
/// off.
///
/// See [https://www.google.com/design/icons/](https://goo.gl/YKrYlu) for
/// available icons. If the icon name contains spaces, replace them with
/// underscores.
///
/// The following css selectors can be used to target the icons for stylign in
/// various states:
/// - `.basic-icon`  -- Standard icon displayed when _not_ in the toggled state.
/// - `.toggled-icon`  -- Toggle icon displayed when in the toggled state.
/// - `.hide-icon` -- No icon when in a toggled state that doesn't have an icon.
@Directive(selector: 'material-icon[toggle]')
class MaterialIconToggleDirective implements AfterChanges {
  MaterialIconComponent iconRef;
  final ChangeDetectorRef _cdRef;
  bool _showToggled;
  bool _showBasic;
  bool _hideIcon;

  MaterialIconToggleDirective(this._cdRef, this.iconRef);

  /// The `Icon` model (third_party.dart_src.acx.model.ui.Icon) or icon
  /// identifier (String) to display.
  ///
  /// Defaults to a checkmark icon.
  @Input()
  dynamic toggledIcon = 'check';

  /// The `Icon` model (third_party.dart_src.acx.model.ui.Icon) or icon
  /// identifier (String) to display.
  ///
  /// If not provided this toggle icon will not display an icon in the standard
  /// state.
  @Input()
  dynamic icon;

  /// The toggled state of this icon.
  ///
  /// The [toggledIcon] is displayed when true.
  @Input()
  bool toggle;

  @override
  ngAfterChanges() {
    iconRef.icon = toggle ? toggledIcon : icon;
    _showToggled = toggle && _hasValue(toggledIcon);
    _showBasic = !toggle && _hasValue(icon);
    _hideIcon =
        (toggle && !_hasValue(toggledIcon)) || (!toggle && !_hasValue(icon));
    // Ensure the icon displayed by the underlying material-icon is updated.
    _cdRef.markForCheck();
  }

  @HostBinding('class.basic-icon.if')
  @visibleForTemplate
  bool get showBasic => _showBasic;

  @HostBinding('class.toggled-icon.if')
  @visibleForTemplate
  bool get showToggled => _showToggled;

  @HostBinding('class.hide-icon.if')
  @visibleForTemplate
  bool get hideIcon => _hideIcon;

  bool _hasValue(dynamic iconValue) => !(iconValue == null || iconValue == '');
}
