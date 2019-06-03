// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Encoding for different types of documenation for the gallery builders.
///
/// Simplifies translating to and from JSON files between build steps.
enum DocType { dartDocInfo, markdownDocInfo, sassDocInfo }

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

    if (docType == DocType.sassDocInfo.toString()) {
      return SassDocInfo.fromJson(jsonMap);
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

/// Documentation information for a Sass file listed in an @GallerySectionConfig
/// annotation.
class SassDocInfo implements DocInfo {
  final String name;
  final String path;
  final String libraryDoc;
  final Iterable<SassVariableInfo> variables;
  final Iterable<SassCallableInfo> functions;
  final Iterable<SassCallableInfo> mixins;

  DocType get docType => DocType.sassDocInfo;

  SassDocInfo(this.name, this.path, this.libraryDoc, this.variables,
      this.functions, this.mixins);

  /// Constructs a new [SassDocInfo] from a decoded json map.
  SassDocInfo.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'] as String,
        path = jsonMap['path'] as String,
        libraryDoc = jsonMap['libraryDoc'] as String,
        variables = (jsonMap['variables'] as Iterable)
            ?.map((element) => SassVariableInfo.fromJson(element)),
        functions = (jsonMap['functions'] as Iterable)
            ?.map((element) => SassCallableInfo.fromJson(element)),
        mixins = (jsonMap['mixins'] as Iterable)
            ?.map((element) => SassCallableInfo.fromJson(element));

  /// Returns a json encodeable representation of this [SassDocInfo].
  Map<String, dynamic> toJson() => {
        'docType': docType.toString(),
        'name': name,
        'path': path,
        'libraryDoc': libraryDoc,
        'variables': variables?.map((v) => v.toJson())?.toList(),
        'functions': functions?.map((f) => f.toJson())?.toList(),
        'mixins': mixins?.map((m) => m.toJson())?.toList(),
      };
}

/// Documentation information for a Sass variable.
class SassVariableInfo {
  final String name;
  final String expression;
  final String comment;

  SassVariableInfo(this.name, this.expression, this.comment);

  /// Constructs a new [SassVariableInfo] from a decoded json map.
  SassVariableInfo.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'] as String,
        expression = jsonMap['expression'] as String,
        comment = jsonMap['comment'] as String;

  /// Returns a json encodeable representation of this [SassVariableInfo].
  Map<String, dynamic> toJson() => {
        'name': name,
        'expression': expression,
        'comment': comment,
      };
}

/// Documentation information for a Sass callable (function or mixin).
class SassCallableInfo {
  final String name;
  final Iterable<SassArgumentInfo> arguments;
  final String restArgument;
  final String comment;

  SassCallableInfo(this.name, this.arguments, this.restArgument, this.comment);

  /// Constructs a new [SassCallableInfo] from a decoded json map.
  SassCallableInfo.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'] as String,
        arguments = (jsonMap['arguments'] as Iterable)
            ?.map((element) => SassArgumentInfo.fromJson(element)),
        restArgument = jsonMap['restArgument'],
        comment = jsonMap['comment'] as String;

  /// Returns a json encodeable representation of this [SassCallableInfo].
  Map<String, dynamic> toJson() => {
        'name': name,
        'arguments': arguments?.map((arg) => arg.toJson())?.toList(),
        'restArgument': restArgument,
        'comment': comment,
      };

  /// A simple signature represtation of this callable.
  ///
  /// Includes the name and arguments including a rest arg.
  String get signature {
    if (arguments == null || arguments.isEmpty) return name;
    var args = arguments
        .map((a) => a.defaultValue == null || a.defaultValue.isEmpty
            ? '\$${a.name}'
            : '\$${a.name}: ${a.defaultValue}')
        .join(', ');
    if (restArgument != null && restArgument.isNotEmpty) {
      args = '$args, \$$restArgument...';
    }
    return '$name( $args )';
  }
}

/// Documentation information for a Sass callable's argument.
class SassArgumentInfo {
  final String name;
  final String defaultValue;

  SassArgumentInfo(this.name, this.defaultValue);

  /// Constructs a new [SassArgumentInfo] from a decoded json map.
  SassArgumentInfo.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'] as String,
        defaultValue = jsonMap['defaultValue'] as String;

  /// Returns a json encodeable representation of this [SassArgumentInfo].
  Map<String, dynamic> toJson() => {
        'name': name,
        'defaultValue': defaultValue,
      };
}
