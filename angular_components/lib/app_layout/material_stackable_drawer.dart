// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/content/deferred_content_aware.dart';

/// A stackable temporary drawer that can be opened and closed.
///
/// While a stackable drawer is open any existing stackable drawer will be
/// expanded to fill the screen in the background.
///
/// Works with deferred content.
@Component(
  selector: 'material-drawer[stackable]',
  providers: [
    ExistingProvider(DeferredContentAware, MaterialStackableDrawerComponent),
  ],
  templateUrl: 'material_stackable_drawer.html',
  styleUrls: ['material_stackable_drawer.scss.css'],
  visibility: Visibility.all, // Injected by child elements.
)
class MaterialStackableDrawerComponent
    extends MaterialTemporaryDrawerComponent {
  final MaterialStackableDrawerComponent parent;

  MaterialStackableDrawerComponent(@Optional() @SkipSelf() this.parent)
      : super();

  /// 'True' when the drawer is expanded to full screen.
  @Input()
  bool isExpanded = false;

  @override
  set visible(bool newVisible) {
    super.visible = newVisible;

    parent?.isExpanded = newVisible;
  }

  @HostBinding('class.mat-drawer-collapsed')
  bool get hostMatDrawerCollapsed => !visible;

  @HostBinding('class.mat-drawer-expanded')
  bool get hostMatDrawerExpanded => visible;

  // TODO(google) click is not accessible; add bindings for esc key. This
  // should also block keyboard selection outside of the drawer, while open.
  @HostListener('click')
  @override
  void toggle() => super.toggle();
}
