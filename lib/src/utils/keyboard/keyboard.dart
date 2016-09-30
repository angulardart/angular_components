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

library angular2_components.utils.keyboard.keyboard;

import 'dart:html';

/// this utility method will check that keyboard even is happening
/// only with list of modifiers passed as true
/// i.e. if called (modifiersKeysFor, shiftKey : true)
/// it will return true if shift is pressed,
/// but false if both shift and alt are pressed
bool modifiersKeysFor(KeyboardEvent event,
    {bool shiftKey: false,
    bool ctrlKey: false,
    bool altKey: false,
    bool metaKey: false}) {
  return (event.shiftKey == shiftKey) &&
      (event.altKey == altKey) &&
      (event.ctrlKey == ctrlKey) &&
      (event.metaKey == metaKey);
}