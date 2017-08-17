// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';

import '../../../components/annotations/rtl_annotation.dart';
import '../../enums/alignment.dart';
import '../../ruler/dom_ruler.dart';
import './popup_source.dart';

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
  DomPopupSource createPopupSource(HtmlElement sourceElement,
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
  Stream<Rectangle> _asyncMeasureSize(HtmlElement element,
      {bool track: false}) {
    if (track) {
      return _domRuler.track(element);
    } else {
      return _domRuler.measure(element).asStream();
    }
  }
}

/// An implementation of [PopupSource] that lives on the UI layer.
class DomPopupSource implements PopupSource {
  static final bool _isRtl = determineRtl(document);

  final AsyncMeasureSize<HtmlElement> _asyncMeasureSize;
  final HtmlElement _sourceElement;

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
  Rectangle get dimensions => _sourceElement.getBoundingClientRect();

  @override
  bool get isRtl => _isRtl;

  @override
  set popupId(String id) {
    if (id == null) return;
    _sourceElement
      ..setAttribute('aria-owns', id)
      ..setAttribute('aria-haspopup', 'true');
  }

  @override
  String toString() =>
      'DomPopupSource ' +
      {'alignOriginX': alignOriginX, 'alignOriginY': alignOriginY}.toString();
}
