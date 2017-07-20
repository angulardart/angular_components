// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../utils/async/async.dart';

// TODO(google): Slowly change to use the refined interfaces in src/interfaces.
// - interfaces/filterable.dart will replace Filterable
// - interfaces/parent.dart will replace Parent.
export 'src/interfaces/selectable.dart';

typedef int CountGetter();
typedef bool Predicate<T>(T item);

Predicate alwaysTrue = (_) => true;
Predicate alwaysFalse = (_) => false;

/// Interface for applying a Filter.
///
/// The interface only returns a future that indicates whether the filter
/// operation was successful or if it failed.  It does not provide the list
/// of items that are filtered.  This allows the trigger to not have a
/// dependency on having to act on the results.
abstract class Filterable {
  /// The query passed in on the last call to filter.
  ///
  /// It is null if filter has never been called.
  Object get currentQuery;

  /// Max number of items requested on the last call to filter.
  ///
  /// It is -1 if filter has never been called.
  int get currentLimit;

  /// Takes in a query and a limit and applies the query to the entire list
  /// of options.
  ///
  /// The query is an object to support the caller passing in a non-string
  /// query.  If the limit is less than 1, it is assumed to be mean no limit.
  ///
  /// Examples:
  /// filter('re', limit: 5) for return colors whose names start with 're'
  /// filter(new DateTime.now(), limit: 10) for showing only meeting that are in
  /// the future.
  DisposableFuture<bool> filter(Object filterQuery, {int limit: -1});
}

/// Interface implemented by classes that support children.
abstract class Parent<P, C> {
  bool hasChildren(P item) => false;

  /// Returns the children of the parent and filter the results based of the
  /// query if supported.
  DisposableFuture<C> childrenOf(P parent, [Object filterQuery = null]) =>
      new DisposableFuture.fromValue(const [] as C);
}
