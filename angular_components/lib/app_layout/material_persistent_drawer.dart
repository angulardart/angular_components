// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content_aware.dart';

import 'material_drawer_base.dart';

/// A persistent drawer that can be pinned open or closed.
///
/// Need to include package:angular_components/app_layout/layout.scss.css
/// in the list of styleUrls of the containing component.
///
/// Works with deferred content.
@Directive(
  selector: 'material-drawer[persistent]',
  exportAs: 'drawer',
  providers: [
    ExistingProvider(DeferredContentAware, MaterialPersistentDrawerDirective),
  ],
  visibility: Visibility.all, // Injected by child elements.
)
class MaterialPersistentDrawerDirective extends MaterialDrawerBase {
  MaterialPersistentDrawerDirective() : super();

  @HostBinding('class.mat-drawer-collapsed')
  bool get hostMatDrawerCollapsed => !visible;

  @HostBinding('class.mat-drawer-expanded')
  bool get hostMatDrawerExpanded => visible;
}
