// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/src/laminate/popup/popup_size_provider.dart';

/// Directive to provide maximum and minimum sizes to a popup from html.
///
/// Example usage (somefile.html):
/// <my-popup-using-component popupMaxHeight="400px" popupMaxWidth="40%">
/// </my-popup-using-component>
///
/// If a maximum or minimum size is not specified, it delegates to parent popup
/// size provider.
@Directive(
  selector: '[popupMinHeight],[popupMinWidth],[popupMaxHeight],[popupMaxWidth]',
  providers: [
    ClassProvider(PopupSizeProvider, useClass: PopupSizeProviderDirective),
  ],
)
class PopupSizeProviderDirective implements PopupSizeProvider {
  _SizeDefinition _minHeight;
  _SizeDefinition _minWidth;
  _SizeDefinition _maxHeight;
  _SizeDefinition _maxWidth;
  PopupSizeProvider _parentPopupSizeProvider;

  PopupSizeProviderDirective(
      @Attribute('popupMinHeight') String minHeight,
      @Attribute('popupMinWidth') String minWidth,
      @Attribute('popupMaxHeight') String maxHeight,
      @Attribute('popupMaxWidth') String maxWidth,
      @Optional() @SkipSelf() this._parentPopupSizeProvider) {
    _minHeight =
        minHeight == null ? null : _SizeDefinition.fromString(minHeight);
    _minWidth = minWidth == null ? null : _SizeDefinition.fromString(minWidth);
    _maxHeight =
        maxHeight == null ? null : _SizeDefinition.fromString(maxHeight);
    _maxWidth = maxWidth == null ? null : _SizeDefinition.fromString(maxWidth);

    // Define a reasonable default if for some reason a parent
    // PopupSizeProvider is not injected.
    if ((_minHeight == null ||
            _minWidth == null ||
            _maxHeight == null ||
            _maxWidth == null) &&
        _parentPopupSizeProvider == null) {
      _parentPopupSizeProvider = PercentagePopupSizeProvider(0.7, 0.5);
    }
  }

  @override
  num getMinWidth(num positionX, num viewportWidth) => _minWidth == null
      ? _parentPopupSizeProvider.getMinWidth(positionX, viewportWidth)
      : _minWidth.getPixels(viewportWidth);

  @override
  num getMinHeight(num positionY, num viewportHeight) => _minHeight == null
      ? _parentPopupSizeProvider.getMinHeight(positionY, viewportHeight)
      : _minHeight.getPixels(viewportHeight);

  @override
  num getMaxWidth(num positionX, num viewportWidth) => _maxWidth == null
      ? _parentPopupSizeProvider.getMaxWidth(positionX, viewportWidth)
      : _maxWidth.getPixels(viewportWidth);

  @override
  num getMaxHeight(num positionY, num viewportHeight) => _maxHeight == null
      ? _parentPopupSizeProvider.getMaxHeight(positionY, viewportHeight)
      : _maxHeight.getPixels(viewportHeight);
}

/// Defines a size in any unit and computes in pixels.
abstract class _SizeDefinition {
  static final RegExp _parseAttribute = RegExp(r'([\d.]+)\s*([^\d\s]+)');

  /// Create from an attribute string.
  ///
  /// [attribute] should be in the format <num><unit>.  i.e: "100px" or "70%".
  factory _SizeDefinition.fromString(String attribute) {
    var match = _parseAttribute.firstMatch(attribute);
    if (match == null) throw StateError('Invalid size string: $attribute');
    num size = num.parse(match.group(1));
    var unit = match.group(2).toLowerCase();
    switch (unit) {
      case 'px':
        return _PixelSizeDefinition(size);
      case '%':
        return _PercentSizeDefinition(size);
      default:
        throw StateError('Invalid unit for size string: $attribute');
    }
  }

  num getPixels(num viewportSize);
}

class _PixelSizeDefinition implements _SizeDefinition {
  final num _size;
  const _PixelSizeDefinition(this._size);
  @override
  num getPixels(num viewportSize) => _size;
}

class _PercentSizeDefinition implements _SizeDefinition {
  final num _percent;
  const _PercentSizeDefinition(this._percent);
  @override
  num getPixels(num viewportSize) => viewportSize * _percent / 100;
}

/// Applies a [WithinViewportPopupSizeProvider] to the attached element and
/// its descendants.
@Directive(selector: '[popupWithinViewport]', providers: [
  ClassProvider(PopupSizeProvider, useClass: WithinViewportPopupSizeProvider)
])
class PopupWithinViewportDirective {}
