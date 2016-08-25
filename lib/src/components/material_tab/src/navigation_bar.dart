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
import 'dart:html';

import 'package:angular2/angular2.dart';

import '../../../utils/browser/dom_service/dom_service.dart';

// Private directive that catches the navi bar element of the tab panel.
// Also provides convenient methods for handling scrolling on it.
@Directive(selector: '[naviBar]')
class NaviBarDirective implements OnDestroy {
  final Element _element;
  bool _isScrollable = false;
  bool _isRtl = false;
  StreamSubscription _layoutChangedSubscription;

  NaviBarDirective(ElementRef elementRef, @Optional() DomService domService)
      : _element = elementRef.nativeElement {
    if (domService != null) {
      _layoutChangedSubscription = domService.onLayoutChanged.listen((_) {
        domService.scheduleRead(() {
          _isScrollable = _element.clientWidth < _element.scrollWidth;
        });
      });
      domService.scheduleRead(() {
        _isRtl = _element.getComputedStyle().direction == 'rtl';
      });
    }
  }

  @override
  void ngOnDestroy() {
    _layoutChangedSubscription?.cancel();
  }

  bool get isRtl => _isRtl;

  bool get atStart => _element.scrollLeft == 0;
  bool get atEnd =>
      _element.scrollLeft.abs() + _element.clientWidth == _element.scrollWidth;

  bool get isScrollable => _isScrollable;

  void scrollLeft() {
    var newValue = _element.scrollLeft.abs() - _element.clientWidth;
    if (newValue < 0) newValue = 0;
    _element.scrollLeft = isRtl ? -newValue : newValue;
  }

  void scrollRight() {
    var newValue = _element.scrollLeft.abs() + _element.clientWidth;
    _element.scrollLeft = isRtl ? -newValue : newValue;
  }
}
