// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.module;

import 'package:angular2/di.dart';

import '../enums/alignment.dart';
import '../overlay/module.dart';
import 'src/dom_popup_source.dart';
import 'src/popup_service.dart';

const inlinePositions = RelativePosition.InlinePositions;

/// DI bindings for Popups and it's dependencies.
///
/// Should be included at most once per the injection chain.
const popupBindings = const [
  const Provider(defaultPopupPositions, useValue: inlinePositions),
  overlayBindings,
  DomPopupSourceFactory,
  PopupService
];

/// DI bindings for Popups and it's dependencies with debugging enabled.
///
/// Should be included at most once per the injection chain.
const popupDebugBindings = const [
  const Provider(defaultPopupPositions, useValue: inlinePositions),
  overlayDebugBindings,
  DomPopupSourceFactory,
  PopupService
];
