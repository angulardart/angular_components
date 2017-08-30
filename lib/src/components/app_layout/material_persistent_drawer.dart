// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import '../content/deferred_content_aware.dart';

import 'material_drawer_base.dart';

/// A persistent drawer that can be pinned open or closed.
///
/// Need to include
/// package:angular_components/src/components/app_layout/layout.scss.css in the
/// list of styleUrls of the containing component.
///
/// Works with deferred content.
/// __Example usage:__
///     <material-drawer persistent #drawer="drawer">
///         ... content here ...
///     </material-drawer>
///     <material-button (trigger)="drawer.toggle()">
///       Toggle Drawer
///     </material-button>
@Directive(
  selector: 'material-drawer[persistent]',
  exportAs: 'drawer',
  providers: const [
    const Provider(DeferredContentAware,
        useExisting: MaterialPersistentDrawerDirective),
  ],
  host: const {
    '[class.mat-drawer-collapsed]': '!visible',
    '[class.mat-drawer-expanded]': 'visible',
  },
)
class MaterialPersistentDrawerDirective extends MaterialDrawerBase {
  MaterialPersistentDrawerDirective(HtmlElement element) : super(element);
}
