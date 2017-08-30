// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

import 'package:angular/angular.dart';

import '../../../laminate/enums/alignment.dart';
import '../../../laminate/popup/popup.dart' show DomPopupSourceFactory;
import '../../../model/action/delayed_action.dart';
import '../../../utils/browser/feature_detector/feature_detector.dart';
import '../../../utils/disposer/disposer.dart';
import '../module.dart';
import 'ink_tooltip.dart';
import 'tooltip_controller.dart';
import 'tooltip_source.dart' show tooltipShowDelay;
import 'tooltip_target.dart';

/// An ink-based tooltip which can be attached to any element.
@Directive(
    selector: '[materialTooltip]',
    providers: const [tooltipControllerBinding],
    visibility: Visibility.none)
class MaterialTooltipDirective extends TooltipTarget
    implements OnDestroy, OnInit, AfterViewInit {
  final _disposer = new Disposer.multi();
  final SlowComponentLoader _viewLoader;
  final ChangeDetectorRef _changeDetector;
  final html.Window _window;

  String _lastText;
  bool _isInitialized = false;
  Tooltip _tooltip;
  bool _canShow = true;
  bool _isShown = false;
  MaterialInkTooltipComponent _inkTooltip;
  DelayedAction _delayedActivate;
  ElementRef elementRef;
  bool inLongPress;
  bool _hostListenersAttached = false;

  ComponentRef _componentRef;

  MaterialTooltipDirective(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      ElementRef elementRef,
      this._viewLoader,
      this._changeDetector,
      this._window)
      : this.elementRef = elementRef,
        super(domPopupSourceFactory, viewContainerRef, elementRef) {
    inLongPress = false;
    _delayedActivate = new DelayedAction(tooltipShowDelay, _activate);
  }

  void _attachHostListeners() {
    if (_hostListenersAttached) return;
    _hostListenersAttached = true;
    html.HtmlElement element = elementRef.nativeElement;
    _disposer.addStreamSubscription(element.onClick.listen((_) {
      hide(true);
    }));
    _disposer.addStreamSubscription(element.onBlur.listen((_) {
      hide(true);
    }));
    _disposer.addStreamSubscription(element.onFocus.listen((_) {
      show();
    }));
    if (supportsHover(_window)) {
      _disposer.addStreamSubscription(element.onMouseOver.listen((_) {
        show();
      }));
      _disposer.addStreamSubscription(element.onMouseLeave.listen((_) {
        hide();
      }));
    }
    if (isHammerLoaded()) {
      _disposer
          .addStreamSubscription(element.on['press'].listen(handleLongPress));
      _disposer.addStreamSubscription(element.onTouchEnd.listen(endLongPress));
    }
  }

  void handleLongPress(html.Event _) {
    inLongPress = true;
    show();
  }

  void endLongPress(html.TouchEvent event) {
    if (inLongPress) {
      // Mouse events always follow the touch events from a single touch.
      // This prevents the mouse events that fire after a press.
      event.preventDefault();

      inLongPress = false;
      hide(true);
    }
  }

  /// Shows the tooltip if `_canShow` is true, initializing and loading it into
  /// the view it if is not already.
  void show() {
    if (_isShown || !_canShow) return;
    _isShown = true;
    _maybeLoadTooltip();
    _delayedActivate.start();
  }

  void hide([bool immediate = false]) {
    if (!_isShown) return;
    _isShown = false;
    _delayedActivate.cancel();
    _tooltip?.deactivate(immediate: immediate);
    _inkTooltip?.deactivate();
  }

  void _maybeLoadTooltip() {
    if (_isInitialized) return;
    _isInitialized = true;
    // Create the view for the first time
    // Note: We also support loading components that contain one <ng-content>,
    // so we provide an empty slot for them.
    _viewLoader
        .loadNextToLocation(MaterialInkTooltipComponent, viewContainerRef)
        .then((ComponentRef componentRef) {
      _componentRef = componentRef;

      // Track the tooltip as `_inkTooltip` so we can set the text later.
      _inkTooltip = _componentRef.instance as MaterialInkTooltipComponent;
      _disposer.addDisposable(_componentRef.destroy);

      _inkTooltip
        ..text = _lastText
        ..tooltipRef = this;
      if (positions != null) {
        _inkTooltip.positions = positions;
      }
    });
  }

  @override
  void setTooltip(Tooltip tooltip) {
    // If this is the first time that the tooltip is being set, activate it.
    // We could have activated in the [onMouseOver] method when the DCL
    // resolves, however, we want to call activate/deactivate on the [Tooltip]
    // handle that the component presents (as it might be a proxy).
    if (_tooltip == null) _delayedActivate.start();
    _tooltip = tooltip;
  }

  void _activate() {
    _changeDetector.markForCheck();
    _tooltip.activate();
  }

  /// The text to show in the tooltip.
  @Input('materialTooltip')
  set text(String text) {
    _lastText = text;
    _inkTooltip?.text = text;
  }

  /// Condition whether to show the tooltip.
  ///
  /// Defaults to true.
  @Input('showTooltipIf')
  set canShow(bool value) {
    if (value == _canShow) return;
    if (value) {
      _attachHostListeners();
    } else {
      _tooltip?.deactivate(immediate: true);
      _delayedActivate.cancel();
    }
    _canShow = value;
  }

  /// Positions that the tooltip should try to show.
  @Input('tooltipPositions')
  List<RelativePosition> positions;

  @override
  void ngOnInit() {
    if (_canShow) _attachHostListeners();
  }

  @override
  void ngOnDestroy() {
    _tooltip?.deactivate(immediate: true);
    _delayedActivate.cancel();
    _disposer.dispose();
  }
}
