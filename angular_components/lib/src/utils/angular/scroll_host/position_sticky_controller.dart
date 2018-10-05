// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:quiver/core.dart';
import 'package:angular_components/utils/angular/scroll_host/interface.dart';
import 'package:angular_components/utils/browser/events/events.dart'
    show compareDocumentPosition;
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart'
    as feature_detector;

/// A [StickyController] implementation based on position: sticky.
///
/// This implementation performs better than the [StickyController]
/// implementation that repositions elements on scroll, but requires browser
/// support for position: sticky (https://caniuse.com/#feat=css-sticky).
///
/// Limitations:
///
/// - [range] not implemented (it's implicit based on the containing block).
/// - [stickyClass] is always applied (not just when the element is fixed) if
///   IntersectionObserver is not supported.
/// - [trackFloating] / [untrackFloating] not implemented.
/// - [onUpdate] not implemented (will throw an exception if called)
class PositionStickyController implements StickyController {
  final ScrollHost _scrollHost;
  final _stickyElements = <_StickyElement>[];

  @override
  final bool usePositionSticky = true;

  PositionStickyController(this._scrollHost);

  @override
  void stick(Element element, StickyPosition position, Element range,
      {String stickyClass, String stickyKey}) {
    final stickyElement =
        _StickyElement(element, position, range, stickyClass, stickyKey);
    if (_stickyElements.contains(stickyElement)) return;

    // Prevent the element from appearing in the layout more than once.
    _stickyElements
        .removeWhere((stickyElement) => element == stickyElement.element);

    _stickyElements.add(stickyElement);
    _scheduleUpdate();
  }

  @override
  void unstick(Element element) {
    _StickyElement stickyElement;
    for (var e in _stickyElements) {
      if (element == e.element) {
        stickyElement = e;
        break;
      }
    }
    if (stickyElement == null) return;
    _stickyElements.remove(stickyElement);
    _removeStickyStyle(stickyElement);
    _scheduleUpdate();
  }

  @override
  void syncOnScroll() {
    // no op
  }

  @override
  void trackFloating(Element element) {
    // not implemented
  }

  @override
  void untrackFloating(Element element) {
    // not implemented
  }

  @override
  Stream<Null> get onUpdate =>
      throw UnsupportedError('PositionStickyController.onUpdate');

  @override
  bool get enableSmoothPushing => false;

  @override
  set enableSmoothPushing(bool _) {
    // not implemented
  }

  @override
  void dispose() {
    for (var stickyElement in _stickyElements) {
      _removeStickyStyle(stickyElement);
    }
    _stickyElements.clear();
  }

  bool _isUpdateScheduled = false;

  void _scheduleUpdate() {
    if (_isUpdateScheduled) return;
    _isUpdateScheduled = true;
    window.requestAnimationFrame((_) {
      _isUpdateScheduled = false;
      _update();
    });
  }

  void _addStickyStyle(_StickyElement stickyElement, String positionProperty,
      num zIndex, num offset) {
    stickyElement.element.style
      ..position = 'sticky'
      ..zIndex = '${zIndex}';
    stickyElement.element.style.setProperty(positionProperty, '${offset}px');

    if (stickyElement.stickyClass != null) {
      if (feature_detector.supportsIntersectionObserver) {
        if (stickyElement.intersectionSubscription == null) {
          _startIntersectionSubscription(stickyElement);
        }
        // + 1px wasn't enough to trigger an intersection.
        stickyElement.intersectionElement.style
            .setProperty(positionProperty, '${-(offset + 2)}px');
      } else {
        stickyElement.element.classes.add(stickyElement.stickyClass);
      }
    }
  }

  void _removeStickyStyle(_StickyElement stickyElement) {
    stickyElement.element.style
      ..position = ''
      ..zIndex = ''
      ..top = ''
      ..bottom = '';

    if (stickyElement.stickyClass != null) {
      stickyElement.element.classes.remove(stickyElement.stickyClass);
      if (stickyElement.intersectionSubscription != null) {
        _stopIntersectionSubscription(stickyElement);
      }
    }
  }

  void _startIntersectionSubscription(_StickyElement stickyElement) {
    assert(stickyElement.intersectionElement == null);
    assert(stickyElement.intersectionSubscription == null);

    // Create an invisible element to monitor for intersection with the
    // edge of the scroll host. The invisible element is positioned relative to
    // the sticky element with an offset opposite of the sticky element's
    // offset.
    stickyElement.intersectionElement = DivElement()
      ..style.width = '0px'
      ..style.height = '1px'
      ..style.position = 'absolute';
    stickyElement.element.append(stickyElement.intersectionElement);

    // This way the element will intersect with the edge of the scroll host at
    // the moment the sticky element becomes stuck (or unstuck).
    stickyElement.intersectionSubscription = _scrollHost
        .onIntersection(stickyElement.intersectionElement)
        .listen((e) {
      if (e.intersectionRect.height > 0) {
        stickyElement.element.classes.remove(stickyElement.stickyClass);
      } else {
        stickyElement.element.classes.add(stickyElement.stickyClass);
      }
    });
  }

  void _stopIntersectionSubscription(_StickyElement stickyElement) {
    stickyElement.intersectionSubscription.cancel();
    stickyElement.intersectionElement.remove();
    stickyElement.intersectionSubscription = null;
    stickyElement.intersectionElement = null;
  }

  void _update() {
    var topElements =
        _stickyElements.where((e) => e.position == StickyPosition.TOP).toList();
    var bottomElements = _stickyElements
        .where((e) => e.position == StickyPosition.BOTTOM)
        .toList();
    int zIndex = _updateLayout(topElements, 1, 'top', stickyControllerZIndex);
    // The elements stuck to the bottom should be positioned above the ones
    // stuck to the top.
    _updateLayout(bottomElements, -1, 'bottom', zIndex);
  }

  int _updateLayout(List<_StickyElement> elements, int sortOrder,
      String positionProperty, int startZIndex) {
    // Create a list of sticky elements and corresponding client rect, sorted by
    // the element's position in the document tree.
    var elementsAndRects =
        elements.map((e) => [e, e.element.getBoundingClientRect()]).toList();
    elementsAndRects.sort((a, b) {
      _StickyElement elementA = a[0];
      _StickyElement elementB = b[0];
      return sortOrder *
          compareDocumentPosition(elementA.element, elementB.element);
    });

    Map<String, num> stickyKeyOffsets = {};
    num offset = 0;
    num zIndex = startZIndex;
    for (var item in elementsAndRects) {
      _StickyElement stickyElement = item[0];
      Rectangle rect = item[1];
      if (stickyElement.stickyKey != null) {
        // All elements with the same stickyKey receive the same offset so that
        // they stack on top of each other.
        if (stickyKeyOffsets[stickyElement.stickyKey] == null) {
          stickyKeyOffsets[stickyElement.stickyKey] = offset;
          offset += rect.height;
        }
        _addStickyStyle(stickyElement, positionProperty, zIndex,
            stickyKeyOffsets[stickyElement.stickyKey]);
      } else {
        _addStickyStyle(stickyElement, positionProperty, zIndex, offset);
        offset += rect.height;
      }
      zIndex++;
    }
    return zIndex;
  }
}

class _StickyElement {
  final Element element;
  final StickyPosition position;
  final Element range;
  final String stickyClass;
  final String stickyKey;

  Element intersectionElement;
  StreamSubscription<IntersectionObserverEntry> intersectionSubscription;

  _StickyElement(this.element, this.position, this.range, this.stickyClass,
      this.stickyKey);

  @override
  bool operator ==(Object other) {
    if (other is! _StickyElement) return false;
    _StickyElement o = other;
    return this.element == o.element &&
        this.position == o.position &&
        this.range == o.range &&
        this.stickyClass == o.stickyClass &&
        this.stickyKey == o.stickyKey;
  }

  @override
  int get hashCode =>
      hashObjects([element, position, range, stickyClass, stickyKey]);
}
