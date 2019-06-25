// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

// These are necessary because 'const' functions don't yet exist within Dart.

/// Returns the current browser's [Document].
///
/// Visible for transformer only.
@Injectable()
HtmlDocument getDocument() => document;

/// Returns the current browser's [Window].
///
/// Visible for transformer only.
@Injectable()
Window getWindow() => window;

/// Provides [Document], [HtmlDocument], and [Window] bound for use
/// within Angular.
///
/// Ideally, an application would limit direct use of these to maintain
/// compatibility with web workers, but there is no Angular sanitized version
/// yet available.
const windowBindings = [
  // This strange syntax is required because we need windowBindings to be a
  // const list to be usable within component annotations.
  FactoryProvider(Document, getDocument),
  FactoryProvider(HtmlDocument, getDocument),
  FactoryProvider(Window, getWindow),
];

const windowModule = Module(provide: [
  FactoryProvider(Document, getDocument),
  FactoryProvider(HtmlDocument, getDocument),
  FactoryProvider(Window, getWindow),
]);

/// Returns the current [Window]'s location.
///
/// This mainly exists so that components can change the location without
/// requiring a mock [Window] in tests, which can be limiting since the [Window]
/// is used for much more than changing the location.
///
/// Visible for transformer only.
@Injectable()
Location getLocation(Window window) => window.location;

/// Provides [Location] bound for use within Angular.
const locationBindings = [
  FactoryProvider(Location, getLocation),
];
