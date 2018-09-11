// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';

@GallerySectionConfig(
  displayName: 'Material Toggle',
  docs: [MaterialToggleComponent],
  demos: [MaterialToggleExampleComponent],
)
@Component(
  selector: 'material-toggle-example',
  directives: [MaterialToggleComponent, NgClass, NgFor],
  styleUrls: ['material_toggle_example.scss.css'],
  templateUrl: 'material_toggle_example.html',
)
class MaterialToggleExampleComponent {
  bool btEnabled = false;
  bool deviceVisible = false;

  bool basicState;

  String get btnToggleLabel =>
      'Tap to turn Bluetooth ${btEnabled ? 'OFF' : 'ON'}.';
}
