// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';

import '../src/template_util.dart';

/// Generates web/syntax_highlight.scss that contains styles targeting classes
/// for use with highlight.js. https://highlightjs.org
class SyntaxHighlightBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final newAssetId =
        AssetId(buildStep.inputId.package, 'web/syntax_highlight.scss');
    await writeAsset(buildStep,
        'lib/builder/template/syntax_highlight.scss.mustache', {}, newAssetId);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$web$': ['syntax_highlight.scss']
      };
}
