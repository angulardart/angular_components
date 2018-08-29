// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'select.dart';
import 'selection_options.dart';

/// A [Filterable] [SelectionOptions] implementation that uses a persistent
/// limit when filtering.
///
/// This implementation is limited in that it will not update outside of [filter]
/// even if the underlying selectionOption has a optionGroup change.
class LockedLimitSelectionOptions<T> extends DelegatingSelectionOptions<T>
    implements Filterable {
  // TODO(google): consider moving to [Filterable]
  static const UNLIMITED = -1;

  final int lockedLimit;
  final SelectionOptions<T> _options;
  final Disposer _disposer = Disposer.oneShot();

  bool _unlockLimit = false;
  int _currentLimit;
  bool _hasMoreOptions = true;

  /// The cached [OptionGroup]s from filtering with the [currentQuery].
  /// This is used to manipulate the underlying OptionGroups without
  /// accidentally throwing away any of the options.
  List<OptionGroup<T>> _filteredGroups;

  /// The flattened [_filteredGroups].
  List<T> _flattenedOptions;

  LockedLimitSelectionOptions(SelectionOptions<T> options, this.lockedLimit)
      : _options = options,
        super(options) {
    assert(_options is Filterable);
    _currentLimit = lockedLimit;
    _updateFilteredOptions();
    _disposer.addStreamSubscription(options.stream.listen((_) {
      _updateFilteredOptions();
    }));
  }

  set unlockLimit(bool unlock) {
    _unlockLimit = unlock;
  }

  /// Returns true if the number of options filtered with [currentQuery] was
  /// truncated so as not to exceed the [currentLimit], or if filtering has not
  /// happened yet.
  bool get hasMoreOptions => _hasMoreOptions;

  @override
  Object get currentQuery => (_options as Filterable).currentQuery;

  @override
  int get currentLimit => _currentLimit;

  @override
  List<OptionGroup<T>> get optionGroups => _filteredGroups;

  @override
  List<T> get optionsList => _flattenedOptions;

  /// Filter up to [limit] results using [filterQuery]. [limit] is used instead
  /// of [lockedLimit] iff [unlockLimit] is true.
  @override
  DisposableFuture<bool> filter(Object filterQuery, {int limit = UNLIMITED}) {
    _currentLimit = _unlockLimit ? limit : lockedLimit;
    // If the limit is locked and finite, only filter one extra item to
    // determine if results will be truncated to meet the lockedLimit.
    if (!(_unlockLimit || limit == UNLIMITED)) {
      limit++;
    }

    DisposableFuture<bool> filtered =
        (_options as Filterable).filter(filterQuery, limit: limit);
    filtered.then((_) {
      _updateFilteredOptions();
    });
    return filtered;
  }

  @override
  void dispose() {
    _disposer.dispose();
    super.dispose();
  }

  void _updateFilteredOptions() {
    if (_unlockLimit) {
      // clone the optionGroups
      _filteredGroups = _options.optionGroups.toList();
      _flattenedOptions = _options.optionsList.toList();
    } else {
      _setLimitedOptions(_options.optionGroups, _currentLimit);
    }
    _hasMoreOptions = _flattenedOptions.length < _options.optionsList.length;
  }

  void _setLimitedOptions(List<OptionGroup<T>> groups, int maxItems) {
    int totalOptionCount = 0;
    _filteredGroups = [];
    for (OptionGroup<T> group in groups) {
      if (totalOptionCount + group.length < maxItems) {
        _filteredGroups.add(group);
        totalOptionCount += group.length;
      } else {
        var lastOptions = group.take(maxItems - totalOptionCount).toList();
        _filteredGroups.add(OptionGroup<T>(lastOptions));
        break;
      }
    }
    _flattenedOptions = _filteredGroups.expand((i) => i).toList();
  }
}
