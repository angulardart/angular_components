// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/src/laminate/enums/base.dart';

export 'package:angular_components/src/laminate/enums/base.dart';

class Position implements ElementStyleEnum {
  static const Static = Position._('static');
  static const Relative = Position._('relative');
  static const Fixed = Position._('fixed');
  static const Absolute = Position._('absolute');

  final String _cssPropertyValue;

  const Position._(this._cssPropertyValue);

  @override
  void apply(SetPropertyFn setProperty) {
    setProperty('position', _cssPropertyValue);
  }
}
