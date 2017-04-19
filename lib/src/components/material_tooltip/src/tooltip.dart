// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;

import 'package:angular2/angular2.dart';

import '../module.dart';
import '../../../laminate/enums/alignment.dart';
import '../../../laminate/popup/popup.dart' show DomPopupSourceFactory;
import '../../../model/action/delayed_action.dart';
import '../../../utils/angular/properties/properties.dart';
import '../../../utils/browser/feature_detector/feature_detector.dart';
import '../../../utils/disposer/disposer.dart';

import 'ink_tooltip.dart';
import 'tooltip_controller.dart';
import 'tooltip_source.dart' show tooltipDelay;
import 'tooltip_target.dart';

/// An ink-based tooltip which can be attached to any element.
@Directive(
    selector: '[materialTooltip]', providers: const [tooltipControllerBinding])
class MaterialTooltipDirective extends TooltipTarget
    implements OnDestroy, OnInit {
  final _disposer = new Disposer.multi();
  final DynamicComponentLoader _viewLoader;
  final ChangeDetectorRef _changeDetector;
  final html.Window _window;

  String _lastText;
  bool _isInitialized = false;
  Tooltip _tooltip;
  bool _show = true;
  bool _closing = true;
  MaterialInkTooltipComponent _inkTooltip;
  DelayedAction _open;
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
    _open = new DelayedAction(tooltipDelay, _activate);
  }

  void _attachHostListeners() {
    if (_hostListenersAttached) return;
    _hostListenersAttached = true;

    html.HtmlElement element = elementRef.nativeElement;
    _disposer.addStreamSubscription(element.onClick.listen((_) {
      closeTooltip(true);
    }));
    _disposer.addStreamSubscription(element.onBlur.listen((_) {
      closeTooltip(true);
    }));
    _disposer.addStreamSubscription(element.onFocus.listen((_) {
      openTooltip();
    }));
    if (supportsHover(_window)) {
      _disposer.addStreamSubscription(element.onMouseOver.listen((_) {
        openTooltip();
      }));
      _disposer.addStreamSubscription(element.onMouseLeave.listen((_) {
        closeTooltip();
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
    openTooltip();
  }

  void endLongPress(html.TouchEvent event) {
    if (inLongPress) {
      // Mouse events always follow the touch events from a single touch.
      // This prevents the mouse events that fire after a press.
      event.preventDefault();

      inLongPress = false;
      closeTooltip(true);
    }
  }

  /// Styles the tooltip as needed for two-line text.
  @Input()
  set twoLineTooltip(b) {
    _twoLine = getBool(b);
  }

  bool _twoLine = false;

  /// Shows the tooltip if `_show` is true, initializing and loading it into
  /// the view it if is not already.
  void openTooltip() {
    if (!_show || !_closing) return;
    _closing = false;
    _maybeLoadTooltip();
    _open.start();
  }

  void closeTooltip([bool immediate = false]) {
    if (_closing) return;
    _closing = true;
    _open.cancel();
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

      // Track the tooltip as [_inkTooltip] so we can set the text later.
      _inkTooltip = _componentRef.instance as MaterialInkTooltipComponent;
      _disposer.addDisposable(_componentRef.destroy);

      _inkTooltip
        ..text = _lastText
        ..twoLine = _twoLine
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
    if (_tooltip == null) _open.start();
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
  set show(bool value) {
    if (value == _show) return;
    if (value) {
      _attachHostListeners();
    } else {
      _tooltip?.deactivate(immediate: true);
      _open.cancel();
    }
    _show = value;
  }

  /// Positions that the tooltip should try to show.
  @Input('tooltipPositions')
  List<RelativePosition> positions;

  @override
  void ngOnInit() {
    super.ngOnInit();
    if (_show) _attachHostListeners();
  }

  @override
  void ngOnDestroy() {
    _tooltip?.deactivate(immediate: true);
    _open.cancel();
    _disposer.dispose();
  }
}
