// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';

import '../../model/ui/display_name.dart';
import '../../model/ui/has_renderer.dart';

/// Add this directive to any [SelectionContainer] or [SelectionItem]
/// component to render [HasUIDisplayName] objects.
@Directive(selector: '[displayNameRenderer]')
class DisplayNameRendererDirective {
  static final _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  DisplayNameRendererDirective(HasRenderer hasRenderer) {
    if (hasRenderer != null) hasRenderer.itemRenderer = _displayNameRenderer;
  }
}
