// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/angular/properties/properties.dart';
import '../content/deferred_content_aware.dart';

// When deferred content should be removed. Needs to be longer than the longest
// animation.
const animationDuration = const Duration(milliseconds: 500);

class MaterialDrawerBase implements DeferredContentAware, OnInit {
  MaterialDrawerBase(this._element, {bool visible = true}) : _visible = visible;

  final HtmlElement _element;

  bool _visible;

  /// Visibility of the drawer.
  bool get visible => _visible;

  @Input()
  set visible(Object o) {
    final value = getBool(o);
    if (value == _visible) return;
    _visible = value;

    if (!_visible) {
      // Wait until after the animation to remove the content
      new Timer(animationDuration, () {
        // Make sure we are still not visible incase the drawer was toggled
        // quickly before the animation was done.
        if (!_visible) _visibleChange.add(_visible);
      });
    } else {
      // Show the content right away when animating in
      _visibleChange.add(_visible);
    }
  }

  final _visibleChange = new StreamController<bool>.broadcast(sync: true);

  /// Event fired when the visibilty of the drawer changes.
  ///
  /// Note: does not fire until after the animation is complete.
  @Output('visibleChange')
  @override
  Stream<bool> get contentVisible => _visibleChange.stream;

  /// Toggle the drawer's visibility.
  void toggle() {
    visible = !visible;
  }

  @override
  ngOnInit() {
    _visibleChange.add(_visible);
  }
}
