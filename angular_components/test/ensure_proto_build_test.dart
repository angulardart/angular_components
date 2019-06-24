// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
@Tags(['presubmit-only'])

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Only to be run externally. Heavily inspired by diff tests from the
/// json_serializable package.
void main() {
  test('ensure proto gen succeeds with no changes', () {
    var pkgRoot = _runProc('git', ['rev-parse', '--show-toplevel']);
    var currentDir = Directory.current.resolveSymbolicLinksSync();
    if (!p.equals(p.join(pkgRoot, 'angular_components'), currentDir)) {
      throw StateError('Expected the git root ($pkgRoot/angular_components) '
          'to match the current directory ($currentDir).');
    }

    // By default try to run from a pre-determined location for Travis.
    var protocPath = '${Platform.environment['HOME']}/protoc/bin/protoc';

    // Use the version of protoc on the $PATH if available.
    var result = Process.runSync('which', ['protoc']);
    if (result.exitCode == 0) {
      protocPath = (result.stdout as String).trim();
    }

    final datepickerProtoPath = './lib/material_datepicker/proto';

    // 1 - get a list of modified `.pb.dart` files - should be empty
    expect(_changedGeneratedFiles(), isEmpty);
    // 2 - run build - should be no output, since nothing should change
    _runProc(protocPath, [
      '--proto_path=$datepickerProtoPath',
      '--dart_out=$datepickerProtoPath',
      '$datepickerProtoPath/date.proto'
    ]);
    _runProc(protocPath, [
      '--proto_path=$datepickerProtoPath',
      '--dart_out=$datepickerProtoPath',
      '$datepickerProtoPath/date_range.proto'
    ]);
    _runProc('dartfmt', ['-w', datepickerProtoPath]);
    // 3 - get a list of modified `.pb.dart` files - should still be empty

    printOnFailure(
        _runProc('git', ['diff', '$datepickerProtoPath/date.pb.dart']));
    printOnFailure(
        _runProc('git', ['diff', '$datepickerProtoPath/date_range.pb.dart']));

    expect(_changedGeneratedFiles(), isEmpty);
    // Print diffs to make it easier to find the problem if one exists.
  });
}

final _whitespace = RegExp(r'\s');
Set<String> _changedGeneratedFiles() {
  var output = _runProc('git', ['status', '--porcelain']);
  return LineSplitter.split(output)
      .map((line) => line.split(_whitespace).last)
      .where((path) => path.endsWith('.pb.dart'))
      .toSet();
}

String _runProc(String proc, List<String> args, {String workingDirectory}) {
  var result = Process.runSync(proc, args);
  if (result.exitCode != 0) {
    throw ProcessException(
        proc, args, result.stderr as String, result.exitCode);
  }
  return (result.stdout as String).trim();
}
