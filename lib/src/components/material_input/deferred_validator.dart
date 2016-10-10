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

import 'package:angular2/angular2.dart';

typedef Map<String, dynamic> _ValidatorFn(AbstractControl c);

/// A validator that defers to another delegator.
///
/// Useful when a component class also serves as a validator. If the component
/// needs to inject [NgControl] it could end up depending on itself if it binds
/// itself to [NG_VALIDATORS]. Instead, it could bind this class, inject it and
/// set itself to [delegate] field.
@Injectable()
class DeferredValidator {
  final Set<_ValidatorFn> _delegates = new Set.identity();
  _ValidatorFn _validator = null;

  void add(_ValidatorFn validation) {
    _delegates.add(validation);
    _validator = Validators.compose(_delegates.toList());
  }

  void remove(_ValidatorFn validation) {
    assert(_delegates.remove(validation)); // Makes sure a function is removed.
    if (_delegates.isEmpty) {
      _validator = null;
    } else {
      _validator = Validators.compose(_delegates.toList());
    }
  }

  Map<String, dynamic> call(AbstractControl control) {
    if (_validator == null) {
      return null; // Component was destroyed, but not cleaned up yet.
    }
    return _validator(control);
  }
}
