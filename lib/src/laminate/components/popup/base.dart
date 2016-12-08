// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.components.popup.base;

import 'dart:async';
import 'dart:math';

import '../../enums/alignment.dart';
import '../../popup/popup.dart';
import '../../../utils/angular/properties/properties.dart';
import '../../../utils/async/async.dart';

/// A reusable interface for something that is or delegates to [PopupComponent].
abstract class PopupInterface {
  /// Fires an asynchronous event when the popup is being opened.
  ///
  /// The event can be cancelled (prevented) or deferred until a future
  /// completes - for an example, to wait for an opening animation to finish.
  ///
  /// The *proposed* size of the popup is also provided as a [Rectangle].
  Stream<PopupEvent> get onOpen;

  /// Fires an asynchronous event when the popup is being closed.
  ///
  /// The event can be cancelled (prevented) or deferred until a future
  /// completes - for an example, to wait for a closing animation to finish.
  Stream<PopupEvent> get onClose;

  /// Fires whenever the *content* size of the popup changes.
  ///
  /// **WARNING**: Listening to this stream requires listening to app-wide
  /// notifications that the DOM may have been modified, and is potentially
  /// expensive.
  Stream<Rectangle> get onSize;

  /// A synchronous event that fires when the [visible] property of the popup
  /// changes (e.g. either from `false` to `true` or `true` to `false`).
  ///
  /// Unlike [onOpen] and [onClose], this occurs *after* the event completes.
  Stream<bool> get onVisible;

  /// Sets the x-axis *content* alignment of the popup.
  set alignContentX(String alignContentX);

  /// Sets the y-axis *content* alignment of the popup.
  set alignContentY(String alignContentY);

  /// Sets whether the popup should dismiss (close) itself on document press.
  set autoDismiss(dynamic autoDismiss);

  /// Sets whether the popup should automatically reposition itself based on
  /// space available relative to the viewport.
  set enforceSpaceConstraints(dynamic enforceSpaceConstraints);

  /// Sets whether popup should resize to width of the [source].
  @Deprecated('Use `matchMinSourceWidth` or hardcode width on your contents')
  set matchSourceWidth(dynamic matchSourceWidth);

  /// Sets whether popup should set a minimum width to the width of [source].
  set matchMinSourceWidth(dynamic matchMinSourceWidth);

  /// Sets the x-offset to where the popup will be positioned ultimately.
  set offsetX(int offsetX);

  /// Sets the y-offset to where the popup will be positioned ultimately.
  set offsetY(int offsetY);

  /// Sets what positions should be tried when [enforceSpaceConstraints] is set.
  ///
  /// Similarly to Angular providers, this supports nested lists of preferred
  /// positions. The popup will flatten out the list of positions and choose the
  /// first one that fits on screen.
  set preferredPositions(Iterable preferredPositions);

  /// Sets the source the popup should be created relative to.
  set source(PopupSource source);

  /// Sets whether the [source] should be tracked for changes.
  set trackLayoutChanges(dynamic trackLayoutChanges);

  /// Sets whether the popup should be shown.
  ///
  /// If [visible] is not the current state, this may close or open the popup.
  set visible(bool visible);

  /// Toggles the visibility of the popup
  void toggle();
}

/// A partial that implements the events of [PopupInterface] with new emitter.
///
/// __Example use__:
///     class MyPopupComponent extends PopupEvents implements PopupInterface {}
abstract class PopupEvents {
  final LazyEventEmitter<PopupEvent> onOpen =
      new LazyEventEmitter<PopupEvent>();

  final LazyEventEmitter<PopupEvent> onClose =
      new LazyEventEmitter<PopupEvent>();

  final LazyEventEmitter<Rectangle> onSize = new LazyEventEmitter<Rectangle>();

  final LazyEventEmitter<bool> onVisible =
      new LazyEventEmitter<bool>.broadcast();
}

/// A partial that implements the setters of [PopupBase] by writing to [state].
abstract class PopupBase implements PopupInterface {
  /// The state of the [PopupRef] that is manipulated by this component.
  PopupState get state;

  @override
  set alignContentX(String alignContentX) {
    state.alignContentX = new Alignment.parse(alignContentX);
  }

  @override
  set alignContentY(String alignContentY) {
    state.alignContentY = new Alignment.parse(alignContentY);
  }

  @override
  set autoDismiss(dynamic autoDismiss) {
    state.autoDismiss = getBool(autoDismiss);
  }

  @override
  set enforceSpaceConstraints(dynamic enforceSpaceConstraints) {
    state.enforceSpaceConstraints = getBool(enforceSpaceConstraints);
  }

  @override
  set matchSourceWidth(dynamic matchSourceWidth) {
    state.matchSourceWidth = getBool(matchSourceWidth);
  }

  @override
  set matchMinSourceWidth(dynamic matchMinSourceWidth) {
    state.matchMinSourceWidth = getBool(matchMinSourceWidth);
  }

  @override
  set offsetX(int offsetX) {
    state.offsetX = offsetX;
  }

  @override
  set offsetY(int offsetY) {
    state.offsetY = offsetY;
  }

  @override
  set preferredPositions(Iterable preferredPositions) {
    state.preferredPositions = preferredPositions;
  }

  @override
  set source(PopupSource source) {
    state.source = source;
  }

  @override
  set trackLayoutChanges(dynamic trackLayoutChanges) {
    state.trackLayoutChanges = getBool(trackLayoutChanges);
  }
}

/// A partial that stores all fields in [PopupInterface] to be sent further
/// down the component tree using change detection.
///
/// An obvious use case is for testing and for composing parent components that
/// want the same properties as a popup without the verbosity of re-typing.
abstract class PopupComposite implements PopupInterface {
  @override
  String alignContentX = 'start';

  @override
  String alignContentY = 'start';

  bool _autoDismiss = true;

  bool get autoDismiss => _autoDismiss;

  @override
  set autoDismiss(value) {
    _autoDismiss = getBool(value);
  }

  bool _enforceSpaceConstraints = false;

  bool get enforceSpaceConstraints => _enforceSpaceConstraints;

  @override
  set enforceSpaceConstraints(value) {
    _enforceSpaceConstraints = getBool(value);
  }

  bool _matchSourceWidth = false;

  bool get matchSourceWidth => _matchSourceWidth;

  @override
  set matchSourceWidth(value) {
    _matchSourceWidth = getBool(value);
  }

  bool _matchMinSourceWidth = true;

  bool get matchMinSourceWidth => _matchMinSourceWidth;

  @override
  set matchMinSourceWidth(value) {
    _matchMinSourceWidth = getBool(value);
  }

  @override
  int offsetX = 0;

  @override
  int offsetY = 0;

  @override
  Iterable preferredPositions = const [];

  @override
  PopupSource source;

  bool _trackLayoutChanges = true;

  bool get trackLayoutChanges => _trackLayoutChanges;

  @override
  set trackLayoutChanges(value) {
    _trackLayoutChanges = value as bool;
  }

  @override
  bool visible = false;

  @override
  void toggle() {
    visible = !visible;
  }
}
