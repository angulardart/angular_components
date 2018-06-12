// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:angular/angular.dart' hide Visibility;
import 'package:angular_components/laminate/enums/position.dart';
import 'package:angular_components/laminate/enums/visibility.dart';
import 'package:angular_components/laminate/ruler/dom_ruler.dart';
import 'package:angular_components/src/laminate/ruler/ruler_interface.dart';

/// An implementation of ruler that works on Angular [ElementRef] objects.
@Deprecated('Use DomRuler instead. ElementRef is deprecated.')
@Injectable()
class NgRuler implements Ruler<ElementRef> {
  // TODO(google): Deprecate doing this when web workers introduced.
  final DomRuler _domRuler;

  NgRuler(this._domRuler);

  @override
  Future<Rectangle> measure(ElementRef elementRef, {bool offset = false}) {
    return _domRuler.measure(elementRef.nativeElement, offset: offset);
  }

  @override
  Stream<Rectangle> track(ElementRef elementRef) {
    return _domRuler.track(elementRef.nativeElement);
  }

  @override
  Future<void> update(ElementRef elementRef,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true}) {
    return _domRuler.update(elementRef.nativeElement,
        cssClasses: cssClasses,
        visibility: visibility,
        position: position,
        width: width,
        height: height,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        zIndex: zIndex,
        useCssTransform: useCssTransform);
  }

  @override
  void updateSync(ElementRef elementRef,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true}) {
    return _domRuler.updateSync(elementRef.nativeElement,
        cssClasses: cssClasses,
        visibility: visibility,
        position: position,
        width: width,
        height: height,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        zIndex: zIndex,
        useCssTransform: useCssTransform);
  }

  @override
  Rectangle measureSync(ElementRef element, {bool offset = false}) {
    return _domRuler.measureSync(element.nativeElement, offset: offset);
  }
}
