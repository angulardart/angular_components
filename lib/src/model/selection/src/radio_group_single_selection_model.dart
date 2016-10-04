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

import '../selection_model.dart';

import 'delegating_selection_model.dart';

/// Single selection model that always has a value selected
class RadioGroupSingleSelectionModel<T> extends DelegatingSelectionModel<T> {
  RadioGroupSingleSelectionModel([T initialValue])
      : super(new SelectionModel<T>.withList(
            selectedValues: initialValue == null ? const [] : [initialValue]));

  @override
  void clear() {}

  @override
  bool deselect(T value) => false;
}
