// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart' hide Visibility;

import '../../../../css/acux/zindexer.dart';
import '../../../../utils/angular/imperative_view/imperative_view.dart';
import '../../../../utils/browser/dom_service/dom_service.dart';
import '../../../enums/visibility.dart';
import '../../../portal/portal.dart';
import '../../../ruler/dom_ruler.dart';
import '../overlay_state.dart';
import './overlay_style_config.dart';

/// An opaque token for the name of the overlay container, if any.
const overlayContainerName = const OpaqueToken('overlayContainerName');

/// An opaque token of the DOM element that is the container.
///
/// Example setup in your bootstrap function:
///     var overlayContainer = document.getElementById('overlay-container');
///     bootstrap(RootComponent, [
///       provide(overlayContainerToken, useValue: overlayContainer)
///     ]);
const overlayContainerToken = const OpaqueToken('overlayContainer');

/// Where [overlayContainerToken] should be created.
const overlayContainerParent = const OpaqueToken('overlayContainerParent');

/// Flag whether to use synchronous reads/writes instead of async.
///
/// The reason for this is that overlays are already in a position:absolute
/// layer in the DOM, and waiting for the next frame makes less sense and causes
/// latency issues.
const overlaySyncDom = const OpaqueToken('overlaySyncDom');

/// Flag whether to reposition popups on every frame when trackLayoutChanges is
/// true.
///
/// This allows popups to scroll with the page if the overlay container is not
/// part of the scrolling container.
const overlayRepositionLoop = const OpaqueToken('overlayRepositionLoop');

/// A DOM implementation of the components needed for [OverlayService].
///
/// In multi-threaded applications that use web workers, this will live on the
/// UI thread and use message passing with the application thread, where the
/// overlay service will live.
@Injectable()
class OverlayDomRenderService {
  static const _defaultConfig = const OverlayState();
  static const _paneClassName = 'pane';

  final HtmlElement containerElement;
  final String _containerName;
  final DomRuler _domRuler;
  final DomService _domService;
  final AcxImperativeViewUtils _imperativeViewUtils;
  final bool _useDomSynchronously;
  final bool _useRepositionLoop;
  final ZIndexer _zIndexer;

  /// Track the last z-index used by an overlay. When updating an overlay,
  /// we want to put it in front of anything else that might be using zIndexer,
  /// so we check the last value against _zIndexer.peek() and increment if
  /// necessary.
  int _lastZIndex;

  // An auto-incrementing value to help track what popups
  int _uniqueId = 0;

  OverlayDomRenderService(
      OverlayStyleConfig styleConfig,
      @Inject(overlayContainerToken) this.containerElement,
      @Inject(overlayContainerName) this._containerName,
      this._domRuler,
      this._domService,
      this._imperativeViewUtils,
      @Inject(overlaySyncDom) this._useDomSynchronously,
      @Inject(overlayRepositionLoop) this._useRepositionLoop,
      this._zIndexer) {
    containerElement.attributes['name'] = _containerName;
    styleConfig.registerStyles();
    _lastZIndex = _zIndexer.peek();
  }

  String _createUniqueId() => '$_containerName-${++_uniqueId}';

  /// An implementation of the typedef interface [AsyncApplyState].
  ///
  /// Converts [state] into a set of CSS property mutations on [pane], applying
  /// them in the next DOM write queue, and returning a future that completes
  /// after applied.
  Future applyState(OverlayState state, HtmlElement pane) async {
    if (!_useDomSynchronously) {
      return _domService.onWrite().then((_) {
        applyStateSync(state, pane);
      });
    } else {
      applyStateSync(state, pane);
    }
  }

  /// Like [applyState], but is done synchronously.
  void applyStateSync(OverlayState state, HtmlElement pane) {
    var cssClasses = <String>[];

    // Optionally, make the overlay "modal" style.
    if (state.captureEvents) {
      cssClasses.add('modal');
    }

    if (state.visibility == Visibility.Visible) cssClasses.add('visible');

    // Write to the DOM.
    _domRuler.updateSync(pane,
        cssClasses: cssClasses,
        width: state.width,
        height: state.height,
        top: state.top,
        left: state.left,
        bottom: state.bottom,
        right: state.right,
        visibility: state.visibility,
        position: state.position,
        useCssTransform: !_useRepositionLoop);

    // This is intentionally not in the ruler.
    if (state.minWidth != null) {
      pane.style.minWidth = '${state.minWidth}px';
    }
    if (state.zIndex != null) {
      pane.style.zIndex = '${state.zIndex}';
    }

    // If it exists, also update z-index of overlay container so it's on top of
    // any other zIndexer-using components
    if (pane.parent != null) {
      if (_lastZIndex != _zIndexer.peek()) {
        _lastZIndex = _zIndexer.pop();
      }
      _domRuler.updateSync(pane.parent, zIndex: _lastZIndex);
    }
  }

  /// An implementation of the typedef interface [AsyncMeasureSize].
  ///
  /// Returns a stream of size and position information on [pane]. If [track]
  /// is true, then listens for likely DOM reflows via [DomService] and dirty
  /// checks for updates, only firing an event on the stream if either the
  /// size or position has changed since the last event.
  ///
  /// If [sync] is true, then the size/position information is read
  /// synchronously and not part of the read/write queue. This helps performance
  /// but should only be used on elements that will not effect layout much such
  /// as overlays/popups.
  Stream<Rectangle> measureSize(HtmlElement pane,
      {bool track: false, bool sync: false}) {
    if (track) {
      return _domRuler.track(pane);
    } else {
      // TODO(google): It should be an actual stream that is updated whenever
      // the portal is changed, right?
      if (!sync) {
        return _domRuler.measure(pane).asStream();
      }
      return new Stream.fromIterable([_domRuler.measureSync(pane)]);
    }
  }

  /// Returns the current size of the overlay container.
  ///
  /// By default this is normally the viewport, but in some apps the container
  /// may be different dimensions (such as multiple apps alive at the same
  /// time).
  Future<Rectangle> measureContainer() {
    if (!_useDomSynchronously) {
      return _domService
          .onWrite()
          .then((_) => containerElement.getBoundingClientRect());
    } else {
      return new Future<Rectangle>.value(
          containerElement.getBoundingClientRect());
    }
  }

  /// Returns a future that completes with an overlay pane DOM element.
  ///
  /// The element is created and appended in the next DOM write queue.
  Future<HtmlElement> createOverlayPane([OverlayState state = _defaultConfig]) {
    // Create a detached DIV to use as the overlay host.
    HtmlElement pane = new DivElement()
      ..attributes['pane-id'] = _createUniqueId()
      ..classes.add(_paneClassName);

    // Depending on the initial positioning, size, and visibility, apply the
    // state properties to the detached element (we do not need to use a DOM
    // write queue because it is not attached).
    applyStateSync(state, pane);

    if (!_useDomSynchronously) {
      return _domService.onWrite().then((_) {
        containerElement.append(pane);
        return pane;
      });
    } else {
      containerElement.append(pane);
      return new Future.value(pane);
    }
  }

  /// Creates and returns an overlay pane DOM element.
  HtmlElement createOverlayPaneSync([OverlayState state = _defaultConfig]) {
    // Create a detached DIV to use as the overlay host.
    HtmlElement pane = new DivElement()
      ..attributes['pane-id'] = _createUniqueId()
      ..classes.add(_paneClassName);

    // Depending on the initial positioning, size, and visibility, apply the
    // state properties to the detached element (we do not need to use a DOM
    // write queue because it is not attached).
    applyStateSync(state, pane);
    containerElement.append(pane);
    return pane;
  }

  /// Creates a DOM-bound [PortalHost] with [hostContainer].
  PortalHost createPortalHost(HtmlElement hostContainer) {
    return new DomPortalHost(hostContainer, _imperativeViewUtils);
  }
}
