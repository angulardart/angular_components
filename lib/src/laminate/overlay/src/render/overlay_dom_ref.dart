// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.overlay.src.render.overlay_dom_ref;

import 'dart:async';
import 'dart:html';

import '../overlay_ref.dart';
import '../overlay_state.dart';
import '../../../portal/portal.dart';

/// An implementation of [OverlayRef] that uses a DOM [HtmlElement] as a container.
class OverlayDomRef extends BaseOverlayRef<HtmlElement> {
  OverlayDomRef(
      AsyncApplyState<HtmlElement> asyncApplyState,
      AsyncMeasureSize<HtmlElement> asyncMeasureSize,
      PortalHost delegatePortalHost,
      HtmlElement elementRef,
      Function runOutsideAngular,
      {OverlayState state})
      : super(asyncApplyState, asyncMeasureSize, delegatePortalHost, elementRef,
            runOutsideAngular, state);

  @override
  void dispose() {
    elementRef.remove();
    super.dispose();
  }

  @override
  Stream<MouseEvent> get onPanePressed => elementRef.onMouseDown;

  @override
  String get uniqueId => elementRef.attributes['pane-id'];
}
