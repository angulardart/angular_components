// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

import '../../model/selection/selection_model.dart';
import '../../model/selection/selection_options.dart';
import './activation_handler.dart';

/// Handles toggling selection of a range of options when shift is held down
/// while clicking on the end value.
abstract class ShiftClickSelectionMixin<T> implements ActivationHandler<T> {
  T _pivot;

  SelectionModel<T> get selection;
  SelectionOptions<T> get options;

  /// Toggles the clicked value within [model].
  ///
  /// If shift was held down all values between the clicked value and the
  /// previously clicked value are set to the new state. As a result if the
  /// value you shift-click was previously selected all values in the range will
  /// become unselected.
  void _handleClick(MouseEvent e, T value) {
    var toggleSelection =
        selection.isSelected(value) ? selection.deselect : selection.select;
    if (_pivot == null || !e.shiftKey) {
      toggleSelection(value);
    } else {
      final optionValues = options.optionsList;
      final clickedIndex = optionValues.indexOf(value);
      final pivotIndex = optionValues.indexOf(_pivot);
      if (pivotIndex == -1) {
        throw new StateError("pivot item is no longer in the model: $_pivot");
      }
      optionValues
          .skip(min(pivotIndex, clickedIndex))
          .take((pivotIndex - clickedIndex).abs() + 1)
          .forEach(toggleSelection);
    }
    _pivot = value;
  }

  /// Handles updating the selection model from [MouseEvent] activations.
  ///
  /// If [event] is not a [MouseEvent] it will not be handled. This method
  /// does handle mouse events even if shift is not held down.
  @override
  bool handle(UIEvent event, T activatedValue) {
    if (selection is! MultiSelectionModel || event is! MouseEvent) return false;
    _handleClick(event, activatedValue);
    return true;
  }
}
