// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../../laminate/popup/popup.dart';
import '../../../laminate/portal/portal.dart';

/// Works with the portal system to indicate where the popup contents should be
/// attached.
@Directive(selector: '[popupRef]')
class PopupRefDirective extends TemplatePortal {
  PopupRefDirective(TemplateRef templateRef, ViewContainerRef viewContainerRef)
      : super(templateRef, viewContainerRef);

  @Input()
  set popupRef(PopupRef popupRef) {
    if (popupRef != null) {
      popupRef.attach(this);
    } else if (isAttached) {
      detach();
    }
  }
}
