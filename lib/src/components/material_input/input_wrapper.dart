// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Properties for a component which wants to expose typical options for a
/// input. See MaterialInput for fields definition.
class MaterialInputWrapper {
  Function characterCounter;
  Function checkValid;
  bool disabled = false;
  bool displayBottomPanel = true;
  bool floatingLabel = false;
  String hintText;
  String leadingText;
  int maxCount;
  bool showHintOnlyOnFocus = false;
  bool required = false;
  bool rightAlign = false;
  String trailingText;

  String _label;
  String get label => _label;
  // Set is added to allow the base classes to override this functionality.
  set label(String value) {
    _label = value;
  }

  String _inputText;
  String get inputText => _inputText;
  // Set is added to allow the base classes to override this functionality.
  set inputText(String value) {
    _inputText = value;
  }
}
