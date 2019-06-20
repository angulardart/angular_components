// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:mustache/mustache.dart' show Template;
import 'package:angular_gallery_section/resolved_config.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart';

/// A builder for generating a "gallery section" (Dart source code) from a
/// @GallerySectionConfig construction.
///
/// Primarily, this tool creates a combined demo of the "demos" attached to the
/// GallerySectionConfig.
class GallerySectionBuilder extends Builder {
  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final infoAssets =
        await buildStep.findAssets(Glob('**/*.gallery_info.json')).toList();
    if (infoAssets.isEmpty) return;

    final mergedImports = <String>{};
    final mergedDemos = <String, String>{};
    final mergedMainDemo = <String, String>{};
    final apis = [];

    for (final assetId in infoAssets) {
      final infoList =
          (jsonDecode(await buildStep.readAsString(assetId)) as List)
              .map((info) => ResolvedConfig.fromJson(info));

      // There is an API page generated for every .gallery_info.json file.
      final api = <String, dynamic>{
        'apiImport': assetToImport(assetId.toString())
            .replaceFirst('.gallery_info.json', '.api.dart'),
      };

      var docs = [];

      for (final info in infoList) {
        for (final demo in info.demos) {
          mergedDemos[demo.name] = demo.selector;
          mergedImports.add(demo.import);
        }

        docs.add({
          'className': '${info.classSafeName}Api',
          'selector': '${info.selectorSafeName}-api'
        });
        if (info.mainDemo != null) {
          mergedMainDemo[info.mainDemo.name] = info.mainDemo.selector;
        }
      }
      api['docs'] = docs;
      apis.add(api);
    }

    final mustacheContext = {
      'imports': mergedImports.map((import) => {'dartImport': import}),
      'demos': mergedDemos.entries
          .map((entry) => {'className': entry.key, 'selector': entry.value}),
      'mainDemo': mergedMainDemo,
      'apis': apis,
    };

    final templateId = AssetId('angular_gallery_section',
        'lib/builder/template/gallery_section.dart.mustache');
    final mustacheTemplate = Template(await buildStep.readAsString(templateId),
        htmlEscapeValues: false);

    final newAssetId = AssetId(inputId.package, 'lib/gallery_section.dart');
    await buildStep.writeAsString(
        newAssetId, mustacheTemplate.renderString(mustacheContext));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': const ['gallery_section.dart'],
      };
}
