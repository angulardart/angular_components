// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Card',
  docs: ['package:angular_components/material_card/README.md'],
  demos: [MaterialCardExample],
  showGeneratedDocs: true,
  relatedUrls: {
    'Material Spec': 'https://material.io/design/components/cards.html',
  },
)
class MaterialButtonGalleryConfig {}

@Component(
  selector: 'material-card-example',
  directives: [
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  templateUrl: 'material_card_example.html',
  styleUrls: [
    // This is a wrapper around mdc-card styling to allow it to be imported
    // in dart.
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
    'material_card_example.scss.css'
  ],
)
class MaterialCardExample {}
