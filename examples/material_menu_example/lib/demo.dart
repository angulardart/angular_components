// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_menu/material_fab_menu.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

import 'material_fab_menu_demo.dart';
import 'material_menu_demo.dart';

@GallerySectionConfig(
  displayName: 'Material Menu',
  docs: [
    MaterialMenuComponent,
    MaterialFabMenuComponent,
  ],
  demos: [
    MaterialMenuDemoComponent,
    MaterialFabMenuDemoComponent,
  ],
)
class MaterialMenuExamples {}
