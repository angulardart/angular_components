// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import '../../../laminate/popup/popup.dart'
    show DomPopupSourceFactory, PopupSourceDirective, PopupRef;
import '../../../model/action/delayed_action.dart';
import '../../../model/ui/toggle.dart';

const tooltipShowDelay = const Duration(milliseconds: 600);

/// An implementation of [PopupSourceDirective] that shows and hides the popup
/// on keyboard and mouse events.
///
/// The popup is shown after a delay on mouseover and keyboard focus. It is
/// hidden immediately on mouseleave and keyboard blur.
///
/// This directive makes use of the [Toggler] interface in order to get a
/// reference to the [PopupRef].
///
/// NOTE: This directive will be used in conjunction with tooltips once they are
/// made to be popups instead of just using popups.
@Directive(selector: '[tooltipSource]', exportAs: 'tooltipSource', host: const {
  '(mouseover)': 'onMouseOver()',
  '(mouseleave)': 'onMouseLeave()',
  '(focus)': r'onFocus()',
  '(blur)': 'onBlur()',
  '(keyup)': 'onKeyUp()',
  'tabindex': '0',
  'aria-label': 'tooltipLabel',
  '[attr.style]': "'cursor: pointer'"
})
class MaterialTooltipSourceDirective extends PopupSourceDirective
    implements Toggler, AfterViewInit, OnDestroy {
  final tooltipLabel = _tooltipLabel;
  final ElementRef elementRef;
  DelayedAction _show;

  // Whether the mouse is currently inside the component.
  bool _isMouseInside = false;

  MaterialTooltipSourceDirective(
      DomPopupSourceFactory domPopupSourceFactory, ElementRef elementRef)
      : this.elementRef = elementRef,
        super(domPopupSourceFactory, elementRef, null) {
    _show = new DelayedAction(tooltipShowDelay, activate);
  }

  /// Makes the tooltip appear.
  void activate() {
    _popupRef.isOn = true;
  }

  /// Makes the tooltip disappear.
  void deactivate() {
    _show.cancel();
    if (_popupRef.isOn) _popupRef.isOn = false;
  }

  bool _focusLatch = false;
  void onFocus() {
    _focusLatch = true;
  }

  void onBlur() {
    _focusLatch = false;
    deactivate();
  }

  void onKeyUp() {
    if (_focusLatch) {
      activate();
      _focusLatch = false;
    }
  }

  void onMouseOver() {
    if (_isMouseInside) return;
    _isMouseInside = true;
    _show.start();
  }

  void onMouseLeave() {
    _isMouseInside = false;
    deactivate();
  }

  @override
  set toggleable(Toggleable popupRef) {
    // This directive implements both [Toggler] and [PopupSource]. Upon seeing
    // that the source is an instance of [Toggler], the [PopupComponent] on
    // which both the Ink and Paper tooltip components are built registers the
    // [PopupRef] as a [Toggleable].
    _popupRef = popupRef;
  }

  Toggleable _popupRef;

  static String get _tooltipLabel => Intl.message(
      'Mouseover or press enter on this icon for more information.',
      name: 'MaterialTooltipSourceDirective__tooltipLabel',
      desc: 'Label for help icon which opens a help center tooltip.');
}
