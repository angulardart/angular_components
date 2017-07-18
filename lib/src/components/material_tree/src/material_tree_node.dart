// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';

import 'package:angular/angular.dart';

import '../../../model/selection/select.dart';
import '../../../model/selection/selection_model.dart';
import '../../../model/selection/selection_options.dart';
import '../../../model/ui/has_renderer.dart';
import '../../../utils/async/async.dart';
import './material_tree_root.dart';

/// Returns whether [option] should be shown as expandable.
typedef bool IsExpandable<T>(T option);

/// Represents a hierarchical node in a nested list UI.
///
/// May serve strictly as an interface or be extended as a base class.
class MaterialTreeNode<T> {
  final OptionGroup<T> _EMPTY_OPTION_GROUP = new OptionGroup<T>(const []);

  final Map<T, Iterable<OptionGroup<T>>> _expandedNodes;
  final MaterialTreeRoot<T> _root;
  final ChangeDetectorRef _changeDetector;

  bool _expandAll = false;
  OptionGroup<T> _group;
  Parent<T, Iterable<OptionGroup<T>>> _parent;
  IsExpandable<T> _isExpandable;
  Selectable<T> _selectable;

  /// Create a new tree node.
  ///
  /// Actual implementation of how to retrieve nested items is provided.
  ///
  /// May specify a custom [isExpandable].
  MaterialTreeNode(this._root, this._changeDetector,
      {IsExpandable<T> isExpandable})
      : _expandedNodes = new HashMap<T, Iterable<OptionGroup<T>>>() {
    _group = _EMPTY_OPTION_GROUP;
    if (!_root.supportsHierarchy) {
      _isExpandable = (_) => false;
      _parent = const _NotAParent();
    } else {
      _isExpandable = isExpandable ?? hasChildren;
      _parent = _root.options as Parent<T, Iterable<OptionGroup<T>>>;
    }
    if (_root.options is Selectable) {
      _selectable = _root.options as Selectable<T>;
    } else {
      _selectable = const _AlwaysSelectable();
    }
  }

  /// Whether all visible options should be expanded.
  bool get expandAll => _expandAll;
  set expandAll(bool expandAll) {
    _expandAll = expandAll;
    expandAll ? expandAllOptions() : clearExpansions();
  }

  /// The current node.
  OptionGroup<T> get group => _group;
  set group(OptionGroup<T> group) {
    _group = group;
    if (expandAll) {
      for (var key in group) {
        expandOption(key);
      }
    } else {
      clearExpansions();
    }
  }

  /// Collapses all options.
  void clearExpansions() {
    _expandedNodes.clear();
    _changeDetector.markForCheck();
  }

  /// Expands all options.
  void expandAllOptions() {
    for (var key in group) {
      expandOption(key);
    }
  }

  /// Returns whether [option] has one or more child nodes when expanded.
  bool hasChildren(T option) => _parent.hasChildren(option);

  /// Returns whether [option] has the *capability* of having child nodes.
  ///
  /// This may be used in the UI to determine whether an indication of expansion
  /// should be shown. It may be beneficial to hide or disable that both express
  /// [isExpandable] = true and [isSelectable] = false, as empty groups of items
  /// are a placeholder.
  ///
  /// **NOTE**: This is potentially different than [hasChildren].
  bool isExpandable(T option) => _isExpandable(option);

  /// Whether [option] should be shown expanded in the UI.
  bool isExpanded(T option) => expandAll || _expandedNodes.containsKey(option);

  /// Whether no selection is possible but the item is normally selectable.
  bool get isReadOnly => _root.selection == const SelectionModel();

  /// Whether multiple items may be selected.
  bool get isMultiSelect => _root.selection is MultiSelectionModel;

  /// Returns whether [option] is selectable.
  bool isSelectable(T option) {
    return isMultiSelect &&
            _selectable.getSelectable(option) == SelectableOption.Selectable ||
        !isExpandable(option) &&
            _selectable.getSelectable(option) == SelectableOption.Selectable;
  }

  /// Returns whether [option] is selected.
  bool isSelected(T option) => _root.selection.isSelected(option);

  /// Returns any child groups of [option] that are loaded.
  Iterable<OptionGroup> getChildGroups(option) => _expandedNodes[option];

  /// Expands the given [option].
  ///
  /// Returns a [Future] that completes when the children are available when
  /// expansion is triggered, otherwise immediately returns [Future<Null>].
  Future<Iterable<OptionGroup<T>>> expandOption(T option) async {
    Iterable<OptionGroup<T>> childGroups = await _parent.childrenOf(option);

    if (expandAll && childGroups != null) {
      for (var group in childGroups) {
        for (var option in group) {
          expandOption(option);
        }
      }
    }
    _changeDetector.markForCheck();
    return _expandedNodes[option] = childGroups;
  }

  /// Toggles the expansion state of [option].
  ///
  /// Returns a [Future] that completes when the children are available when
  /// expansion is triggered, otherwise immediately returns [Future<Null>].
  Future<Iterable<OptionGroup<T>>> toggleExpansion(T option) {
    var previousState = _expandedNodes.remove(option);
    if (previousState == null) {
      return expandOption(option);
    }
    _changeDetector.markForCheck();
    return new Future<Iterable<OptionGroup<T>>>.value();
  }

  /// Toggles the [isSelected] state of [option] and returns the result.
  bool toggleSelection(T option) {
    if (isSelected(option)) {
      return !_root.selection.deselect(option);
    } else {
      return _root.selection.select(option);
    }
  }

  /// Whether to use a dynamic component to render an option.
  bool get useComponentRenderer => _root.componentRenderer != null;

  /// Whether to use a simple text formatter to render an option.
  bool get useItemRenderer => !useComponentRenderer;

  /// Whether to show the selection state within a dropdown.
  bool get showSelectionState => isMultiSelect || !_root.optimizeForDropdown;

  /// Converts [T] into a component type (requires [useComponentRenderer]).
  Type getComponentType(option) => _root.componentRenderer(option);

  /// Converts [T] into a text equivalent (requires [useItemRenderer]).
  String getOptionAsText(T option) {
    var itemRenderer = _root.itemRenderer ?? defaultItemRenderer;
    return itemRenderer(option);
  }
}

// TODO(google): Remove once we switch over Selectable interfaces.
class _AlwaysSelectable<T> implements Selectable<T> {
  const _AlwaysSelectable();

  @override
  SelectableOption getSelectable(T item) => SelectableOption.Selectable;
}

class _NotAParent<P, C> implements Parent<P, C> {
  const _NotAParent();

  @override
  bool hasChildren(P item) => false;

  @override
  DisposableFuture<C> childrenOf(P parent, [Object filterQuery]) {
    throw new UnsupportedError('Does not support hierarchy');
  }
}
