// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:angular_components/utils/strings/string_utils.dart' as strings;

import '../src/template_util.dart';

/// Generates lib/gallery/gallery.dart, lib/gallery/gallery.html,
/// lib/gallery/gallery.scss, and lib/gallery/gallery_route_library.dart for the
/// ACX component gallery.
class GalleryLibBuilder extends Builder {
  final String _galleryTitle;
  final List<String> _styleUrls;
  final List<String> _examplePackages;

  GalleryLibBuilder(this._galleryTitle, this._styleUrls, this._examplePackages);

  @override
  Future<void> build(BuildStep buildStep) async {
    final examples = await loadSummaries(buildStep);
    await _generateGalleryDart(buildStep, examples);
    await _generateGalleryHtml(buildStep);
    await _generateGalleryScss(buildStep);
    await _generateGalleryRouteLibraryDart(buildStep, examples);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [
          'gallery/gallery.dart',
          'gallery/gallery.html',
          'gallery/gallery.scss',
          'gallery/gallery_route_library.dart'
        ]
      };

  Future<void> _generateGalleryHtml(BuildStep buildStep) async {
    final mustacheContext = {'galleryTitle': _galleryTitle};
    final newAssetId =
        AssetId(buildStep.inputId.package, 'lib/gallery/gallery.html');
    await writeAsset(buildStep, 'lib/builder/template/gallery.html.mustache',
        mustacheContext, newAssetId);
  }

  Future<void> _generateGalleryDart(
      BuildStep buildStep, List<Example> examples) async {
    final mustacheContext = {
      'styleUrls': _styleUrls,
      'examples': examples,
    };

    final newAssetId =
        AssetId(buildStep.inputId.package, 'lib/gallery/gallery.dart');
    await writeAsset(buildStep, 'lib/builder/template/gallery.dart.mustache',
        mustacheContext, newAssetId);
  }

  Future<void> _generateGalleryScss(BuildStep buildStep) async {
    final newAssetId =
        AssetId(buildStep.inputId.package, 'lib/gallery/gallery.scss');
    await writeAsset(buildStep, 'lib/builder/template/gallery.scss.mustache',
        {}, newAssetId);
  }

  Future<void> _generateGalleryRouteLibraryDart(
      BuildStep buildStep, List<Example> examples) async {
    final mustacheContext = {
      'examples': examples,
    };

    final newAssetId = AssetId(
        buildStep.inputId.package, 'lib/gallery/gallery_route_library.dart');
    await writeAsset(
        buildStep,
        'lib/builder/template/gallery_route_library.dart.mustache',
        mustacheContext,
        newAssetId);
  }

  /// Reads gallery_section_summary.json files from all `_examplePackages`.
  Future<List<Example>> loadSummaries(BuildStep buildStep) async {
    final examples = <Example>[];

    for (var package in _examplePackages) {
      final gallerySectionSummaryId =
          AssetId(package, 'lib/gallery_section_summary.json');
      if (!await buildStep.canRead(gallerySectionSummaryId)) continue;

      final summaryContents =
          await buildStep.readAsString(gallerySectionSummaryId);
      final summaries = (jsonDecode(summaryContents) as Iterable)
          .map((m) => (m as Map).cast<String, dynamic>());
      examples.addAll(summaries.map((summary) => Example(
          summary['displayName'],
          summary['group'],
          summary['dartImport'],
          summary['componentClass'],
          summary['docs']?.cast<String>())));
    }

    examples
        .sort((Example a, Example b) => a.displayName.compareTo(b.displayName));
    return examples;
  }
}

class Example {
  final String displayName;
  final String group;
  final String dartImport;
  final String component;
  final List<String> relatedComponents;

  Example(this.displayName, this.group, this.dartImport, this.component,
      this.relatedComponents);

  String get name => strings
      .underscore(displayName.replaceAll(RegExp(r'[^a-zA-Z0-9 _-]'), ''));

  String get linkName => strings.capitalizeFirstLetter(name);

  String get loader => 'load${name}Example';
}
