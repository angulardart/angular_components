// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Spinner',
  docs: [MaterialSpinnerComponent],
  demos: [MaterialSpinnerExample],
)
class MaterialSpinnerGalleryConfig {}

@Component(
  selector: 'material-spinner-example',
  directives: [MaterialSpinnerComponent],
  templateUrl: 'material_spinner_example.html',
  styleUrls: ['material_spinner_example.scss.css'],
)
class MaterialSpinnerExample {}
