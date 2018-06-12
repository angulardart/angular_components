// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Represents no selection selected index.
const int noSelectionIndex = -1;

/// The event fired when tab is about to switch or has switched to
/// a new one.
///
/// [oldIndex], [newIndex] refer to the tab index.
/// [oldSubIndex], [newSubIndex] refer to the index of the selected item from
/// the de-emphasized tab dropdown. For normal tabs, this is
/// [noSelectionIndex], i.e. -1.
class TabChangeEvent {
  final int oldIndex;
  final int oldSubIndex;

  final int newIndex;
  final int newSubIndex;
  bool defaultPrevented = false;

  TabChangeEvent(this.oldIndex, this.newIndex,
      {this.oldSubIndex = noSelectionIndex,
      this.newSubIndex = noSelectionIndex});

  void preventDefault() {
    defaultPrevented = true;
  }

  /// Returns whether the event is to or from a de-emphasized tab.
  bool get isDeEmphasizedTabChange =>
      oldSubIndex != noSelectionIndex || newSubIndex != noSelectionIndex;

  @override
  String toString() =>
      'TabChangeEvent: [$oldIndex:$oldSubIndex] => [$newIndex:$newSubIndex]';
}
