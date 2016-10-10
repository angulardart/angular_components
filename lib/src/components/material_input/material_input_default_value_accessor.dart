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

  MaterialInputDefaultValueAccessor(
      this._input, @Self() @Optional() NgControl cd) {
    // To get around a circular dependency injection assign the valueAccessor
    // ourselves.
    cd?.valueAccessor = this;
    _disposer.addFunction(() {
      // Kill the control's handle on this accessor directive so that it can be
      // GC'ed.
      cd?.valueAccessor = null;
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
  void registerOnTouched(_) {} // onTouched API is not supported for now.

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}

/// Copy of NgModel with a different selector and sync update stream.
///
/// This is to allow for transition away from
/// [MaterialInputDefaultValueAccessor] being a model, and the accessor. Also
/// allows moving to the more standard [NgModel].
/// Needed until everything can be renamed to use ngModel instead.
@Directive(
    selector: "material-input[inputText]:not([ngModel])"
        ":not([ngControl]):not([ngFormControl])",
    providers: const [const Provider(NgControl, useExisting: InputTextModel)],
    inputs: const ["model: inputText"],
    outputs: const ["update: inputTextChange"],
    exportAs: "ngForm")
class InputTextModel extends NgModel implements OnChanges {
  InputTextModel(
      @Optional()
      @Self()
      @Inject(NG_VALIDATORS)
          validators,
      @Optional()
      @Self()
      @Inject(NG_ASYNC_VALIDATORS)
          asyncValidators,
      @Optional()
      @Self()
      @Inject(NG_VALUE_ACCESSOR)
          List<ControlValueAccessor> valueAccessors)
      : super(validators, asyncValidators, valueAccessors);
  @override
  ngOnChanges(Map<String, SimpleChange> changes) {
    super.ngOnChanges(changes);
  }
}
