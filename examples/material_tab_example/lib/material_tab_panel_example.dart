// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_tab/material_tab.dart';
import 'package:angular_components/material_tab/material_tab_panel.dart';
import 'package:angular_gallery_section/components/content/delayed_content.dart';
import 'package:angular_gallery_section/components/content/named_content.dart';

@Component(
  selector: 'material-tab-panel-example',
  providers: [rtlProvider],
  directives: [
    DeferredContentDirective,
    DelayedContentComponent,
    MaterialTabPanelComponent,
    MaterialTabComponent,
    NamedContentComponent
  ],
  templateUrl: 'material_tab_panel_example.html',
  styleUrls: ['material_tab_panel_example.scss.css'],
)
class MaterialTabPanelExample {}
