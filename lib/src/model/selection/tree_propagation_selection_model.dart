// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import './selection_model.dart';
import './tree_selection_options.dart';

/// A [MultiSelectionModel] implementation that supports
/// propagation selections to it children,
///
/// All the overrides are needed, because MultiSelectionModel
/// is abstract class.
/// Meaning, this class acts like [DelegatingSelectionModel].
///
/// Used in [TreeDropdownSelectComponent] when 'auto-select-children'
/// option in ess is turned true.
class TreePropagationSelectionModel<T>
    extends DelegatingMultiSelectionModel<T> {
  /// The available options for this for the tree selection.
  TreeSelectionOptions<T> _treeOptions;

  TreePropagationSelectionModel(
      MultiSelectionModel<T> delegateModel, this._treeOptions)
      : super(delegateModel);

  /// When given a selected entity, this will check the
  /// treeoptions for children and select them all.
  @override
  bool select(T value) {
    bool wasNewSelection = super.select(value);
    if (wasNewSelection) {
      super.selectAll(_treeOptions.allChildrenOf(value));
    }
    return wasNewSelection;
  }

  /// When given a un-selected entity, this will check the
  /// treeoptions for children and deselect them.
  @override
  bool deselect(T value) {
    bool wasNewSelection = super.deselect(value);
    if (wasNewSelection) {
      _treeOptions
          .allChildrenOf(value)
          .forEach((subItem) => super.deselect(subItem));
    }
    return wasNewSelection;
  }
}
