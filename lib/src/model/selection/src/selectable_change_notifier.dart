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

part of angular2_components.model.selection.selection_model;

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
