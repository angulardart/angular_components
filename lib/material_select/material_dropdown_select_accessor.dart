// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import 'material_dropdown_select.dart';

/// [ControlValueAccessor] for material dropdown select which only allows a
/// single selection allowing integration with the angular forms API.
@Directive(
  selector: 'material-dropdown-select[ngModel]:not([multi]),'
      'material-dropdown-select[ngFormControl]:not([multi]),'
      'material-dropdown-select[ngControl]:not([multi]),',
  providers: const [
    const Provider(NG_VALUE_ACCESSOR,
        useExisting: DropdownSelectValueAccessor, multi: true)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class DropdownSelectValueAccessor extends BaseDropdownSelectValueAccessor
    implements ControlValueAccessor, OnDestroy {
  StreamSubscription _selectionChangesSub;
  DropdownSelectValueAccessor(MaterialDropdownSelectComponent select)
      : super(select, new SelectionModel.withList());

  @override
  void registerOnChange(callback) {
    _selectionChangesSub = selectionModel.selectionChanges.listen((_) {
      var value = (selectionModel.selectedValues == null ||
              selectionModel.selectedValues.isEmpty)
          ? null
          : selectionModel.selectedValues?.first;
      callback(value);
    });
  }

  @override
  void writeValue(newValue) {
    initializeSelectionModel();
    if (newValue != null) {
      selectionModel.select(newValue);
    } else {
      selectionModel.clear();
    }
  }

  @override
  void ngOnDestroy() {
    _selectionChangesSub?.cancel();
    super.ngOnDestroy();
  }
}

/// [ControlValueAccessor] for material dropdown select which only allows
/// multi-selection allowing integration with the angular forms API.
@Directive(
  selector: 'material-dropdown-select[multi][ngModel],'
      'material-dropdown-select[multi][ngControl],'
      'material-dropdown-select[multi][ngFormControl]',
  providers: const [
    const Provider(NG_VALUE_ACCESSOR,
        useExisting: MultiDropdownSelectValueAccessor, multi: true)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MultiDropdownSelectValueAccessor extends BaseDropdownSelectValueAccessor
    implements ControlValueAccessor, OnDestroy {
  var selectionChangesSub;

  MultiDropdownSelectValueAccessor(MaterialDropdownSelectComponent select)
      : super(select, new MultiSelectionModel());

  @override
  void registerOnChange(callback) {
    selectionChangesSub = selectionModel.selectionChanges.listen((_) {
      callback(selectionModel.selectedValues?.toList());
    });
  }

  @override
  void writeValue(newValue) {
    initializeSelectionModel();
    selectionModel.clear();
    if (newValue == null) return;
    assert(newValue is Iterable, 'Multi select must be backed by an iterable');
    for (final value in newValue) {
      selectionModel.select(value);
    }
  }

  @override
  void ngOnDestroy() {
    selectionChangesSub?.cancel();
    super.ngOnDestroy();
  }
}

/// Base [ControlValueAccessor] for material dropdown select for common logic
/// between single, and multiple selection dropdowns.
abstract class BaseDropdownSelectValueAccessor
    implements ControlValueAccessor, OnDestroy {
  final MaterialDropdownSelectComponent _select;
  @protected
  final SelectionModel selectionModel;
  StreamSubscription _visibileSub;
  bool initialized = false;

  BaseDropdownSelectValueAccessor(this._select, this.selectionModel);

  @protected
  initializeSelectionModel() {
    if (initialized) return;
    initialized = true;
    assert(_select.selection == null,
        'Cannot set [selection] when using a Dropdown control value accessor.');
    _select.selection = selectionModel;
  }

  @override
  void registerOnTouched(callback) {
    _visibileSub = _select.visibleStream.listen((_) {
      // We only need the first event. Cancel the subscription.
      _visibileSub.cancel();
      callback();
    });
  }

  @override
  void ngOnDestroy() {
    _visibileSub?.cancel();
  }
}
