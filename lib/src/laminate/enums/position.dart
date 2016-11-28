// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/base.dart';

export 'src/base.dart';

class Position implements ElementStyleEnum {
  static const Static = const Position._('static');
  static const Relative = const Position._('relative');
  static const Fixed = const Position._('fixed');
  static const Absolute = const Position._('absolute');

  final String _cssPropertyValue;

  const Position._(this._cssPropertyValue);

  @override
  void apply(SetPropertyFn setProperty) {
    setProperty('position', _cssPropertyValue);
  }
}
