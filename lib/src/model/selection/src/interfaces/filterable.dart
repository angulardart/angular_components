// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// **NOTE**: This library is currently unused and will replace select.dart.

import 'dart:async';

/// Interface for creating and applying a filter on visible data.
///
/// A filterable may either do an in-memory search based on available data or
/// make an asynchronous/RPC call to determine a subset of data base on the
/// query.
///
/// See [AbstractFilterable] for a base implementation that simplifies usage.
abstract class Filterable<Q> {
  /// Signifies that results returned should be unbounded in [filter].
  static const int UNLIMITED = -1;

  /// The currently active limit from [filter].
  ///
  /// If there is no active query, will be [UNLIMITED].
  int get currentLimit;

  /// The currently active query from [filter].
  ///
  /// If there is no active query, will be `null`.
  Q get currentQuery;

  /// Returns a [Stream] that adjusts the visible data based on [query].
  ///
  /// Optionally may specify a maximum number of items via [limit].
  ///
  /// __Example use__:
  ///     // The visible list shows 'Abraham Lincoln' and 'George Washington'.
  ///     var filter = filterable.filter('Geo', limit: 1);
  ///     // The visible list now only shows 'George Washington'.
  ///     filter.listen((_) {});
  ///
  /// The returned [Stream] emits when the filter changes the data set. It is
  /// possible to *cancel* the [StreamSubscription] in order to automatically
  /// clear the [currentQuery] and restore the initial data set.
  ///
  /// __Example use__:
  ///   StreamSubscription appliedFilter;
  ///   appliedFilter = filterable.filter('Geo').listen((_){
  ///     // The visible list now only shows 'George Washington'.
  ///     appliedFilter.cancel().then((_) {
  ///       // The visible list now shows nothing.
  ///     });
  ///   });
  Stream filter(Q query, {int limit: Filterable.UNLIMITED});

  /// Whether a [currentQuery] is applied.
  bool get isFiltered;
}

/// An optional mixin/parent class that just requires implementing [doFilter].
///
/// [currentLimit] and [currentQuery] are automatically filled when [filter] is
/// listened to, and cleared when the filter is cancelled. If an attempt is
/// made to listen to a new filter without cancelling a previous one, the
/// previously applied filter is automatically cancelled.
///
/// __Example use__:
///     abstract class BaseOptions {
///       List<String> options;
///     }
///
///     class MyOptions extends BaseOptions with AbstractFilterable<String> {
///       @override
///       Stream doFilter(String partialText, {int limit: UNLIMITED}) {
///         return makeSearchRpc(partialText, limit: limit).map((results) {
///           options = results;
///           return results;
///         });
///       }
///     }
abstract class AbstractFilterable<Q> implements Filterable<Q> {
  StreamController _currentDoFilterController;
  StreamSubscription _currentDoFilterSubscription;

  int _currentLimit = Filterable.UNLIMITED;
  Q _currentQuery;

  @override
  int get currentLimit => _currentLimit;

  @override
  Q get currentQuery => _currentQuery;

  /// Implement the actual logic for [filter] here.
  ///
  /// The stream returned should immediately emit an event once the underlying
  /// data structure has been modified based on the returned data.
  Stream doFilter(Q query, {int limit: Filterable.UNLIMITED});

  /// Automatically called when [isFiltered] flips to `false` from `true`.
  ///
  /// May be used to restore the original (pre-filtered) data.
  void onFilterCancelled();

  @override
  Stream filter(Q query, {int limit: Filterable.UNLIMITED}) {
    StreamController streamController;
    StreamSubscription streamSubscription;
    streamController = new StreamController.broadcast(onListen: () {
      if (isFiltered) {
        _currentDoFilterSubscription.cancel();
        _currentDoFilterController.close();
      }
      streamSubscription =
          doFilter(query, limit: limit).listen(streamController.add);
      _currentDoFilterSubscription = streamSubscription;
      _currentDoFilterController = streamController;
      _currentQuery = query;
      _currentLimit = limit;
    }, onCancel: () {
      streamSubscription.cancel();
      if (_currentDoFilterController == streamController) {
        _currentDoFilterController = null;
        _currentQuery = null;
        _currentLimit = Filterable.UNLIMITED;
        onFilterCancelled();
      }
    });
    return streamController.stream;
  }

  @override
  bool get isFiltered => _currentDoFilterController != null;
}
