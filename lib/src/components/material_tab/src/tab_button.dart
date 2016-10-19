// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../material_button/material_button_base.dart';
import '../../material_ripple/material_ripple.dart';
import './tab_mixin.dart';

/// A specialized button component used only by the tab strip.
@Component(
    selector: 'tab-button',
    inputs: const ['label'],
    outputs: const ['trigger'], // from [MaterialButtonBase]
    host: const {
      '[class.is-disabled]': 'disabled',
      '(mousedown)': r'onMouseDown($event)',
      '(mouseup)': r'onMouseUp($event)',
      '(click)': r'handleClick($event)',
      '(keypress)': r'handleKeyPress($event)',
      '(focus)': r'onFocus($event)',
      '(blur)': r'onBlur($event)',
      '[attr.aria-disabled]': 'disabledStr',
      '[attr.tabindex]': 'tabIndex',
      'role': 'tab'
    },
    template: r'''
          <div class="content">
            {{label}}
          </div>
          <material-ripple (mousedown)="onMouseDown($event)"
                           (mouseup)="onMouseUp($event)"
                           [focused]="visualFocus">
          </material-ripple>
        ''',
    styleUrls: const ['tab_button.scss.css'],
    directives: const [MaterialRippleComponent])
class TabButtonComponent extends MaterialButtonBase with TabMixin {
  final Element _nativeElement;

  TabButtonComponent(ElementRef element)
      : _nativeElement = element.nativeElement as Element,
        super(element);

  @override
  Element get nativeElement => _nativeElement;
}
