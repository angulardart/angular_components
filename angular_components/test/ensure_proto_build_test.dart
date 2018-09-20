// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
@TestOn('vm')
@Tags(const ['presubmit-only'])

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

    // 1 - get a list of modified `.pb.dart` files - should be empty
    expect(_changedGeneratedFiles(), isEmpty);
    // 2 - run build - should be no output, since nothing should change
    print(_runProc(protocPath,
        ['--dart_out=.', './lib/material_datepicker/proto/date.proto']));
    _runProc(protocPath,
        ['--dart_out=.', './lib/material_datepicker/proto/date_range.proto']);
    print(_runProc('dartfmt', ['-w', './lib/material_datepicker/proto']));
    // 3 - get a list of modified `.pb.dart` files - should still be empty
    expect(_changedGeneratedFiles(), isEmpty);
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
