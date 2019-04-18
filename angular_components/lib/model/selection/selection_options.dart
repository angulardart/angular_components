// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components.model.selection.selection_options;

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:angular_components/model/collection/labeled_list.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

export 'package:angular_components/src/model/selection/delegating_selection_options.dart';

part 'package:angular_components/src/model/selection/future_selection_options_impl.dart';
part 'package:angular_components/src/model/selection/stream_selection_options_impl.dart';

/// An interface for functions that segment [items] into option groups.
typedef OptionGroupMapper<T> = List<OptionGroup<T>> Function(Iterable<T> items);

/// A collection of options with an optional label.
class OptionGroup<T> extends LabeledList<T> {
  String get emptyLabel => _emptyLabelFcn != null ? _emptyLabelFcn() : null;

  LabelFunction _emptyLabelFcn;

  bool get hasEmptyLabel => _emptyLabelFcn != null;

  OptionGroup(List<T> items, [LabelFunction labelFcn]) : super(items, labelFcn);

  OptionGroup.withLabelFunction(List<T> items,
      [LabelFunction labelFcn, this._emptyLabelFcn])
      : super.withLabelFunction(items, labelFcn);

  /// An option group with a label is recommended when multiple option groups
  /// exist in a selection list.
  OptionGroup.withLabel(List<T> items, [String label, String emptyLabel])
      : _emptyLabelFcn = emptyLabel != null ? (() => emptyLabel) : null,
        super.withLabel(items, label);

  /// Creates a new option group with options from [start] inclusive to [end]
  /// exclusive, other properties stay the same.
  OptionGroup<T> slicedOptionGroup(int start, int end) {
    List<T> subListItems = this.sublist(start, end);

    return OptionGroup.withLabelFunction(
        subListItems, hasLabel ? null : () => uiDisplayName, _emptyLabelFcn);
  }
}

/// Holds a list of options for a selection-based component.
///
/// The options are organized into [OptionGroup]s.
abstract class GroupedOptions<T> implements Disposable {
  /// The groups of available options.
  ///
  /// Do not modify this list from outside of this class. Instead, create a
  /// [SelectionOptions] from a stream.  This list may be replaced by the data
  /// provider, so consider this list reference to be ephemeral, with the
  /// [SelectionOptions] object's property as the source of truth.
  List<OptionGroup<T>> get optionGroups;
  set optionGroups(List<OptionGroup<T>> value);

  /// All options flattened in one list.
  List<T> get optionsList;

  /// Dispose when the the options come from a stream.
  @override
  void dispose() {}
}

/// Holds a list of options for a selection-based component.
///
/// The options are organized into [OptionGroup]s. The underlying options may
/// be async and resolved by a `Future` or updated using a `Stream`.
///
/// [SelectionOptions] supports a simple form of the [Observable] pattern
/// that will fire a change notification when the optionGroups list changes but
/// it will not detect if the contents of the List or the individual
/// [OptionGroup]s changed.
class SelectionOptions<T> extends GroupedOptions<T>
    implements ObserveAware<List<OptionGroup<T>>> {
  final _controller =
      StreamController<List<OptionGroup<T>>>.broadcast(sync: true);

  List<T> _flattenedList;
  List<OptionGroup<T>> _optionGroups;

  /// Creates an instance with the given option groups.
  SelectionOptions(List<OptionGroup<T>> optionGroups) {
    this.optionGroups = optionGroups;
  }

  /// Creates an instance from a list of options.
  // TODO(google): Rename this to withOptions.
  SelectionOptions.fromList(List<T> options, {String label})
      : this(<OptionGroup<T>>[OptionGroup<T>.withLabel(options, label)]);

  /// Creates an instance with the given option groups.
  SelectionOptions.withOptionGroups(List<OptionGroup<T>> optionGroups)
      : this(optionGroups);

  /// Creates an instance with options resolved from the provided `Future`.
  factory SelectionOptions.fromFuture(
          Future<List<OptionGroup<T>>> optionGroupListFuture) =>
      _FutureSelectionOptions<T>(optionGroupListFuture);

  /// Creates an instance where the available options are the last data item
  /// from the provided `Stream`.
  ///
  /// Be sure to `dispose` of this instance when done in order to dispose of
  /// the stream listener.
  factory SelectionOptions.fromStream(
          Stream<List<OptionGroup<T>>> optionGroupListStream) =>
      _StreamSelectionOptions<T>(optionGroupListStream);

  /// Provides the stream of options group changes.
  @override
  Stream<List<OptionGroup<T>>> get stream => _controller.stream;

  @override
  List<OptionGroup<T>> get optionGroups => _optionGroups;

  @override
  set optionGroups(List<OptionGroup<T>> value) {
    var oldValue = _optionGroups;
    if (oldValue != value) {
      _optionGroups = value;
      _flattenedList = _optionGroups != null
          ? _optionGroups.expand((i) => i).toList()
          : <T>[];
      _controller.add(_optionGroups);
    }
  }

  /// All options flattened in one list.
  @override
  List<T> get optionsList => _flattenedList;

  /// TODO(google): Remove method after b/26784290 is resolved.
  bool get isNotEmpty => optionGroups.any((group) => group.isNotEmpty);

  void _setOptions(List<OptionGroup<T>> newOptions) {
    optionGroups = newOptions;
  }

  @mustCallSuper
  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
