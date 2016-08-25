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

library ads.acx2.utils.strings.string_utils;

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