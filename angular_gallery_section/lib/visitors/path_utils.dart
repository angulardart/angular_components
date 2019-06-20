// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:path/path.dart' as path;

final RegExp _pathPartsRegExp = RegExp(r'(.*)/lib/(.*)');

final RegExp _targetPartsRegExp = RegExp(r'(.*):lib/(.*)');

final RegExp _genFilesDir = RegExp(r'genfiles[/.]');

final RegExp _binDir = RegExp(r'blaze-out/[^/]+/bin/');

final String _thirdPartyPrefix = 'third_party/dart/';

/// Converts a path to a Dart import URI.
///
/// Namely, it removes the "lib/" directory, and replaces all of the '/'
/// characters before "lib/" with '.' characters.
///
/// Examples:
///
///     pathToImportUri('a/b/lib/c.dart');  // => 'a.b/c.dart'
///     pathToImportUri('a/b/lib/src/c.dart');  // => 'a/b/src/c.dart'
String pathToImportUri(String pathName, {Pattern pattern}) {
  pattern ??= _pathPartsRegExp;
  if (pathName.contains(_genFilesDir)) {
    pathName = pathName.split(_genFilesDir)[1];
  }

  if (pathName.contains(_binDir)) {
    pathName = pathName.split(_binDir)[1];
  }

  if (pathName.startsWith(_thirdPartyPrefix)) {
    pathName = pathName.substring(_thirdPartyPrefix.length);
  }

  pathName = path.normalize(pathName);
  return pathName.replaceFirstMapped(
      pattern, (m) => '${m[1].replaceAll('/', '.')}/${m[2]}');
}

/// Converts a path to a Dart import URI, prefixed with the "package:" scheme.
///
/// Examples:
///
///     pathToPackageUri('a/b/lib/c.dart');  // => 'package:a.b/c.dart'
///     pathToPackageUri('a/b/lib/src/c.dart');  // => 'package:a/b/src/c.dart'
String pathToPackageUri(String pathName) =>
    'package:${pathToImportUri(pathName)}';

/// Converts a path to a viable Dart library name.
///
/// Essentially removes '/lib/', '.dart', and converts all '/' to '.'
/// characters.
///
/// Example:
///
///     pathToLibraryName('a/b/lib/c.dart');  // => 'a.b.c'
String pathToLibraryName(String pathName) =>
    pathToImportUri(pathName).replaceFirst('.dart', '').replaceAll('/', '.');

/// Converts a blaze target into a path.
///
/// Example:
///
///     targetToImportUri('a/b:lib/c.dart');  // => 'a.b/c.dart'
String targetToImportUri(String pathName) =>
    pathToImportUri(pathName, pattern: _targetPartsRegExp);

// Splits [p] on package boundary ("/lib/"), and replaces slashes with dots in
// the package part.
///
/// Example:
///
///     splitPathOnPackage('a/b/lib/c.dart');  // => ['a.b', 'lib/c.dart']
List<String> splitPathOnPackage(String p) {
  if (!p.contains('/lib/')) {
    throw ArgumentError('Bad argument: "$p"; must contain a "lib/" directory.');
  }
  var parts = p.split('/lib/');
  parts[0] = parts[0].replaceAll('/', '.');
  parts[1] = 'lib/${parts[1]}';
  return parts;
}

/// Convert assetId string representation to a path and replaces "." in the
/// package name with slashes.
///
/// Example: "package.name|lib/path/to/asset.txt" to
/// "package/name/lib/path/to/asset.txt".
String assetToPath(String asset) => asset.replaceFirstMapped(
    RegExp(r'(.*)\|(lib.*)'), (m) => '${m[1].replaceAll('.', '/')}/${m[2]}');

/// Convert assetId string representation to a package string usable in a dart
/// import.
///
/// Example: "package.name|lib/path/to/asset.txt" to
/// "package:package.name/path/to/asset.txt".
String assetToImport(String asset) =>
    'package:${asset.replaceFirst('|lib/', '/')}';
