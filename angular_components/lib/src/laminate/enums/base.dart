// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A function that sets [propertyName] to [propertyValue].
typedef SetPropertyFn = void Function(
    String propertyName, dynamic propertyValue);

abstract class ElementStyleEnum {
  /// Applies this enum using [setProperty].
  void apply(SetPropertyFn setProperty);
}
