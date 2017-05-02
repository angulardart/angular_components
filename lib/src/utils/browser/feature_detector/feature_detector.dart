// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:js' as js;

import 'package:js/js_util.dart' as js_util;

/// Provides information of current browser features.

/// Detects if the current device and platform supports hovering.
///
/// Nexus 9 is a special case here because it does not match the
/// "(hover: none)" media query.
bool supportsHover(Window window) =>
    !((window.matchMedia("(hover: none)")?.matches ?? false) ||
        window.navigator.userAgent.contains("Nexus 9"));

/// Returns true if Hammer.js is loaded in the current browser.
///
/// Hammer provides support for detection of additional touch gestures.
/// Apps that want to use Hammer's recognizers need to load
/// https://www.gstatic.com/external_hosted/hammerjs/v2_0_2/hammer.min.js
/// into the browser before bootstrapping.
bool isHammerLoaded() => js.context.hasProperty('Hammer');

/// Whether the browser supports the Web Animations API.
final bool supportsAnimationApi =
    js_util.hasProperty(new DivElement(), 'animate') &&
        !js.context.hasProperty('__acxDisableWebAnimationsApi');

/// Whether the current web browser is Firefox.
final bool isFirefox = window.navigator.userAgent.contains('Firefox/');

/// Whether the current web browser is MS Edge.
final bool isEdge = window.navigator.userAgent.contains('Edge/');
