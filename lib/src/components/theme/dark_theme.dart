// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:html';

import 'package:angular2/angular2.dart';

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

  bool get isDarkTheme => _darkTheme;
}

/// Sets the dark theme value for a subtree.
@Directive(
    selector: '[darkTheme]',
    providers: const [const Provider(darkThemeToken, useValue: true)])
class DarkThemeDirective {}
