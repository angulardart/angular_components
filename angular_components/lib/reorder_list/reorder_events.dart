// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An event data emitted after single drag element is dropped.
class ReorderEvent {
  final int sourceIndex;
  final int destIndex;

  ReorderEvent(this.sourceIndex, this.destIndex);
}

/// An event data emitted when [multiSelect] is set to true.
///
/// (Even if only one item is dragged).
class MultiReorderEvent extends ReorderEvent {
  /// All the selected items indexes before their repositioning.
  final List<int> sourceIndexes;

  MultiReorderEvent(this.sourceIndexes, int destIndex)
      : super(sourceIndexes[0], destIndex);
}

/// An event to represent each selection change.
class ItemSelectionEvent {
  /// The newly selected indexes.
  final List<int> selectedIndexes;

  ItemSelectionEvent(List<int> indexes)
      : selectedIndexes = List<int>.unmodifiable(indexes);
}
