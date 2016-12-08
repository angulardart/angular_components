// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../content/deferred_content_aware.dart';
import '../../laminate/enums/alignment.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';

/// A simple handle for Dropdown components.
/// Components wishing to control an ancestral dropdown can have this interface
/// injected:
///     @Optional() DropdownHandle dropdown
abstract class DropdownHandle {
  void open();
  void close();
  void toggle();
  bool _autoDismiss;
  bool get autoDismiss => _autoDismiss;
  set autoDismiss(value) {
    _autoDismiss = getBool(value);
  }
}

/// Base class for Material Dropdown components.
///
/// __Expected Properties:__
/// - `visible:bool` -- Whether the dropdown is visible.
/// - `enforceSpaceConstraints` -- Avoid rendering drop down offscreen
/// - `auto-dismiss: bool` -- Whether the popup should close when the document
///   pressed.
///
/// __Expected Events:__
/// - `onVisible:bool` -- Stream for visibility changes.
///
/// __Bindings:__
/// - `DropdownHandle` -- Provides a common interface to open/close dropodowns.
/// - `DeferredContentAware` -- Provides a means to lazily create/attach
///   content.
class MaterialDropdownBase implements DropdownHandle, DeferredContentAware {
  final visibleStream = new LazyEventEmitter<bool>.broadcast();
  final _contentVisible = new LazyStreamController<bool>.broadcast(sync: true);

  bool _enforceSpaceConstraints = false;
  bool get enforceSpaceConstraints => _enforceSpaceConstraints;
  set enforceSpaceConstraints(value) {
    _enforceSpaceConstraints = getBool(value);
  }

  /// Whether or not the popup width is at least as wide as the select width.
  bool _popupMatchInputWidth = true;
  bool get popupMatchInputWidth => _popupMatchInputWidth;
  set popupMatchInputWidth(value) {
    _popupMatchInputWidth = getBool(value);
  }

  /// Direction of popup scaling.
  String slide;

  bool _autoDismiss = true;
  bool get autoDismiss => _autoDismiss;
  set autoDismiss(value) {
    _autoDismiss = getBool(value);
  }

  bool _visible = false;
  bool get visible => _visible;
  set visible(value) {
    bool vis = getBool(value);
    // Make the content visible if visible is being set to true.
    if (vis && _visible != vis) {
      _contentVisible.add(true);
    }
    _visible = vis;
  }

  /// Preferred positions for alignment when enforceSpaceConstraints is true
  var preferredPositions = RelativePosition.InlinePositions;

  void onVisible(bool vis) {
    visibleStream.add(vis);
    visible = vis;

    // Hide content after popup is closed.
    if (!vis) {
      _contentVisible.add(false);
    }
  }

  void close() {
    visible = false;
  }

  void open() {
    visible = true;
  }

  void toggle() {
    visible = !visible;
  }

  @override
  Stream<bool> get contentVisible => _contentVisible.stream;
}
