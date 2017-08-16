// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import '../content/deferred_content_aware.dart';

import 'material_drawer_base.dart';

/// A temporary drawer that can be opened and closed.
///
/// Works with deferred content.
/// __Example usage:__
///     <material-drawer temporary #drawer="drawer">
///         ... content here ...
///     </material-drawer>
///     <material-button (trigger)="drawer.toggle()">
///       Toggle Drawer
///     </material-button>
@Component(
  selector: 'material-drawer[temporary]',
  exportAs: 'drawer',
  providers: const [
    const Provider(DeferredContentAware,
        useExisting: MaterialTemporaryDrawerComponent),
  ],
  host: const {
    // TODO(google) click is not accessible; add bindings for esc key. This
    // should also block keyboard selection outside of the drawer, while open.
    '(click)': 'toggle()',
    '[class.mat-drawer-collapsed]': '!visible',
    '[class.mat-drawer-expanded]': 'visible',
  },
  templateUrl: 'material_temporary_drawer.html',
  styleUrls: const ['material_temporary_drawer.scss.css'],
  preserveWhitespace: false,
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTemporaryDrawerComponent extends MaterialDrawerBase {
  MaterialTemporaryDrawerComponent(HtmlElement element)
      : super(element, visible: false);
}
