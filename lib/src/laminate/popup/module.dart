// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../enums/alignment.dart';
import '../overlay/module.dart';
import 'src/dom_popup_source.dart';

const inlinePositions = RelativePosition.InlinePositions;

/// A token representing a [List] of [RelativePosition]s to use when popup auto
/// positioning is set (`enforceSpaceConstraints`) but no custom positions
/// (`preferredPositions`) are set.
const OpaqueToken defaultPopupPositions =
    const OpaqueToken('defaultPopupPositions');

/// DI bindings for Popups and its dependencies.
///
/// Should be included at most once per the injection chain.
const popupBindings = const [
  const Provider(defaultPopupPositions, useValue: inlinePositions),
  overlayBindings,
  DomPopupSourceFactory,
];

/// DI bindings for Popups and its dependencies with debugging enabled.
///
/// Should be included at most once per the injection chain.
const popupDebugBindings = const [
  const Provider(defaultPopupPositions, useValue: inlinePositions),
  overlayDebugBindings,
  DomPopupSourceFactory,
];
