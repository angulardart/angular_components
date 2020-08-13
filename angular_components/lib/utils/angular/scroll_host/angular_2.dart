// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/utils/angular/scroll_host/interface.dart';
import 'package:angular_components/src/utils/angular/scroll_host/gestures.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_base.dart';
import 'package:angular_components/src/utils/angular/scroll_host/scroll_host_interface.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';

export 'package:angular_components/src/utils/angular/scroll_host/scroll_host_interface.dart'
    show ScrollHost;

const clockValue = Clock();

const scrollHostProviders = <Provider>[
  ClassProvider(ScrollHost, useClass: WindowScrollHost),
  ValueProvider(Clock, clockValue),
  ClassProvider(GestureListenerFactory),
];
@Deprecated('Use [scrollHostProviders] or [scrollHostNewModule]')
const scrollHostModule = scrollHostProviders;

const scrollHostNewModule = Module(
  provide: scrollHostProviders,
);

/// Provides a scroll host that is restricted within the content area of
/// a specific element.
@Directive(
  selector: '[acxScrollHost]',
  providers: [
    ExistingProvider(ScrollHost, ElementScrollHost),
    ValueProvider(Clock, clockValue),
    GestureListenerFactory,
  ],
  exportAs: 'acxScrollHost',
  visibility: Visibility.all, // injected
)
class ElementScrollHost implements OnInit, OnDestroy, ElementScrollHostBase {
  final DomService _domService;
  final NgZone _ngZone;
  final HtmlElement element;
  final GestureListenerFactory _gestureListenerFactory;

  // This is sync to reduce the time between StickyController writing to the
  // DOM and clients writing to the DOM, making scrolling smoother.
  final StreamController<Null> _onUpdate =
      StreamController.broadcast(sync: true);

  ElementScrollHostBase _scrollHost;

  bool _disableAutoScroll;
  bool _usePositionSticky = false;
  bool _useTouchGestureListener = true;
  bool _enableSmoothPushing = false;

  ElementScrollHost(this._domService, this._ngZone,
      this._gestureListenerFactory, this.element);

  @override
  void ngOnInit() {
    _init();
  }

  void _init() {
    _scrollHost?.dispose();
    _scrollHost = ElementScrollHostBase(
        _domService, _ngZone, _gestureListenerFactory, element,
        usePositionSticky: _usePositionSticky,
        useTouchGestureListener: _useTouchGestureListener);
    stickyController.enableSmoothPushing = _enableSmoothPushing;

    if (!_usePositionSticky) {
      _onUpdate.addStream(stickyController.onUpdate);
    }
  }

  /// If true, forces a vertical scrollbar to appear even if the contents are
  /// not long enough to normally trigger a scrollbar.
  ///
  /// Works by setting `overflow-y` to `scroll` on the attached element.
  /// If false, `overflow-y` is set to `auto`.
  ///
  /// This avoids a re-layout in cases where the content of the scroll area is
  /// loaded dynamically, thus improving performance slightly.
  @Input()
  set disableAutoScroll(bool value) {
    if (value != _disableAutoScroll) {
      _disableAutoScroll = value;
      _domService.scheduleWrite(() {
        element.style.overflowY = value ? 'scroll' : 'auto';
      });
    }
  }

  /// If enabled, smoothly push colliding elements which share a stickyKey,
  /// instead of overlapping them (limitations apply).
  ///
  /// Limitations are:
  ///
  /// - The behavior is unspecified when elements with differing stickyKeys are
  ///   interleaved. It should only be enabled when using one stickyKey.
  ///
  /// - Ignored if [usePositionSticky] is true.
  @Input()
  set enableSmoothPushing(bool value) {
    _enableSmoothPushing = value;
    stickyController?.enableSmoothPushing = value;
  }

  /// Whether to use the position: sticky [StickyController] for improved
  /// scrolling performance.
  @Input()
  set usePositionSticky(bool value) {
    _usePositionSticky = value;
    if (_scrollHost != null) {
      _init();
    }
  }

  /// Whether to use [GestureListener] to override the native browser smooth
  /// scrolling on touch devices.
  ///
  /// This is required to enable smooth scrolling for any components which
  /// handle scrolling themselves, e.g. horizontal scrolling in the Material
  /// Table.
  ///
  /// Note: because the listener tries to replicate native browser scrolling
  /// mechanics, it won't precisely match whichever platform the code is
  /// running on and may feel slightly unusual.
  @Input()
  set useTouchGestureListener(bool value) {
    _useTouchGestureListener = value;
    if (_scrollHost != null) {
      _init();
    }
  }

  /// Fires an event immediately after [StickyController] updates the DOM.
  ///
  /// The intended use case is to allow manually positioning elements relative
  /// to stuck elements, with reasonable efficiency. Do note that reading the
  /// DOM during a listener may cause an extra reflow, as the event is fired
  /// immediately after reading and then writing to the DOM (during a
  /// requestAnimationFrame triggered by a scroll event).
  ///
  /// Not supported if [usePositionSticky] is true.
  ///
  /// While this is an @Output() to provide flexibility, note that subscribing
  /// via the template adds some overhead.
  @Output()
  Stream<Null> get onUpdate => _onUpdate.stream;

  @override
  void dispose() {
    _scrollHost?.dispose();
    _onUpdate.close();
  }

  @override
  Rectangle calcViewportRect() => _scrollHost.calcViewportRect();

  @override
  void scrollToPosition(int position) =>
      _scrollHost?.scrollToPosition(position);

  @override
  void scrollWithDelta(int delta) => _scrollHost?.scrollWithDelta(delta);

  @override
  void startNativeScrollListener() => _scrollHost.startNativeScrollListener();

  @override
  int get scrollHeight => _scrollHost.scrollHeight;

  @override
  int get clientHeight => _scrollHost.clientHeight;

  @override
  Stream<ScrollHostEvent> get nativeOnScroll => _scrollHost.nativeOnScroll;

  @override
  bool get usePositionSticky => _scrollHost.usePositionSticky;

  @override
  bool get useTouchGestureListener => _scrollHost.useTouchGestureListener;

  @override
  bool get throttleScrollEvents => _scrollHost.throttleScrollEvents;

  @override
  GlobalEventHandlers get scrollbarHost => _scrollHost.scrollbarHost;

  @override
  int get clientWidth => _scrollHost.clientWidth;

  @override
  num get offsetX => _scrollHost.offsetX;

  @override
  num get offsetY => _scrollHost.offsetY;

  @override
  Element get anchorElement => _scrollHost.anchorElement;

  @override
  Stream<ScrollHostEvent> get onScroll => _scrollHost.onScroll;

  @override
  PanController get panController => _scrollHost.panController;

  @override
  StickyController get stickyController => _scrollHost?.stickyController;

  @override
  int get scrollLength => _scrollHost.scrollLength;

  @override
  int get scrollPosition => _scrollHost.scrollPosition;

  @override
  Stream<IntersectionObserverEntry> onIntersection(Element element) =>
      _scrollHost.onIntersection(element);

  @override
  void ngOnDestroy() {
    dispose();
  }

  @override
  void stopEvent(WheelEvent event) => _scrollHost.stopEvent(event);
}

/// Provides a scroll host that uses the browser window content area.
@Injectable()
class WindowScrollHost extends WindowScrollHostBase implements OnDestroy {
  WindowScrollHost(DomService domService, NgZone ngZone,
      GestureListenerFactory gestureListenerFactory, Window window)
      : super(domService, ngZone, gestureListenerFactory, window);

  @override
  ngOnDestroy() {
    dispose();
  }
}

/// A directive to track already sticking Elements on the page (e.g. one that
/// has position fixed).
///
/// The sticky controller will respect their position and
/// will put the other sticky headers and footers below or above them.
@Directive(
  selector: '[acxStickyFloating]',
)
class StickyFloatingTracker implements OnInit, OnDestroy {
  final ScrollHost _scrollHost;
  final Element _element;

  StickyFloatingTracker(this._scrollHost, this._element);

  @override
  void ngOnInit() {
    _scrollHost.stickyController.trackFloating(_element);
  }

  @override
  void ngOnDestroy() {
    _scrollHost.stickyController.untrackFloating(_element);
  }
}

/// A directive to dynamically set a class based on the pan state.
///
/// Example use:
///
///     <some-element acxPanClass="'pan-style'" ...
///
/// The directive will add -top, -right, -bottom and -left suffix to the style
/// name, adding and removing it in a dom write callback.
/// E.g. in the example above, if the panning is top-left, both the
/// `pan-style-top` and the `pan-style-left` styles names will be set.
@Directive(
  selector: '[acxPanClass]',
)
class AcxPanClassDirective extends BasePanClassDirective
    implements OnInit, OnDestroy {
  AcxPanClassDirective(
      DomService domService, ScrollHost scrollHost, HtmlElement element)
      : super(domService, scrollHost, element);

  @override
  void ngOnInit() => startPanListener();

  @override
  void ngOnDestroy() => stopPanListener();

  // Overridden to add Input annotation and keep angular2 dep outside of base
  // class.
  @override
  @Input('acxPanClass')
  set className(String value) => super.className = value;
}

/// A directive to sticky an Element.
///
/// Example use:
///
///     <div [acxStickyElement]="endsticky">
///       Your awesome content
///     </div>
///     Other awesome content
///     <div #endsticky></div> <!-- Where sticky should end -->
///
/// Note that adding the acxStickyElement to an element that has ngIf has been
/// known to not work correctly. Suggestion is to have the ngIf and
/// acxStickyElements on different html elements (i.e., add an extra outer div
/// for the ngIf).
@Directive(
  selector: '[acxStickyElement]',
)
class StickyElementDirective implements AfterViewInit, OnDestroy {
  final Element _stickyElement;
  final ScrollHost _scrollHost;
  Element _endElement;
  String _stickyClass;
  String _stickyKey;
  bool _sticky = true;
  StickyPosition _position = StickyPosition.TOP;

  StickyElementDirective(this._scrollHost, this._stickyElement);

  /// The end element that determines the range of the sticky element.
  @Input('acxStickyElement')
  set endElement(Element element) {
    _endElement = element;
  }

  /// Optional css class to use when element is stuck.
  @Input('stickyClass')
  set stickyClass(String stickyClass) {
    _stickyClass = stickyClass;
  }

  /// If [stickyKey] is provided, then only the last (when [position] is top)
  /// or the first (when [position] is bottom) sticky element with the same
  /// [stickyKey] will be stuck.
  @Input('stickyKey')
  set stickyKey(String stickyKey) {
    _stickyKey = stickyKey;
  }

  /// Whether to stick the element.
  ///
  /// This allows the directive to be used for components in which the
  /// the sticky property is optional and dependent on input.
  @Input('sticky')
  set sticky(bool sticky) {
    _sticky = sticky;
    if (_sticky) {
      _stick();
    } else {
      _unstick();
    }
  }

  /// Whether element should stick to top or bottom of sticky range.
  ///
  /// Default is [StickyPosition.TOP].
  @Input('stickyPosition')
  set position(StickyPosition position) {
    _position = position;
  }

  @override
  void ngAfterViewInit() {
    if (_sticky) _stick();
  }

  @override
  void ngOnDestroy() {
    if (_sticky) _unstick();
  }

  void _stick() {
    _stickyController?.stick(_stickyElement, _position, _endElement,
        stickyClass: _stickyClass, stickyKey: _stickyKey);
  }

  void _unstick() {
    _stickyController?.unstick(_stickyElement);
  }

  StickyController get _stickyController => _scrollHost.stickyController;
}
