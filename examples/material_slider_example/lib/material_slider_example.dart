// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_slider/material_slider.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Slider',
  docs: [MaterialSliderComponent],
  demos: [MaterialSliderExample],
)
class MaterialSliderGalleryConfig {}

@Component(
  selector: 'material-slider-example',
  providers: [],
  directives: [
    MaterialSliderComponent,
    MaterialToggleComponent,
  ],
  templateUrl: 'material_slider_example.html',
  styleUrls: ['material_slider_example.scss.css'],
)
class MaterialSliderExample {
  int value = 60;
  double value2 = 0.5;
  int leftValue = 60;
  int rightValue = 80;
  bool disabled = false;
  bool disabled2 = false;
  bool disabled3 = false;
}
