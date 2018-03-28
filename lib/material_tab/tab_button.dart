// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button_base.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/material_tab/tab_mixin.dart';

/// A specialized button component used only by the tab strip.
@Component(
  selector: 'tab-button',
  host: const {
    '[class.focus]': 'visualFocus',
    '[class.active]': 'isActive || isMouseDown',
    'role': 'tab'
  },
  template: r'''
          <div class="content">
            {{label}}
          </div>
          <material-ripple></material-ripple>
        ''',
  styleUrls: const ['tab_button.scss.css'],
  directives: const [MaterialRippleComponent],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class TabButtonComponent extends MaterialButtonBase with TabMixin {
  final Element _nativeElement;

  TabButtonComponent(this._nativeElement) : super(_nativeElement);

  @override
  Element get nativeElement => _nativeElement;

  /// Whether the tab represented by this button is currently active.
  @Input('active')
  bool isActive;
}
