// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.overlay.src.overlay_service;

import 'dart:async';
import 'dart:math';

import './overlay_ref.dart';
import './overlay_state.dart';

/// A low-level service exists to be able to manage the overlay container, spawn,
/// mutate, and dispose of overplay panes and abstract away most of the Angular
/// and direct DOM access.
abstract class OverlayService {
  /// Creates an overlay pane within the registered container.
  ///
  /// If [initialState] is specified, configuration for the overlay is setup on
  /// creation, versus waiting for the future to resolve. [initialState] may
  /// also be a [MutableOverlayState], in which case it is not copied, but used
  /// as the state instance.
  ///
  /// The returned future completes with a reference to the pane.
  Future<OverlayRef> create([OverlayState initialState]);

  /// Creates a overlay pane within the registered container.
  ///
  /// Returns with a reference to the pane.
  OverlayRef createSync([OverlayState initialState]);

  /// Returns the current size of the overlay container.
  ///
  /// By default this is normally the viewport, but in some apps the container
  /// may be different dimensions (such as multiple apps alive at the same
  /// time).
  Future<Rectangle> measureContainer();
}
