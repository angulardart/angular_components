// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';

/// A type of component which renders items from a `SelectionModel` and may
/// show options from a `SelectionOptions` model.
abstract class SelectionContainer<T>
    implements
        HasRenderer<T>,
        HasComponentRenderer<RendersValue, Object>,
        HasFactoryRenderer<RendersValue, T> {
  /// The selection model this container represents.
  SelectionModel<T> selection;

  /// The available options for this container.
  SelectionOptions<T> options;

  /// A simple function to render the an item to string.
  /// @override
  @override
  ItemRenderer<T> itemRenderer;

  /// Specifies the componentRenderer to use to determine the component for
  /// rendering an item.
  @override
  @Deprecated(
      'Use factoryRenderer instead it provides more tree-shakeable code')
  ComponentRenderer componentRenderer;

  /// Specifies the factoryRenderer to use to determine the factory for
  /// rendering an item.
  @override
  FactoryRenderer<RendersValue, T> factoryRenderer;
}

/// A type of component which renders an item from a `SelectionModel`.
abstract class SelectionItem<T> implements HasRenderer<T> {
  /// The selection model this item is a member of.
  SelectionModel<T> selection;

  /// The value this component represents.
  T value;

  /// A simple function to render the item to string.
  @override
  ItemRenderer<T> itemRenderer;
}
