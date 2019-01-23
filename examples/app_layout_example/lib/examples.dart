// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_stackable_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'stacking_drawer_example.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

import 'app_layout_example.dart';
import 'mobile_app_layout_example.dart';

@GallerySectionConfig(
  displayName: 'App Layout',
  docs: [
    'package:angular_components/app_layout/README.md',
    'package:angular_components/app_layout/_mixins.scss',
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialStackableDrawerComponent,
  ],
  demos: [
    MaterialDrawerExample,
    MaterialDrawerMobileExample,
    MaterialStackingDrawerExample,
  ],
  relatedUrls: {
    'Material Spec (Drawer)':
        'https://material.io/design/components/navigation-drawer.html',
    'Material Spec (App Bar)':
        'https://material.io/design/components/app-bars-top.html',
  },
)
class MaterialDrawerExamples {}
