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

/// Whether the primary input mechanism on this system is touch.
///
/// Note: this check doesn't confirm the presence of a touchscreen, or that
/// [TouchEvent] is supported at all. Any device which doesn't have a mouse
/// or other fine-grained pointing device will pass this check, e.g. a TV, or
/// a PC with alternative input devices.
///
/// Checking if touch events are supported? You probably want
/// [TouchEvent.supported] instead.
final bool isTouchInterface =
    (window.matchMedia('(pointer: coarse)').matches ?? false) ||
        js.context.hasProperty('__acxForceTouchEnabled');

/// Returns true if Hammer.js is loaded in the current browser.
///
/// Hammer provides support for detection of additional touch gestures.
/// Apps that want to use Hammer's recognizers need to load
/// https://www.gstatic.com/external_hosted/hammerjs/v2_0_2/hammer.min.js
/// into the browser before bootstrapping.
bool isHammerLoaded() => js.context.hasProperty('Hammer');

/// Whether the browser supports the Web Animations API.
final bool supportsAnimationApi =
    js_util.hasProperty(DivElement(), 'animate') &&
        !js.context.hasProperty('__acxDisableWebAnimationsApi');

/// Whether the browser supports IntersectionObserver.
final bool supportsIntersectionObserver =
    js.context.hasProperty('IntersectionObserver');

/// Whether the browser supports ResizeObserver.
final bool supportsResizeObserver = js.context.hasProperty('ResizeObserver');

/// Whether the browser supports position: sticky.
final bool supportsPositionSticky = () {
  var el = DivElement();
  el.style.cssText = 'position: sticky';
  return el.style.position == 'sticky';
}();

/// Whether the current web browser is Firefox.
final bool isFirefox = window.navigator.userAgent.contains('Firefox/');

/// Whether the current web browser is MS Edge.
final bool isEdge = window.navigator.userAgent.contains('Edge/');
