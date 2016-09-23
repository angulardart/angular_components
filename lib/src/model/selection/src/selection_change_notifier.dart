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

/// Interface for something that can be observed for selection.
abstract class SelectionObservable<T> {
  /// Synchronously deliver all [SelectionChangeRecord]s.
  ///
  /// Returns true if any records were delivered.
  bool deliverSelectionChanges();

  /// Returns true if a subscriber is listening to [selectionChanges].
  bool get hasSelectionObservers;

  /// Schedules a [SelectionChangeRecord].
  void notifySelectionChange(
      {Iterable<T> added: const [], Iterable<T> removed: const []});

  /// A stream that returns changes to selected elements.
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges;
}

/// Mixin for providing [SelectionModel.selectionChanges].
abstract class SelectionChangeNotifier<T> implements SelectionModel<T> {
  StreamController<List<SelectionChangeRecord<T>>> _selectionChangeController;
  List<SelectionChangeRecord<T>> _selectionChangeRecords;

  @override
  bool deliverSelectionChanges() {
    if (hasSelectionObservers &&
        _selectionChangeRecords != null &&
        _selectionChangeRecords.isNotEmpty) {
      var records = new UnmodifiableListView<SelectionChangeRecord<T>>(
          _selectionChangeRecords);
      _selectionChangeRecords = null;
      _selectionChangeController.add(records);
      return true;
    } else {
      return false;
    }
  }

  @override
  void notifySelectionChange(
      {Iterable<T> added: const [], Iterable<T> removed: const []}) {
    if (hasSelectionObservers) {
      var record = new SelectionChangeRecord<T>(added: added, removed: removed);
      if (_selectionChangeRecords == null) {
        _selectionChangeRecords = [];
        scheduleMicrotask(deliverSelectionChanges);
      }
      _selectionChangeRecords.add(record);
    }
  }

  @override
  bool get hasSelectionObservers {
    return _selectionChangeController != null &&
        _selectionChangeController.hasListener;
  }

  @override
  Stream<List<SelectionChangeRecord<T>>> get selectionChanges {
    if (_selectionChangeController == null) {
      _selectionChangeController =
          new StreamController<List<SelectionChangeRecord<T>>>.broadcast(
              sync: true);
    }
    return _selectionChangeController.stream;
  }
}

/// Default implementation of [SelectionChangeRecord].
class _SelectionChangeRecordImpl<T> extends ChangeRecord
    implements SelectionChangeRecord<T> {
  @override
  final Iterable<T> added;

  @override
  final Iterable<T> removed;

  factory _SelectionChangeRecordImpl({Iterable<T> added, Iterable<T> removed}) {
    added = added != null ? new UnmodifiableListView(added) : const [];
    removed = removed != null ? new UnmodifiableListView(removed) : const [];
    return new _SelectionChangeRecordImpl._(added, removed);
  }

  _SelectionChangeRecordImpl._(this.added, this.removed);

  @override
  String toString() =>
      'SelectionChangeRecord{added: $added, removed: $removed}';
}