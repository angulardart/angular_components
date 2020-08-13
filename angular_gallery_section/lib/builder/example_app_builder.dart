// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:build/build.dart';
import 'package:mustache/mustache.dart' show Template;

/// Generates a small app that hosts a single AngularDart standalone example
/// and gallery page that are generated from @GallerySectionConfig annotations.
/// Produces web/main.dart, web/index.html, and web/styles.css.
class ExampleAppBuilder extends Builder {
  final String _direction;

  ExampleAppBuilder(this._direction);

  @override
  Future build(BuildStep buildStep) async {
    await _generateIndexHtml(buildStep);
    await _generateMainDart(buildStep);
    await _generateStyleCss(buildStep);
  }

  Future _generateIndexHtml(BuildStep buildStep) async {
    final mustacheContext = {'direction': _direction};
    final newAssetId = AssetId(buildStep.inputId.package, 'web/index.html');
    final templateId = AssetId(
        'angular_gallery_section', 'lib/builder/template/index.html.mustache');
    final mustacheTemplate = Template(await buildStep.readAsString(templateId));
    await buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  Future _generateMainDart(BuildStep buildStep) async {
    final mustacheContext = {
      'example_import':
          '${buildStep.inputId.package}/gallery_section.template.dart',
    };
    final newAssetId = AssetId(buildStep.inputId.package, 'web/main.dart');
    final templateId = AssetId(
        'angular_gallery_section', 'lib/builder/template/main.dart.mustache');
    final mustacheTemplate = Template(await buildStep.readAsString(templateId));
    await buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  Future _generateStyleCss(BuildStep buildStep) async {
    final mustacheContext = {'direction': _direction};
    final newAssetId = AssetId(buildStep.inputId.package, 'web/style.css');
    final templateId = AssetId(
        'angular_gallery_section', 'lib/builder/template/style.css.mustache');
    final mustacheTemplate = Template(await buildStep.readAsString(templateId));
    await buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$web$': ['index.html', 'main.dart', 'style.css']
      };
}
