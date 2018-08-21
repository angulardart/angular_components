// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

/// this utility method will check that keyboard even is happening
/// only with list of modifiers passed as true
/// i.e. if called (modifiersKeysFor, shiftKey : true)
/// it will return true if shift is pressed,
/// but false if both shift and alt are pressed
bool modifiersKeysFor(KeyboardEvent event,
    {bool shiftKey = false,
    bool ctrlKey = false,
    bool altKey = false,
    bool metaKey = false}) {
  return (event.shiftKey == shiftKey) &&
      (event.altKey == altKey) &&
      (event.ctrlKey == ctrlKey) &&
      (event.metaKey == metaKey);
}
