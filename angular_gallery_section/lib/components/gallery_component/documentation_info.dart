// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Encoding for different types of documenation for the gallery builders.
///
/// Simplifies translating to and from JSON files between build steps.
enum DocType { dartDocInfo, markdownDocInfo }

/// Base class for all documentation models in the gallery app.
abstract class DocInfo {
  String get name;
  String get path;
  DocType get docType;

  /// Constructs a new [DocInfo] from a decoded json map.
  factory DocInfo.fromJson(Map<String, dynamic> jsonMap) {
    final docType = jsonMap['docType'];

    // Identify the specific documentation model to construct.
    if (docType == DocType.dartDocInfo.toString()) {
      return DartDocInfo.fromJson(jsonMap);
    }

    if (docType == DocType.markdownDocInfo.toString()) {
      return MarkdownDocInfo.fromJson(jsonMap);
    }

    throw FormatException(
        'Unexpected docType found when constructing a DocInfo from JSON: '
        '$docType.');
  }

  Map<String, dynamic> toJson();
}

/// Documentation information for a Dart doc listed in an @GallerySectionConfig
/// annotation.
///
/// Contains information for the Angular API of a @Component or @Directive.
class DartDocInfo implements DocInfo {
  String name;
  bool deprecated;
  String deprecatedMessage;
  String selector;
  String exportAs;
  String path;
  String comment;
  Iterable<DartPropertyInfo> inputs;
  Iterable<DartPropertyInfo> outputs;

  DocType get docType => DocType.dartDocInfo;

  DartDocInfo(
      [this.name,
      this.deprecated,
      this.deprecatedMessage,
      this.selector,
      this.exportAs,
      this.path,
      this.comment,
      this.inputs,
      this.outputs]);

  /// Constructs a new [DartDocInfo] from a decoded json map.
  DartDocInfo.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] as String;
    deprecated = jsonMap['deprecated'] as bool;
    deprecatedMessage = jsonMap['deprecatedMessage'] as String;
    selector = jsonMap['selector'] as String;
    exportAs = jsonMap['exportAs'] as String;
    path = jsonMap['path'] as String;
    comment = jsonMap['comment'] as String;
    inputs = (jsonMap['inputs'] as Iterable)
        ?.map((element) => DartPropertyInfo.fromJson(element));
    outputs = (jsonMap['outputs'] as Iterable)
        ?.map((element) => DartPropertyInfo.fromJson(element));
  }

  /// Returns a json encodeable representation of this [DartDocInfo].
  Map<String, dynamic> toJson() => {
        'docType': docType.toString(),
        'name': name,
        'deprecated': deprecated,
        'deprecatedMessage': deprecatedMessage,
        'selector': selector,
        'exportAs': exportAs,
        'path': path,
        'comment': comment,
        'inputs': inputs?.map((p) => p.toJson())?.toList(),
        'outputs': outputs?.map((p) => p.toJson())?.toList(),
      };
}

/// Documentation information for an @Input or @Output property of an Angular
/// @Component or @Directive.
class DartPropertyInfo {
  String annotation;
  String name;
  String bindingAlias;
  String type;
  String comment;
  String classPath;
  bool deprecated;
  String deprecatedMessage;

  DartPropertyInfo(
      [this.annotation,
      this.name,
      this.bindingAlias,
      this.type,
      this.comment,
      this.classPath,
      this.deprecated,
      this.deprecatedMessage]);

  /// Constructs a new [DartPropertyInfo] from a decoded json map.
  DartPropertyInfo.fromJson(Map<String, dynamic> jsonMap) {
    annotation = jsonMap['annotation'] as String;
    name = jsonMap['name'] as String;
    bindingAlias = jsonMap['bindingAlias'] as String;
    type = jsonMap['type'] as String;
    comment = jsonMap['comment'] as String;
    classPath = jsonMap['classPath'] as String;
    deprecated = jsonMap['deprecated'] as bool;
    deprecatedMessage = jsonMap['deprecatedMessage'] as String;
  }

  /// Returns a json encodeable representation of this [DartPropertyInfo].
  Map<String, dynamic> toJson() => {
        'annotation': annotation,
        'name': name,
        'bindingAlias': bindingAlias,
        'type': type,
        'comment': comment,
        'classPath': classPath,
        'deprecated': deprecated,
        'deprecatedMessage': deprecatedMessage,
      };
}

/// Documentation information for a single document, typically a markdown file.
class MarkdownDocInfo implements DocInfo {
  String name;
  String path;
  String contents;

  DocType get docType => DocType.markdownDocInfo;

  MarkdownDocInfo([this.name, this.path, this.contents]);

  /// Constructs a new [MarkdownDocInfo] from a decoded json map.
  MarkdownDocInfo.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'] as String;
    path = jsonMap['path'] as String;
    contents = jsonMap['contents'] as String;
  }

  /// Returns a json encodeable representation of this [MarkdownDocInfo].
  Map<String, dynamic> toJson() => {
        'docType': docType.toString(),
        'name': name,
        'path': path,
        'contents': contents,
      };
}
