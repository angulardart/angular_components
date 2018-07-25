// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/src/laminate/enums/base.dart';

export 'package:angular_components/src/laminate/enums/base.dart';

/// Enum for browser visibility options.
class Visibility implements ElementStyleEnum {
  /// Equivalent to "display: none". Does not render.
  static const None = Visibility._('None', 'display', 'none');

  /// Equivalent to "visibility: hidden". Renders, but not visible to user.
  static const Hidden = Visibility._('Hidden', 'visibility', 'hidden');

  /// Equivalent to "display: inherit". Renders in most cases.
  static const Visible = Visibility._('Visible');

  /// The enum name of the instance.
  final String displayName;

  final String _propertyName;
  final String _propertyValue;

  factory Visibility.fromBoolean(bool visible) {
    return visible ? Visible : None;
  }

  const Visibility._(this.displayName,
      [this._propertyName, this._propertyValue]);

  @override
  void apply(SetPropertyFn setProperty) {
    if (_propertyName != null) {
      setProperty(_propertyName, _propertyValue);
    }
  }

  @override
  String toString() => 'Visibility {$displayName}';
}
