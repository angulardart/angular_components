// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';
import '../../utils/disposer/disposer.dart';

import 'base_material_input.dart';

/// [ControlValueAccessor] for [MaterialInputComponent] that updates on
/// keypress.
// TODO(google): Migrate away from this being the default accessor.
@Directive(selector: 'material-input:not([blurUpdate])')
class MaterialInputDefaultValueAccessor extends BaseMaterialInputValueAccessor
    implements ControlValueAccessor, OnDestroy {
  MaterialInputDefaultValueAccessor(
      BaseMaterialInput input, @Self() @Optional() NgControl control)
      : super(input, control);

  @override
  void registerOnChange(callback) {
    disposer.addStreamSubscription(input.onKeypress.listen((value) {
      callback(value);
    }));
  }
}

/// [ControlValueAccessor] to be used with a [MaterialInputComponent] that
/// updates on blur.
@Directive(selector: 'material-input[blurUpdate]')
class MaterialInputBlurValueAccessor extends BaseMaterialInputValueAccessor
    implements ControlValueAccessor, OnDestroy {
  MaterialInputBlurValueAccessor(
      BaseMaterialInput input, @Self() @Optional() NgControl control)
      : super(input, control);

  @override
  void registerOnChange(callback) {
    disposer.addStreamSubscription(input.onBlur.listen((_) {
      if (input != null) callback(input.inputText);
    }));
  }
}

/// Common logic for a [ControlValueAccessor] for a
/// [BaseMaterialInputComponent].
abstract class BaseMaterialInputValueAccessor
    implements ControlValueAccessor, OnDestroy {
  @protected
  final disposer = new Disposer.oneShot();
  @protected
  final BaseMaterialInput input;
  final NgControl _cd;

  BaseMaterialInputValueAccessor(this.input, @Self() @Optional() this._cd) {
    // To get around a circular dependency injection assign the valueAccessor
    // ourselves.
    _cd?.valueAccessor = this;
    disposer.addFunction(() {
      // Kill the control's handle on this accessor directive so that it can be
      // GC'ed.
      _cd?.valueAccessor = null;
    });
  }

  @override
  void writeValue(newValue) {
    input.inputText = newValue;
  }

  @override
  void registerOnTouched(callback) {
    var sub;
    sub = input.onBlur.listen((_) {
      sub.cancel(); // We only need the first event. Cancel the subscription.
      callback();
    });
    disposer.addStreamSubscription(sub);
  }

  @override
  void ngOnDestroy() {
    disposer.dispose();
  }
}
