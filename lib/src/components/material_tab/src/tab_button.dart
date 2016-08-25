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

import '../../material_button/material_button_base.dart';
import '../../material_ripple/material_ripple.dart';

/// A specialized button component used only by the tab strip.
@Component(
    selector: 'tab-button',
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
class TabButtonComponent extends MaterialButtonBase {
  final Element _nativeElement;
  String _label;
  int _textWidth = 0;

  TabButtonComponent(ElementRef element)
      : _nativeElement = element.nativeElement as Element,
        super(element);

  /// Label of the button.
  @Input()
  set label(String label) {
    _textWidth = 0;
    _label = label;
  }

  String get label => _label;

  /// The width of the text without any constraints as if no width was set.
  int get textWidth => _textWidth;

  /// These getters should ideally be used inside dom_service schedule read.
  String get width => _nativeElement.style.width;
  int get offsetWidth => _nativeElement.offsetWidth;
  int get offsetLeft => _nativeElement.offsetLeft;
  void updateTextWidth() {
    if (_textWidth == 0) {
      _textWidth = offsetWidth;
    }
  }

  /// Theses should ideally be used inside dom_service schedule write.
  set width(String width) => _nativeElement.style.width = width;
  void tryClearWidth() {
    if (_textWidth == 0 && !width.isEmpty) {
      width = '';
    }
  }
}
