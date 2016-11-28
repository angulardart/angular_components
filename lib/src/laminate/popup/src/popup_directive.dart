// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_directive;

import 'dart:async';

import 'package:angular2/angular2.dart';

import './dom_popup_source.dart';
import './popup_controller_base.dart';
import './popup_ref.dart';
import './popup_service.dart';
import '../../portal/portal.dart';

/// An Angular directive that declaratively uses [PopupService].
///
/// All of the content inside this template directive is transcluded to the
/// application-level overlay container and positioned [relativeTo] another
/// component or DOM element.
///
/// Example usage:
///     <button #openBtn (click)="isVisible = !isVisible">Toggle Popup</button>
///     <template popup [relativeTo]="openBtn" [(visible)]="isVisible">
///       Hello World!
///     </template>
///
/// Events:
///   - `visible`: Triggers when popup visibility changes (after open/close).
///   - `open`: Triggers when the popup is trying to open.
///   - `close`: Triggers when the popup is trying to close.
///   - `ready`: Triggers when the popup has been created.
///
/// Properties:
///   - `alignX`: How the popup should align to the source on the x-axis
///   - `alignY`: How the popup should align to the source on the y-axis
///   - 'autoDismiss': Whether the popup should close when the document pressed
///   - `enforceSpaceConstraints`: Whether to move/resize based on content
///   - `matchSourceWidth`: Whether to set the width to the source element
///   - `offsetX`: A manual X-offset to apply to the position
///   - `offsetY`: A manual Y-offset to apply to the position
///   - `preferredPositions`: A manual list of preferred auto-alignments
///   - `relativeTo`: The source element
///   - `visible`: Whether to hide or show the popup
///
/// Child directives can inject [Future<PopupRef>] to receive a [Future] that
/// resolves once the popup is created and to directly interact with it.
@Directive(selector: '[popup]', outputs: const [
  'onVisible: visibleChange',
  'onOpen: open',
  'onClose: close',
  'onReady: ready'
], inputs: const [
  'alignX',
  'alignY',
  'autoDismiss',
  'enforceSpaceConstraints',
  'matchSourceWidth',
  'offsetX',
  'offsetY',
  'preferredPositions',
  'relativeTo',
  'trackLayoutChanges',
  'visible'
])
class PopupDirective extends TemplatePortal
    with PopupController
    implements OnDestroy {
  @override
  final DomPopupSourceFactory domPopupSourceFactory;

  @override
  final PopupService popupService;

  PopupDirective(TemplateRef templateRef, this.domPopupSourceFactory,
      this.popupService, ViewContainerRef viewContainerRef)
      : super(templateRef, viewContainerRef) {
    eagerPopupRefFuture.then(attachPortal);
  }

  void attachPortal(PopupRef popupRef) {
    setPaneId(popupRef);
    if (isDisposed) {
      return;
    }
    attachPopupContents(this, popupRef);
  }

  void setPaneId(PopupRef popupRef) {
    final parentEl = template.elementRef.nativeElement.parent;
    final id = popupRef.uniqueId.toString();
    parentEl.setAttribute('pane-id', id);
  }
}
