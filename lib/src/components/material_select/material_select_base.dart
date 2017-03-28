// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../model/selection/selection_container.dart';
import '../../model/selection/selection_model.dart';
import '../../model/ui/accepts_width.dart';
import '../../model/ui/has_renderer.dart';
import '../../utils/angular/properties/properties.dart';

/// A [SelectionContainer] implementation with an additional option for setting
/// the rendered list's `width`.
///
/// __Expected Properties__:
///  - `selection`
///  - `options`
///  - `itemRenderer`
///  - `width`
///
/// __Expected Binding:__
/// `HasRenderer`
abstract class MaterialSelectBase extends SelectionContainer
    implements AcceptsWidth {
  bool get isMultiSelect => selection is MultiSelectionModel;
  bool get isSingleSelect => !isMultiSelect;

  /// Preset width, 1 through 5. By default, width #0 is used.
  /// Each width multiplies the base block width (64px on desktop and tablet) by
  /// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
  /// Set to 0 to have the list expand to fit its content.
  /// Note: The spec clearly lays out predefined list sizes so use
  /// the default, expanding size, sparingly.
  int get width => _width;
  set width(val) {
    _width = getInt(val, defaultValue: 0);
    assert(_width >= 0 && _width <= 5);
  }

  int _width = 0;

  @override
  ItemRenderer get itemRenderer => super.itemRenderer ?? defaultItemRenderer;
}
