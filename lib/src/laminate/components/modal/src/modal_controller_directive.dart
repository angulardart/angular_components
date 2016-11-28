// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.components.modal.src.modal_controller_directive;

import 'package:angular2/angular2.dart';

import '../../../overlay/overlay.dart';
import '../../../portal/portal.dart';

/// An internal directive that is used by the modal component to hoist content.
@Directive(
    selector: '[modalController]', inputs: const ['overlay: modalController'])
class ModalControllerDirective extends TemplatePortal implements OnDestroy {
  ModalControllerDirective(
      TemplateRef templateRef, ViewContainerRef viewContainerRef)
      : super(templateRef, viewContainerRef);

  @override
  void ngOnDestroy() {
    if (isAttached) {
      detach();
    }
  }

  /// Attaches content to the provided [overlayRef].
  set overlay(OverlayRef overlayRef) {
    if (overlayRef == null) {
      if (isAttached) {
        this.detach();
      }
    } else {
      overlayRef.attach(this);
    }
  }
}
