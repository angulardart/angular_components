// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:angular/angular.dart';

import './popup_event.dart';
import './popup_source.dart';
import './popup_state.dart';

/// A reusable interface for something that is or delegates to [PopupComponent].
abstract class PopupInterface {
  /// Fires an asynchronous event when the popup is being opened.
  ///
  /// The event can be cancelled (prevented) or deferred until a future
  /// completes - for an example, to wait for an opening animation to finish.
  ///
  /// The *proposed* size of the popup is also provided as a [Rectangle].
  @Output('open')
  Stream<PopupEvent> get onOpen;

  /// Fires an asynchronous event when the popup is being closed.
  ///
  /// The event can be cancelled (prevented) or deferred until a future
  /// completes - for an example, to wait for a closing animation to finish.
  @Output('close')
  Stream<PopupEvent> get onClose;

  /// A synchronous event that fires when the [visible] property of the popup
  /// changes (e.g. either from `false` to `true` or `true` to `false`).
  ///
  /// Unlike [onOpen] and [onClose], this occurs *after* the event completes.
  @Output('visibleChange')
  Stream<bool> get onVisible;

  /// Sets whether the popup should dismiss (close) itself on document press.
  @Input()
  set autoDismiss(bool autoDismiss);

  /// Sets whether the popup should automatically reposition itself based on
  /// space available relative to the viewport.
  @Input()
  set enforceSpaceConstraints(bool enforceSpaceConstraints);

  /// Sets whether popup should set a minimum width to the width of [source].
  @Input()
  set matchMinSourceWidth(bool matchMinSourceWidth);

  /// Sets the x-offset to where the popup will be positioned ultimately.
  @Input()
  set offsetX(int offsetX);

  /// Sets the y-offset to where the popup will be positioned ultimately.
  @Input()
  set offsetY(int offsetY);

  /// Sets what positions should be tried when [enforceSpaceConstraints] is set.
  ///
  /// Similarly to Angular providers, this supports nested lists of preferred
  /// positions. The popup will flatten out the list of positions and choose the
  /// first one that fits on screen.
  @Input()
  set preferredPositions(Iterable preferredPositions);

  /// Sets the source the popup should be created relative to.
  @Input()
  set source(PopupSource source);

  /// Sets whether the [source] should be tracked for changes.
  @Input()
  set trackLayoutChanges(bool trackLayoutChanges);

  /// Sets whether the popup should be shown.
  ///
  /// If [visible] is not the current state, this may close or open the popup.
  @Input()
  set visible(bool visible);

  /// Toggles the visibility of the popup
  void toggle();
}

/// A partial that implements the events of [PopupInterface] with new emitter.
///
/// __Example use__:
///     class MyPopupComponent extends PopupEvents implements PopupInterface {}
// TODO(google): Consider moving these into material_popup as there aren't
// any other users of these streams.
abstract class PopupEvents {
  Stream<PopupEvent> get onOpen => onOpenController.stream;
  final StreamController<PopupEvent> onOpenController =
      new StreamController<PopupEvent>.broadcast(sync: true);

  Stream<PopupEvent> get onClose => onCloseController.stream;
  final StreamController<PopupEvent> onCloseController =
      new StreamController<PopupEvent>.broadcast(sync: true);

  Stream<bool> get onVisible => onVisibleController.stream;
  final StreamController<bool> onVisibleController =
      new StreamController<bool>.broadcast(sync: true);
}

/// A partial that implements the setters of [PopupBase] by writing to [state].
abstract class PopupBase implements PopupInterface {
  /// The state of the [PopupRef] that is manipulated by this component.
  PopupState get state;

  @override
  set autoDismiss(bool autoDismiss) {
    state.autoDismiss = autoDismiss;
  }

  @override
  set enforceSpaceConstraints(bool enforceSpaceConstraints) {
    state.enforceSpaceConstraints = enforceSpaceConstraints;
  }

  @override
  set matchMinSourceWidth(bool matchMinSourceWidth) {
    state.matchMinSourceWidth = matchMinSourceWidth;
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
  set trackLayoutChanges(bool trackLayoutChanges) {
    state.trackLayoutChanges = trackLayoutChanges;
  }
}

/// A partial that stores all fields in [PopupInterface] to be sent further
/// down the component tree using change detection.
///
/// An obvious use case is for testing and for composing parent components that
/// want the same properties as a popup without the verbosity of re-typing.
abstract class PopupComposite implements PopupInterface {
  @override
  bool autoDismiss = true;

  @override
  bool enforceSpaceConstraints = false;

  @override
  bool matchMinSourceWidth = true;

  @override
  int offsetX = 0;

  @override
  int offsetY = 0;

  @override
  Iterable preferredPositions = const [];

  @override
  PopupSource source;

  @override
  bool trackLayoutChanges = true;

  @override
  bool visible = false;

  @override
  void toggle() {
    visible = !visible;
  }
}
