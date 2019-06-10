// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/laminate/overlay/constants.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/src/material_tooltip/tooltip_controller.dart';
import 'package:angular_components/model/action/delayed_action.dart';
import 'package:angular_components/utils/browser/events/events.dart';

import 'tooltip_source.dart' show tooltipShowDelay;

/// A directive that marks the target of a tooltip and handles showing and
/// hiding a tooltip on hover, click, and focus.
///
/// This directive is used in conjunction with a [Tooltip] Component. Such as
/// the [MaterialInkTooltipComponent], which gives full control over
/// the content of a simple tooltip.
@Directive(
  selector: '[tooltipTarget]',
  exportAs: 'tooltipTarget',
)
class MaterialTooltipTargetDirective extends TooltipBehavior
    implements AfterViewInit, OnDestroy {
  HtmlElement element;

  MaterialTooltipTargetDirective(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      this.element,
      ChangeDetectorRef changeDetector,
      @Attribute('initPopupAriaAttributes') String initAriaAttributes)
      : super(domPopupSourceFactory, viewContainerRef, element, changeDetector,
            initAriaAttributes);

  /// Show tooltip on focus to allow keyboard users to see tooltip contents.
  @visibleForTemplate
  @HostListener('focus')
  void onFocus() {
    showTooltipWithDelay();
  }

  @override
  void ngOnDestroy() {
    element = null;
  }
}

/// Class incorporating the common behavior of a [Directive] that marks the
/// target of a tooltip.
abstract class TooltipBehavior extends TooltipTarget {
  final _tooltipActivate = StreamController<bool>.broadcast(sync: true);
  final ChangeDetectorRef _changeDetector;
  DelayedAction _show;

  // Whether the mouse is currently inside the component.
  bool _isMouseInside = false;

  /// Event that fires when the tooltip is activated.
  @Output()
  Stream<bool> get tooltipActivate => _tooltipActivate.stream.distinct();

  TooltipBehavior(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      HtmlElement element,
      this._changeDetector,
      String initAriaAttributes)
      : super(domPopupSourceFactory, viewContainerRef, element,
            initAriaAttributes) {
    _show = DelayedAction(tooltipShowDelay, showTooltip);
  }

  @protected
  @visibleForTesting
  void showTooltipWithDelay() {
    _show.start();
  }

  void showTooltip() {
    _show.cancel(); // Cancel any pending actions if tooltip is shown early.
    _changeDetector.markForCheck();
    _tooltipActivate.add(true);
    _tooltip?.activate();
  }

  @HostListener('click')
  void onBlurOrClick() => hideTooltip();

  void hideTooltip({bool immediate = false}) {
    _show.cancel(); // Cancel any pending actions if tooltip is hidden early.
    _tooltipActivate.add(false);
    _tooltip?.deactivate(immediate: immediate);
  }

  @HostListener('mouseover')
  void onMouseOver() {
    if (_isMouseInside) return;
    _isMouseInside = true;
    showTooltipWithDelay();
  }

  @HostListener('mouseleave')
  void onMouseLeave() {
    _isMouseInside = false;
    hideTooltip();
  }

  /// Ensure the tooltip is deactivated when the popup closes.
  ///
  /// This is necessary because the popup can close itself and has no concept
  /// of tooltip activate / deactivate.
  @override
  void onClose() {
    super.onClose();
    hideTooltip(immediate: true);
  }

  @HostListener('blur')
  void onBlur(FocusEvent event) {
    // Don't hide the tooltip if the user clicked an empty area on the page.
    if (event.relatedTarget == null) return;

    // Don't hide the tooltip if focus went to an element inside the tooltip.
    HtmlElement el;
    for (el = event.relatedTarget; el.parent != null; el = el.parent) {
      if (el.className == overlayContainerClassName) return;
    }

    hideTooltip(immediate: true);
  }
}

/// A directive that marks the target of a tooltip and handles activating on
/// mouse over (with delay), click, enter, and space.
///
/// This directive is slightly different from [MaterialPaperTooltipComponent].
/// Click / key events open the tooltip with no delay, and tooltips do not open
/// on focus.
///
/// This directive is used in conjunction with a [Tooltip] Component. Such as
/// the [MaterialPaperTooltipComponent], which gives full control over the
/// content of a simple tooltip.
@Directive(
  selector: '[clickableTooltipTarget]',
  exportAs: 'tooltipTarget',
)
class ClickableTooltipTargetDirective extends TooltipBehavior
    implements AfterViewInit, OnDestroy {
  StreamSubscription _tooltipSubscription;
  HtmlElement element;
  bool _tooltipVisible = false;

  ClickableTooltipTargetDirective(
      DomPopupSourceFactory domPopupSourceFactory,
      ViewContainerRef viewContainerRef,
      this.element,
      ChangeDetectorRef changeDetector,
      @Attribute('initPopupAriaAttributes') String initAriaAttributes)
      : super(domPopupSourceFactory, viewContainerRef, element, changeDetector,
            initAriaAttributes) {
    _tooltipSubscription = tooltipActivate.listen((visible) {
      _tooltipVisible = visible;
    });
  }

  @HostListener('click')
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

  @HostListener('keypress')
  void kbTrigger(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER || isSpaceKey(event)) {
      _toggleVisibility();
      // Required to prevent window from scrolling.
      event.preventDefault();
    }
  }

  @override
  void ngOnDestroy() {
    element = null;
    _tooltipSubscription.cancel();
  }
}

/// Base class for tooltip targets.
///
/// This component is the target of alignment for a tooltip and
/// the object responsible for controlling a tooltip.
abstract class TooltipTarget extends PopupSourceDirective {
  Tooltip _tooltip;
  final ViewContainerRef viewContainerRef;
  final HtmlElement _element;
  String _previousDescribedbyId;

  TooltipTarget(DomPopupSourceFactory domPopupSourceFactory,
      this.viewContainerRef, this._element, String initAriaAttributes)
      : super(
            domPopupSourceFactory,
            _element,
            /* referenceDirective */ null,
            /* focusable */ null,
            initAriaAttributes);

  /// Sets the tooltip associated with this target.
  void setTooltip(Tooltip component) {
    _tooltip = component;
  }

  String _id;
  @override
  set popupId(String id) {
    super.popupId = id;
    _id = id;
    if (id == null) return;
  }

  @override
  void onOpen() {
    if (_id == null) return;
    _previousDescribedbyId = _element.getAttribute('aria-describedby');
    _element.setAttribute('aria-describedby', _id);
  }

  @override
  void onClose() {
    if (_id == null) return;
    if (_previousDescribedbyId != null) {
      _element.setAttribute('aria-describedby', _previousDescribedbyId);
    } else {
      _element.attributes.remove('aria-describedby');
    }
  }
}
