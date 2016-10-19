// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Properties for a component which wants to expose typical options for a
/// input. See MaterialInput for fields definition.
class MaterialInputWrapper {
  Function characterCounter = null;
  Function checkValid = null;
  bool disabled = false;
  bool displayBottomPanel = true;
  bool floatingLabel;
  String leadingText;
  String label;
  int maxCount;
  bool required;
  bool rightAlign = false;
  String trailingText;

  String _inputText;
  String get inputText => _inputText;
  set inputText(String value) {
    _inputText = value;
  }
}
