// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

/// Simple pass-thru content container which announces its construction and
/// displays a label (in a <p> tag) above the content.
/// Only use this component in demos.
///
/// __Attributes__
/// `name: string` -- Name of component.
@Component(
  selector: 'named-content',
  template: r'''
        <p>{{label}}</p>
        <ng-content></ng-content>''',
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class NamedContentComponent {
  String get label => '$_componentName Content';
  final String _componentName;
  NamedContentComponent(@Attribute('name') this._componentName) {
    print('Named Component "$_componentName" instantiated');
  }
}
