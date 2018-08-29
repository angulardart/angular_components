// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:path/path.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/gallery_docs_extraction.dart';
import 'package:angular_gallery_section/gallery_section_config_extraction.dart';
import 'package:angular_gallery_section/resolved_config.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as path_utils;

/// A builder for generating a json summary of each occurance of a
/// @GallerySectionConfig annotation.
///
/// The json file will be read by other builders that might not have access to
/// a resolver. Reading all the important information here gets around that
/// limitation.
class GalleryInfoBuilder extends Builder {
  final String _staticImageServer;

  GalleryInfoBuilder(this._staticImageServer);

  @override
  build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    final extractedConfigs =
        await extractGallerySectionConfigs(inputId, buildStep);

    // File does not contain @GallerySectionConfig annotation.
    if (extractedConfigs.isEmpty) return;

    final resolvedConfigs = await _resolveConfigs(
        extractedConfigs, await buildStep.inputLibrary, buildStep);

    var newAssetId = inputId.changeExtension('.gallery_info.json');
    buildStep.writeAsString(newAssetId, jsonEncode(resolvedConfigs));
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
          ..benchmarks = config.benchmarks
          ..benchmarkPrefix = config.benchmarkPrefix
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
        ]);
        return resolved;
      }));

  /// Resolve all [docs] into a [_DocInfo] that contains the HTML to be rendered
  /// in the gallery.
  ///
  /// Searches imports for documentation starting at [rootLibrary], reading
  /// source files with [assetReader].
  Iterable<Future<DocInfo>> _resolveDocs(Iterable<String> docs,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (docs == null) return const Iterable.empty();

    return docs.map((doc) async {
      if (doc.startsWith('package:')) {
        // This is a Markdown asset, grab it directly.
        return _readMarkdownAsset(doc, assetReader);
      } else {
        // Assume it is a class or function that needs to be found.
        final docLibrary = _searchFor(doc, rootLibrary);

        if (docLibrary == null) {
          log.warning('Could not find @Directive or @Component annotation '
              'to extract documentation: $doc.');
          return null;
        }

        return _resolveDocFromClass(doc, docLibrary, assetReader);
      }
    });
  }

  /// Read the [markdownAsset] with [assetReader] and render as HTML.
  Future<DocInfo> _readMarkdownAsset(
      String markdownAsset, AssetReader assetReader) async {
    final assetId = AssetId.resolve(markdownAsset);
    if (extension(assetId.path) != '.md') {
      log.warning('Generator only supports .md files as supplementary docs. '
          'Can not insert $assetId into gallery.');
      return null;
    }

    if (!await assetReader.canRead(assetId)) {
      log.warning('Counld not find the asset: $markdownAsset.');
      return null;
    }

    final content = await assetReader.readAsString(assetId);
    // Convert markdown to html and insert static server for images.
    final htmlContent = _replaceImgTags(g3docMarkdownToHtml(content));

    return DocInfo()
      ..name = basenameWithoutExtension(assetId.path)
      ..path = path_utils.assetToPath(assetId.toString())
      ..comment = htmlContent;
  }

  /// Find the file that defines [identifier], and extract the documentation
  /// comments, and render as HTML.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<DocInfo> _resolveDocFromClass(String identifier,
      LibraryElement library, AssetReader assetReader) async {
    final libraryId = AssetId.resolve(library.source.uri.toString());
    final docClass = library.getType(identifier);
    DocInfo docs;

    // If this a functional directive, just extract the docs and we are done.
    if (docClass == null) {
      docs = await extractDocumentation(identifier, libraryId, assetReader);
      if (docs == null) {
        log.warning('Failed to extract documentation from: $identifier.');
      }
      return docs;
    }

    // Otherwise there is additional documenation for a class. Collect all
    // inherited @Input and @Output documentation.
    final mergedInputs = <String, PropertyInfo>{};
    final mergedOutputs = <String, PropertyInfo>{};

    for (final classElement in _classHierarcy(docClass)) {
      // Must extract doumentation from AST becauses the
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

      // Merge the properties into the collections so far.
      // This is the last chance to find the resolved type while we have access
      // to the defining LibraryElement.
      docs.inputs.forEach((input) => mergedInputs[input.name] = input
        ..type = _propertyType(input.name, classElement));

      docs.outputs.forEach((output) => mergedOutputs[output.name] = output
        ..type = _propertyType(output.name, classElement));
    }

    if (docs == null) {
      log.warning('Failed to extract documentation from: $identifier.');
      return null;
    }

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

  /// Returns a class hierarchy that ends at [leafClass] and ommiting [Object].
  Iterable<ClassElement> _classHierarcy(ClassElement leafClass) {
    final interfaces = leafClass.allSupertypes;

    // Object contains no interesting documentation and complicates searching.
    interfaces.removeWhere((interface) => interface.isObject);

    final classes = _asClassElements(interfaces, leafClass.library);

    // Add the leaf class at the begining of the hierarcy.
    classes.insert(0, leafClass);

    // Determine property inheritence with the reversed supertypes, the same way
    // Angular does.
    return classes.reversed;
  }

  /// Returns [interfaces] as the [ClassElement]s that they represent as
  /// reachable from [library].
  List<ClassElement> _asClassElements(
          Iterable<InterfaceType> interfaces, LibraryElement library) =>
      interfaces
          .map((interface) =>
              _searchFor(interface.name, library).getType(interface.name))
          .toList();

  /// Returns the type of the property [name] in [classElment].
  String _propertyType(String name, ClassElement classElement) =>
      classElement.getField(name).type.toString();

  /// Replace web server in `<img>` tags with the [_staticImageServer].
  String _replaceImgTags(String content) => content.replaceAllMapped(
      RegExp(r'<img alt="(.*)" src="(\S*g3doc\S+)" \/>'),
      (Match m) => '<img alt="${m[1]}" src="$_staticImageServer${m[2]}" />');

  /// Resolve all [demoClassNames] into [_DemoInfo]s.
  ///
  /// Will search imports starting at [rootLibrary] for the demo classes. Reads
  /// files with [assetReader] during the search.
  Iterable<Future<DemoInfo>> _resolveDemos(Iterable<String> demoClassNames,
      LibraryElement rootLibrary, AssetReader assetReader) {
    if (demoClassNames == null) return const Iterable.empty();
    return demoClassNames.map((demoClassName) async {
      final demoLibrary = _searchFor(demoClassName, rootLibrary);

      if (demoLibrary == null) {
        log.warning('Could not find Demo class: $demoClassName.');
        return null;
      }
      return _resolveDemo(demoClassName, demoLibrary, assetReader);
    });
  }

  /// Find the file that defines [demoClassName] and extract the information
  /// from the @Component annotation needed to load the demo in the gallery.
  ///
  /// Searches imports starting at [library], reading source files with
  /// [assetReader].
  Future<DemoInfo> _resolveDemo(String demoClassName, LibraryElement library,
      AssetReader assetReader) async {
    final libraryId = AssetId.resolve(library.source.uri.toString());
    final extractedDemo =
        await extractDocumentation(demoClassName, libraryId, assetReader);

    if (extractedDemo == null) {
      log.warning('Failed to extract demo information from: $demoClassName.');
      return null;
    }
    return DemoInfo()
      ..type = extractedDemo.name
      ..name = extractedDemo.name
      ..selector = extractedDemo.selector
      ..asset = libraryId.toString();
  }

  /// Search imports for the file that defines [identifier] as a class or top
  /// level function, starting from [rootLibrary].
  ///
  /// Searches imports with a breadth-first search, as that should find
  /// [identifier] faster than a depth-first search.
  LibraryElement _searchFor(String identifier, LibraryElement rootLibrary) {
    final visited = Set<LibraryElement>();
    final toVisit = Queue<LibraryElement>();

    toVisit.add(rootLibrary);

    while (toVisit.isNotEmpty) {
      final library = toVisit.removeFirst();
      visited.add(library);

      // Search for a class name.
      if (library.getType(identifier) != null) {
        return library;
      }

      // Search for a function name.
      if (library.definingCompilationUnit.functions
          .any((function) => function.name == identifier)) {
        return library;
      }

      toVisit.addAll(library.importedLibraries
          .where((import) => !import.isInSdk && !visited.contains(import)));
      toVisit.addAll(library.exportedLibraries
          .where((export) => !export.isInSdk && !visited.contains(export)));
    }
    // Never found [className] in any of [rootLibrary]'s imports.
    return null;
  }
}
