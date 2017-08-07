// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import './module.dart';

/// The class applied to elements which have been themed, iff the dark theme is
/// active.
const darkThemeClass = 'acx-theme-dark';

/// Applies the dark theme class to an element, iff the dark theme is active.
///
/// Use in conjunction with `@include acx-theme-dark`
///
/// code:
///
///     MyComponent(AcxTheme acxTheme, ElementRef myElementRef) {
///       acxTheme.theme(myElementRef);
///     }
///
/// sass:
///
///    :host {
///      @include acx-theme-dark {
///        # set styles for dark theme
///      }
///    }
@Injectable()
class AcxDarkTheme {
  final bool _darkTheme;

  AcxDarkTheme(@Inject(darkThemeToken) @Optional() bool dark)
      : _darkTheme = dark ?? false;

  void theme(ElementRef element) {
    if (_darkTheme) {
      (element.nativeElement as HtmlElement).classes.add(darkThemeClass);
    }
  }

  void themeElement(HtmlElement element) {
    if (_darkTheme) {
      element.classes.add(darkThemeClass);
    }
  }

  bool get isDarkTheme => _darkTheme;
}

/// Sets the dark theme value for a subtree.
@Directive(
    selector: '[darkTheme]',
    providers: const [const Provider(darkThemeToken, useValue: true)])
class DarkThemeDirective {}
