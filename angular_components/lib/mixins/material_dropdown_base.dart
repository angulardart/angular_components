// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';

/// A simple handle for Dropdown components.
/// Components wishing to control an ancestral dropdown can have this interface
/// injected:
///     @Optional() DropdownHandle dropdown
abstract class DropdownHandle {
  void open();
  void close();
  void toggle();
  bool autoDismiss;
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
class MaterialDropdownBase
    implements DropdownHandle, DeferredContentAware, PopupRef {
  /// Fired when the dropdown's visibility changes.
  @Output('visibleChange')
  Stream<bool> get visibleStream => _visibleStream.stream;
  final _visibleStream = StreamController<bool>.broadcast(sync: true);
  final _contentVisible = StreamController<bool>.broadcast(sync: true);

  /// Avoid rendering drop down offscreen.
  @Input()
  bool enforceSpaceConstraints = false;

  /// Whether to clamp the dropdown position so that it never goes offscreen.
  @Input()
  bool constrainToViewport = false;

  /// Whether or not the popup width is at least as wide as the select width.
  @Input()
  bool popupMatchInputWidth = true;

  /// Direction of popup scaling.
  ///
  /// Valid values are `x`, `y`, or `null`.
  @Input()
  String slide;

  /// Whether the popup should close when the document pressed.
  bool autoDismiss = true;

  bool _visible = false;

  bool get visible => _visible;

  /// Whether the dropdown is visible.
  @Input()
  set visible(bool value) {
    bool vis = value;
    // Make the content visible if visible is being set to true.
    if (vis && _visible != vis) {
      _contentVisible.add(true);
    }
    _visible = vis;
  }

  /// Preferred positions for alignment when enforceSpaceConstraints is true
  @Input()
  List<dynamic> preferredPositions = RelativePosition.InlinePositions;

  void onVisible(bool vis) {
    _visibleStream.add(vis);
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

  @override
  bool get isVisible => visible;

  @override
  Stream<bool> get onVisibleChanged => visibleStream;
}
