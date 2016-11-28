// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.overlay.src.overlay_dom_service;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import './overlay_ref.dart';
import './overlay_service.dart';
import './overlay_state.dart';
import 'render/overlay_dom_ref.dart';
import 'render/overlay_dom_render_service.dart';
import 'package:angular2/angular2.dart'
    show Inject, Injectable, NgZone, SkipSelf, Optional;
import 'package:logging/logging.dart';

// This file exists, versus putting everything in overlay_service.dart, to avoid
// having dart:html references in the core interfaces, something that will be
// necessary to have web worker support (overlay_dom_render_service uses the
// direct DOM API).

/// A temporary implementation of [OverlayService] that just delegates to the
/// DOM rendering service. In the future, it will use message passing.
@Injectable()
class OverlayDomService implements OverlayService {
  static const _defaultState = const OverlayState();
  static final _logger = new Logger('OverlayDomService');

  final bool _useDomSynchronously;
  final NgZone _ngZone;
  final OverlayDomRenderService _renderService;

  OverlayDomService(
      this._ngZone,
      @Inject(overlaySyncDom) this._useDomSynchronously,
      this._renderService,
      @SkipSelf() @Optional() OverlayService existingInstance) {
    assert(() {
      // Overlay service should not be injected if it is already available
      if (existingInstance != null) {
        _logger.severe('OverlayDomService must be a singleton: '
            'Check that there is no nested overlayBindings or popupBindings');
      }
      return true;
    });
  }

  @override
  Future<OverlayRef> create([OverlayState initialState = _defaultState]) async {
    HtmlElement pane = await _renderService.createOverlayPane(initialState);
    return _createRef(pane, initialState);
  }

  @override
  OverlayRef createSync([OverlayState initialState = _defaultState]) {
    HtmlElement pane = _renderService.createOverlayPaneSync(initialState);
    return _createRef(pane, initialState);
  }

  OverlayDomRef _createRef(HtmlElement pane, OverlayState state) {
    // TODO(google): Consider either passing ngZone directly, or making sure
    // that DomService is safe. Need to think about approach further.
    return new OverlayDomRef(_renderService.applyState, _measurePane,
        _renderService.createPortalHost(pane), pane, _ngZone.runOutsideAngular,
        state: state);
  }

  @override
  Future<Rectangle<num>> measureContainer() =>
      _renderService.measureContainer();

  // Depending on client flags, either measure sync or async.
  Stream<Rectangle<num>> _measurePane(HtmlElement pane, {bool track: false}) {
    return _renderService.measureSize(pane,
        track: track, sync: _useDomSynchronously);
  }
}
