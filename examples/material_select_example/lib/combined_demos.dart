// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'material_dropdown_select_demo.dart'
    show MaterialDropdownSelectDemoComponent;
import 'material_select_demo.dart' show MaterialSelectDemoComponent;
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Select',
  docs: [
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialDropdownSelectComponent,
    DropdownButtonComponent,
    displayNameRendererDirective
  ],
  demos: [MaterialSelectDemoComponent, MaterialDropdownSelectDemoComponent],
  benchmarks: [
    'material_select_item_init',
    'material_select_init',
    'material_dropdown_select_init'
  ],
  showGeneratedDocs: true,
)
class MaterialSelectExamples {}
