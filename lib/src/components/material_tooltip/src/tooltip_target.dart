// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../../laminate/popup/popup.dart';
import '../../../model/action/delayed_action.dart';
import '../../../utils/angular/reference/reference.dart';
import '../../../utils/browser/events/events.dart';
import './tooltip_controller.dart';
import 'tooltip_source.dart' show tooltipShowDelay;

/// A directive that marks the target of a tooltip and handles showing and
/// hiding a tooltip on hover, click, enter, and space.
///
/// This directive is used in conjunction with a [Tooltip] Component. Currently
/// the only stand-alone tooltip component is the [MaterialInkTooltipComponent],
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
  '(click)': 'hideTooltip()',
  '(blur)': 'hideTooltip()',
  '(keyup)': 'showTooltipWithDelay()',
})
class MaterialTooltipTargetDirective extends TooltipBehavior
    implements AfterViewInit, OnDestroy {
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

/// Class incorporating the common behavior of a [Directive] that marks the
/// target of a tooltip.
abstract class TooltipBehavior extends TooltipTarget {
  final _tooltipActivate = new StreamController<bool>.broadcast(sync: true);
  final ChangeDetectorRef _changeDetector;
  DelayedAction _show;

  // Whether the mouse is currently inside the component.
  bool _isMouseInside = false;

  @Output()
  Stream<bool> get tooltipActivate => _tooltipActivate.stream.distinct();

  TooltipBehavior(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      ElementRef elementRef,
      this._changeDetector)
      : super(domPopupSourceFactory, viewContainerRef, elementRef) {
    _show = new DelayedAction(tooltipShowDelay, showTooltip);
  }

  void showTooltipWithDelay() {
    _show.start();
  }

  void showTooltip() {
    _show.cancel(); // Cancel any pending actions if tooltip is shown early.
    _changeDetector.markForCheck();
    _tooltipActivate.add(true);
    _tooltip?.activate();
  }

  void hideTooltip({bool immediate: false}) {
    _show.cancel(); // Cancel any pending actions if tooltip is hidden early.
    _tooltipActivate.add(false);
    _tooltip?.deactivate(immediate: immediate);
  }

  void onMouseOver() {
    if (_isMouseInside) return;
    _isMouseInside = true;
    showTooltipWithDelay();
  }

  void onMouseLeave() {
    _isMouseInside = false;
    hideTooltip();
  }
}

/// A directive that marks the target of a tooltip and handles activating on
/// mouse over (with delay), click, enter, and space.
///
/// This directive is slightly different from [MaterialTooltipTargetDirective]
/// as click and key events make tooltips appear with no delay.
///
/// This directive is used in conjunction with a [Tooltip] Component. Currently
/// the only stand-alone tooltip component is the [MaterialInkTooltipComponent],
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
)
class ClickableTooltipTargetDirective extends TooltipBehavior
    implements AfterViewInit, OnDestroy {
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
    // Don't hide the tooltip if the user clicked an empty area on the page.
    if (event.relatedTarget == null) return;

    // Don't hide the tooltip if focus went to an element inside the tooltip.
    HtmlElement el;
    for (el = event.relatedTarget; el.parent != null; el = el.parent) {
      if (el.className == "acx-overlay-container") return;
    }

    hideTooltip(immediate: true);
  }

  void onClick() {
    _toggleVisibility();
  }

  void _toggleVisibility() {
    if (_tooltipVisible) {
      hideTooltip(immediate: true);
    } else {
      showTooltip();
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

/// Base class for tooltip targets.
///
/// This component is the target of alignment for a tooltip and
/// the object responsible for controlling a tooltip.
abstract class TooltipTarget extends PopupSourceDirective
    implements ReferenceDirective {
  Tooltip _tooltip;
  final ViewContainerRef viewContainerRef;
  final ElementRef _elementRef;

  TooltipTarget(DomPopupSourceFactory domPopupSourceFactory,
      this.viewContainerRef, this._elementRef)
      : super(
            domPopupSourceFactory, _elementRef, /* referenceDirective */ null);

  /// Sets the tooltip associated with this target.
  void setTooltip(Tooltip component) {
    _tooltip = component;
  }

  @override
  set popupId(String id) {
    super.popupId = id;
    if (id == null) return;
    _elementRef.nativeElement.setAttribute('aria-describedby', id);
  }
}
