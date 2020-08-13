// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/src/laminate/popup/popup_source.dart';
import 'package:angular_components/laminate/ruler/dom_ruler.dart';

/// A handler to return the position and size of the *content* of [element].
///
/// If [track] is true, should observe the DOM for layout changes. This is used
/// to decouple [DomPopupSource] from the Ruler package.
typedef AsyncMeasureSize<E> = Stream<Rectangle> Function(E element,
    {bool track});

/// A factory that can [createPopupSource] from HTML elements.
@Injectable()
class DomPopupSourceFactory {
  final DomRuler _domRuler;

  DomPopupSourceFactory(this._domRuler);

  /// Returns a new [DomPopupSource] from [sourceElement].
  DomPopupSource createPopupSource(HtmlElement sourceElement,
      {Alignment alignOriginX = Alignment.Start,
      Alignment alignOriginY = Alignment.Start,
      bool initAriaAttributes = true}) {
    return DomPopupSource(_asyncMeasureSize, sourceElement,
        alignOriginX: alignOriginX,
        alignOriginY: alignOriginY,
        initAriaAttributes: initAriaAttributes);
  }

  /// Returns a stream of client sizes for [element], and offsets with the
  /// current scrolling position.
  ///
  /// If [track] is set, will wait for DOM update notifications and respond if
  /// the measurement changes.
  Stream<Rectangle> _asyncMeasureSize(HtmlElement element,
      {bool track = false}) {
    if (track) {
      return _domRuler.track(element);
    } else {
      return _domRuler.measure(element).asStream();
    }
  }
}

/// An implementation of [PopupSource] that lives on the UI layer.
class DomPopupSource implements ElementPopupSource {
  static final bool _isRtl = determineRtl(document);

  final AsyncMeasureSize<HtmlElement> _asyncMeasureSize;
  final HtmlElement sourceElement;
  final bool _initAriaAttributes;

  /// Creates a new source from a measure function and source DOM element.
  ///
  /// Setting [alignOriginX] and [alignOriginY] is used for calculating what
  /// the x and y position should be.
  ///
  /// [initAriaAttributes] decides whether to set the popup related aria
  /// attributes. This defaults to true and can be set to false for cases where
  /// the popup source isn't the focus target.
  DomPopupSource(this._asyncMeasureSize, this.sourceElement,
      {Alignment alignOriginX = Alignment.Start,
      Alignment alignOriginY = Alignment.Start,
      Point transform = const Point(0, 0),
      bool initAriaAttributes = true})
      : _initAriaAttributes = initAriaAttributes {
    _alignOriginX = alignOriginX;
    _alignOriginY = alignOriginY;
  }

  Alignment _alignOriginX;
  Alignment _alignOriginY;
  String _id;

  @override
  Alignment get alignOriginX => _alignOriginX;

  @override
  Alignment get alignOriginY => _alignOriginY;

  @override
  Stream<Rectangle<num>> onDimensionsChanged({bool track = false}) {
    return _asyncMeasureSize(sourceElement, track: track);
  }

  @override
  Rectangle get dimensions => sourceElement.getBoundingClientRect();

  @override
  bool get isRtl => _isRtl;

  @override
  set popupId(String id) {
    _id = id;
    if (_id == null || !_initAriaAttributes) return;
    sourceElement.setAttribute('aria-haspopup', 'true');
  }

  @override
  void focus() {
    sourceElement.focus();
  }

  @override
  String toString() =>
      'DomPopupSource ' +
      {'alignOriginX': alignOriginX, 'alignOriginY': alignOriginY}.toString();

  @override
  void onOpen() {
    if (_id == null || !_initAriaAttributes) return;
    sourceElement.setAttribute('aria-owns', _id);
  }

  @override
  void onClose() {
    if (_id == null || !_initAriaAttributes) return;
    sourceElement.attributes.remove('aria-owns');
  }
}
