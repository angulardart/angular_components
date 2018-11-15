// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/di.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';

/// A mixin to provide a simplier API for accepting [SelectionModel] and
/// [SelectionOptions] for [SelectionContainer] components.
abstract class SelectionInputAdapter<T> implements SelectionContainer<T> {
  StreamController _selectionChangeController;

  void _initSelectionModel() {
    selection ??= SelectionModel.single();
  }

  /// Emits the selected value(s) whenever selection changes.
  ///
  /// For single select, it will either be the selected value or null.
  /// For multi select, it will a list of selected values or an empty list.
  @Output()
  Stream get selectionChange {
    if (_selectionChangeController == null) {
      _selectionChangeController = StreamController();
    }
    _initSelectionModel();
    return _selectionChangeController.stream;
  }

  @protected
  void emitSelectionChange() {
    if (_selectionChangeController == null) return;
    if (selection is SingleSelectionModel<T>) {
      _selectionChangeController.add(selection.selectedValues.isNotEmpty
          ? selection.selectedValues.first
          : null);
    } else {
      _selectionChangeController.add(selection.selectedValues);
    }
  }

  /// Sets the selected value or selection model for the selection component.
  ///
  /// Accepts either a [SelectionModel], a selected value or null.
  @Input('selection')
  set selectionInput(dynamic value) {
    if (value is SelectionModel<T>) {
      selection = value;
      return;
    }
    _initSelectionModel();
    if (value == null) {
      selection.clear();
    } else {
      assert(
          selection is SingleSelectionModel<T>,
          'Passing selected value through `selection` input is only supported '
          'for single select.');
      selection.select(value);
    }
  }

  /// Sets the available options for the selection component.
  ///
  /// Accepts either a [SelectionOptions] or a [List]. If a [List] is passed,
  /// the [StringSelectionOptions] class will be used to create the selection
  /// options.
  set optionsInput(dynamic value) {
    if (value == null || value is SelectionOptions<T>) {
      options = value;
    } else if (value is List<T>) {
      options = StringSelectionOptions(value, toFilterableString: itemRenderer);
    } else {
      throw ArgumentError(
          'Unsupported selection options type; value must be null, '
          'SelectionOptions<$T>, or List<$T>, but is ${value.runtimeType}');
    }
  }
}
