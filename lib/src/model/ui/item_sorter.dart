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

library angular2_components.model.ui.item_sorter;

import 'dart:collection';

import './has_renderer.dart';

/// Sorts a list of items using the ItemRenderer to obtain a string
/// representation.
List sortItems(ItemRenderer itemRenderer, Iterable entities,
    {bool ignoreCase: false}) {
  if (ignoreCase) {
    return new SplayTreeMap.fromIterable(entities,
        key: (Object c) => itemRenderer(c).toLowerCase()).values.toList();
  }
  return new SplayTreeMap.fromIterable(entities,
      key: (Object c) => itemRenderer(c)).values.toList();
}