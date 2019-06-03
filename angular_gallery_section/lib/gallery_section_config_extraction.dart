// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';

import 'src/common_extractors.dart';

/// Extracts the information from @GallerySectionConfig annotations.
///
/// The asset identified by [assetId] will be read using [assetReader].
Future<Iterable<ConfigInfo>> extractGallerySectionConfigs(
        AssetId assetId, AssetReader assetReader) async =>
    parseCompilationUnit(await assetReader.readAsString(assetId),
            parseFunctionBodies: false)
        .accept(GallerySectionConfigExtraction());

/// [AstVisitor] to extract multiple @GallerySectionConfig annotations, and
/// the parameters they are constructed with.
class GallerySectionConfigExtraction
    extends SimpleAstVisitor<Iterable<ConfigInfo>> {
  @override
  visitCompilationUnit(CompilationUnit node) => node.declarations
      .map((delcaration) => delcaration.accept(_GallerySectionConfigVisitor()))
      .where((config) => config != null);
}

/// [AstVisitor] to extract a single @GallerySectionConfig annotation, applied
/// to a class declaration.
///
/// For use by a [GallerySectionConfigExtraction].
class _GallerySectionConfigVisitor extends SimpleAstVisitor<ConfigInfo> {
  ConfigInfo config;

  @override
  visitClassDeclaration(ClassDeclaration node) {
    for (final metadata in node.metadata) {
      if (metadata.name.name == 'GallerySectionConfig') {
        config = ConfigInfo();
        metadata.accept(this);
      }
    }
    return config;
  }

  @override
  visitAnnotation(Annotation node) {
    final args = node?.arguments?.arguments;
    if (args == null) return null;
    args.accept(this);
    return null;
  }

  @override
  visitNamedExpression(NamedExpression node) {
    final name = node.name.label.name;
    final expression = node.expression;
    if (name == 'displayName') {
      config.displayName = expression.accept(StringExtractor());
    } else if (name == 'group') {
      config.group = expression.accept(StringExtractor());
    } else if (name == 'docs') {
      config.docs = expression.accept(ListStringExtractor());
    } else if (name == 'demos') {
      config.demoClassNames = expression.accept(ListStringExtractor());
    } else if (name == 'mainDemo') {
      config.mainDemoName = expression.accept(StringExtractor());
    } else if (name == 'benchmarks') {
      config.benchmarks = expression.accept(ListStringExtractor());
    } else if (name == 'owners') {
      config.owners = expression.accept(ListStringExtractor());
    } else if (name == 'uxOwners') {
      config.uxOwners = expression.accept(ListStringExtractor());
    } else if (name == 'relatedUrls') {
      config.relatedUrls = expression.accept(MapStringExtractor());
    } else if (name == 'showGeneratedDocs') {
      config.showGeneratedDocs = expression.accept(BoolExtractor());
    }
    return null;
  }
}

/// Represents the values used to construct an @GallerySectionConfig annotation
/// extracted as Strings.
class ConfigInfo {
  String displayName;
  String group;
  Iterable<String> docs;
  Iterable<String> demoClassNames;
  String mainDemoName;
  Iterable<String> benchmarks;
  Iterable<String> owners;
  Iterable<String> uxOwners;
  Map<String, String> relatedUrls;
  bool showGeneratedDocs = true;
}
