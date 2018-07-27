// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' show max;

import 'package:angular/angular.dart';
import 'package:js/js.dart' as js;
import 'package:angular_components/src/utils/angular/scroll_host/gestures.dart';
import 'package:angular_components/src/utils/angular/scroll_host/pan_controller_impl.dart';
import 'package:angular_components/src/utils/angular/scroll_host/position_sticky_controller.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_event_impl.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_interface.dart';
import 'package:angular_components/src/utils/angular/scroll_host/sticky_controller_impl.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart'
    as feature_detector;
import 'package:angular_components/utils/disposer/disposer.dart';

/// Base implementation of [ScrollHost] with common methods.
abstract class ScrollHostBase implements ScrollHost {
  final DomService _domService;
  final NgZone _ngZone;
  PanController _panController;
  StickyController _stickyController;
  GestureListener _gestureListener;

  final Map<Element, StreamController<IntersectionObserverEntry>>
      _intersectionStreams = {};
  IntersectionObserver _intersectionObserver;

  StreamController<ScrollHostEvent> _nativeOnScrollController;
  Disposer _elementListenersDisposer;
  StreamSubscription _nativeOnScrollSubscription;
  StreamController<ScrollHostEvent> _onScrollController;
  Stream<ScrollHostEvent> _onScrollStream;

  /// The total scrollable content height
  int get scrollHeight;

  /// The visible content height
  int get clientHeight;

  /// The visible content width
  int get clientWidth;

  /// The leftmost position
  num get offsetX;

  /// The topmost position
  num get offsetY;

  /// Whether to throttle scroll events to at most one event per frame.
  bool get throttleScrollEvents => true;

  /// Whether to use position: sticky and multithreaded scrolling.
  final bool usePositionSticky;

  /// The target of scroll events from the scrollbar.
  GlobalEventHandlers get scrollbarHost;

  ScrollHostBase(this._domService, this._ngZone,
      GestureListenerFactory gestureListenerFactory,
      {this.usePositionSticky = false}) {
    // TODO(google): add alternative impl based on TouchEvent.supported.
    _panController = NonTouchPanController(_ngZone, _domService, anchorElement);
    _stickyController = usePositionSticky
        ? PositionStickyController(this)
        : StickyControllerImpl(_domService, this);
    if (feature_detector.isTouchInterface) {
      _gestureListener =
          gestureListenerFactory.create(anchorElement, _isDirectionScrollable);
    }

    if (feature_detector.supportsIntersectionObserver) {
      var root = scrollbarHost is Element ? scrollbarHost : null;
      _intersectionObserver = IntersectionObserver(
          // allowInterop still required; otherwise this breaks under dart2js.
          js.allowInterop(_onIntersection),
          {'root': root});
    }
  }

  @override
  PanController get panController => _panController;

  @override
  StickyController get stickyController => _stickyController;

  /// The stream of ScrollHostEvents from [nativeOnScroll] after they have been
  /// handled, i.e. the content of the ScrollHost has been scrolled.
  @override
  Stream<ScrollHostEvent> get onScroll {
    if (_onScrollStream == null) {
      _onScrollController = StreamController.broadcast(
          onListen: startNativeScrollListener, sync: true);
      _onScrollStream = ZonedStream<ScrollHostEvent>(
          _onScrollController.stream, _ngZone.runOutsideAngular);
    }
    return _onScrollStream;
  }

  @override
  int get scrollLength => max(0, 1 + scrollHeight - clientHeight);

  @override
  Rectangle calcViewportRect() {
    return Rectangle(offsetX, offsetY, clientWidth, clientHeight);
  }

  @override
  void scrollWithDelta(int delta) {
    scrollToPosition(scrollPosition + delta);
  }

  @override
  void dispose() {
    _panController.dispose();
    _stickyController.dispose();
    _onScrollController?.close();
    if (_intersectionObserver != null) {
      _intersectionObserver.disconnect();
      for (var controller in _intersectionStreams.values) {
        controller.close();
      }
    }
    _stopNativeScrollListener();
  }

  @override
  void startNativeScrollListener() {
    _nativeOnScrollSubscription ??= nativeOnScroll.listen(_onNativeScroll);
  }

  bool _scrollInProgress = false;

  /// The stream of ScrollHostEvents before they have been handled to scroll the
  /// content of the ScrollHost.
  Stream<ScrollHostEvent> get nativeOnScroll {
    if (_nativeOnScrollController == null) {
      _nativeOnScrollController = StreamController<ScrollHostEvent>.broadcast(
          onListen: _startElementListeners, onCancel: _stopElementListeners);
    }

    return _nativeOnScrollController.stream;
  }

  bool _isDirectionScrollable(GestureDirection d) {
    switch (d) {
      case GestureDirection.up:
        return true;
      case GestureDirection.down:
        return true;
      default:
        return false;
    }
  }

  void _startElementListeners() {
    if (_elementListenersDisposer != null) return;
    _elementListenersDisposer = Disposer.oneShot();

    if (_gestureListener != null) {
      _elementListenersDisposer.addStreamSubscription(
          _gestureListener.scrollStream.listen((ScrollHostEvent event) {
        _nativeOnScrollController.add(event);
      }));
    }

    // Synchronous scrolling isn't necessary with position: sticky (the UI
    // doesn't jump around when position: sticky is used).
    if (!usePositionSticky) {
      _elementListenersDisposer.addStreamSubscription(
          anchorElement.onMouseWheel.listen((WheelEvent event) {
        // Ignore mouse wheel event if the CTRL key or SHIFT key is pressed.
        // This is consistent with other Google sites and ensures compatibility
        // with embedded APIs (e.g. Maps zooms the map when CTRL is pressed).
        if ((event?.ctrlKey ?? false) || (event?.shiftKey ?? false)) return;

        // [event.deltaY] is negated because [scrollDirection] treats the bottom
        // as the y-axis whereas [event] treats the top as the y-axis.
        var d = scrollDirection(event.deltaX, -event.deltaY);
        if (event.deltaY == 0 || !_isDirectionScrollable(d)) return;
        if (innerScrollableDirections(anchorElement, event.target)[d]) return;

        event.preventDefault();
        event.stopPropagation();
        // Firefox sends wheel events with [event.deltaMode] set to 1, meaning
        // [event.deltaY] uses 'lines' rather than pixels as a unit. There is no
        // correct way to covert lines to pixels, but 16 pixels/line is works
        // reasonably well.
        int pixelsPerDeltaUnit = event.deltaMode == 0 ? 1 : 16;
        int deltaYPixels = event.deltaY.toInt() * pixelsPerDeltaUnit;
        _nativeOnScrollController.add(ScrollHostEventImpl(0, deltaYPixels));
      }));
    }

    // Scroll events can come from the user interacting with the scrollbar,
    // using the mouse wheel, or can be fired by a call to [scrollWithDelta].
    // We use [_scrollInProgress] to ignore events fired by [scrollWithDelta],
    // preventing an infinite loop.
    _elementListenersDisposer
        .addStreamSubscription(scrollbarHost.onScroll.listen((Event event) {
      if (_scrollInProgress) {
        _scrollInProgress = false;
        return;
      }
      _nativeOnScrollController.add(ScrollHostEventImpl(0, 0));
    }));
  }

  void _stopElementListeners() {
    if (_nativeOnScrollController.hasListener) return;
    _elementListenersDisposer.dispose();
    _elementListenersDisposer = null;
  }

  bool _scrollFrameScheduled = false;
  int _scrollFrameDelta = 0;

  void _onNativeScroll(ScrollHostEvent event) {
    _scrollFrameDelta += event.deltaY ?? 0;
    if (_scrollFrameScheduled && throttleScrollEvents) return;
    _scrollFrameScheduled = true;
    window.requestAnimationFrame((_) {
      if (_scrollFrameDelta != 0) {
        _scrollInProgress = true;
        scrollWithDelta(_scrollFrameDelta);
      }
      stickyController.syncOnScroll();
      _onScrollController?.add(event);
      _scrollFrameScheduled = false;
      _scrollFrameDelta = 0;
    });
  }

  void _stopNativeScrollListener() {
    if (_nativeOnScrollSubscription != null) {
      _nativeOnScrollSubscription.cancel();
      _nativeOnScrollSubscription = null;
    }
  }

  void _onIntersection(Iterable entries, IntersectionObserver _observer) {
    for (IntersectionObserverEntry entry in entries) {
      _intersectionStreams[entry.target]?.add(entry);
    }
  }

  @override
  Stream<IntersectionObserverEntry> onIntersection(Element element) {
    assert(feature_detector.supportsIntersectionObserver);
    _intersectionStreams[element] ??=
        StreamController<IntersectionObserverEntry>.broadcast(
            onListen: () => _intersectionObserver.observe(element),
            onCancel: () => _intersectionObserver.unobserve(element),
            sync: true);
    return _intersectionStreams[element].stream;
  }
}

/// Default scroll host if nothing else specified: the window's content area.
class WindowScrollHostBase extends ScrollHostBase {
  final Window _window;

  WindowScrollHostBase(DomService domService, NgZone managedZone,
      GestureListenerFactory gestureListenerFactory, this._window)
      : super(domService, managedZone, gestureListenerFactory);

  @override
  GlobalEventHandlers get scrollbarHost => _window;

  @override
  int get scrollPosition => _window.scrollY;

  @override
  void scrollToPosition(int newPosition) {
    _window.scrollTo(_window.scrollX, newPosition);
  }

  @override
  int get scrollHeight {
    int bodyScrollHeight = 0;
    if (_window.document is HtmlDocument) {
      var htmlDoc = _window.document as HtmlDocument;
      bodyScrollHeight = htmlDoc.body.scrollHeight;
    }
    return max(bodyScrollHeight, _window.document.documentElement.scrollHeight);
  }

  @override
  int get clientHeight => _window.document.documentElement.clientHeight;

  @override
  int get clientWidth => _window.document.documentElement.clientWidth;

  @override
  final offsetX = 0;

  @override
  final offsetY = 0;

  @override
  Element get anchorElement => _window.document.documentElement;
}

class ElementScrollHostBase extends ScrollHostBase {
  final Element element;

  ElementScrollHostBase(DomService domService, NgZone managedZone,
      GestureListenerFactory gestureListenerFactory, this.element,
      {bool usePositionSticky = false})
      : super(domService, managedZone, gestureListenerFactory,
            usePositionSticky: usePositionSticky) {
    element.style.overflowY = 'auto';

    if (usePositionSticky) {
      // Moves the container to a separate render layer (for multithreaded
      // scrolling) and establishes a containing block for position: sticky.
      element.style.transform = 'translateZ(0)';
    }
  }

  @override
  GlobalEventHandlers get scrollbarHost => element;

  @override
  int get scrollPosition => element.scrollTop;

  @override
  void scrollToPosition(int newPosition) {
    element.scrollTop = newPosition;
  }

  @override
  int get scrollHeight => element.scrollHeight;

  @override
  int get clientHeight => element.clientHeight;

  @override
  int get clientWidth => element.clientWidth;

  @override
  num get offsetX => element.getBoundingClientRect().left;

  @override
  num get offsetY => element.getBoundingClientRect().top;

  @override
  Element get anchorElement => element;

  @override
  bool _isDirectionScrollable(GestureDirection d) {
    switch (d) {
      case GestureDirection.up:
        return scrollPosition > 0;
      case GestureDirection.down:
        return scrollHeight > scrollPosition + clientHeight;
      default:
        return false;
    }
  }
}

/// Base class to implement the dynamic class setter that follows the current
/// pan state.
class BasePanClassDirective {
  final DomService _domService;
  final ScrollHost _scrollHost;
  final Element _element;

  PanEvent _lastEvent = PanEventImpl(false, false, false, false);
  String _className;
  StreamSubscription _subscription;

  BasePanClassDirective(this._domService, this._scrollHost, this._element);

  set className(String value) {
    // assuming that the bound value does not change over time
    assert((_className == null) || (_className == value));
    _className = value;
  }

  void startPanListener() {
    if (_subscription != null) return;
    _subscription = _scrollHost.panController.onPan.listen((PanEvent event) {
      _updateClass(_lastEvent.isTop, event.isTop, '-top');
      _updateClass(_lastEvent.isRight, event.isRight, '-right');
      _updateClass(_lastEvent.isBottom, event.isBottom, '-bottom');
      _updateClass(_lastEvent.isLeft, event.isLeft, '-left');
      _lastEvent = event;
    });
  }

  void stopPanListener() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  _updateClass(bool prevValue, bool newValue, String suffix) {
    if (prevValue == newValue) return;
    if (prevValue) {
      _domService.scheduleWrite(() {
        _element.classes.remove(_className + suffix);
      });
    } else if (newValue) {
      _domService.scheduleWrite(() {
        _element.classes.add(_className + suffix);
      });
    }
  }
}
