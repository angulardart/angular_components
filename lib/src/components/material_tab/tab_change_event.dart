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
