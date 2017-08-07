// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

import './overlay_ref.dart';
import './overlay_state.dart';
import 'render/overlay_dom_render_service.dart';

/// A low-level service which exists to be able to manage the overlay
/// container and overlay panes.
@Injectable()
class OverlayService {
  /// Creates an overlay pane within the registered container.
  ///
  /// If [initialState] is specified, configuration for the overlay is setup on
  /// creation, versus waiting for the future to resolve. [initialState] may
  /// also be a [MutableOverlayState], in which case it is not copied, but used
  /// as the state instance.
  ///
  /// The returned future completes with a reference to the pane.
  Future<OverlayRef> createOverlayRef(
      [OverlayState initialState = _defaultState]) async {
    HtmlElement pane = await _renderService.createOverlayPane(initialState);
    return _createRef(pane, initialState);
  }

  /// Creates a overlay pane within the registered container.
  ///
  /// Returns with a reference to the pane.
  OverlayRef createOverlayRefSync([OverlayState initialState = _defaultState]) {
    HtmlElement pane = _renderService.createOverlayPaneSync(initialState);
    return _createRef(pane, initialState);
  }

  /// Returns the current size of the overlay container.
  ///
  /// By default this is normally the viewport, but in some apps the container
  /// may be different dimensions (such as multiple apps alive at the same
  /// time).
  Future<Rectangle<num>> measureContainer() =>
      _renderService.measureContainer();

  static const _defaultState = const OverlayState();
  static final _logger = new Logger('OverlayService');

  final bool _useDomSynchronously;
  final NgZone _ngZone;
  final OverlayDomRenderService _renderService;

  OverlayRef _createRef(HtmlElement pane, OverlayState state) => new OverlayRef(
      _renderService.applyState,
      _measurePane,
      _renderService.createPortalHost(pane),
      _renderService.containerElement,
      pane,
      _ngZone.runOutsideAngular,
      state: state);

  // Depending on client flags, either measure sync or async.
  Stream<Rectangle<num>> _measurePane(HtmlElement pane, {bool track: false}) {
    return _renderService.measureSize(pane,
        track: track, sync: _useDomSynchronously);
  }

  OverlayService(
      this._ngZone,
      @Inject(overlaySyncDom) this._useDomSynchronously,
      this._renderService,
      @SkipSelf() @Optional() OverlayService existingInstance) {
    assert(() {
      // Overlay service should not be injected if it is already available
      if (existingInstance != null) {
        _logger.severe('OverlayService must be a singleton: '
            'Check that there is no nested overlayBindings or popupBindings');
      }
      return true;
    });
  }
}
