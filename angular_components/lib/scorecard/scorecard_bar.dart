// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

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
// TODO(google): move this file to a shared common directory.
@Directive(
  selector: '[scorecardBar]',
)
class ScorecardBarDirective implements OnInit, OnDestroy, AfterViewChecked {
  final _refreshController = StreamController<bool>.broadcast();
  final _disposer = Disposer.oneShot();
  final HtmlElement _element;
  final DomService _domService;

  bool _isRtl;
  bool _isVertical;
  int _clientSize;
  int _scrollSize;
  int _scrollingMove;
  int _transform = 0;
  int _buttonSize = 0;

  ScorecardBarDirective(
    this._domService,
    this._element,
    @Optional() @Inject(rtlToken) bool isRtl,
  ) {
    _isRtl = isRtl ?? false;
  }

  @override
  void ngOnInit() {
    _disposer.addDisposable(_domService.scheduleRead(_readElement));
    _disposer.addDisposable(_domService.trackLayoutChange(
        () => currentClientSize.toString() + ' ' + currentScrollSize.toString(),
        (_) {
      _readElement(windowResize: true);
      _refreshController.add(true);
    }, runInAngularZone: true));
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  @override
  void ngAfterViewChecked() {
    _getButtonSize();
  }

  /// Stream to indicate when the scoreboard arrows should be refreshed.
  ///
  /// This includes after user has clicked on left or right buttons, and when
  /// the window has been resized.
  Stream<bool> get refreshStream => _refreshController.stream;

  /// Whether the scrollbar is aligned vertically.
  @Input()
  set isVertical(value) {
    _isVertical = value;
  }

  /// Whether the scoreboard is in a scrollable state.
  ///
  /// Scoreboard is considered scrollable if the client size is less than the
  /// scroll size.
  bool get isScrollable =>
      _clientSize != null && _scrollSize != null && _clientSize < _scrollSize;

  /// Whether the scoreboard is at its starting scroll state.
  bool get atStart => _transform == 0;

  /// Whether the scoreboard is at its end scroll state.
  bool get atEnd => _clientSize != null
      ? _transform.abs() + _clientSize >= _scrollSize
      : false;

  /// Whether the scoreboard will reach its starting scroll state in at most one
  /// backwards movement.
  bool get nearStart => _transform.abs() - _scrollingMove <= 0;

  /// Whether the scoreboard will reach its ending scroll state in at most one
  /// forwards movement.
  bool get nearEnd => _clientSize != null
      ? _transform.abs() + _clientSize + _scrollingMove >= _scrollSize
      : false;

  /// The current size of the client.
  ///
  /// Depends upon orientation of scrollbar.
  int get currentClientSize =>
      _isVertical ? _element.parent.clientHeight : _element.parent.clientWidth;

  /// The current size of the scrollbar.
  ///
  /// Depends upon orientation of scrollbar.
  int get currentScrollSize =>
      _isVertical ? _element.scrollHeight : _element.scrollWidth;

  /// The axis upon which transforms should occur.
  ///
  /// Depends upon orientation of scrollbar.
  String get transformAxis => _isVertical ? 'Y' : 'X';

  /// Get the current transform of scorecard bar in pixels.
  int get currentTransformSize => _transform.abs();

  /// Returns the size of the current buttons
  int get currentButtonSize => _buttonSize;

  /// Scroll the scoreboard back.
  ///
  /// This should only be called when the scoreboard is not already in its
  /// start scroll state (e.g., [atStart] is false).
  void scrollBack() {
    _disposer.addDisposable(_domService.scheduleRead(() {
      _readElement();
      var newValue = _scrollingMove;
      assert(_buttonSize > 0);
      if (atEnd) newValue -= _buttonSize;
      if (_transform.abs() - newValue < 0) {
        newValue = _transform.abs();
      }
      if (_isVertical || !_isRtl) {
        _transform += newValue;
      } else {
        _transform -= newValue;
      }
      _updateTransform();
    }));
  }

  /// Scroll the scoreboard forward.
  ///
  /// This should only be called when the scoreboard is not already in its
  /// end scroll state (e.g., [atEnd] is false).
  void scrollForward() {
    _disposer.addDisposable(_domService.scheduleRead(() {
      _readElement();
      var newValue = _scrollingMove;
      assert(_buttonSize > 0);
      if (atStart) newValue -= _buttonSize;
      if (_scrollSize + _transform < newValue + _clientSize) {
        newValue = _scrollSize + _transform - _clientSize;
      }
      if (_isVertical || !_isRtl) {
        _transform -= newValue;
      } else {
        _transform += newValue;
      }
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
      _element.style.transform = 'translate$transformAxis(${_transform}px)';
      _refreshController.add(true);
    }));
  }

  void _readElement({windowResize = false}) {
    assert(_domService.isReadingDom);
    _clientSize = currentClientSize;
    _scrollSize = currentScrollSize;

    if (windowResize && !isScrollable && _transform != 0) {
      // Window has been resized such that scrolling is not needed. Reset
      // the transform shift so scoreboard moves back to original position.
      reset();
      return;
    }

    _getButtonSize();

    if (_element.children.isNotEmpty && _scrollSize > 0) {
      // Find the average size of the cards. This assumes cards are of uniform
      // size (as required in ACUX specs).
      var avg = _scrollSize / _element.children.length;
      if (_clientSize < avg) {
        _scrollingMove = _clientSize;
      } else {
        var temp = ((_clientSize - _buttonSize * 2) / avg).floor();
        _scrollingMove = (temp * avg).floor();
      }
    } else {
      _scrollingMove = _clientSize;
    }
  }

  /// Sets the value of _buttonSize to an integer representation of the height
  /// or width depending on the scrollbar orientation.
  void _getButtonSize() {
    // Get scroll button size.
    if (_buttonSize == 0) {
      final buttons = _element.parent.querySelectorAll('.scroll-button');
      for (var button in buttons) {
        var dimension = _isVertical ? 'height' : 'width';
        var size = button.getComputedStyle().getPropertyValue(dimension);
        if (size != 'auto') {
          final parsed =
              double.tryParse(size.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0;
          _buttonSize = parsed.floor();
          break;
        }
      }
    }
  }
}
