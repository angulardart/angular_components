// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'base_material_input.dart';

/// Directive to control automatic text selection on `material-input` when
/// focused.
///
/// NOTE: This directive can't be used with `MaterialMultilineInputComponent` as
/// auto selecting multiple lines on focus is not generic. Please reach out to
/// ACX team if you have a use case for the same.
///
/// __Example usage:__
///     <material-input autoSelect ngModel="Auto-selecting input">
///     </material-input>
@Directive(selector: 'material-input[autoSelect]:not([multiline])')
class MaterialInputAutoSelectDirective implements OnDestroy {
  final _disposer = Disposer.oneShot();

  /// Timer to select the input text.
  Timer _selectionTimer;

  @Input()
  bool autoSelect = true;

  MaterialInputAutoSelectDirective(BaseMaterialInput input) {
    _disposer.addStreamSubscription(input.onFocus.listen((event) {
      if (!autoSelect) return;

      // Selection of the text needs to be delayed a bit because in some
      // browsers click event fires after the focus event causing text selection
      // to be lost.
      // Please visit go/acx-input-auto-select-directive for more details.
      _selectionTimer?.cancel();
      _selectionTimer = Timer(Duration(milliseconds: 30), input.selectAll);
    }));
  }

  @override
  void ngOnDestroy() {
    _selectionTimer?.cancel();
    _disposer.dispose();
  }
}
