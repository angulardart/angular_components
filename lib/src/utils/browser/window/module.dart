// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.utils.browser.window.module;

import 'dart:html';

import 'package:angular2/angular2.dart';

// These are necessary because 'const' functions don't yet exist within Dart.

/// Returns the current browser's [Document].
///
/// Visible for transformer only.
@Injectable()
Document getDocument() => document;

/// Returns the current browser's [Window].
///
/// Visible for transformer only.
@Injectable()
Window getWindow() => window;

/// Provides [Document] and [Window] bound for use within Angular.
///
/// Ideally, an application would limit direct use of these to maintain
/// compatibility with web workers, but there is no Angular sanitized version
/// yet available.
const windowBindings = const [
  // This strange syntax is required because we need windowBindings to be a
  // const list to be usable within component annotations.
  const Provider(Document, useFactory: getDocument),
  const Provider(Window, useFactory: getWindow)
];
