// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:angular_components/laminate/enums/position.dart';
import 'package:angular_components/laminate/enums/visibility.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// A ruler is an interface for querying and manipulating element positions
/// and size through asynchronous APIs, and with integration with internal
/// DOM scheduling to prevent synchronous reflows.
abstract class Ruler<E> {
  /// Returns a dimension client rectangle for [element].
  ///
  /// If [offset] is true, returns the offset positions from the parent instead
  /// of absolute.
  ///
  /// Throws [StateError] if [element] is not within the live DOM.
  Future<Rectangle> measure(E element, {bool offset = false});

  /// Returns a dimension client rectangle for [element].
  ///
  /// If [offset] is true, returns the offset positions from the parent instead
  /// of absolute.
  ///
  /// Throws [StateError] if [element] is not within the live DOM.
  Rectangle measureSync(E element, {bool offset = false});

  /// Returns a stream of bounding client rectangles for [element].
  ///
  /// **NOTE**: The first event is not guaranteed to happen in the same VM turn.
  /// To obtain a first response without waiting, use [measure].
  ///
  /// The stream is automatically deduped, and an updated scheduled whenever the
  /// DOM *may* have re-flowed (see [DomService.onLayoutChanged]). This is an
  /// expensive operation and should be limited to active elements.
  ///
  /// Throws [StateError] if [element] is not within the live DOM.
  Stream<Rectangle> track(E element);

  /// Returns a future that completes after updating position and dimension
  /// based properties on [element].
  ///
  /// **NOTE**: All of these properties are *cleared* before updating.
  Future<void> update(E element,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true});

  /// Updates position and dimension based properties on [element].
  ///
  /// **NOTE**: All of these properties are *cleared* before updating.
  void updateSync(E element,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true});
}

/// A partial implementation of [Ruler] without external dependencies.
///
/// Needs the following implemented:
/// - [onLayoutChanged]
/// - [onRead]
/// - [onWrite]
/// - [measureSync]
/// - [setProperties]
abstract class RulerBase<E> implements Ruler<E> {
  // Holds what CSS classes were previously set by the Ruler.
  final _addedCssClasses = Expando<List<String>>();

  /// Return true if [element] can be synchronously updated safely because it is
  /// not in the live DOM document.
  bool canSyncWrite(E element);

  /// Override with an implementation of [DomService.onLayoutChanged].
  ///
  /// The stream should fire within a DOM read queue.
  Stream<DomService> get onLayoutChanged;

  /// Override with an implementation of [DomService.onRead].
  Future<void> onRead();

  /// Override with an implementation of [DomService.onWrite].
  Future<void> onWrite();

  @override
  Future<Rectangle> measure(E element, {bool offset = false}) {
    return onRead().then((_) => measureSync(element, offset: offset));
  }

  @override
  Rectangle measureSync(E element, {bool offset = false});

  /// Removes [classes] on [element].
  void removeCssClassesSync(E element, List<String> classes);

  /// Synchronously set [element].classes to add [classes].
  void addCssClassesSync(E element, List<String> classes);

  /// Clear all CSS style properties on [element].
  void clearCssPropertiesSync(E element);

  /// Synchronously write [element].style[propertyName] = [propertyValue].
  void setCssPropertySync(E element, String propertyName, String propertyValue);

  @override
  Stream<Rectangle> track(E element) {
    StreamController<Rectangle> controller;
    StreamSubscription<dynamic> subscription;
    controller = StreamController<Rectangle>(
        sync: true,
        onListen: () {
          // Get an initial measure of the element prior to onLayoutChanged.
          measure(element).then(controller.add);
          subscription = onLayoutChanged.listen((_) {
            controller.add(measureSync(element));
          }, onDone: () {
            controller.close();
          });
        },
        onCancel: () {
          subscription.cancel();
        });
    return controller.stream.distinct((Rectangle previous, Rectangle next) {
      if (previous == null || next == null) return identical(previous, next);

      // We consider rectangles equal if their coordinates are within a
      // small epsilon of each other.
      // Under the right conditions, Chrome will return slightly different
      // rectangles even though nothing has changed likely due to floating
      // precision limitations combined with varying orders values are
      // calculated by the browser.
      // A delta of 0.01 pixels should never be user visible and is
      // large enough to be safely outside the range of floating point
      // errors for plausibly sized UIs. We could likely get away with 0.001
      // pixels and still avoid round errors for plausible sized UIs. A more
      // sophisticated approach would be to adjust the epsilon based on the
      // magnitude of the inputs but that is overkill for this use case.
      bool withinEpsilon(num a, num b) => (a - b).abs() < 0.01;
      return withinEpsilon(previous.top, next.top) &&
          withinEpsilon(previous.left, next.left) &&
          withinEpsilon(previous.width, next.width) &&
          withinEpsilon(previous.height, next.height);
    });
  }

  @override
  Future<void> update(E element,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true}) {
    void doSyncUpdate() {
      updateSync(element,
          cssClasses: cssClasses,
          visibility: visibility,
          position: position,
          width: width,
          height: height,
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          zIndex: zIndex,
          useCssTransform: useCssTransform);
    }

    if (canSyncWrite(element)) {
      doSyncUpdate();
      return Future.value();
    }
    return onWrite().then((_) => doSyncUpdate());
  }

  void updateSync(E element,
      {List<String> cssClasses,
      Visibility visibility,
      Position position,
      num width,
      num height,
      num left,
      num top,
      num right,
      num bottom,
      num zIndex,
      bool useCssTransform = true}) {
    // TODO(google): Consider another format for dimensions.
    SetPropertyFn setProperty = (name, value) {
      setCssPropertySync(element, name, value);
    };
    setProperty('display', null);
    setProperty('visibility', null);
    // It's important to put this first to avoid FOUC *if* becoming hidden.
    if (visibility != null && visibility != Visibility.Visible) {
      visibility.apply(setProperty);
    }
    if (cssClasses != null) {
      var lastCssClasses = _addedCssClasses[element];
      if (lastCssClasses != null) {
        removeCssClassesSync(element, lastCssClasses);
      }
      addCssClassesSync(element, cssClasses);
      _addedCssClasses[element] = cssClasses;
    }
    if (width != null) {
      setProperty('width', width == 0 ? '0' : '${width}px');
    } else {
      setProperty('width', null);
    }
    if (height != null) {
      setProperty('height', height == 0 ? '0' : '${height}px');
    } else {
      setProperty('height', null);
    }

    position?.apply(setProperty);

    // Using translateX/Y is faster than left/top, but there is at least one
    // use case that needs the other behavior.
    if (useCssTransform) {
      var buffer = StringBuffer();
      if (left != null) {
        setProperty('left', '0');
        buffer.write('translateX(${left.round()}px) ');
      } else {
        setProperty('left', null);
      }
      if (top != null) {
        setProperty('top', '0');
        buffer.write('translateY(${top.round()}px)');
      } else {
        setProperty('top', null);
      }
      setProperty('transform', buffer.toString());
      setProperty('-webkit-transform', buffer.toString());
      if (buffer.isNotEmpty) {
        setProperty('transform', buffer.toString());
        setProperty('-webkit-transform', buffer.toString());
      }
    } else {
      if (left != null) {
        setProperty('left', left == 0 ? '0' : '${left}px');
      } else {
        setProperty('left', null);
      }
      if (top != null) {
        setProperty('top', top == 0 ? '0' : '${top}px');
      } else {
        setProperty('top', null);
      }
      setProperty('transform', null);
      setProperty('-webkit-transform', null);
    }

    if (right != null) {
      setProperty('right', right == 0 ? '0' : '${right}px');
    } else {
      setProperty('right', null);
    }
    if (bottom != null) {
      setProperty('bottom', bottom == 0 ? '0' : '${bottom}px');
    } else {
      setProperty('bottom', null);
    }
    if (zIndex != null) {
      setProperty('z-index', '$zIndex');
    } else {
      setProperty('z-index', null);
    }
    // It's important to put this last to avoid FOUC *if* becoming visible.
    if (visibility != null && visibility == Visibility.Visible) {
      visibility.apply(setProperty);
    }
  }
}
