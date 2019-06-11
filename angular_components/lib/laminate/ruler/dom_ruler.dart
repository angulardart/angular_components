// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/src/laminate/ruler/ruler_interface.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// Measures and tracks size changes for HTML elements in Dart web applications.
@Injectable()
abstract class DomRuler implements Ruler<Element> {
  factory DomRuler(Document document, DomService domService) = DomRulerImpl;
}

/// Actual implementation.
@Injectable()
class DomRulerImpl extends RulerBase<Element> implements DomRuler {
  final Document _document;
  final DomService _domService;

  DomRulerImpl(this._document, this._domService);

  @override
  bool canSyncWrite(Element element) {
    if (_document is HtmlDocument) {
      return !(_document as HtmlDocument).body.contains(element);
    }
    return !_document.contains(element);
  }

  @override
  Stream<DomService> get onLayoutChanged => _domService.onLayoutChanged;

  @override
  Future<void> onRead() => _domService.onRead();

  @override
  Future<void> onWrite() => _domService.onWrite();

  @override
  Future<Rectangle> measure(Element element, {bool offset = false}) {
    if (canSyncWrite(element)) {
      // It is not possible to measure something not in the live DOM.
      // throw new StateError('Element is not in the live DOM document.');
      return Future<Rectangle>.value(const Rectangle(0, 0, 0, 0));
    }
    return super.measure(element, offset: offset);
  }

  @override
  Rectangle measureSync(Element element, {bool offset = false}) {
    // Purposefully don't use a 'canSyncWrite' here because some places in the
    // code will want a synchronous write regardless (e.g. overlays).
    if (offset) {
      return element.offset;
    }
    return element.getBoundingClientRect();
  }

  @override
  Stream<Rectangle> track(Element element) {
    if (canSyncWrite(element)) {
      // It is not possible to measure something not in the live DOM.
      // throw new StateError('Element is not in the live DOM document.');
      return Stream<Rectangle>.fromIterable(const [Rectangle(0, 0, 0, 0)]);
    }
    return super.track(element);
  }

  @override
  void removeCssClassesSync(Element element, List<String> classes) {
    element.classes.removeAll(classes.where((c) => c.isNotEmpty));
  }

  @override
  void addCssClassesSync(Element element, List<String> classes) {
    element.classes.addAll(classes.where((c) => c.isNotEmpty));
  }

  @override
  void clearCssPropertiesSync(Element element) {
    element.style.cssText = '';
  }

  @override
  void setCssPropertySync(
      Element element, String propertyName, String propertyValue) {
    element.style.setProperty(propertyName, propertyValue);
  }
}
