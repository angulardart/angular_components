// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

/// Return a string representing the encapsulated classes from [classes]
/// combined with the classes from [className].
///
/// This can be used to copy encapsulation scope of a component outside of the
/// component without copying any extra classes that might be on the host
/// element. Then ::ng-deep (through mixins) can be used in the host component
/// to style the popup without that style leaking to the whole application.
///
/// For example:
///  .myPopup {
///    // Mixin uses ::ng-deep but won't make all inputs blue. Instead just the
///    // popups that originate from this component that the `myPopup` class
///    // were added to.
///    @include mat-input-bg-color($mat-blue);
///  }
///
/// Dart Code:
///  final popupClass =
///      constructEncapsulatedCss('myPopup', _hostElement.classes);
String constructEncapsulatedCss(String className, CssClassSet classes) {
  var result = className ?? '';
  for (final i in classes) {
    // Add encapsulation classes from host
    if (i.startsWith('_ngcontent')) result += ' $i';
  }
  return result;
}
