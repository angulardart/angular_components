// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/src/laminate/popup/dom_popup_source.dart';

const inlinePositions = RelativePosition.InlinePositions;

/// A token representing a [List] of [RelativePosition]s to use when popup auto
/// positioning is set (`enforceSpaceConstraints`) but no custom positions
/// (`preferredPositions`) are set.
const defaultPopupPositions = OpaqueToken<List<RelativePosition>>(
  'defaultPopupPositions',
);

/// DI module for Popups and its dependencies.
///
/// Should be included at most once per the injection chain.
const popupModule = Module(
  include: [
    overlayModule,
  ],
  provide: _popupProviders,
);

const _popupProviders = <Provider>[
  ValueProvider.forToken(defaultPopupPositions, inlinePositions),
  ClassProvider(DomPopupSourceFactory),
];

/// DI bindings for Popups and its dependencies.
///
/// Should be included at most once per the injection chain.
const popupBindings = [
  overlayBindings,
  _popupProviders,
];

/// DI module for Popups and its dependencies with debugging enabled.
///
/// Should be included at most once per the injection chain.
const popupDebugModule = Module(
  include: [
    overlayDebugModule,
  ],
  provide: _popupProviders,
);

/// DI bindings for Popups and its dependencies with debugging enabled.
///
/// Should be included at most once per the injection chain.
const popupDebugBindings = [
  overlayDebugBindings,
  _popupProviders,
];
