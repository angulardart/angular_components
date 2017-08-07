// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';

import '../../utils/browser/dom_service/dom_service.dart';
import 'src/ruler_interface.dart';

/// An implementation of ruler that uses raw DOM access and [Element]s.
///
/// Angular components should *not* import and use this class. See [NgRuler].
///
/// In multi-threaded applications, the [DomRuler] will live on the UI thread
/// and use message passing with the application thread and [NgRuler].
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
  Stream get onLayoutChanged => _domService.onLayoutChanged;

  @override
  Future onRead() => _domService.onRead();

  @override
  Future onWrite() => _domService.onWrite();

  @override
  Future<Rectangle> measure(Element element, {bool offset: false}) {
    if (canSyncWrite(element)) {
      // It is not possible to measure something not in the live DOM.
      // throw new StateError('Element is not in the live DOM document.');
      return new Future<Rectangle>.value(const Rectangle(0, 0, 0, 0));
    }
    return super.measure(element, offset: offset);
  }

  @override
  Rectangle measureSync(Element element, {bool offset: false}) {
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
      return new Stream<Rectangle>.fromIterable(
          const [const Rectangle(0, 0, 0, 0)]);
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
  void setCssPropertySync(Element element, String propertyName, propertyValue) {
    element.style.setProperty(propertyName, propertyValue);
  }
}
