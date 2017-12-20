// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';

/// A type of component which renders items from a `SelectionModel` and may
/// show options from a `SelectionOptions` model.
abstract class SelectionContainer<T>
    implements HasRenderer<T>, HasComponentRenderer, HasFactoryRenderer {
  /// The selection model this container represents.
  SelectionModel<T> _selection;
  SelectionModel<T> get selection => _selection;
  set selection(SelectionModel<T> value) {
    _selection = value;
  }

  /// The available options for this contianer.
  SelectionOptions<T> _options;
  SelectionOptions<T> get options => _options;
  set options(SelectionOptions<T> value) {
    _options = value;
  }

  /// A simple function to render the an item to string.
  /// @override
  ItemRenderer<T> _itemRenderer;
  @override
  ItemRenderer<T> get itemRenderer => _itemRenderer;
  @override
  set itemRenderer(ItemRenderer<T> value) {
    _itemRenderer = value;
  }

  /// Specifies the componentRenderer to use to determine the component for
  /// rendering an item.
  ComponentRenderer _componentRenderer;
  @override
  ComponentRenderer get componentRenderer => _componentRenderer;
  @override
  @Deprecated(
      'Use factoryRenderer instead it provides more tree-shakeable code')
  set componentRenderer(ComponentRenderer value) {
    _componentRenderer = value;
  }

  /// Specifies the factoryRenderer to use to determine the factory for
  /// rendering an item.
  FactoryRenderer _factoryRenderer;
  @override
  FactoryRenderer get factoryRenderer => _factoryRenderer;
  @override
  set factoryRenderer(FactoryRenderer value) {
    _factoryRenderer = value;
  }
}

/// A type of component which renders an item from a `SelectionModel`.
abstract class SelectionItem<T> implements HasRenderer<T> {
  /// The selection model this item is a member of.
  SelectionModel<T> _selection;
  SelectionModel<T> get selection => _selection;
  set selection(SelectionModel<T> value) {
    _selection = value;
  }

  /// The value this component represents.
  T _value;
  T get value => _value;
  set value(T value) {
    _value = value;
  }

  /// A simple function to render the item to string.
  /// @override
  ItemRenderer<T> _itemRenderer;
  @override
  ItemRenderer<T> get itemRenderer => _itemRenderer;
  @override
  set itemRenderer(ItemRenderer<T> value) {
    _itemRenderer = value;
  }
}
