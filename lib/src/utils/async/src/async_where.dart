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

library ads.acx2.utils.async.src.future_where;

import 'dart:async';

/// Returns a single-subscription stream of the [items] for which the [filter]
/// returns a future that completes with true.  The stream fires an event for
/// an item only when its future completes with true AND the filter futures for
/// all previous items have completed.
///
/// Example: familyBlackSheep = asyncWhere(children, growsUpRotten);
Stream/*<T>*/ asyncWhere/*<T>*/(
    List/*<T>*/ items, Future<bool> filter(/*=T*/ item)) async* {
  for (var item in items) {
    if (await filter(item)) {
      yield item;
    }
  }
}

/// Returns a future that completes with the first item in [items] for which
/// [filter] returns a future that completes with true.  It completes with an
/// item only when its filter future completes with true AND the filter futures
/// for all previous items have completed.
/// If all filter futures complete with false and [orElse] is absent, completes
/// with an error.
/// If all filter futures complete with false and [orElse] is present,
/// completes with the return value of [orElse].
///
/// Example: newKing = asyncFirst(sons, survivesToMaturity);
Future/*<T>*/ asyncFirst/*<T>*/(
        List/*<T>*/ items, Future<bool> filter(/*=T*/ item), {orElse()}) =>
    asyncWhere/*<T>*/(items, filter)
        .firstWhere((_) => true, defaultValue: orElse) as dynamic/*=Future<T>*/;

/// Returns a future that completes with the unique item in [items] for which
/// [filter] returns a future that completes with true.  It completes with an
/// item only when its filter future completes with true AND all the other
/// filter futures complete with false.
/// If all filter futures complete with false or (at least 2 complete with true
/// and all the ones before them complete), then it completes with an error.
///
/// Example: prisonersDilemmaWinner = asyncSingle(prisoners, defects);
Future/*<T>*/ asyncSingle/*<T>*/(
        List/*<T>*/ items, Future<bool> filter(/*=T*/ item)) =>
    asyncWhere/*<T>*/(items, filter).single;