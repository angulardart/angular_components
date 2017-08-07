// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

// TODO(google): Remove this once use of '#' in a template is either
// consistent, or has a way to declare specifically what you want - e.g. the
// component instance or the element ref. Today, using # on an HTML element will
// be an elementRef, but # on a component will be a component instance.

/// Place on an element or component to expose the [ElementRef] as 'ref'.
///
/// Example usage:
///     <material-button ref #button="ref"></materialButton>
///     <!-- You can now use 'button' in this template as a property -->
@Directive(selector: '[ref]', exportAs: 'ref')
class ReferenceDirective {
  final ElementRef elementRef;

  ReferenceDirective(this.elementRef);
}
