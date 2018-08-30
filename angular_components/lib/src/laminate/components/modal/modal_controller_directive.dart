// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/overlay/overlay.dart';
import 'package:angular_components/laminate/portal/portal.dart';

/// An internal directive that is used by the modal component to hoist content.
@Directive(
  selector: '[modalController]',
)
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
  @Input('modalController')
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
