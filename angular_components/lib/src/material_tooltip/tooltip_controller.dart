// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';

/// Lightweight interface for Tooltip components to implement so they can be
/// controlled by a [TooltipController].
///
/// Implementations may use the [controllerAsTooltipProxy] factory to create a
/// proxy for activating/deactivating the tooltip through the
/// [TooltipController] to ensure only one is open at a time.
abstract class Tooltip {
  /// Activates this Tooltip.
  void activate();

  /// Deactivates this Tooltip.
  void deactivate({bool immediate = false});
}

/// A simple controller which ensures only one tooltip is visible on the screen.
///
/// Should not be used outside the material_tooltip package.
@Injectable()
class TooltipController {
  /// Activates [tooltip].
  ///
  /// If another [Tooltip] (the current tooltip) is active, it is deactivated.
  void activate(Tooltip tooltip) {
    if (tooltip == null || tooltip == _activeTooltip) return;
    _activeTooltip?.deactivate();
    _activeTooltip = tooltip..activate();
  }

  /// Deactivates [tooltip].
  ///
  /// The controller waits for a delay to allow for tooltips to keep
  /// themselves open as a result of being moused over.
  void deactivate(Tooltip tooltip) {
    if (tooltip == null) return;

    // Use a small delay just in case the user mouses into the tooltip.
    final tooltipToClose = tooltip;
    _closeTimerByTooltip[tooltipToClose]?.cancel();
    _closeTimerByTooltip[tooltipToClose] = Timer(keepAliveDuration, () {
      tooltipToClose.deactivate();
      if (tooltipToClose == _activeTooltip) _activeTooltip = null;
      _closeTimerByTooltip.remove(tooltipToClose);
    });
  }

  /// Deactivates [tooltip] without any delay.
  void deactivateImmediately(Tooltip tooltip) {
    tooltip?.deactivate();
    if (tooltip == _activeTooltip) _activeTooltip = null;
  }

  void keepOpen(Tooltip tooltip) {
    if (tooltip != _activeTooltip) return;
    _cancelTooltipCloseTimer(tooltip);
  }

  void _cancelTooltipCloseTimer(Tooltip tooltip) {
    _closeTimerByTooltip[tooltip]?.cancel();
    _closeTimerByTooltip.remove(tooltip);
  }

  /// The currently active tooltip.
  Tooltip _activeTooltip;

  /// Timers to close each tooltip.
  final _closeTimerByTooltip = <Tooltip, Timer>{};

  Tooltip proxyFor(Tooltip tooltip) => _ProxyTooltip(tooltip, this);
}

const keepAliveDuration = Duration(milliseconds: 500);

class _ProxyTooltip implements Tooltip {
  final Tooltip _tooltip;
  final TooltipController _controller;

  _ProxyTooltip(this._tooltip, this._controller);

  @override
  void activate() {
    _controller.activate(_tooltip);
  }

  @override
  void deactivate({bool immediate = false}) {
    if (immediate) {
      _controller.deactivateImmediately(_tooltip);
    } else {
      _controller.deactivate(_tooltip);
    }
  }
}
