// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_tab/fixed_material_tab_strip.dart';
import 'package:angular_components/material_tab/material_tab.dart';
import 'package:angular_components/material_tab/material_tab_panel.dart';
import 'material_tab_panel_example.dart';
import 'material_tab_strip_example.dart';
import 'material_tab_strip_mixin_example.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Tab',
  docs: [
    FixedMaterialTabStripComponent,
    MaterialTabPanelComponent,
    MaterialTabComponent
  ],
  demos: [
    MaterialTabStripExample,
    MaterialTabPanelExample,
    MaterialTabStripMixinExample,
  ],
)
class MaterialTabExamples {}
