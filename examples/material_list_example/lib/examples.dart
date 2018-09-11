// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';
import 'material_list_demo.dart';

@GallerySectionConfig(
  displayName: 'Material List',
  docs: [
    MaterialListComponent,
    MaterialListItemComponent,
  ],
  demos: [
    MaterialListDemoComponent,
  ],
)
class MaterialListExamples {}
