// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of angular_components.model.selection.selection_model;

/// Mixin for providing [SelectionModel.selectableChanges].
abstract class SelectableChangeNotifier<T>
    implements SelectionModel<T>, SelectableWithComposition<T> {
  StreamController<SelectableChangeRecord> _selectableChangeController;
  SelectableChangeRecord _selectableChangeRecord;

  void _deliverSelectableChange() {
    if (_hasSelectableObservers && _selectableChangeRecord != null) {
      _selectableChangeController.add(_selectableChangeRecord);
      _selectableChangeRecord = null;
    }
  }

  void notifySelectableChange() {
    if (_hasSelectableObservers && _selectableChangeRecord == null) {
      _selectableChangeRecord = const SelectableChangeRecord();
      scheduleMicrotask(_deliverSelectableChange);
    }
  }

  bool get _hasSelectableObservers {
    return _selectableChangeController != null &&
        _selectableChangeController.hasListener;
  }

  Stream<SelectableChangeRecord> get selectableChanges {
    if (_selectableChangeController == null) {
      _selectableChangeController = new StreamController.broadcast(sync: true);
    }
    return _selectableChangeController.stream;
  }
}

/// Default implementation of [SelectableChangeRecord].
class _SelectableChangeRecordImpl<T> implements SelectableChangeRecord<T> {
  const _SelectableChangeRecordImpl();
}
