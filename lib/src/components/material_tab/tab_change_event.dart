// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The event fired when tab is about to switch or has switched to
/// a new one.
///
/// [oldIndex], [newIndex] refer to the tab index.
/// [oldSubIndex], [newSubIndex] refer to the index of the selected item from
/// the de-emphasized tab dropdown. For normal tabs, this is 0.
class TabChangeEvent {
  final int oldIndex;
  final int oldSubIndex;

  final int newIndex;
  final int newSubIndex;
  bool defaultPrevented = false;

  TabChangeEvent(this.oldIndex, this.newIndex,
      {this.oldSubIndex: 0, this.newSubIndex: 0});

  void preventDefault() {
    defaultPrevented = true;
  }

  @override
  String toString() =>
      'TabChangeEvent: [$oldIndex:$oldSubIndex] => [$newIndex:$newSubIndex]';
}
