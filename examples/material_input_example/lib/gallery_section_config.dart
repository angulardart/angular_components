// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/material_input/material_auto_suggest_input.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';
import 'package:angular_components/material_input/material_percent_directive.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

import 'material_auto_suggest_input_full_demo.dart';
import 'material_auto_suggest_input_simple_demo.dart';
import 'material_input_demo.dart';
import 'material_input_mixins.dart';
import 'material_input_number_value_accessor_demo.dart';
import 'material_percent_input_demo.dart';

@GallerySectionConfig(
  displayName: 'Material Input',
  docs: [
    MaterialInputComponent,
    MaterialMultilineInputComponent,
    'package:angular_components/material_input/material_auto_suggest_input.md',
    MaterialAutoSuggestInputComponent,
    MaterialNumberValueAccessor,
    MaterialPercentInputDirective,
  ],
  demos: [
    MaterialInputDemoComponent,
    MaterialAutoSuggestInputSimpleDemoComponent,
    MaterialAutoSuggestInputFullDemoComponent,
    MaterialPercentInputDemoComponent,
    MaterialInputMixinDemoComponent,
    MaterialInputNumberValueAccessorDemoComponent,
  ],
)
class MaterialInputGallerySection {}

@GallerySectionConfig(
  displayName: 'Material Auto Suggest Input',
  docs: [
    'package:angular_components/material_input/material_auto_suggest_input.md',
    MaterialAutoSuggestInputComponent
  ],
  demos: [
    MaterialAutoSuggestInputSimpleDemoComponent,
    MaterialAutoSuggestInputFullDemoComponent
  ],
)
class MaterialAutoSuggestInputGallerySection {}
