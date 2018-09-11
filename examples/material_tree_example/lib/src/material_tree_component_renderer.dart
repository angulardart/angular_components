// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/model/ui/has_renderer.dart';

/// An example component renderer that adds an android icon.
@Component(
  selector: 'component-renderer-example',
  directives: [MaterialIconComponent],
  template: r'''
        <material-icon icon="android" size="small"></material-icon> {{value}}
    ''',
  styles: [':host {display: inline-block;}'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class ComponentRendererExample implements RendersValue<String> {
  @override
  String value;
}
