// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';

/// A directive providing a [MenuRoot] through the injected [DropdownHandle].
@Directive(
  selector: '[menu-root]',
  providers: [ExistingProvider(MenuRoot, MenuRootDirective)],
)
class MenuRootDirective extends MenuRoot {
  final DropdownHandle _dropdown;

  MenuRootDirective(@Optional() this._dropdown) {
    visible = true;
  }

  @override
  void closeHierarchy() {
    visible = false;
    _dropdown?.close();
  }
}

/// The root of a hierarchy of [MenuItemGroups].
///
/// This must be provided as it permits to close the menu hierarchy on menu
/// actions.
abstract class MenuRoot {
  void closeHierarchy();

  /// Is this menu closed or closing.
  bool visible;
}
