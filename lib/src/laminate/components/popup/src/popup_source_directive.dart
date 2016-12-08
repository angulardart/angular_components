// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.components.popup.src.popup_source_directive;

import 'dart:async';
import 'dart:math';

import 'package:angular2/angular2.dart';

import '../../../enums/alignment.dart';
import '../../../popup/popup.dart'
    show DomPopupSourceFactory, PopupSource;
import '../../../../utils/async/async.dart';

/// A directive that exposes the [PopupSource] interface as `popupSource`:
///
/// Example of use:
///     <div popupSource
///          alignPositionX="alignX"
///          alignPositionY="alignY"
///          #source="popupSource">
///     </div>
///     <popup [source]="source"></popup>
@Directive(selector: '[popupSource]', exportAs: 'popupSource')
class PopupSourceDirective implements PopupSource, OnInit {
  final DomPopupSourceFactory _domPopupSourceFactory;
  final ElementRef _elementRef;

  AsyncUpdateScheduler _asyncScheduler;
  Alignment _alignOriginX = Alignment.Start;
  Alignment _alignOriginY = Alignment.Start;
  PopupSource _delegatePopupSource;

  PopupSourceDirective(this._domPopupSourceFactory, this._elementRef) {
    _asyncScheduler = new AsyncUpdateScheduler(_updateSource);
  }

  @override
  Alignment get alignOriginX => _alignOriginX;

  @Input()
  set alignPositionX(String alignPositionX) {
    _alignOriginX = new Alignment.parse(alignPositionX);
    _asyncScheduler.scheduleUpdate();
  }

  @override
  Alignment get alignOriginY => _alignOriginY;

  @Input()
  set alignPositionY(String alignPositionY) {
    _alignOriginY = new Alignment.parse(alignPositionY);
    _asyncScheduler.scheduleUpdate();
  }

  @override
  Stream<Rectangle> onDimensionsChanged({bool track: false}) {
    return _delegatePopupSource.onDimensionsChanged(track: track);
  }

  void _updateSource() {
    _delegatePopupSource = _domPopupSourceFactory.create(
        _elementRef.nativeElement,
        alignOriginX: _alignOriginX,
        alignOriginY: _alignOriginY);
  }

  @override
  void ngOnInit() {
    _asyncScheduler.scheduleUpdate();
  }
}
