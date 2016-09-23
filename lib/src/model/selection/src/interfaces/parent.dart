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

/// **NOTE**: This library is currently unused and will replace select.dart.
library angular2_components.model.selection.src.interfaces.parent;

import 'dart:async';

/// Interface implemented by classes that may have nodes with children.
abstract class Parent<P, C> {
  /// Whether the [item] of parent type [P] has child a child entity [C].
  bool hasChildren(P item);

  /// Returns a stream that results in child entity [C] of [parent].
  ///
  /// Should throw [StateError] if [hasChildren] for [parent] is `false`.
  Stream<C> getChildren(P parent);
}