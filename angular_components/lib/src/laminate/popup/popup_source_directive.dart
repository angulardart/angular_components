// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_interface.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/src/laminate/popup/dom_popup_source.dart';
import 'package:angular_components/src/laminate/popup/popup_source.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/angular/reference/reference.dart';

/// A directive that exposes the [PopupSource] interface as `popupSource`.
@Directive(
  selector: '[popupSource]',
  exportAs: 'popupSource',
)
// TODO(google): Deprecate use of `relativeTo` with an Element, use instead.
// TODO(google): Move the setting of alignOriginX and Y into DomPopupSource.
class PopupSourceDirective
    implements ElementPopupSource, AfterViewInit, OnDestroy {
  final DomPopupSourceFactory _domPopupSourceFactory;
  final bool _initAriaAttributes;
  HtmlElement _element;
  ReferenceDirective _referenceDirective;
  Focusable _focusable;

  Alignment _alignOriginX = Alignment.Start;
  Alignment _alignOriginY = Alignment.Start;

  PopupSource _popupSource;
  String _popupId;

  /// [initPopupAriaAttributes] is an attribute input that decide whether to
  /// set the popup related aria attributes. This defaults to true and can be
  /// set to false for cases where the popup source isn't the focus target.
  PopupSourceDirective(
      this._domPopupSourceFactory,
      this._element,
      @Optional() this._referenceDirective,
      @Optional() this._focusable,
      @Attribute('initPopupAriaAttributes') String initAriaAttributes)
      : _initAriaAttributes =
            attributeToBool(initAriaAttributes, defaultValue: true);

  @override
  ngOnDestroy() {
    _element = null;
    _popupSource = null;
    _referenceDirective = null;
    _focusable = null;
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

  /// Alignment of the popup in the horizontal direction.
  ///
  /// Possible values are:
  /// - `start`: Align popup to the start of a container. This is equivalent
  ///   to 'flex-start'. (Default)
  /// - `center`: Align popup to the center of a container. This is equivalent
  ///   to 'center'.
  /// - `end`: Align popup to the end of a container. This is equivalent to
  ///   'flex-end'.
  /// - `before`: Align popup before a container. This is *not* equivalent to
  ///   any CSS positioning model.
  /// - `after`: Align popup after a container. This is *not* equivalent to
  ///   any CSS positioning model.
  @Input('alignPositionX')
  set alignX(String align) {
    _alignOriginX = Alignment.parse(align);
    _updateSource();
  }

  @override
  Alignment get alignOriginY => _popupSource.alignOriginY;

  /// Alignment of the popup in the vertical direction.
  ///
  /// Possible values are:
  /// - `start`: Align popup to the start of a container. This is equivalent
  ///   to 'flex-start'. (Default)
  /// - `center`: Align popup to the center of a container. This is equivalent
  ///   to 'center'.
  /// - `end`: Align popup to the end of a container. This is equivalent to
  ///   'flex-end'.
  /// - `before`: Align popup before a container. This is *not* equivalent to
  ///   any CSS positioning model.
  /// - `after`: Align popup after a container. This is *not* equivalent to
  ///   any CSS positioning model.
  @Input('alignPositionY')
  set alignY(String align) {
    _alignOriginY = Alignment.parse(align);
    _updateSource();
  }

  @override
  Stream<Rectangle<num>> onDimensionsChanged({bool track = false}) {
    return _popupSource?.onDimensionsChanged(track: track)?.distinct();
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
    _popupSource = _domPopupSourceFactory.createPopupSource(_element,
        alignOriginX: _alignOriginX,
        alignOriginY: _alignOriginY,
        initAriaAttributes: _initAriaAttributes);

    if (_popupId != null) {
      _popupSource.popupId = _popupId;
    }
  }

  @override
  void focus() {
    if (_focusable != null) {
      _focusable.focus();
    } else {
      _element?.focus();
    }
  }

  @override
  void onOpen() {
    _popupSource?.onOpen();
  }

  @override
  void onClose() {
    _popupSource?.onClose();
  }
}
