// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/async/async.dart';

/// Formats [value] as a lowercase string without spaces.
String _stringFormatSuggestion(String value) =>
    value.replaceAll(' ', '').toLowerCase();

ItemRenderer<T> _defaultRenderer<T>(ItemRenderer<String> sanitizeString) =>
    newCachingItemRenderer<T>((T value) => sanitizeString(value.toString()));

typedef StringSuggestionFilter<T> = bool Function(
    T suggestion, String filterQuery);

/// The class is meant to be used in areas where a selection can be represented
/// as a string.
///
/// __Example usage:__
/// ```dart
/// class Color {
///   final int colorId;
///   final String displayName;
///
///   Color(this.colorId, this.displayName);
/// }
///
/// var options = new StringSelectionOptions<Color>(
///     // list of colors
///     [new Color (1, 'Red'), new Color(2, 'Blue'), new Color(3, 'Purple')],
///     toFilterableString: (Color color) => color.displayName.toLowerCase());
/// ```
class StringSelectionOptions<T> extends SelectionOptions<T>
    implements Filterable {
  /// Unlimited large value to support no limit for filtering.
  static const int UNLIMITED = 9007199254740992;

  /// The last query passed to [filter].
  String _currentQuery;

  /// The current limit for the filter being applied.
  int _currentLimit = -1;

  List<OptionGroup<T>> _optionGroups;

  /// A function that converts a single option to a filterable string.
  final ItemRenderer<T> _toFilterableString;

  /// Function for filtering a single suggestion/option, defaults to
  /// [filterOption] method.
  StringSuggestionFilter<T> _suggestionFilter;

  /// The [ItemRenderer] that sanitizes options and queries before filtering.
  final ItemRenderer<String> _sanitizeString;

  final bool _shouldSort;

  /// True if [filter] should return the first limit of values when the query is
  /// empty.
  final bool _shouldFilterEmpty;

  /// The list of options and optionally a function to convert the option into a
  /// string that can be used for filtering the list.
  ///
  /// The options must be either strings or convertible to strings using an
  /// optional [ItemRenderer] that is passed in.  If no [ItemRenderer] is passed
  /// in, [_stringFormatSuggestion] will be used.
  ///
  /// If the data needs to be sorted, it should be passed in sorted. The option
  /// [shouldSort] is a simple way to apply the default sorting rules.
  ///
  /// Set [shouldFilterEmpty] to false if [filter] should return empty when the
  /// query is empty.
  StringSelectionOptions(List<T> options,
      {ItemRenderer<T> toFilterableString,
      StringSuggestionFilter<T> suggestionFilter,
      ItemRenderer<String> sanitizeString = _stringFormatSuggestion,
      bool shouldSort = false,
      bool shouldFilterEmpty = true})
      : this.withOptionGroups([OptionGroup(options)],
            toFilterableString: toFilterableString,
            suggestionFilter: suggestionFilter,
            sanitizeString: sanitizeString,
            shouldSort: shouldSort,
            shouldFilterEmpty: shouldFilterEmpty);

  StringSelectionOptions.withOptionGroups(List<OptionGroup<T>> optionGroups,
      {ItemRenderer<T> toFilterableString,
      StringSuggestionFilter<T> suggestionFilter,
      ItemRenderer<String> sanitizeString = _stringFormatSuggestion,
      bool shouldSort = false,
      bool shouldFilterEmpty = true})
      : _toFilterableString =
            toFilterableString ?? _defaultRenderer(sanitizeString),
        _shouldSort = shouldSort,
        _shouldFilterEmpty = shouldFilterEmpty,
        _sanitizeString = sanitizeString,
        super(optionGroups) {
    _suggestionFilter =
        suggestionFilter != null ? suggestionFilter : filterOption;
  }

  /// Accepts a string query and limit and applies the filter to the options.
  ///
  /// If the limit is 0 or negative, it will return all possible options that
  /// match the query.
  ///
  /// TODO(google): In a followup CL, refactor the reusable portions of this code
  /// into a generic filter.
  @override
  DisposableFuture<bool> filter(Object query, {int limit = -1}) {
    _currentLimit = limit < 1 ? UNLIMITED : limit;
    _currentQuery = query as String;
    refilter();
    return DisposableFuture.fromValue(true);
  }

  @protected
  bool get filterApplied => currentQuery != null;

  @protected
  void refilter() {
    List<OptionGroup<T>> filtered = [];
    int count = 0;
    String filterQuery =
        _currentQuery == null ? '' : _sanitizeString(_currentQuery);
    for (var group in _optionGroups) {
      if (count >= currentLimit) break;
      var filteredGroup =
          filterOptionGroup(group, filterQuery, currentLimit - count);
      count += filteredGroup.length;
      filtered.add(filteredGroup);
    }
    super.optionGroups = filtered;
  }

  @protected
  OptionGroup<T> filterOptionGroup(
      OptionGroup<T> group, String filterQuery, int limit) {
    Iterable<T> list;
    if (filterQuery.isNotEmpty) {
      // TODO(google): Optimize the code below to stop filtering if the
      // limit is met rather than filtering everything than taking the
      // matches.
      list = group
          .where((suggestion) => _suggestionFilter(suggestion, filterQuery))
          .take(limit);
    } else if (_shouldFilterEmpty) {
      list = group.take(limit);
    } else {
      list = Iterable<T>.empty();
    }
    var filteredGroup = OptionGroup<T>.withLabelFunction(
        list.toList(growable: false),
        () => group.uiDisplayName,
        group.emptyLabel != null ? () => group.emptyLabel : null);

    return filteredGroup;
  }

  @protected
  bool filterOption(T option, String filterQuery) {
    // StringFormatSuggestion is used to eliminate spaces to make the
    // pattern matching a simple contains as opposed to a regex.
    return _sanitizeString(_toFilterableString(option)).contains(filterQuery);
  }

  @override
  Object get currentQuery => _currentQuery;

  @override
  int get currentLimit => _currentLimit;

  List<OptionGroup<T>> get unfilteredOptionGroups => _optionGroups;

  @override
  set optionGroups(List<OptionGroup<T>> value) {
    // This mutates value...
    if (_shouldSort) {
      value.forEach((optionGroup) {
        optionGroup.sort(_sortFn);
      });
    }
    // Cache the data so original is kept during filtering.
    _optionGroups = value;
    super.optionGroups = value;
    if (filterApplied) {
      refilter();
    }
  }

  int _sortFn(T a, T b) =>
      _toFilterableString(a).compareTo(_toFilterableString(b));
}
