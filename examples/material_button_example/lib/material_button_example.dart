// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'buttons.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';
import 'package:angular_components/theme/dark_theme.dart';

@GallerySectionConfig(
  displayName: 'Material Button',
  docs: [
    MaterialButtonComponent,
    MaterialFabComponent,
  ],
  demos: [MaterialButtonExample],
)
class MaterialButtonGalleryConfig {}

@Component(
  selector: 'material-button-example',
  directives: [
    ButtonsExampleComponent,
    DarkThemeDirective,
    MaterialButtonComponent,
    MaterialFabComponent,
    MaterialIconComponent,
  ],
  templateUrl: 'material_button_example.html',
  styleUrls: ['material_button_example.scss.css'],
  preserveWhitespace: true,
)
class MaterialButtonExample {
  String content = 'click me';
}
