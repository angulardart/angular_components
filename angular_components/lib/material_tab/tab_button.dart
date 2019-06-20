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
  template: r'''
          <div class="content">
            {{label}}
          </div>
          <material-ripple></material-ripple>
        ''',
  styleUrls: ['tab_button.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [MaterialRippleComponent],
)
class TabButtonComponent extends MaterialButtonBase with TabMixin {
  final Element _nativeElement;

  TabButtonComponent(this._nativeElement) : super(_nativeElement, 'tab');

  @override
  Element get nativeElement => _nativeElement;

  /// Whether the tab represented by this button is currently active.
  @Input('active')
  bool isActive = false;

  @HostBinding('class.focus')
  bool get hostClassFocus => visualFocus;

  @HostBinding('class.active')
  bool get hostClassActive => isActive || isMouseDown;

  @HostBinding('attr.disabled')
  String get hostDisabled => disabled ? "" : null;
}
