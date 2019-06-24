// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Definition for a method that takes in an item and converts it to a string.
typedef ItemRenderer<T> = String Function(T item);

/// Interface for a class defining itemRenderer.
abstract class HasRenderer<T> {
  ItemRenderer<T> itemRenderer;
}

final _rendererMarker = Expando('Renderer marker');

/// Returns an ItemRenderer that caches the results of calls.  It should be used
/// in Selection widgets.
///
/// If the item passed in is already a caching ItemRenderer, it is returned
/// unchanged.
ItemRenderer<T> newCachingItemRenderer<T>(ItemRenderer<T> itemRenderer) {
  if (itemRenderer != null && _rendererMarker[itemRenderer] != null) {
    return itemRenderer;
  }
  var _cache = <T, String>{};
  ItemRenderer<T> cachingItemRenderer = (T item) {
    String value = _cache[item];
    if (value == null) {
      value = itemRenderer(item);
      _cache[item] = value;
    }
    return value;
  };
  _rendererMarker[cachingItemRenderer] = cachingItemRenderer;

  return cachingItemRenderer;
}

/// Interface to render a value.
///
/// In particular, if a component is loaded by [DynamicComponent] and it needs
/// to render a value, it must implement this interface to allow
/// DynamicComponent to set the value.
abstract class RendersValue<T> {
  set value(T newValue);
}

/// Defines a method that returns a component to render the Item.  The
/// component must implement RendersValue.
@Deprecated('Use FactoryRenderer instead as it allows for treeshaking')
typedef ComponentRenderer<T extends RendersValue, I> = Type Function(I item);

/// HasComponentRenderer defines a method that takes in an item and returns the
/// type to use to render the item.
@Deprecated('Use HasFactoryRenderer instead as it allows for treeshaking')
abstract class HasComponentRenderer<T extends RendersValue, I> {
  ComponentRenderer<T, I> componentRenderer;
}

String defaultItemRenderer(dynamic value) => '$value';

/// An [ItemRenderer] that indicates that components should not render items.
const ItemRenderer nullRenderer = _nullRenderer;

String _nullRenderer(dynamic value) =>
    throw StateError("nullRenderer should never be called");
