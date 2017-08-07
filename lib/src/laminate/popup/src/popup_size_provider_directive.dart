// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import './popup_size_provider.dart';

/// Directive to provide maximum sizes to a popup from html.
///
/// Example usage (somefile.html):
/// <my-popup-using-component popupMaxHeight="400px" popupMaxWidth="40%">
/// </my-popup-using-component>
///
/// If popupMaxHeight or popupMaxWidth is not specified, delegates to parent
/// popup provider.
@Directive(selector: '[popupMaxHeight],[popupMaxWidth]', providers: const [
  const Provider(PopupSizeProvider, useClass: PopupSizeProviderDirective),
])
class PopupSizeProviderDirective implements PopupSizeProvider {
  _SizeDefinition _maxHeight;
  _SizeDefinition _maxWidth;
  PopupSizeProvider _parentPopupSizeProvider;

  PopupSizeProviderDirective(
      @Attribute('popupMaxHeight') maxHeight,
      @Attribute('popupMaxWidth') maxWidth,
      @Optional() @SkipSelf() this._parentPopupSizeProvider) {
    _maxHeight =
        maxHeight == null ? null : new _SizeDefinition.fromString(maxHeight);
    _maxWidth =
        maxWidth == null ? null : new _SizeDefinition.fromString(maxWidth);

    // Define a reasonable default if for some reason a parent
    // PopupSizeProvider is not injected.
    if ((_maxHeight == null || _maxWidth == null) &&
        _parentPopupSizeProvider == null) {
      _parentPopupSizeProvider = new PercentagePopupSizeProvider(0.7, 0.5);
    }
  }

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
  static final RegExp _parseAttribute = new RegExp(r'([\d.]+)\s*([^\d\s]+)');

  /// Create from an attribute string.
  ///
  /// [attribute] should be in the format <num><unit>.  i.e: "100px" or "70%".
  factory _SizeDefinition.fromString(String attribute) {
    var match = _parseAttribute.firstMatch(attribute);
    if (match == null) throw new StateError('Invalid size string: $attribute');
    num size = num.parse(match.group(1));
    var unit = match.group(2).toLowerCase();
    switch (unit) {
      case 'px':
        return new _PixelSizeDefinition(size);
      case '%':
        return new _PercentSizeDefinition(size);
      default:
        throw new StateError('Invalid unit for size string: $attribute');
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
