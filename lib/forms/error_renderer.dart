// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A function which takes in an error map, and returns another modified errors
/// map.
typedef Map<String, dynamic> ErrorFn(Map<String, dynamic> errors);

/// Convience function for replacing multiple errors for Components using the
/// errorRenderer pattern.
ErrorFn replaceErrors(Map<String, String> overrides) =>
    (errors) => _replaceErrorsImpl(overrides, errors);

Map<String, dynamic> _replaceErrorsImpl(
    Map<String, String> overrides, Map<String, dynamic> errors) {
  final result = new Map<String, dynamic>.from(errors);
  for (var error in errors.keys) {
    if (overrides.containsKey(error)) result[error] = overrides[error];
  }
  return result;
}
