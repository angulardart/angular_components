// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_source;

import 'dart:async';
import 'dart:math';

import '../../enums/alignment.dart';
import 'package:angular2/angular2.dart';

/// The source of where a popup will be created from.
///
/// In most cases, this will be the origin of a user action like a click or
/// hover. However, it may also be a defined static location or an associated
/// component or element.
abstract class PopupSource {
  /// Create a [PopupSource] from a predefined location ([rectangle]).
  factory PopupSource.fromRectangle(Rectangle rectangle,
      {Alignment alignX: Alignment.Start, Alignment alignY: Alignment.Start}) {
    return new _RectanglePopupSource(rectangle,
        alignOriginX: alignX, alignOriginY: alignY);
  }

  /// What point of the origin to use on the x-axis.
  ///
  /// In most implementations:
  /// - [Alignment.start] == clientRect.left
  /// - [Alignment.center] == clientRect.left + clientRect.width / 2
  /// - [Alignment.end] == clientRect.left + clientRect.width
  ///
  /// Changing this value will fire a new event on [measure]
  Alignment get alignOriginX;

  /// What point of the origin to use on the y-axis.
  ///
  /// In most implementations:
  /// - [Alignment.start] == clientRect.top
  /// - [Alignment.center] == clientRect.top + clientRect.height / 2
  /// - [Alignment.end] == clientRect.top + clientRect.height
  ///
  /// Changing this value will fire a new event on [measure].
  Alignment get alignOriginY;

  /// Returns a stream that has events with the dimensions of a DOM element that
  /// the popup is positioned relatively to.
  ///
  /// It is guaranteed to return at least a single event, the current position.
  ///
  /// If [track] is true, then the DOM is observed for any possible layout
  /// changes. This has some performance impact. See [DomService]. If [track]
  /// is false, the stream will only update when [alignOriginX] or
  /// [alignOriginY] change.
  Stream<Rectangle> onDimensionsChanged({bool track: false});
}

/// An [PopupSource] that's based on an element.
abstract class ElementPopupSource implements PopupSource {
  ElementRef get sourceElement;
}

/// An immutable [PopupSource] implementation based on a predefined polygon.
class _RectanglePopupSource implements PopupSource {
  @override
  final Alignment alignOriginX;

  @override
  final Alignment alignOriginY;

  final Rectangle _predefinedRectangle;

  _RectanglePopupSource(this._predefinedRectangle,
      {this.alignOriginX, this.alignOriginY});

  @override
  Stream<Rectangle> onDimensionsChanged({bool track: false}) {
    // Track is ignored for this type, as it's assumed that the Rectangle is
    // immutable. If in the future we have an ObservableRectangle, then track
    // can be supported.
    return new Stream<Rectangle>.fromIterable([this._predefinedRectangle]);
  }
}
