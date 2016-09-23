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