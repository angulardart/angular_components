// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import './tooltip_controller.dart';
import '../../../laminate/components/popup/popup.dart'
    show PopupSourceDirective;
import '../../../laminate/popup/popup.dart' show DomPopupSourceFactory;
import '../../../model/action/delayed_action.dart';
import '../../../utils/angular/reference/reference.dart';
import '../../../utils/async/async.dart';
import '../../../utils/browser/events/events.dart';

import 'tooltip_source.dart' show tooltipDelay;

/// A directive which marks the source of a tooltip and handles activating and
/// deactivating a tooltip on mouse-hover, click, enter, and space.
///
/// This directive is used in conjunction with a [Tooltip] Component. Currently
/// the only stand-alone tooltip component is the [MaterialInkTooltipComponent]
/// which gives full control over the content of a simple tooltip.
///
/// __Example Usage:__
///
/// ```html
/// <!-- Explicitly declare the tooltip target. Allows for custom content -->
/// <span tooltipTarget #ref="tooltipTarget">
///   Explicitly declare a tooltip component
/// </span>
/// <material-tooltip-text [for]="ref">
///   Allows for <strong>formatted</strong> <em>text</em>.
/// </material-tooltip-text>```
@Directive(selector: '[tooltipTarget]', exportAs: 'tooltipTarget', host: const {
  '(mouseover)': 'onMouseOver()',
  '(mouseleave)': 'onMouseLeave()',
  '(click)': 'closeTooltip()',
  '(blur)': 'closeTooltip()',
  '(keyup)': 'openTooltipWithDelay()',
})
class MaterialTooltipTargetDirective extends TooltipBehavior
    implements OnInit, OnDestroy {
  ElementRef elementRef;

  MaterialTooltipTargetDirective(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      ElementRef elementRef,
      ChangeDetectorRef changeDetector)
      : super(domPopupSourceFactory, viewContainerRef, elementRef,
            changeDetector) {
    this.elementRef = elementRef;
  }

  @override
  void ngOnDestroy() {
    elementRef = null;
  }
}

/// Class encorporating the common behavior for a [Directive] that marks the
/// source of a tooltip.
abstract class TooltipBehavior extends TooltipTarget {
  final _tooltipActivate = new LazyStreamController<bool>.broadcast(sync: true);
  final ChangeDetectorRef _changeDetector;
  DelayedAction _open;

  // Whether the mouse is currently inside the component.
  bool _isMouseInside = false;

  Stream<bool> get tooltipActivate => _tooltipActivate.stream.distinct();

  TooltipBehavior(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      ElementRef elementRef,
      this._changeDetector)
      : super(domPopupSourceFactory, viewContainerRef, elementRef) {
    _open = new DelayedAction(tooltipDelay, openTooltip);
  }

  void openTooltipWithDelay() {
    _open.start();
  }

  void openTooltip() {
    _open.cancel(); // Cancel any pending actions if tooltip is opened early.
    _changeDetector.markForCheck();
    _tooltipActivate.add(true);
    _tooltip?.activate();
  }

  void closeTooltip({bool immediate: false}) {
    _open.cancel(); // Cancel any pending actions if tooltip is closed early.
    _tooltipActivate.add(false);
    _tooltip?.deactivate(immediate: immediate);
  }

  void onMouseOver() {
    if (_isMouseInside) return;
    _isMouseInside = true;
    openTooltipWithDelay();
  }

  void onMouseLeave() {
    _isMouseInside = false;
    closeTooltip();
  }
}

/// A directive which marks the source of a tooltip and handles activating on
/// mouse over (with delay), click, enter, and space.
///
/// This directive is slightly different from [MaterialTooltipTargetDirective]
/// as click and key events open tooltips with no delay.
///
/// This directive is used in conjunction with a [Tooltip] Component. Currently
/// the only stand-alone tooltip component is the [MaterialInkTooltipComponent]
/// which gives full control over the content of a simple tooltip.
///
/// __Example Usage:__
///
/// ```html
/// <!-- Explicitly declare the tooltip target. Allows for custom content -->
/// <span clickableTooltipTarget #ref="tooltipTarget">
///   Explicitly declare a tooltip component
/// </span>
/// <material-tooltip-text [for]="ref">
///   Allows for <strong>formatted</strong> <em>text</em>.
/// </material-tooltip-text>```
@Directive(
    selector: '[clickableTooltipTarget]',
    exportAs: 'tooltipTarget',
    host: const {
      '(mouseover)': 'onMouseOver()',
      '(mouseleave)': 'onMouseLeave()',
      '(click)': 'onClick()',
      '(keypress)': r'kbTrigger($event)',
      '(blur)': r'onBlur($event)',
    },
    outputs: const [
      "tooltipActivate" /*From [TooltipBehavior]*/
    ])
class ClickableTooltipTargetDirective extends TooltipBehavior
    implements OnInit, OnDestroy {
  StreamSubscription _tooltipSubscription;
  ElementRef elementRef;
  bool _tooltipVisible = false;

  ClickableTooltipTargetDirective(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      ElementRef elementRef,
      ChangeDetectorRef changeDetector)
      : super(domPopupSourceFactory, viewContainerRef, elementRef,
            changeDetector) {
    this.elementRef = elementRef;
    _tooltipSubscription = tooltipActivate.listen((visible) {
      _tooltipVisible = visible;
    });
  }

  void onBlur(FocusEvent event) {
    // Don't close the tooltip if the user clicked an empty area on the page.
    if (event.relatedTarget == null) return;

    // Don't close the tooltip if focus went to an element inside the tooltip.
    HtmlElement el;
    for (el = event.relatedTarget; el.parent != null; el = el.parent) {
      if (el.className == "acx-overlay-container") return;
    }

    closeTooltip(immediate: true);
  }

  void onClick() {
    _toggleVisibility();
  }

  void _toggleVisibility() {
    if (_tooltipVisible) {
      closeTooltip(immediate: true);
    } else {
      openTooltip();
    }
  }

  void kbTrigger(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER || isSpaceKey(event)) {
      _toggleVisibility();
      // Required to prevent window from scrolling.
      event.preventDefault();
    }
  }

  @override
  void ngOnDestroy() {
    elementRef = null;
    _tooltipSubscription.cancel();
  }
}

/// Base class for Tooltip Target components/directives.
///
/// A tooltip target component is the source of alignment for and the object
/// responsible for controlling a tooltip.
abstract class TooltipTarget extends PopupSourceDirective
    implements ReferenceDirective {
  Tooltip _tooltip;
  final ViewContainerRef viewContainerRef;

  TooltipTarget(DomPopupSourceFactory domPopupSourceFactory,
      this.viewContainerRef, ElementRef elementRef)
      : super(domPopupSourceFactory, elementRef);

  /// Sets the tooltip associated with this target.
  void setTooltip(Tooltip component) {
    _tooltip = component;
  }
}
