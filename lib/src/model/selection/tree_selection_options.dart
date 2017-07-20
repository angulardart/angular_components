// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../utils/async/async.dart';
import '../ui/has_renderer.dart';
import './selection_options.dart';
import './tree_selection_mixin.dart';

export './tree_selection_mixin.dart';

/// A [SelectionOptions] implementation that supports hierarchy.
///
/// TODO(google): add filtering and search options.
/// TODO(google): improve the performance of the defaultComaprator.
/// It is doing 2 * O(n log n) string conversions (which might be cheap
/// if itemRenderer is just returning a string or expensive).
class TreeSelectionOptions<T> extends SelectionOptions<T>
    with TreeSelectionMixin<T> {
  Map<T, List<OptionGroup<T>>> _parentToChildrenMap;
  final Map<T, TreeSelectionOptionData<T>> _itemsOptions;

  final ItemRenderer<T> _itemRenderer;
  Comparator<T> _comparator;

  TreeSelectionOptions()
      : _itemRenderer = defaultItemRenderer,
        _itemsOptions = {},
        super(const []) {
    _comparator = _defaultComparator;
  }

  TreeSelectionOptions.fromList(List<TreeSelectionOptionData<T>> listOfOptions,
      {ItemRenderer<T> itemRenderer, Comparator<T> comparator})
      : _itemRenderer = itemRenderer ?? defaultItemRenderer,
        _itemsOptions = new Map<T, TreeSelectionOptionData<T>>.fromIterable(
            listOfOptions,
            key: (TreeSelectionOptionData<T> item) => item.value),
        super(const []) {
    _comparator = comparator ?? _defaultComparator;
    List<T> rootOptions = [];
    var parentToChildrenMap = _generateEntitiesOptionsMap(rootOptions);

    /// Sets the actual options to start from.
    optionGroups = [new OptionGroup<T>(rootOptions..sort(_comparator))];

    /// Will save all the options per Entity.
    this.parentToChildrenMap = parentToChildrenMap;
  }

  @override
  bool hasChildren(T e) => _parentToChildrenMap[e]?.isNotEmpty == true;

  @override
  DisposableFuture<List<OptionGroup<T>>> childrenOf(T e, [_]) {
    return new DisposableFuture<List<OptionGroup<T>>>.fromValue(
        _parentToChildrenMap[e]);
  }

  @override
  Map<T, List<OptionGroup<T>>> getHierarchyMap() => _parentToChildrenMap;

  set parentToChildrenMap(Map<T, List<OptionGroup<T>>> value) {
    _parentToChildrenMap = value;
  }

  @override
  T getParent(T child) {
    return _itemsOptions[child]?.parent;
  }

  Map<T, List<OptionGroup>> _generateEntitiesOptionsMap(List<T> rootOptions) {
    Map<T, List<OptionGroup>> itemOptionsMap = {};

    _itemsOptions.values.forEach((item) =>
        _generateItemOptionsMapInternal(item, itemOptionsMap, rootOptions));
    return itemOptionsMap;
  }

  void _generateItemOptionsMapInternal(TreeSelectionOptionData<T> parent,
      Map<T, List<OptionGroup<T>>> itemOptionsMap, List<T> rootOptions) {
    itemOptionsMap[parent.value] = _createOptionGroups(parent);
    if (_itemsOptions[parent.value].parent == null) {
      rootOptions.add(parent.value);
    }
  }

  List<OptionGroup<T>> _createOptionGroups(TreeSelectionOptionData<T> parent) {
    List<TreeSelectionOptionData<T>> childrenEntities = const [];
    if (parent != null) {
      childrenEntities = _itemsOptions.values
          .where((child) => parent.value == child.parent)
          .toList(growable: false)
            ..sort((TreeSelectionOptionData<T> item1,
                    TreeSelectionOptionData<T> item2) =>
                _comparator(item1.value, item2.value));
    }

    if (childrenEntities.length > 0) {
      return [
        new OptionGroup<T>(childrenEntities.map((item) => item.value).toList())
      ];
    } else {
      return [];
    }
  }

  int _defaultComparator(T value1, T value2) =>
      _itemRenderer(value1).compareTo(_itemRenderer(value2));
}

/// A [TreeSelectionOptionData] class is used as data to the selection options
class TreeSelectionOptionData<T> {
  // The option's parent, will be used to define the hierarchy
  final T parent;
  final T value;

  TreeSelectionOptionData(this.value, this.parent);
}
