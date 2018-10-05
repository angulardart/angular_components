// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/di.dart';
import 'package:angular_components/src/utils/angular/managed_zone/managed_zone.dart';

export 'package:angular_components/src/utils/angular/managed_zone/managed_zone.dart';

/// An implementation of [ManagedZone] that uses Angular 2's [NgZone].
@Deprecated('Use NgZone directly instead')
@Injectable()
class Angular2ManagedZone extends ManagedZoneBase {
  final NgZone _ngZone;

  bool _isDisposed = false;

  @override
  Zone innerZone;

  @override
  Zone outerZone;

  Angular2ManagedZone(this._ngZone) {
    _ngZone.runOutsideAngular(() {
      outerZone = Zone.current;
      _ngZone.onTurnStart.listen(capturedTurnStart);
      _ngZone.onMicrotaskEmpty.listen(capturedTurnDone);
      _ngZone.onTurnDone.listen(capturedEventDone);
    });
  }

  @override
  void capturedTurnDone(dynamic event) {
    if (_isDisposed) return;
    super.capturedTurnDone(event);
  }

  @override
  void capturedEventDone(dynamic event) {
    if (_isDisposed) return;
    super.capturedEventDone(event);
  }

  @override
  void dispose() {
    _isDisposed = true;
  }

  @override
  bool get inInnerZone => !inOuterZone;

  @override
  T runInside<T>(T fn()) => _ngZone.run(fn);

  @override
  T runOutside<T>(T fn()) => _ngZone.runOutsideAngular(fn);
}
