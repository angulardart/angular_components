// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.dom_popup_source;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular2/angular2.dart';

import '../../enums/alignment.dart';
import './popup_source.dart';
import '../../ruler/dom_ruler.dart';

/// A handler to return the position and size of the *content* of [element].
///
/// If [track] is true, should observe the DOM for layout changes. This is used
/// to decouple [DomPopupSource] from the Ruler package.
typedef Stream<Rectangle> AsyncMeasureSize<E>(E element, {bool track});

/// A factory that can [createPopupSource] from HTML elements.
@Injectable()
class DomPopupSourceFactory {
  final Window _window;
  final DomRuler _domRuler;

  DomPopupSourceFactory(this._window, this._domRuler);

  /// Returns a new [DomPopupSource] from [sourceElement].
  DomPopupSource create(Element sourceElement,
      {Alignment alignOriginX: Alignment.Start,
      Alignment alignOriginY: Alignment.Start}) {
    return new DomPopupSource(_asyncMeasureSize, sourceElement,
        alignOriginX: alignOriginX, alignOriginY: alignOriginY);
  }

  /// Returns a stream of client sizes for [element], and offsets with the
  /// current scrolling position.
  ///
  /// If [track] is set, will wait for DOM update notifications and respond if
  /// the measurement changes.
  Stream<Rectangle> _asyncMeasureSize(Element element, {bool track: false}) {
    if (track) {
      return _domRuler.track(element).map(_withOffset);
    } else {
      return _domRuler.measure(element).asStream().map(_withOffset);
    }
  }

  /// Offsets [clientRect] with the current scrolling position.
  Rectangle _withOffset(Rectangle clientRect) {
    // TODO(google): Consider using ScrollHost instead.
    return new Rectangle(_window.scrollX + clientRect.left,
        _window.scrollY + clientRect.top, clientRect.width, clientRect.height);
  }
}

/// An implementation of [PopupSource] that lives on the UI layer.
class DomPopupSource implements PopupSource {
  final AsyncMeasureSize<Element> _asyncMeasureSize;
  final Element _sourceElement;

  /// Creates a new source from a measure function and source DOM element.
  ///
  /// Setting [alignOriginX] and [alignOriginY] is used for calculating what
  /// the x and y position should be.
  DomPopupSource(this._asyncMeasureSize, this._sourceElement,
      {Alignment alignOriginX: Alignment.Start,
      Alignment alignOriginY: Alignment.Start,
      Point transform: const Point(0, 0)}) {
    _alignOriginX = alignOriginX;
    _alignOriginY = alignOriginY;
  }

  Alignment _alignOriginX;
  Alignment _alignOriginY;

  @override
  Alignment get alignOriginX => _alignOriginX;

  @override
  Alignment get alignOriginY => _alignOriginY;

  @override
  Stream<Rectangle<num>> onDimensionsChanged({bool track: false}) {
    return _asyncMeasureSize(_sourceElement, track: track);
  }

  @override
  String toString() =>
      'DomPopupSource ' +
      {'alignOriginX': alignOriginX, 'alignOriginY': alignOriginY}.toString();
}
