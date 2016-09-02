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

@JS()
library ads.acx.css.acux.zindexer;

import 'package:angular2/angular2.dart';
import 'package:js/js.dart';

import 'acux_css_const.dart';

@JS('acxZIndex')
external int get _currentZIndex;

@JS('acxZIndex')
external set _currentZIndex(int value);

/// This allows a monotonically increasing z-index for hoverable elements. This
/// works around the problem where setting a static z-index for newly shown
/// elements will sometimes show up underneath existing elements.
@Injectable()
class ZIndexer {
  // TODO(google): Replace this with support for shared z-index in particle overlays.
  static ZIndexer _currentInstance;

  static void _initZIndex() {
    if (_currentZIndex == null) {
       _currentZIndex = AcuxZIndexConsts.hoverableAutoIncrement;
    }
  }

  factory ZIndexer() {
    return _currentInstance ??= new ZIndexer._();
  }

  ZIndexer._() {
    _initZIndex();
  }

  /// Increment and get the current z-index.
  int pop() => ++_currentZIndex;

  /// Peek at the current z-index without changing it.
  int peek() => _currentZIndex;
}