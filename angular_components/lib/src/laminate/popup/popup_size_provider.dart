// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A handler that provides max width and max height of a popup based on its
/// position and the current viewport size.
abstract class PopupSizeProvider {
  /// The min width.
  ///
  /// Returns null if min width is not specified.
  num getMinWidth(num positionX, num viewportWidth);

  /// The min height.
  ///
  /// Returns null if min height is not specified.
  num getMinHeight(num positionY, num viewportHeight);

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
  final num _minWidthPercentage;
  final num _minHeightPercentage;

  final num _maxWidthPercentage;
  final num _maxHeightPercentage;

  const PercentagePopupSizeProvider(
      [num maxWidthPercentage,
      num maxHeightPercentage,
      num minWidthPercentage,
      num minHeightPercentage])
      : _minWidthPercentage = minWidthPercentage,
        _minHeightPercentage = minHeightPercentage,
        _maxWidthPercentage = maxWidthPercentage ?? 0.7,
        _maxHeightPercentage = maxHeightPercentage ?? 0.5;

  @override
  num getMinHeight(num positionY, num viewportHeight) =>
      _minHeightPercentage == null
          ? null
          : viewportHeight * _minHeightPercentage;

  @override
  num getMinWidth(num positionX, num viewportWidth) =>
      _minWidthPercentage == null ? null : viewportWidth * _minWidthPercentage;

  @override
  num getMaxWidth(num _, num viewportWidth) =>
      viewportWidth * _maxWidthPercentage;

  @override
  num getMaxHeight(num _, num viewportHeight) =>
      viewportHeight * _maxHeightPercentage;
}

/// Constrains popups to fit within the viewport's bottom and right edges.
///
/// This assumes that the position of the popup source does not change, and is
/// intended for use in cases where the popup source is not within a scrollable
/// area. Since it controls only the size and not the position, it works best
/// for popups that open to the bottom and right of the anchor.
class WithinViewportPopupSizeProvider implements PopupSizeProvider {
  static const _paddingPixels = 8;

  @override
  num getMaxHeight(num positionY, num viewportHeight) =>
      viewportHeight - positionY - _paddingPixels;

  @override
  num getMaxWidth(num positionX, num viewportWidth) =>
      viewportWidth - positionX - _paddingPixels;

  @override
  num getMinHeight(num positionY, num viewportHeight) => null;

  @override
  num getMinWidth(num positionX, num viewportWidth) => null;
}

/// Provides a popup size with a fixed maximum width and height in pixels.
///
/// A null value for max width or max height indicates no limit.
class FixedPopupSizeProvider implements PopupSizeProvider {
  final num _minWidth;
  final num _minHeight;
  final num _maxWidth;
  final num _maxHeight;

  const FixedPopupSizeProvider(
      {num minWidth, num minHeight, num maxWidth, num maxHeight})
      : this._minWidth = minWidth,
        this._minHeight = minHeight,
        this._maxWidth = maxWidth,
        this._maxHeight = maxHeight;

  @override
  num getMinWidth(num _, num __) => _minWidth;

  @override
  num getMinHeight(num _, num __) => _minHeight;

  @override
  num getMaxWidth(num _, num __) => _maxWidth;

  @override
  num getMaxHeight(num _, num __) => _maxHeight;
}

/// A popup size provider of no maximum size.
const unboundedPopupSize = FixedPopupSizeProvider();
