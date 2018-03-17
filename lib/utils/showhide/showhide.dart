// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:async/async.dart' show StreamQueue;
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';

/// Shows or hides the given HTML element based on an expression.
///
/// The element is shown or hidden by removing or adding the 'ng-hide' css
/// class at first, and 'ng-hidden' at the end of transition (or after 16ms
/// delay if no transition happened).
@Directive(
  selector: '[showhide]',
)
class ShowHideDirective implements OnInit, OnDestroy {
  static String NG_HIDE_CLASS = 'ng-hide';
  static String NG_HIDDEN_CLASS = 'ng-hidden';
  // time after transition started, when ng-hidden is added forcefully
  static int TRANSITION_TIMEOUT_MS = 16;

  final Element _element;
  final DomService _domService;
  StreamQueue<TransitionEvent> _transitionEndQueue;

  bool _initialized = false;
  bool _initialWritePending = false;
  bool _hiding = true;

  ShowHideDirective(this._element, this._domService) {
    _transitionEndQueue = new StreamQueue(_element.onTransitionEnd);
  }

  @override
  void ngOnInit() {
    _initialized = true;
  }

  @override
  void ngOnDestroy() {
    _stopHiding();
  }

  /// Fires when the hide styles are first applied to the element.
  @Output('hide')
  Stream<Element> get onHide => _onHide.stream;
  var _onHide = new StreamController<Element>.broadcast(sync: true);

  /// Fires when the show styles are first applied to the element.
  @Output('show')
  Stream<Element> get onShow => _onShow.stream;
  var _onShow = new StreamController<Element>.broadcast(sync: true);

  /// Fires when the transitions have finished and the element is fully visible.
  @Output('showEnd')
  Stream<Element> get onShowEnd => _onShowEnd.stream;
  var _onShowEnd = new StreamController<Element>.broadcast(sync: true);

  /// Fires when the transitions have finished and the element is fully hidden.
  @Output('hideEnd')
  Stream<Element> get onHideEnd => _onHideEnd.stream;
  var _onHideEnd = new StreamController<Element>.broadcast(sync: true);

  @Input('showhide')
  set visible(bool value) {
    if (_initialized) {
      value ? _show() : _hide();
    } else {
      _initialWritePending = true;
      _domService.scheduleWrite(() {
        _element.classes.toggle(NG_HIDE_CLASS, !value);
        _element.classes.toggle(NG_HIDDEN_CLASS, !value);
        _initialWritePending = false;
      });
    }
  }

  void _show() {
    _stopHiding();
    _domService.scheduleRead(() {
      if (_initialWritePending || _element.classes.contains(NG_HIDDEN_CLASS)) {
        _domService.scheduleWrite(() {
          _element.classes.remove(NG_HIDDEN_CLASS);
        });
        // remove the ng-hide class in the next event loop, so that effects of
        // removing ng-hidden can settle (like changing display from none to
        // block)
        _domService.nextFrame.then((_) {
          _removeNgHide();
        });
      } else {
        _removeNgHide();
      }
    });
  }

  void _removeNgHide() {
    if (_hiding) return;
    _domService.scheduleWrite(() {
      _element.classes.remove(NG_HIDE_CLASS);
      _onShow.add(_element);
    });
    _onTransitionEnd(() {
      _onShowEnd.add(_element);
    });
  }

  void _onTransitionEnd(void callback()) {
    _domService.scheduleRead(() {
      bool finished = false;
      void complete([_]) {
        if (!finished) {
          finished = true;
          callback();
        }
      }

      int duration = _transitionDurationMs(_element);
      if (duration > 0) {
        _transitionEndQueue.next.then(complete);
      }
      // if the transition wasn't started because the hidden element already
      // have the same properties, hide it manually
      Duration timeout =
          new Duration(milliseconds: duration + TRANSITION_TIMEOUT_MS);
      new Future.delayed(timeout, complete);
    });
  }

  void _hide() {
    _hiding = true;
    _domService.scheduleWrite(() {
      _element.classes.add(NG_HIDE_CLASS);
      _onHide.add(_element);
    });
    _onTransitionEnd(_hideIfHiding);
  }

  /// Hides the element if it is in hiding state. It may not be if hiding was
  /// canceled before this is invoked.
  void _hideIfHiding() {
    if (_hiding) {
      _domService.scheduleWrite(() {
        _element.classes.add(NG_HIDDEN_CLASS);
      });
      _onHideEnd.add(_element);
      _hiding = false;
    }
    _stopHiding();
  }

  void _stopHiding() {
    _hiding = false;
  }

  static int _transitionDurationMs(Element element) {
    String duration = element.getComputedStyle().transitionDuration;
    if (duration == null || duration.isEmpty) return 0;

    // TODO(google): remove this when
    // https://code.google.com/p/dart/issues/detail?id=16059 is fixed
    Match matches = new RegExp(r"([0-9.]+)([ms]+)").matchAsPrefix(duration);
    if (matches == null || matches.groupCount < 2) return 0;

    double value = double.parse(matches[1]);
    String unit = matches[2];
    if (unit == "s") return (value * 1000).floor();
    if (unit == "ms") return value.floor();
    return 0;
  }
}
