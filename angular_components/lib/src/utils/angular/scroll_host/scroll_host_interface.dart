// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// The object that gets sent on scroll events.
abstract class ScrollHostEvent {
  /// Change in the host's content's horizontal position associated with this
  /// event, in pixels.
  int get deltaX;

  /// Change in the host's content's vertical position associated with this
  /// event, in pixels.
  int get deltaY;
}

/// Provides access to a scrollbar, its size and their change events.
///
/// Interacting with the scroll container, or reading values from it may cause
/// reflows, and should be done only in batched read and write cycles (e.g.
/// Angular's domRead, or DomService's layout check and update callbacks.
abstract class ScrollHost implements Disposable {
  /// The total scrollable length.
  ///
  /// Calling this may cause reflow, and should be done only in a batched
  /// domRead block or DomService's layout check.
  int get scrollLength;

  /// The current position (>=0, < scrollLength)
  ///
  /// Calling this may cause reflow, and should be done only in a batched
  /// domRead block or DomService's layout check.
  int get scrollPosition;

  /// The stream of scroll events.
  ///
  /// The event stream is running outside of the Angular zone, making it cheap
  /// to consume. If you need to trigger change detection, inject
  /// [ChangeDetectorRef] and [NgZone] and call
  /// [ChangeDetectorRef.markForCheck()] inside [NgZone.run()].
  Stream<ScrollHostEvent> get onScroll;

  /// Start intercepting events that would cause scrolling.
  ///
  /// If [onScroll] is listened to, calling this is unnecessary. Some
  /// implementations may also not require calling this.
  void startNativeScrollListener() {}

  /// Scrolls the scrollbar into the new position.
  ///
  /// Calling this may cause reflow, and should be done only in a batched
  /// domWrite block or DomService's updateLayout callbacks.
  void scrollToPosition(int newPosition);

  /// Scrolls the scrollbar with the given delta.
  ///
  /// Calling this may cause reflow, and should be done only in a batched
  /// domWrite block or DomService's updateLayout callbacks.
  void scrollWithDelta(int delta);

  /// Returns absolute positions of the visible frame.
  ///
  /// Calling this may cause reflow, and should be done only in a batched
  /// domRead block or DomService's layout check.
  Rectangle calcViewportRect();

  /// Returns anchor element for hosting virtual horizontal scrollbar.
  Element get anchorElement;

  /// Gets the pan controller for the given scroll host.
  PanController get panController;

  /// Gets the sticky controller for the given scroll host.
  StickyController get stickyController;

  /// A stream which fires when [element] intersects with the scroll viewport.
  ///
  /// NOTE: This requires
  /// [IntersectionObserver](caniuse.com/intersectionobserver). Check
  /// [supportsIntersectionObserver] from feature_detector.dart before using.
  Stream<IntersectionObserverEntry> onIntersection(Element element);

  /// Stop an event.
  // When listening from the document body the event cannot be prevented.
  @protected
  void stopEvent(WheelEvent event);
}

/// The position  of the sticky row.
enum StickyPosition { NONE, TOP, BOTTOM }

/// Coordinates sticky headers and footers, handles their appearance and their
/// in- and out animation.
abstract class StickyController implements Disposable {
  /// Registers the [element] for sticking to the [position] (top or bottom),
  /// while the given reference element ([range]) is in the opposite side of
  /// the scroll container host.
  ///
  /// If [range] is null, then the element will stick until [unstick] is called,
  /// which is useful if the desired [range] element is lazily created.
  ///
  /// If [stickyKey] is provided, then only the last (when [position] is top)
  /// or the first (when [position] is bottom) sticky element with the same
  /// [stickyKey] will be stuck.
  void stick(Element element, StickyPosition position, Element range,
      {String stickyClass, String stickyKey});

  /// Unregisters the element from sticking.
  void unstick(Element element);

  /// Called by the [ScrollHost] during the scroll animation, to reposition
  /// sticky elements.
  void syncOnScroll();

  /// Register the tracking of the [element] that is already floating in the
  /// visual range of the scroll host.
  /// Sticky rows will be placed below or above of such elements.
  void trackFloating(Element element);

  /// Unregisters the tracking of a floating [element].
  void untrackFloating(Element element);

  /// Fires an event immediately after this [StickyController] updates the DOM.
  ///
  /// The intended use case is to allow manually positioning elements relative
  /// to stuck elements, with reasonable efficiency. Do note that reading the
  /// DOM during a listener may cause an extra reflow, as the event is fired
  /// immediately after reading and then writing to the DOM (during a
  /// requestAnimationFrame triggered by a scroll event).
  ///
  /// Not supported if [usePositionSticky] is true.
  // TODO(google): Compute and pass updated position information to the
  // callback, to avoid implementations needing to read the DOM.
  Stream<Null> get onUpdate;

  /// Clears resources.
  @override
  void dispose();

  /// Whether the StickyController is using position: sticky for sticky
  /// elements.
  bool get usePositionSticky;

  /// Whether elements with the same stickyKey should smoothly "push" each other
  /// when they collide, instead of overlapping.
  ///
  /// This does not work correctly for any current implementations when
  /// interleaving different stickyKeys.
  bool enableSmoothPushing;
}

/// Sticky controller z index.
int stickyControllerZIndex = 100;

/// Recognizes and interprets pan-related events and user intents.
abstract class PanController implements Disposable {
  // A stream of pan events.
  Stream<PanEvent> get onPan;

  /// Clears resources.
  @override
  void dispose();
}

/// A pan event.
abstract class PanEvent extends ScrollHostEvent {
  /// Whether any of the border pan.
  bool get isPanning;

  /// Whether it is a top border pan.
  bool get isTop;

  /// Whether it is a right border pan.
  bool get isRight;

  /// Whether it is a bottom border pan.
  bool get isBottom;

  /// Whether it is a left border pan.
  bool get isLeft;
}
