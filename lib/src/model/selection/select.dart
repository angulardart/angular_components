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

library ads.acx2.model.selection.select;

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