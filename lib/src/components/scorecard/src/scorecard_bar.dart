// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import '../../../utils/browser/dom_service/angular_2.dart';
import '../../../utils/disposer/disposer.dart';
import 'package:angular2/angular2.dart';

/// Private directive that catches the scorecard bar element of the scoreboard.
///
/// The directive's role is to handle scrolling within the scoreboard. It
/// provides convenience methods, such as for scrolling left and right, along
/// with computations for determining how far to scroll.
///
/// The rule for scrolling is that the scoreboard will try to scroll such
/// that for any card currently partially covered by a scroll button, it will
/// then finish the scroll with that card's border flush to the client edge.
/// For example, assume that a user clicks on the scroll right button. The
/// scoreboard will then scroll such that the card currently visible (and
/// furthest to the right) will then be the leftmost card after scrolling is
/// done. The reason for this is to make sure that as a user scrolls through the
/// cards, each cards will at one point be fully visible to the user. If we did
/// not take this precaution, then in some situations, some cards will always be
/// partially covered by the scroll buttons, regardless of how the user
/// scrolled.
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

  /// Whether the direction is right-to-left.
  // TODO(google):  Add support for ltr animated scrolling.
  bool get isRtl => _isRtl;

  /// Whether the scoreboard is in a scrollable state.
  ///
  /// Scoreboard is considered scrollable if the client width is less than the
  /// scrollwidth.
  bool get isScrollable =>
      _clientWidth != null &&
      _scrollWidth != null &&
      _clientWidth < _scrollWidth;

  /// Whether the scoreboard is at its starting scroll state.
  bool get atStart => _transform == 0;

  /// Whether the scoreboard is at its end scroll state.
  bool get atEnd => _clientWidth != null
      ? _transform.abs() + _clientWidth >= _scrollWidth
      : false;

  /// Scroll the scoreboard left.
  ///
  /// This should only be called when the scoreboard is not already in its
  /// start scroll state (e.g., [atStart] is false).
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

  /// Scroll the scoreboard right.
  ///
  /// This should only be called when the scoreboard is not already in its
  /// end scroll state (e.g., [atEnd] is false).
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

  /// Resets the scoreboard to its initial scroll state.
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

  void _updateTransform() {
    _disposer.addDisposable(_domService.scheduleWrite(() {
      _element.style.transform = 'translateX(${_transform}px)';
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
      // Find the average width of the cards. This assumes cards are of uniform
      // width (as required in ACUX specs).
      var avg = _scrollWidth / _element.children.length;
      var temp = ((_clientWidth - _buttonWidth * 2) / avg).floor();
      _scrollingMove = (temp * avg).floor();
    } else {
      _scrollingMove = _clientWidth;
    }
  }
}
