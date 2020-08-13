// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/standard_ast_factory.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/ast/token.dart';
import 'package:analyzer/src/dart/resolver/scope.dart';
import 'package:build/build.dart';
import 'package:path/path.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/gallery_docs_extraction.dart';
import 'package:angular_gallery_section/gallery_section_config_extraction.dart';
import 'package:angular_gallery_section/resolved_config.dart';
import 'package:angular_gallery_section/sass_docs_extraction.dart';
import 'package:angular_gallery_section/components/gallery_component/documentation_info.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as path_utils;

/// A builder for generating a json summary of each occurrence of a
/// @GallerySectionConfig annotation.
///
/// The json file will be read by other builders that might not have access to
/// a resolver. Reading all the important information here gets around that
/// limitation.
class GalleryInfoBuilder extends Builder {
  final String _staticImageServer;

  GalleryInfoBuilder(this._staticImageServer);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    final extractedConfigs =
        await extractGallerySectionConfigs(inputId, buildStep);

    // File does not contain @GallerySectionConfig annotation.
    if (extractedConfigs.isEmpty) return;

    final resolvedConfigs = await _resolveConfigs(
        extractedConfigs, await buildStep.inputLibrary, buildStep);

    var newAssetId = inputId.changeExtension('.gallery_info.json');
    await buildStep.writeAsString(newAssetId, jsonEncode(resolvedConfigs));
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['.gallery_info.json'],
      };

  /// Resolve the docs and demos within all [configs].
  ///
  /// Will search imports starting at [rootLibrary] for demo classes and
  /// documentation. Reads files with [assetReader] during the search.
  Future<Iterable<ResolvedConfig>> _resolveConfigs(Iterable<ConfigInfo> configs,
          LibraryElement rootLibrary, AssetReader assetReader) async =>
      Future.wait(configs.map((config) async {
        final resolved = ResolvedConfig()
          ..displayName = config.displayName
          ..group = config.group
          ..benchmarks = config.benchmarks
          ..owners = config.owners
          ..uxOwners = config.uxOwners
          ..relatedUrls = config.relatedUrls
          ..showGeneratedDocs = config.showGeneratedDocs;
        await Future.wait([
          Future.wait(_resolveDocs(config.docs, rootLibrary, assetReader)).then(
              (docs) =>
                  resolved.docs = docs.where((doc) => doc != null).toList()),
          Future.wait(_resolveDemos(
                  config.demoClassNames, rootLibrary, assetReader))
              .then((demos) => resolved.demos =
                  demos.where((demo) => demo != null).toList()),
          _resolveDemoFromRootLibrary(
                  config.mainDemoName, rootLibrary, assetReader)
              .then((demo) => resolved.mainDemo = demo),
        ]);
        return resolved;
      }));

  /// Resolve all [docs] into a [DocInfo] that contains the HTML to be rendered
  /// in the gallery.
  ///
  /// Searches imports for documentation starting at [rootLibrary], reading
  /// source files with [assetReader].
  Iterable<Future<DocInfo>> _resolveDocs(Iterable<String> docs,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (docs == null) return const Iterable.empty();

    return docs.map((doc) async {
      if (doc.startsWith('package:')) {
        // This is an external asset to collect docs from.
        return _readExternalAsset(doc, assetReader);
      } else {
        // Assume it is a class, mixin, or function.
        final docLibrary = _getLibrary(doc, rootLibrary);

        if (docLibrary == null) {
          log.warning('Could not find @Directive or @Component annotation '
              'to extract documentation: $doc.');
          return null;
        }

        return _resolveDocFromClass(doc, docLibrary, assetReader);
      }
    });
  }

  /// Read the [externalAsset] with [assetReader] and collect documentation
  /// information.
  ///
  /// Supports reading .md or .scss assets.
  Future<DocInfo> _readExternalAsset(
      String externalAsset, AssetReader assetReader) async {
    final assetId = AssetId.resolve(externalAsset);

    if (!await assetReader.canRead(assetId)) {
      throw ('Could not find the asset: $externalAsset.');
    }

    if (assetId.extension == '.scss') {
      return extractSassDocs(
          'Sass: ' +
              basenameWithoutExtension(assetId.path)
                  .replaceAll('_', ' ')
                  .trim(),
          assetId,
          assetReader);
    }

    if (assetId.extension == '.md') {
      final content = await assetReader.readAsString(assetId);
      return MarkdownDocInfo()
        ..name = basenameWithoutExtension(assetId.path)
        ..path = path_utils.assetToPath(assetId.toString())
        // Convert markdown to html and insert static server for images.
        ..contents = _replaceImgTags(g3docMarkdownToHtml(content));
    }

    throw ('Documentation generator only supports external files of type .md '
        'or .scss. Can not load documentation from $assetId.');
  }

  /// Find the file that defines [identifier], and extract the documentation
  /// comments, and render as HTML.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<DartDocInfo> _resolveDocFromClass(String identifier,
      LibraryElement library, AssetReader assetReader) async {
    // Outputs an error and fails the build.
    void failBuild(String missingIdentifier) =>
        throw 'Error: Failed to extract documentation from: '
            '$missingIdentifier.';

    final libraryId = AssetId.resolve(library.source.uri.toString());
    final docClass = library.getType(identifier);
    DartDocInfo docs;

    // If this a functional directive, just extract the docs and we are done.
    if (docClass == null) {
      docs = await extractDocumentation(identifier, libraryId, assetReader);
      if (docs == null) failBuild(identifier);
      return docs;
    }

    // Otherwise there is additional documentation for a class. Collect all
    // inherited @Input and @Output documentation.
    final mergedInputs = <String, DartPropertyInfo>{};
    final mergedOutputs = <String, DartPropertyInfo>{};

    for (final classElement in _classHierarchy(docClass)) {
      // Must extract documentation from AST because the
      // classElement.documentationComment, classElement.metadata, etc are not
      // populated in the resolved element model available here.
      var libraryId =
          AssetId.resolve(classElement.library.source.uri.toString());
      docs =
          await extractDocumentation(classElement.name, libraryId, assetReader);

      if (docs == null) {
        // The super class must be defined in the library as a part file.
        for (var part in classElement.library.parts) {
          if (part.getType(classElement.name) != null) {
            libraryId = AssetId.resolve(part.source.uri.toString());
            docs = await extractDocumentation(
                classElement.name, libraryId, assetReader);
          }
        }
      }

      if (docs == null) failBuild(classElement.name);

      // Merge the properties into the collections so far.
      // This is the last chance to find the resolved type while we have access
      // to the defining LibraryElement. NOTE: Collecting the types like this
      // diverges from the behavior of DartDoc which always uses the getter type
      // when they are different.
      docs.inputs.forEach((input) => mergedInputs[input.name] = input
        ..type = _setterType(input.name, classElement));

      docs.outputs.forEach((output) => mergedOutputs[output.name] = output
        ..type = _getterType(output.name, classElement));
    }

    if (docs == null) failBuild(identifier);

    // Sort the inputs and outputs by name to make the display simple later.
    final inputs = mergedInputs.values.toList();
    inputs.sort((a, b) => Comparable.compare(a.name, b.name));
    final outputs = mergedOutputs.values.toList();
    outputs.sort((a, b) => Comparable.compare(a.name, b.name));

    // Assign the merged and sorted properties to the leaf class docs.
    docs.inputs = inputs;
    docs.outputs = outputs;

    return docs;
  }

  /// Returns a class hierarchy that ends at [leafClass] omitting [Object].
  Iterable<ClassElement> _classHierarchy(ClassElement leafClass) {
    final interfaces = leafClass.allSupertypes;

    // Object contains no interesting documentation and complicates searching.
    interfaces.removeWhere((interface) => interface.isObject);

    final classes = <ClassElement>[];
    for (var i in interfaces) {
      classes.add(i.element);
    }

    // Add the leaf class at the beginning of the hierarchy.
    classes.insert(0, leafClass);

    // Determine property inheritance with the reversed supertypes, the same way
    // Angular does.
    return classes.reversed;
  }

  /// Returns the type of setter [name] in [classElement].
  String _setterType(String name, ClassElement classElement) =>
      classElement.getSetter(name).type.normalParameterTypes.first.toString();

  /// Returns the type of the getter [name] in [classElement].
  String _getterType(String name, ClassElement classElement) =>
      classElement.getGetter(name).returnType.toString();

  /// Replace web server in `<img>` tags with the [_staticImageServer].
  String _replaceImgTags(String content) => content.replaceAllMapped(
      RegExp(r'<img src="(\S*g3doc\S+)" alt="(.*)" \/>'),
      (Match m) => '<img src="$_staticImageServer${m[1]}" alt="${m[2]}" />');

  /// Resolve all [demoClassNames] into [_DemoInfo]s.
  ///
  /// Will search imports starting at [rootLibrary] for the demo classes. Reads
  /// files with [assetReader] during the search.
  Iterable<Future<DemoInfo>> _resolveDemos(Iterable<String> demoClassNames,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (demoClassNames == null) return const Iterable.empty();
    return demoClassNames.map((demoClassName) async =>
        _resolveDemoFromRootLibrary(demoClassName, rootLibrary, assetReader));
  }

  /// Resolve [demoClassName] into [_DemoInfo].
  ///
  /// Will search imports starting at [rootLibrary] for the demo class. Reads
  /// files with [assetReader] during the search.
  Future<DemoInfo> _resolveDemoFromRootLibrary(String demoClassName,
      LibraryElement rootLibrary, AssetReader assetReader) async {
    if (demoClassName == null) return null;
    final demoLibrary = _getLibrary(demoClassName, rootLibrary);
    return _resolveDemo(demoClassName, demoLibrary, assetReader);
  }

  /// Find the file that defines [demoClassName] and extract the information
  /// from the @Component annotation needed to load the demo in the gallery.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<DemoInfo> _resolveDemo(String demoClassName, LibraryElement library,
      AssetReader assetReader) async {
    if (demoClassName == null) return null;
    final libraryId = AssetId.resolve(library.source.uri.toString());
    final extractedDemo =
        await extractDocumentation(demoClassName, libraryId, assetReader);

    if (extractedDemo == null) {
      throw 'Error: Failed to extract demo information from: $demoClassName.';
    }
    return DemoInfo()
      ..type = extractedDemo.name
      ..name = extractedDemo.name
      ..selector = extractedDemo.selector
      ..asset = libraryId.toString();
  }

  /// Returns the library that defines [name] as a class or top level function,
  /// as reachable from [rootLibrary].
  LibraryElement _getLibrary(String name, LibraryElement rootLibrary) {
    var token = SyntheticStringToken(TokenType.IDENTIFIER, name, 0);
    var identifier = astFactory.simpleIdentifier(token);
    var scope = LibraryScope(rootLibrary);
    var result = scope.lookup(identifier, rootLibrary);

    if (result == null) {
      throw 'Error: Failed to locate a library containing $name.';
    }

    return result.library;
  }
}
