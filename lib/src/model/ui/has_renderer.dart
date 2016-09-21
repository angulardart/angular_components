// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library ads.acx2.model.ui.has_renderer;

/// Definition for a method that takes in an item and converts it to a string.
typedef String ItemRenderer<T>(T item);

/// Interface for a class defining itemRenderer.
abstract class HasRenderer<T> {
  ItemRenderer<T> itemRenderer;
}

/// Caches the results of calls to ItemRenderer.  It should be used in
/// Selection widgets.
class CachingItemRenderer<T> {
  /// See [ItemRenderer].
  final ItemRenderer<T> _renderer;

  /// Caches the result of calls to [ItemRenderer].
  final Map<T, String> _cache = new Map<T, String>();

  /// Creates of a CachingRenderer object.
  CachingItemRenderer.create(this._renderer);

  /// Returns a CachingRenderer, if the item passed in is already a
  /// CachingRenderer, it just returns it directly.
  factory CachingItemRenderer(ItemRenderer<T> itemRenderer) {
    if (itemRenderer is CachingItemRenderer<T>) {
      return itemRenderer;
    }
    return new CachingItemRenderer<T>.create(itemRenderer);
  }

  /// Caches the value of the ItemRenderer call on the item if it does not
  /// exist and uses the value if it does.
  String call(T item) {
    String value = _cache[item];
    if (value == null) {
      value = _renderer(item);
      _cache[item] = value;
    }
    return value;
  }
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
typedef Type ComponentRenderer<T extends RendersValue, I>(I item);

/// HasComponentRenderer defines a method that takes in an item and returns the
/// type to use to render the item.
abstract class HasComponentRenderer<T extends RendersValue, I> {
  ComponentRenderer<T, I> componentRenderer;
}

String defaultItemRenderer(dynamic value) => '$value';

abstract class SupportsRendering<T extends RendersValue, I>
    implements HasRenderer, HasComponentRenderer<T, I> {
  /// Sets the componentRenderer and itemRenderer based on whether the
  /// renderer implements the appropriate interfaces.
  @Deprecated('Set componentRenderer or itemRenderer directly')
  set renderer(Object renderer) {
    if (renderer is HasRenderer) {
      itemRenderer = renderer.itemRenderer;
    } else {
      // Provide a default.
      itemRenderer = defaultItemRenderer;
    }
    if (renderer is HasComponentRenderer<T, I>) {
      componentRenderer = renderer.componentRenderer;
    }
  }

  @override
  ComponentRenderer<T, I> componentRenderer;

  /// This item renderer is used to convert list items into a string that for
  /// the user of the UI.
  /// Ex: itemRenderer(0) returns 'black';
  @override
  ItemRenderer itemRenderer = defaultItemRenderer;
}