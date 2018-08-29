// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@GallerySectionConfig(
  displayName: 'Material List',
  docs: ['package:third_party.dart_src.acx.material_list/README.md'],
  demos: [ListExample],
  benchmarks: [],
  showGeneratedDocs: true,
  relatedUrls: {
    'Material Spec': 'https://material.io/design/components/lists.html',
  },
)
class MaterialListGalleryConfig {}

@Component(
    selector: 'list-example',
    templateUrl: 'list_example.html',
    styleUrls: [
      // This is a wrapper around mdc-list styling to allow it to be imported
      // in dart.
      'package:third_party.dart_src.acx.material_list/list.scss.css',
      'list_example.scss.css'
    ],
    directives: [
      MaterialIconComponent
    ])
class ListExample {}
