// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Interface that defines how a type `T` should be formatted.
abstract class Formatter<T> {
  String format(T value, [String parameters]);
}
