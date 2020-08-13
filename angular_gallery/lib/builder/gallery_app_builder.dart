// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';

import '../src/template_util.dart';

/// Generates web/index.html, web/main.dart, and web/style.scss for the ACX
/// component gallery.
class GalleryWebBuilder extends Builder {
  final String _galleryTitle;
  final String _direction;
  final String _galleryBindingName;
  final String _galleryBindingImport;
  final String _bugUrl;
  final String _sourcecodeUrl;

  GalleryWebBuilder(
      this._direction,
      this._galleryTitle,
      this._galleryBindingName,
      this._galleryBindingImport,
      this._bugUrl,
      this._sourcecodeUrl);

  @override
  Future<void> build(BuildStep buildStep) async {
    await _generateIndexHtml(buildStep);
    await _generateMainDart(buildStep);
    await _generateStyleScss(buildStep);
  }

  Future<void> _generateIndexHtml(BuildStep buildStep) async {
    final mustacheContext = {
      'direction': _direction,
      'galleryTitle': _galleryTitle
    };
    final newAssetId = AssetId(buildStep.inputId.package, 'web/index.html');
    await writeAsset(buildStep, 'lib/builder/template/index.html.mustache',
        mustacheContext, newAssetId);
  }

  Future<void> _generateMainDart(BuildStep buildStep) async {
    final mustacheContext = {
      'galleryImportUri':
          'package:${buildStep.inputId.package}/gallery/gallery.template.dart',
      'hasBinding':
          _galleryBindingName != null && _galleryBindingImport != null,
      'bindingName': _galleryBindingName,
      'bindingImport': _galleryBindingImport,
      'bugUrl': _bugUrl,
      'sourcecodeUrl': _sourcecodeUrl,
    };

    final newAssetId = AssetId(buildStep.inputId.package, 'web/main.dart');
    await writeAsset(buildStep, 'lib/builder/template/main.dart.mustache',
        mustacheContext, newAssetId);
  }

  Future<void> _generateStyleScss(BuildStep buildStep) async {
    final newAssetId = AssetId(buildStep.inputId.package, 'web/style.scss');
    await writeAsset(
        buildStep, 'lib/builder/template/style.scss.mustache', {}, newAssetId);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$web$': ['index.html', 'main.dart', 'style.scss']
      };
}

/// Generates a home.dart component for the html template.
class HomeDartBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final mustacheContext = {
      'htmlTemplateUrl':
          'package:${inputId.package}${inputId.path.replaceFirst('lib', '')}'
    };
    await writeAsset(buildStep, 'lib/builder/template/home.dart.mustache',
        mustacheContext, inputId.changeExtension('.dart'));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.html': ['.dart']
      };
}
