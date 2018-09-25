// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_select/display_name.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_select.dart';
import 'package:angular_components/material_select/material_select_item.dart';
import 'material_dropdown_select_full_demo.dart'
    show MaterialDropdownSelectFullDemoComponent;
import 'material_dropdown_select_simple_demo.dart';
import 'material_select_demo.dart' show MaterialSelectDemoComponent;
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Select',
  docs: [
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    'package:angular_components/material_select/material_dropdown_select.md',
    MaterialDropdownSelectComponent,
    DropdownButtonComponent,
    displayNameRendererDirective
  ],
  demos: [
    MaterialSelectDemoComponent,
    MaterialDropdownSelectSimpleDemoComponent,
    MaterialDropdownSelectFullDemoComponent
  ],
)
class MaterialSelectExamples {}

@GallerySectionConfig(
  displayName: 'Material Dropdown Select',
  docs: [
    'package:angular_components/material_select/material_dropdown_select.md',
    MaterialDropdownSelectComponent
  ],
  demos: [
    MaterialDropdownSelectSimpleDemoComponent,
    MaterialDropdownSelectFullDemoComponent
  ],
)
class MateriaDropdownSelectExamples {}
