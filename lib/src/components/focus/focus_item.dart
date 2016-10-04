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

import 'dart:async';
import 'dart:html' show KeyboardEvent;

import 'package:angular2/angular2.dart';

import './focus.dart';
import '../../utils/async/async.dart';

/// `FocusItemDirective`, used in conjunction with [FocusListDirective],
/// provides a means to move focus between a list of components (or elements)
/// by way of keyboard interaction.
///
/// __Example Usage:__
///
///     <div focusList>
///       <div focusItem>Item 1</div>
///       <div focusItem>Item 2</div>
///       <div focusItem>Item 3</div>
///     </div>
///
@Directive(selector: '[focusItem]', host: const {
  '[attr.tabindex]': 'tabIndex',
  '(keydown)': r'keydown($event)'
}, providers: const [
  const Provider(FocusableItem, useExisting: FocusItemDirective)
])
class FocusItemDirective extends RootFocusable implements FocusableItem {
  FocusItemDirective(ElementRef element) : super(element);

  String tabIndex = "0";

  final _focusMoveCtrl =
      new LazyStreamController<FocusMoveEvent>.broadcast(sync: true);
  @override
  Stream<FocusMoveEvent> get focusmove => _focusMoveCtrl.stream;

  void keydown(KeyboardEvent event) {
    var focusEvent = new FocusMoveEvent.fromKeyboardEvent(this, event);
    if (focusEvent != null) {
      _focusMoveCtrl.add(focusEvent);
    }
  }

  @override
  set tabbable(bool value) {
    tabIndex = value ? "0" : "-1";
  }
}
