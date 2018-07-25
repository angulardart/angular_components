// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content_aware.dart';

// When deferred content should be removed. Needs to be longer than the longest
// animation.
const animationDuration = Duration(milliseconds: 500);

class MaterialDrawerBase implements DeferredContentAware, OnInit {
  MaterialDrawerBase({bool visible = true}) : _visible = visible;

  bool _visible;

  bool get visible => _visible;

  /// Visibility of the drawer.
  @Input()
  set visible(bool value) {
    if (value == _visible) return;
    _visible = value;

    if (!_visible) {
      // Wait until after the animation to remove the content
      Timer(animationDuration, () {
        // Make sure we are still not visible in case the drawer was toggled
        // quickly before the animation was done.
        if (!_visible) _visibleChange.add(_visible);
      });
    } else {
      // Show the content right away when animating in
      _visibleChange.add(_visible);
    }
  }

  final _visibleChange = StreamController<bool>.broadcast(sync: true);

  /// Event fired when the visibility of the drawer changes.
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
