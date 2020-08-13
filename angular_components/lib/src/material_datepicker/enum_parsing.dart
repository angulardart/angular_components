// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Apparently Dart enums don't have any kind of "valueOf" or anything.
/// Fuzzy-parses an enum, given a list of enum values and the string. It's
/// "fuzzy" because it ignores case and treats hyphens and underscores as
/// equivalent (so "single-date" matches "SINGLE_DATE").
T fuzzyParseEnum<T>(List<T> values, String val) {
  var valAsRegex = val
      .toUpperCase()
      .replaceAll('.', r'\.')
      .replaceAll(RegExp(r'[_-]'), r'[-_]');
  var regex = RegExp(valAsRegex + r'$');
  return values.firstWhere((v) => regex.hasMatch(v.toString().toUpperCase()));
}
