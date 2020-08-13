// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/ui/has_factory.dart';

/// An limited interface for child groups to use to access the tree.
abstract class MaterialTreeRoot<T>
    implements
        SelectionContainer<T>,
        HasComponentRenderer<RendersValue, Object>,
        HasFactoryRenderer<RendersValue, T> {
  /// Whether a filter is currently applied.
  bool isFiltered = false;

  /// Whether to hide check-marks in a single select dropdown
  bool get optimizeForDropdown => false;

  /// Whether the widget supports searching the data set.
  ///
  /// When `false`, no search box is shown.
  bool get supportsFiltering => options is Filterable;

  /// Whether the widgets supports expansion and child data sets.
  ///
  /// When `false`, the widget falls back to a simple flat list. This is not a
  /// recommended use case and is provided for graceful failure. If you intend
  /// to use a flat data set consider [MaterialSelect].
  bool get supportsHierarchy => options is Parent;

  /// Whether the widgets supports the selection of non-leaf nodes
  ///
  /// When `false`, and the widget is using a single selection model clicking
  /// the widget should toggle expansion when a non-leaf node is clicked. When
  /// `true` the widget should select non-leaf nodes when clicked and only
  /// toggle expansion when the expansion icon is clicked.
  bool get allowParentSingleSelection => false;

  /// Whether the widgets supports the selection of non-leaf nodes.
  ///
  /// When `false`, and the widget should toggle expansion when a non-leaf
  /// node is clicked. When `true` the widget should select non-leaf nodes
  /// when clicked and only toggle expansion when the expansion icon is clicked.
  bool get allowParentMultiSelection => true;

  /// The previously toggled node.
  T previouslyToggledNode;
}
