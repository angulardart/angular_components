// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'base_material_input.dart';

/// [ControlValueAccessor] for [MaterialInputComponent] that updates on
/// keypress.
///
/// Note: This is less accessible since any errors that are produced by the
/// input are shown immediately which is distracting when using a screen reader.
/// instead please consider using [blurUpdate] which only shows errors after
/// a blur event.
// TODO(google): Migrate away from this being the default accessor.
@Directive(
  selector: 'material-input:not([blurUpdate]):not([changeUpdate])',
)
class MaterialInputDefaultValueAccessor
    extends BaseMaterialInputValueAccessor<String> {
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
@Directive(
  selector: 'material-input[blurUpdate]',
)
class MaterialInputBlurValueAccessor
    extends BaseMaterialInputValueAccessor<String> {
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

/// [ControlValueAccessor] to be used with a [MaterialInputComponent] that
/// updates on change.
@Directive(
  selector: 'material-input[changeUpdate]',
)
class MaterialInputChangeValueAccessor
    extends BaseMaterialInputValueAccessor<String> {
  MaterialInputChangeValueAccessor(
      BaseMaterialInput input, @Self() @Optional() NgControl control)
      : super(input, control);

  @override
  void registerOnChange(callback) {
    disposer.addStreamSubscription(input.onChange.listen((_) {
      if (input != null) callback(input.inputText);
    }));
  }
}

/// Common logic for a [ControlValueAccessor] for a
/// [BaseMaterialInputComponent].
abstract class BaseMaterialInputValueAccessor<T>
    implements ControlValueAccessor<T>, OnDestroy {
  @protected
  final disposer = Disposer.oneShot();
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
  void writeValue(T newValue) {
    input.inputText = formatValue(newValue);
  }

  /// Handles converting input value to [String].
  ///
  /// Override this if you need additional formatting for your value type, ex.
  /// if using a [NumberFormatter].
  String formatValue(T value) => '${value ?? ''}';

  @override
  void registerOnTouched(callback) {
    StreamSubscription sub;
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

  @override
  void onDisabledChanged(bool isDisabled) {
    input.disabled = isDisabled;
  }
}
