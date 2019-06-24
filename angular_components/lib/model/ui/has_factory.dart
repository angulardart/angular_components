// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This file is separate from has_renderer.dart so it doesn't add the angular
// dependency and transitively 'dart:html', which doesn't work in a simple
// dart_test.
import 'package:angular/angular.dart' show ComponentFactory;

import 'has_renderer.dart';

export 'has_renderer.dart';

/// Defines a method that returns a factory to render the Item.  The component
/// created must implement [RendersValue].
typedef FactoryRenderer<T extends RendersValue, I> = ComponentFactory Function(
    I item);

/// HasFactoryRenderer defines a method that takes in an item and returns the
/// factory to use to render the item.
abstract class HasFactoryRenderer<T extends RendersValue, I> {
  FactoryRenderer<T, I> factoryRenderer;
}
