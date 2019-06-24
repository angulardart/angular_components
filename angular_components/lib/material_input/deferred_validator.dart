// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

typedef _ValidatorFn = Map<String, dynamic> Function(AbstractControl c);

/// A validator that defers to another delegator.
///
/// Useful when a component class also serves as a validator. If the component
/// needs to inject [NgControl] it could end up depending on itself if it binds
/// itself to [NG_VALIDATORS]. Instead, it could bind this class, inject it and
/// set itself to [delegate] field.
@Injectable()
class DeferredValidator {
  // Use list instead of set so that don't need to conver for the compose
  // function.
  final List<_ValidatorFn> _delegates = <_ValidatorFn>[];
  _ValidatorFn _validator;

  void add(_ValidatorFn validation) {
    // Shouldn't add the same validator
    assert(!_delegates.contains(validation));
    _delegates.add(validation);
    _validator = null; // Reset the validator so that is is rebuilt.
  }

  void remove(_ValidatorFn validation) {
    assert(_delegates.contains(validation)); // Should contain the validator
    _delegates.remove(validation);
    _validator = null; // Reset the validator so that is is rebuilt.
  }

  Map<String, dynamic> call(AbstractControl control) {
    if (_validator == null) {
      final numDelegates = _delegates.length;
      if (numDelegates == 0) return null; // No validation needed
      // Set _validator once right before it is needed instead of on
      // every add/remove to increase performance. Also short circuit compose
      // when there is only one value as that has a performance cost.
      _validator =
          numDelegates > 1 ? Validators.compose(_delegates) : _delegates.single;
    }
    return _validator(control);
  }
}
