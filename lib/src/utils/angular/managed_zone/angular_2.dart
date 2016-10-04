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

library angular2_components.utils.angular.managed_zone.angular_2;

import 'dart:async';

import 'package:angular2/di.dart';

import 'src/managed_zone.dart';

export 'src/managed_zone.dart';

/// An implementation of [ManagedZone] that uses Angular 2's [NgZone].
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
      _ngZone.onUnstable.listen(capturedTurnStart);
      _ngZone.onMicrotaskEmpty.listen(capturedTurnDone);
      _ngZone.onStable.listen(capturedEventDone);
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
  /*=T*/ runInside/*<T>*/(/*=T*/ fn()) => _ngZone.run(fn);

  @override
  /*=T*/ runOutside/*<T>*/(/*=T*/ fn()) =>
      _ngZone.runOutsideAngular(fn) as dynamic/*=T*/;
}
