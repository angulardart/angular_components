// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(google): Make this generic and shareable at first opportunity.
library angular_components.material_tree.src.material_tree_filter;

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/utils/async/async.dart';

/// A simple component that maps an input box to the [Filterable] interface.
@Component(
  selector: 'material-tree-filter',
  directives: [materialInputDirectives, NgIf],
  templateUrl: 'material_tree_filter.html',
)
class MaterialTreeFilterComponent {
  final StreamController _onFocusController =
      StreamController.broadcast(sync: true);
  final StreamController _onFilteredController =
      StreamController.broadcast(sync: true);
  final MaterialTreeRoot _treeRoot;

  @ViewChild('materialInput')
  MaterialInputComponent materialInput;

  Filterable _filterable;
  String _inputText = '';

  // A Future that represents the most recent filtering computation.
  DisposableFuture _lastFilterFuture;

  /// If created within a [MaterialTreeRoot], automatically setup.
  MaterialTreeFilterComponent(@Optional() this._treeRoot) {
    if (_treeRoot?.supportsFiltering == true) {
      filterable = _treeRoot.options as Filterable;
    }
  }

  /// Query text to filter on.
  String get inputText => _inputText;
  set inputText(String inputText) {
    if (_inputText != inputText) {
      _inputText = inputText;
      _updateVisibleItems();
    }
  }

  /// Any symbol to show at the leading edge of the input
  @Input()
  String leadingGlyph;

  /// Set a handle to a [Filterable] interface to use.
  @Input()
  set filterable(Filterable filterable) {
    if (_filterable != filterable) {
      _filterable = filterable;
      var query = filterable.currentQuery;
      if (query != null) {
        _inputText = query.toString();
      }
      _updateVisibleItems();
    }
  }

  /// Whether a handle to the filterable interface has been set.
  bool get hasFilterable => _filterable != null;

  void handleFocus() {
    _onFocusController.add(null);
  }

  void focus() {
    materialInput.focus();
  }

  void clear() {
    inputText = '';
  }

  @Output('focus')
  Stream get onFocus => _onFocusController.stream;

  /// Fires events whenever items are filtered.
  @Output('filter')
  Stream get onFiltered => _onFilteredController.stream;

  @Input()
  String placeholder;

  void _updateVisibleItems() {
    _lastFilterFuture?.dispose();
    _lastFilterFuture = _filterable.filter(_inputText);
    _treeRoot.isFiltered = _inputText.isNotEmpty;
    _onFilteredController.add(null);
  }
}
