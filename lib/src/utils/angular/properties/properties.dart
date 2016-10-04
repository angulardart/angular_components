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

library angular2_components.utils.angular.properties.properties;

// These are alternative to Angular 2.0 pipes that are lighter weight and typed.
// However, ideally Angular should help with these.
// See: https://github.com/angular/angular/issues/2870

/// A utility function that returns either [inputValue], or, if it is null, uses
/// [defaultValue] to return a default value, or uses [onString] to parse it
/// into a value that is usable.
///
/// This is an untyped version of [getInt] and [getBool].
dynamic getDynamic(inputValue, {defaultValue, onString(String strValue)}) {
  if (inputValue == null) {
    return defaultValue;
  } else if (inputValue is String) {
    return onString(inputValue);
  } else {
    return inputValue;
  }
}

/// Parses [strValue] into a [bool].
///
/// Only the following values are acceptable as `strValue`:
///  '' = true
///  'true' = true
///  'false' = false
///
/// **NOTE**: If [strValue] is an empty string (''), it is always true. This is
/// because when you declare something like:
///     <material-button disabled></material-button>
///
/// ... The value of "disabled" is ''.
bool _parseBool(String strValue) {
  switch (strValue) {
    case '':
      return true;
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw new ArgumentError.value(
          strValue,
          'strValue',
          'Only "", "true", and "false" are acceptable values for parseBool. '
          'Found: ');
  }
}

/// A typed version of [getDynamic].
///
/// If [inputValue] is a [bool], returns it.
/// If [inputValue] is a [String], then '' and 'true' evaluate to `true` while
/// 'false' evaluates to `false`. All other string values produce an argument
/// error.
///
/// **NOTE**: inputValue must be non-null.
bool getBool(inputValue) {
  if (inputValue == null) throw new ArgumentError.notNull('inputValue');

  if (inputValue is String) return _parseBool(inputValue);
  if (inputValue is bool) return inputValue;

  throw new ArgumentError.value(
      inputValue, 'inputValue', 'Expected a String, or bool type');
}

/// A typed version of [getDynamic].
///
/// If [inputValue] is an [int], returns it.
/// If [inputValue] is a `null`, returns [defaultValue].
/// If [inputValue] is a String, parses using [onString], or uses [int.parse].
int getInt(inputValue,
    {int defaultValue: 0, int onString(String strValue): int.parse}) {
  return getDynamic(inputValue, defaultValue: defaultValue, onString: onString);
}
