// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus.dart';

/// Used in conjunction with other components to allow tagging view or content
/// elements that should be focused either by index or [key].
@Directive(
  selector: '[focusActivableItem]',
  providers: [
    ExistingProvider(FocusableActivateItem, FocusActivableItemDirective)
  ],
)
class FocusActivableItemDirective extends RootFocusable
    implements FocusableActivateItem {
  /// Key to assign to the focusable item.
  @Input('focusActivableItem')
  @override
  String key;

  FocusActivableItemDirective(HtmlElement root) : super(root);
}

/// A focusable component with a matching [key].
abstract class FocusableActivateItem implements Focusable {
  String get key;
}
