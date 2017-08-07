// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

final RegExp _camelCaseSplitter = new RegExp('([a-z])([A-Z])');

final RegExp _capitalLetter = new RegExp('[A-Z]');

final RegExp _wordBreakSplitter = new RegExp(r'[\s\-_]');

final RegExp _wordBreak = new RegExp(r'(^|[\-_ ])(\w)');

/// Returns the hyphenated form of [s].
///
/// The string is also made lower case.
String hyphenate(String s) => _split(s).join('-').toLowerCase();

/// Returns the underscored form of [s].
///
/// The string is also made lower case.
String underscore(String s) => _split(s).join('_').toLowerCase();

/// Returns the camel-cased form of [s].
///
/// This is a very simple function: it merely replaces usual delimiters (spaces,
/// hyphens, underscores) and the following word-character, with the upper case
/// form of the word-character. It doesn't change the case of any other letters.
String camelCase(String s) =>
    s.replaceAllMapped(_wordBreak, (m) => m[2].toUpperCase());

/// Returns the lower-camel-cased form of [s].
String lowerCamelCase(String s) {
  String result = camelCase(s);
  result = result.replaceRange(0, 1, s[0].toLowerCase());
  return result;
}

/// Returns a human-readable title-cased form of a camel-cased String.
String titleCase(String s) =>
    s[0].toUpperCase() +
    s.substring(1).replaceAllMapped(_capitalLetter, (m) => ' ${m[0]}');

/// Returns the String [s], with the first letter capitalized.
String capitalizeFirstLetter(s) => s[0].toUpperCase() + s.substring(1);

// Splits [s] into tokens.
//
// Splits occur on:
//
// * Whitespace: "foo bar" => ["foo", "bar"]
// * Hyphens: "foo-bar" => ["foo", "bar"]
// * Underscores: "foo_bar" => ["foo", "bar"]
// * Camelcasing: "fooBar" => ["foo", "Bar"]
List<String> _split(String s) => s
    // Convert camelCase splitting into word splitting.
    .replaceAllMapped(_camelCaseSplitter, (m) => '${m[1]} ${m[2]}')
    .split(_wordBreakSplitter);
