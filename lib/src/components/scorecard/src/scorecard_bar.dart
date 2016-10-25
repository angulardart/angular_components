// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import '../../../utils/browser/dom_service/angular_2.dart';
import '../../../utils/disposer/disposer.dart';
import 'package:angular2/angular2.dart';

/// Private directive that catches the scorecard bar element of the scoreboard.
/// Also provides convenient methods for handling scrolling on it.
@Directive(selector: '[scorecardBar]')
class ScorecardBarDirective implements OnInit, OnDestroy {
  final _refreshController = new StreamController<bool>.broadcast();
  final _disposer = new Disposer.oneShot();
  final HtmlElement _element;
  final DomService _domService;

  bool _isRtl;
  int _clientWidth;
  int _scrollWidth;
  int _scrollingMove;
  int _transform = 0;
  int _buttonWidth = 0;

  ScorecardBarDirective(this._domService, ElementRef elementRef)
      : _element = elementRef.nativeElement;

  @override
  void ngOnInit() {
    _isRtl = _element.getComputedStyle().direction == 'rtl';
    _disposer.addDisposable(_domService.scheduleRead(_readElement));
    _disposer.addDisposable(
        _domService.trackLayoutChange(() => _element.parent.clientWidth, (_) {
      _readElement();
      _refreshController.add(true);
    }, runInAngularZone: true));
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  /// Stream to indicate when the scoreboard arrows should be refreshed.
  ///
  /// This includes after user has clicked on left or right buttons, and when
  /// the window has been resized.
  Stream<bool> get refreshStream => _refreshController.stream;

  bool get isRtl => _isRtl;

  bool get isScrollable =>
      _clientWidth != null &&
      _scrollWidth != null &&
      _clientWidth < _scrollWidth;

  bool get atStart => _transform == 0;

  bool get atEnd => _clientWidth != null
      ? _transform.abs() + _clientWidth >= _scrollWidth
      : false;

  void scrollLeft() {
    _disposer.addDisposable(_domService.scheduleRead(() {
      _readElement();
      var newValue = _scrollingMove;
      assert(_buttonWidth > 0);
      if (atEnd) newValue -= _buttonWidth;
      if (_transform.abs() - newValue < 0) {
        newValue = _transform.abs();
      }
      _transform += newValue;
      _updateTransform();
    }));
  }

  void scrollRight() {
    _disposer.addDisposable(_domService.scheduleRead(() {
      _readElement();
      var newValue = _scrollingMove;
      assert(_buttonWidth > 0);
      if (atStart) newValue -= _buttonWidth;
      if (_scrollWidth + _transform < newValue + _clientWidth) {
        newValue = _scrollWidth + _transform - _clientWidth;
      }
      _transform -= newValue;
      _updateTransform();
    }));
  }

  void _updateTransform() {
    _disposer.addDisposable(_domService.scheduleWrite(() {
      _element.style.transform = 'translateX(${_transform}px)';
      _refreshController.add(true);
    }));
  }

  void reset() {
    if (_transform != 0) {
      _transform = 0;
      _updateTransform();
    }
    _disposer.addDisposable(_domService.scheduleRead(() {
      _readElement();
      _refreshController.add(true);
    }));
  }

  void _readElement() {
    assert(_domService.isReadingDom);
    _clientWidth = _element.parent.clientWidth;
    _scrollWidth = _element.scrollWidth;
    // Get scroll button width.
    if (_buttonWidth == 0) {
      ElementList buttons =
          _element.parent.querySelectorAll(':scope > material-button');
      for (var button in buttons) {
        var width = button.getComputedStyle().width;
        if (width != 'auto') {
          _buttonWidth = double
              .parse(width.replaceAll(new RegExp('[^0-9.]'), ''), (_) => 0.0)
              .floor();
          break;
        }
      }
    }
    if (_element.children.isNotEmpty && _scrollWidth > 0) {
      var avg = _scrollWidth / _element.children.length;
      var temp = ((_clientWidth - _buttonWidth * 2) / avg).floor();
      _scrollingMove = (temp * avg).floor();
    } else {
      _scrollingMove = _clientWidth;
    }
  }
}
