// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/src/laminate/popup/dom_popup_source.dart';
import 'package:angular_components/src/laminate/popup/popup_source.dart';
import 'package:angular_components/utils/angular/reference/reference.dart';

/// A directive that exposes the [PopupSource] interface as `popupSource`:
///
/// Example of use:
///     <div popupSource
///          alignPositionX="alignX"
///          alignPositionY="alignY"
///          #source="popupSource">
///     </div>
///     <template popup [relativeTo]="source"></template>
@Directive(selector: '[popupSource]', exportAs: 'popupSource')
// TODO(google): Deprecate use of `relativeTo` with an Element, use instead.
// TODO(google): Move the setting of alignOriginX and Y into DomPopupSource.
class PopupSourceDirective
    implements ElementPopupSource, AfterViewInit, OnDestroy {
  final DomPopupSourceFactory _domPopupSourceFactory;
  HtmlElement _element;
  ReferenceDirective _referenceDirective;

  Alignment _alignOriginX = Alignment.Start;
  Alignment _alignOriginY = Alignment.Start;

  PopupSource _popupSource;
  String _popupId;

  PopupSourceDirective(this._domPopupSourceFactory, this._element,
      @Optional() this._referenceDirective);

  @override
  ngOnDestroy() {
    _element = null;
    _popupSource = null;
    _referenceDirective = null;
  }

  @override
  void ngAfterViewInit() {
    // We have to wait until the view is inited to have elementRef
    _element = _referenceDirective?.elementRef?.nativeElement ?? _element;
    _updateSource();
  }

  @override
  HtmlElement get sourceElement => _element;

  @override
  Alignment get alignOriginX => _popupSource.alignOriginX;

  @Input('alignPositionX')
  set alignX(String align) {
    _alignOriginX = new Alignment.parse(align);
    _updateSource();
  }

  @override
  Alignment get alignOriginY => _popupSource.alignOriginY;

  @Input('alignPositionY')
  set alignY(String align) {
    _alignOriginY = new Alignment.parse(align);
    _updateSource();
  }

  @override
  Stream<Rectangle<num>> onDimensionsChanged({bool track: false}) {
    return _popupSource.onDimensionsChanged(track: track).distinct();
  }

  @override
  Rectangle get dimensions => _popupSource?.dimensions;

  @override
  bool get isRtl => _popupSource.isRtl;

  @override
  set popupId(String id) {
    _popupId = id;
    _popupSource?.popupId = id;
  }

  void _updateSource() {
    _popupSource = _domPopupSourceFactory.createPopupSource(
      _element,
      alignOriginX: _alignOriginX,
      alignOriginY: _alignOriginY,
    );

    if (_popupId != null) {
      _popupSource.popupId = _popupId;
    }
  }
}
