// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/src/laminate/popup/popup_size_provider.dart';

class PopupPosition {
  static const String AUTO = '';
  static const String ABOVE = 'above';
  static const String BELOW = 'below';
}

/// Assistant for supporting custom preferred popup positions.
class PopupPositionMixin implements PopupSizeProvider {
  /// Space to leave between the popup and the edge of the viewport.
  static const _EDGE_SPACE_PX = 4;

  /// Minimum height for the popup.
  static const _MIN_HEIGHT_PX = 40;

  PopupSizeProvider delegatePopupSizeProvider = PercentagePopupSizeProvider();

  @override
  num getMinWidth(num positionX, num viewportWidth) =>
      delegatePopupSizeProvider.getMinWidth(positionX, viewportWidth);

  @override
  num getMinHeight(num positionY, num viewportHeight) =>
      delegatePopupSizeProvider.getMinHeight(positionY, viewportHeight);

  @override
  num getMaxWidth(num positionX, num viewportWidth) =>
      delegatePopupSizeProvider.getMaxHeight(positionX, viewportWidth);

  @override
  num getMaxHeight(num positionY, num viewportHeight) {
    var maxHeight =
        delegatePopupSizeProvider.getMaxHeight(positionY, viewportHeight);
    if (_popupPosition == PopupPosition.BELOW) {
      // Prevent popup content from going off the bottom of the visible
      // viewport.
      return max(_MIN_HEIGHT_PX,
          min(viewportHeight - positionY - _EDGE_SPACE_PX, maxHeight));
    } else {
      return maxHeight;
    }
  }

  String _popupPosition = PopupPosition.AUTO;

  List<RelativePosition> _popupPositions = const [];

  List<RelativePosition> get popupPositions => _popupPositions;

  /// Position relative to popup source.
  /// Optional, defaults to PopupPosition.AUTO.
  @Input()
  set popupPosition(String position) {
    _popupPosition = position;
    switch (_popupPosition) {
      case PopupPosition.ABOVE:
        _popupPositions = const [
          RelativePosition.AdjacentTopLeft,
          RelativePosition.AdjacentTopRight
        ];
        break;
      case PopupPosition.BELOW:
        _popupPositions = const [
          RelativePosition.AdjacentBottomLeft,
          RelativePosition.AdjacentBottomRight
        ];
        break;
      case PopupPosition.AUTO:
      default:
        _popupPositions = const [];
    }
  }
}
