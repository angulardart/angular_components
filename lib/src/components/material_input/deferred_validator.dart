// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
  _ValidatorFn _validator;

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
