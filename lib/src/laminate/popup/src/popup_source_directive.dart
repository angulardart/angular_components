// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components.laminate.popup.src.popup_source_directive;

import 'dart:async';
import 'dart:math';

import 'package:angular2/angular2.dart';

import '../../../utils/angular/reference/reference.dart';
import '../../enums/alignment.dart';
import './dom_popup_source.dart';
import './popup_source.dart';

/// A directive that exposes the [PopupSource] interface as `popupSource`:
///
/// Example of use:
///     <div popupSource
///          alignPositionX="alignX"
///          alignPositionY="alignY"
///          #source="popupSource">
///     </div>
///     <template popup [relativeTo]="source"></template>
@Directive(
    selector: '[popupSource]',
    inputs: const ['alignX: alignPositionX', 'alignY: alignPositionY'],
    exportAs: 'popupSource')
// TODO(google): Deprecate use of `relativeTo` with an Element, use instead.
// TODO(google): Move the setting of alignOriginX and Y into DomPopupSource.
class PopupSourceDirective
    implements ElementPopupSource, AfterViewInit, OnDestroy {
  final DomPopupSourceFactory _domPopupSourceFactory;
  ElementRef _elementRef;
  ReferenceDirective _referenceDirective;

  Alignment _alignOriginX = Alignment.Start;
  Alignment _alignOriginY = Alignment.Start;

  PopupSource _popupSource;

  PopupSourceDirective(this._domPopupSourceFactory, this._elementRef,
      @Optional() this._referenceDirective);

  @override
  ngOnDestroy() {
    _elementRef = null;
    _popupSource = null;
    _referenceDirective = null;
  }

  @override
  void ngAfterViewInit() {
    // We have to wait until the view is inited to have elementRef
    _elementRef = _referenceDirective?.elementRef ?? _elementRef;
    _updateSource();
  }

  @override
  ElementRef get sourceElement => _elementRef;

  @override
  Alignment get alignOriginX => _popupSource.alignOriginX;

  set alignX(String align) {
    _alignOriginX = new Alignment.parse(align);
    _updateSource();
  }

  @override
  Alignment get alignOriginY => _popupSource.alignOriginY;

  set alignY(String align) {
    _alignOriginY = new Alignment.parse(align);
    _updateSource();
  }

  @override
  Stream<Rectangle<num>> onDimensionsChanged({bool track: false}) {
    return _popupSource.onDimensionsChanged(track: track).distinct();
  }

  @override
  bool get isRtl => _popupSource.isRtl;

  void _updateSource() {
    _popupSource = _domPopupSourceFactory.create(
      _elementRef.nativeElement,
      alignOriginX: _alignOriginX,
      alignOriginY: _alignOriginY,
    );
  }
}
