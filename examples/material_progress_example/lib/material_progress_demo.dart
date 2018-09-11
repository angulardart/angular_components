// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_progress/material_progress.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Progress',
  docs: [MaterialProgressComponent],
  demos: [MaterialProgressDemoComponent],
)
class MaterialProgressExamples {}

@Component(
  selector: 'material-progress-demo',
  templateUrl: 'material_progress_demo.html',
  styleUrls: ['material_progress_demo.scss.css'],
  directives: [MaterialProgressComponent],
)
class MaterialProgressDemoComponent {}
