// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/src/material_tree/material_tree_expand_state.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Returns whether [option] should be shown as expandable.
typedef IsExpandable<T> = bool Function(T option);

/// Represents a hierarchical node in a nested list UI.
///
/// May serve strictly as an interface or be extended as a base class.
class MaterialTreeNode<T> {
  final OptionGroup<T> _EMPTY_OPTION_GROUP = OptionGroup<T>(const []);

  final _expandedNodes = Map<T, Iterable<OptionGroup<T>>>.identity();
  var _disposer = Disposer.multi();
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
      {IsExpandable<T> isExpandable}) {
    _group = _EMPTY_OPTION_GROUP;
    if (!_root.supportsHierarchy) {
      _isExpandable = (_) => false;
      _parent = _NotAParent();
    } else {
      _isExpandable = isExpandable ?? hasChildren;
      _parent = _root.options as Parent<T, Iterable<OptionGroup<T>>>;
    }
    // TODO(google).
    final Object options = _root.options;
    if (options is Selectable<T>) {
      _selectable = options;
    } else {
      _selectable = _AlwaysSelectable<T>();
    }
  }

  /// Whether all visible options should be expanded.
  bool get expandAll => _expandAll;

  @Input()
  set expandAll(bool expandAll) {
    if (identical(expandAll, _expandAll)) return;
    _expandAll = expandAll;
    expandAll ? expandAllOptions() : clearExpansions();
  }

  /// Whether the parent node can be selected in single select mode
  bool allowParentSingleSelection = false;

  /// Whether the parent node can be selected in multi select mode
  bool allowParentMultiSelection = true;

  /// The current node.
  OptionGroup<T> get group => _group;
  @Input()
  set group(OptionGroup<T> group) {
    _disposer.dispose();
    _group = group;
    if (!expandAll) {
      _expandedNodes.clear();
    }
    for (var key in group) {
      bool manualExpand = false;
      if (key is MaterialTreeExpandState) {
        manualExpand = key.expanded;
        // When we receive an expansion state change event, update the option
        _disposer.addStreamSubscription(key.expandEvents.listen((bool newVal) {
          if (newVal == _expandedNodes.containsKey(key)) return;
          if (newVal) {
            expandOption(key);
          } else {
            closeOption(key);
          }
        }));
      }
      if (expandAll || manualExpand) {
        expandOption(key);
      }
    }
    _changeDetector.markForCheck();
  }

  /// Collapses all options.
  void clearExpansions() {
    _expandedNodes.clear();
    for (T option in group) {
      setExpandedState(option, false);
    }
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
  bool isExpanded(T option) => _expandedNodes.containsKey(option);

  /// Whether no selection is possible but the item is normally selectable.
  bool get isReadOnly => _root.selection == const SelectionModel.empty();

  /// Whether multiple items may be selected.
  bool get isMultiSelect => _root.selection is MultiSelectionModel;

  /// Returns whether [option] is selectable.
  bool isSelectable(T option) {
    return _allowParentSelection &&
            _selectable.getSelectable(option) == SelectableOption.Selectable ||
        !isExpandable(option) &&
            _selectable.getSelectable(option) == SelectableOption.Selectable;
  }

  // True when flag for allowing parent selection is true for the selection
  // model type in use.
  bool get _allowParentSelection =>
      (isMultiSelect && allowParentMultiSelection) ||
      (!isMultiSelect && allowParentSingleSelection);

  /// Whether a disabled checkbox should be rendered for this option.
  bool showDisabledCheckbox(option) =>
      _selectable.getSelectable(option) == SelectableOption.Disabled &&
      !hasChildren(option);

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

    setExpandedState(option, true);
    if (expandAll && childGroups != null) {
      for (var group in childGroups) {
        for (var option in group) {
          await expandOption(option);
        }
      }
    }
    _changeDetector.markForCheck();
    return _expandedNodes[option] = childGroups;
  }

  /// Closes the given [option], if it is open.
  ///
  /// Returns whether the option was open.
  bool closeOption(T option) {
    var previousState = _expandedNodes.remove(option);
    setExpandedState(option, false);
    _changeDetector.markForCheck();
    return previousState != null;
  }

  /// Sets the expansion state of [option] to [state].
  ///
  /// No-op if [option] is not a [MaterialTreeExpandState].
  void setExpandedState(T option, bool state) {
    if (option is MaterialTreeExpandState) {
      option.expanded = state;
    }
  }

  /// Toggles the expansion state of [option].
  ///
  /// Returns a [Future] that completes when the children are available when
  /// expansion is triggered, otherwise immediately returns [Future<Null>].
  Future<Iterable<OptionGroup<T>>> toggleExpansion(T option) {
    bool didClose = closeOption(option);
    if (!didClose) {
      return expandOption(option);
    }
    return Future<Iterable<OptionGroup<T>>>.value();
  }

  /// Sets the [isSelected] state of [option] and returns the result.
  bool setSelectionState(T option, bool state) {
    if (isSelected(option) == state) return state;
    if (!state) {
      return !_root.selection.deselect(option);
    } else {
      return _root.selection.select(option);
    }
  }

  /// Selects or deselects two nodes and all the siblings in between.
  void toggleSelectionRangeInclusive(
      T firstNode, T lastNode, bool isSelection) {
    // Only proceeds if both nodes are siblings of the same group.
    if (!group.contains(firstNode) || !group.contains(lastNode)) return;

    // Using a for loop instead of a lazy iterable (e.g., takeWhile) because
    // it's better for performance.
    var isCurrentlyToggling = false;
    for (var node in group) {
      // Skip over if the node is not within the range of 2 terminal nodes.
      if (node != firstNode && node != lastNode && !isCurrentlyToggling) {
        continue;
      }

      if (isSelection) {
        _root.selection.select(node);
      } else {
        _root.selection.deselect(node);
      }

      if (node == firstNode || node == lastNode) {
        if (!isCurrentlyToggling) {
          isCurrentlyToggling = true;
        } else {
          break;
        }
      }
    }
  }

  /// Whether to use a dynamic component to render an option.
  // TODO(google): Rename this is to control whether to use dynamic component
  // loader.
  bool get useComponentRenderer =>
      _root.factoryRenderer != null || _root.componentRenderer != null;

  /// Whether to use a simple text formatter to render an option.
  bool get useItemRenderer => !useComponentRenderer;

  /// Whether to show the selection state within a dropdown.
  bool get showSelectionState => isMultiSelect || !_root.optimizeForDropdown;

  /// Converts [T] into a component type (requires [useComponentRenderer]).
  Type getComponentType(option) =>
      _root.componentRenderer != null ? _root.componentRenderer(option) : null;

  /// Converts [T] into a component factory (requires [factoryRenderer]).
  ComponentFactory getComponentFactory(option) =>
      _root.factoryRenderer != null ? _root.factoryRenderer(option) : null;

  /// Converts [T] into a text equivalent (requires [useItemRenderer]).
  String getOptionAsText(T option) {
    var itemRenderer = _root.itemRenderer ?? defaultItemRenderer;
    return itemRenderer(option);
  }

  /// Cleans up the node. Disposes subscriptions to [MaterialTreeExpandState].
  ///
  /// Currently a no-op if T doesn't implement [MaterialTreeExpandState].
  void onDestroy() {
    _disposer.dispose();
    // Cause a NPE if we attempt to use the disposer after being destroyed
    _disposer = null;
  }
}

// TODO(google): Remove once we switch over Selectable interfaces.
class _AlwaysSelectable<T> implements Selectable<T> {
  @override
  SelectableOption getSelectable(T item) => SelectableOption.Selectable;
}

class _NotAParent<P, C> implements Parent<P, C> {
  _NotAParent();

  @override
  bool hasChildren(P item) => false;

  @override
  DisposableFuture<C> childrenOf(P parent, [Object filterQuery]) {
    throw UnsupportedError('Does not support hierarchy');
  }
}
