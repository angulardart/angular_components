// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

/// Properties for a component which wants to expose typical options for a
/// input. See MaterialInput for fields definition.
class MaterialInputWrapper {
  @Input()
  Function characterCounter;
  @Input()
  Function checkValid;
  @Input()
  bool disabled = false;
  @Input()
  bool displayBottomPanel = true;
  @Input()
  String error;
  @Input()
  bool floatingLabel = false;
  @Input()
  String hintText;
  @Input()
  String leadingText;
  @Input()
  int maxCount;
  @Input()
  bool showHintOnlyOnFocus = false;
  @Input()
  bool required = false;
  @Input()
  String requiredErrorMsg;
  @Input()
  bool rightAlign = false;
  @Input()
  String trailingText;

  /// Any persistent glyph to show before the input box.
  @Input()
  String leadingGlyph;

  /// Any persistent glyph to show at the end of the input box.
  @Input()
  String trailingGlyph;

  String _label;
  String get label => _label;
  // Set is added to allow the base classes to override this functionality.
  @Input()
  set label(String value) {
    _label = value;
  }

  String _inputText;
  String get inputText => _inputText;
  // Set is added to allow the base classes to override this functionality.
  @Input()
  set inputText(String value) {
    _inputText = value;
  }
}
