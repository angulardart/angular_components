// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';

import '../../utils/disposer/disposer.dart';

import 'base_material_input.dart';

/// The default accessor for writing a [String] value and listening to changes
/// that is used by [MaterialInputComponent].
// TODO(google): add material-input:not([type]) once other value accessors are
// implemented.
@Directive(selector: 'material-input')
class MaterialInputDefaultValueAccessor
    implements ControlValueAccessor, OnDestroy {
  final _disposer = new Disposer.oneShot();

  final BaseMaterialInput _input;
  final NgControl _cd;

  MaterialInputDefaultValueAccessor(this._input, @Self() @Optional() this._cd) {
    // To get around a circular dependency injection assign the valueAccessor
    // ourselves.
    _cd?.valueAccessor = this;
    _disposer.addFunction(() {
      // Kill the control's handle on this accessor directive so that it can be
      // GC'ed.
      _cd?.valueAccessor = null;
    });
  }

  @override
  void writeValue(newValue) {
    _input.inputText = newValue;
  }

  @override
  void registerOnChange(callback) {
    _disposer.addStreamSubscription(
        _input.onKeypress.listen((value) => callback(value)));
  }

  @override
  void registerOnTouched(callback) {
    _disposer.addStreamSubscription(_input.onBlur.take(1).listen((_) {
      callback();
    }));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
