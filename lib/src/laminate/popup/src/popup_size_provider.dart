// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_size_provider;

import 'package:angular2/angular2.dart';

/// A handler that provides max width and max height of a popup based on its
/// position and the current viewport size.
abstract class PopupSizeProvider {
  /// The max width.
  ///
  /// Returns null if max width is not specified.
  num getMaxWidth(num positionX, num viewportWidth);

  /// The max height.
  ///
  /// Returns null if max height is not specified.
  num getMaxHeight(num positionY, num viewportHeight);
}

/// A popup size provider that determines the popup size based on a fixed
/// percentage of the current viewport size.
class PercentagePopupSizeProvider implements PopupSizeProvider {
  final num _maxWidthPercentage;
  final num _maxHeightPercentage;

  const PercentagePopupSizeProvider(
      [num maxWidthPercentage, num maxHeightPercentage])
      : _maxWidthPercentage = maxWidthPercentage ?? 0.7,
        _maxHeightPercentage = maxHeightPercentage ?? 0.5;

  @override
  num getMaxWidth(num _, num viewportWidth) =>
      viewportWidth * _maxWidthPercentage;

  @override
  num getMaxHeight(num _, num viewportHeight) =>
      viewportHeight * _maxHeightPercentage;
}
