// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/resolved_config.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as path_utils;

import 'src/common_extractors.dart';

/// Extracts a [DocInfo] from [assetId] for the identifier [name].
///
/// Will read [assetId] with [assetReader].
Future<DocInfo> extractDocumentation(
        String name, AssetId assetId, AssetReader assetReader) async =>
    parseCompilationUnit(await assetReader.readAsString(assetId),
            parseFunctionBodies: false)
        .accept(GalleryDocumentaionExtraction(
            name, path_utils.assetToPath(assetId.toString())));

/// A visitor that extracts a [DocInfo] for an identifier [_name] and
/// additional information from the Angular annotations @Component and
/// @Directive (if present) for documentation purposes. [_filePath] is
/// passed through to the extractor for [ProperyInfo]s.
class GalleryDocumentaionExtraction extends SimpleAstVisitor<DocInfo> {
  static final inputAnnotation = 'Input';
  static final outputAnnotation = 'Output';
  final String _name;
  final String _filePath;
  DocInfo _info;

  GalleryDocumentaionExtraction(this._name, this._filePath);

  @override
  visitCompilationUnit(CompilationUnit node) {
    for (final declaration in node.declarations) {
      final info = declaration.accept(this);
      if (info != null) return info;
    }
    return null;
  }

  @override
  DocInfo visitClassDeclaration(ClassDeclaration node) {
    if (_extractDocumentation(node) == null) return null;

    var allProperties = <PropertyInfo>[];
    var propertyVisitor = _AllMemberDocsExtraction(_filePath);
    for (Declaration member in node.members) {
      // Must collect the annotations early becausae class fields don't have
      // annotations attached to their actual node. The comments are attached to
      // the field nodes so we have to continue visiting.
      var propertyAnnotationNode = _angularPropertyAnnotation(member);
      var deprecatedAnnotationNode = _deprecatedAnnotation(member);
      if (propertyAnnotationNode == null) continue;

      allProperties
          .addAll(member.accept(propertyVisitor).map((property) => property
            ..annotation = propertyAnnotationNode.name.name
            ..deprecated = deprecatedAnnotationNode != null
            ..deprecatedMessage = deprecatedAnnotationNode?.arguments?.arguments
                // Visit the first arg or null if no args.
                ?.firstWhere((_) => true, orElse: () => null)
                ?.accept(StringExtractor())
            ..bindingAlias = propertyAnnotationNode.arguments?.arguments
                // Visit the first arg or null if no args.
                ?.firstWhere((_) => true, orElse: () => null)
                ?.accept(StringExtractor())));
    }

    _info.inputs = allProperties
        .where((property) => property.annotation == inputAnnotation);
    _info.outputs = allProperties
        .where((property) => property.annotation == outputAnnotation);
    return _info;
  }

  @override
  visitFunctionDeclaration(FunctionDeclaration node) =>
      _extractDocumentation(node);

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
    if (name == 'selector') {
      _info.selector = expression.accept(StringExtractor());
    } else if (name == 'exportAs') {
      _info.exportAs = expression.accept(StringExtractor());
    }
    return null;
  }

  /// Collect information needed for documentaiton from [node].
  DocInfo _extractDocumentation(NamedCompilationUnitMember node) {
    if (node.name.name != _name) return null;

    _info = DocInfo()
      ..name = node.name.name
      ..comment = g3docMarkdownToHtml(parseComment(node.documentationComment))
      ..path = _filePath;
    node.metadata
        .firstWhere((annotation) => _isAngularDirective(annotation),
            orElse: () => null)
        ?.accept(this);
    return _info;
  }

  /// If the annotation [node] contains information for the Angular annotations
  /// @Component or @Directive
  bool _isAngularDirective(Annotation node) =>
      node.name.name == 'Directive' || node.name.name == 'Component';

  /// If the annotation [node] contains information for the Angular annotations
  /// @Input or @Output.
  bool _isAngularProperty(Annotation node) =>
      node.name.name == inputAnnotation || node.name.name == outputAnnotation;

  /// If the annotation [node] contains represents @deprecated or @Deprecated.
  bool _isDeprecated(Annotation node) =>
      node.name.name == 'deprecated' || node.name.name == 'Deprecated';

  /// Returns the first Angular property (@Input or @Output) annotation found
  /// on [node] or null if there are none.
  Annotation _angularPropertyAnnotation(Declaration node) =>
      node?.metadata?.firstWhere((annotation) => _isAngularProperty(annotation),
          orElse: () => null);

  /// Returns the first deprecated annotation found on [node] or null if there
  /// are none.
  Annotation _deprecatedAnnotation(Declaration node) =>
      node?.metadata?.firstWhere((annotation) => _isDeprecated(annotation),
          orElse: () => null);
}

/// A visitor that extracts a [PropertyInfo] for every @Input and @Output
/// property.
///
/// Only passes [_filePath] through the the indivudual extractor each
/// [PropertyInfo].
class _AllMemberDocsExtraction
    extends SimpleAstVisitor<Iterable<PropertyInfo>> {
  final _MemberDocExtraction _propertyVisitor;

  _AllMemberDocsExtraction(_filePath)
      : this._propertyVisitor = _MemberDocExtraction(_filePath);

  @override
  visitConstructorDeclaration(ConstructorDeclaration node) =>
      const Iterable.empty();

  @override
  visitMethodDeclaration(MethodDeclaration node) =>
      [node.accept(_propertyVisitor)];

  @override
  visitFieldDeclaration(FieldDeclaration node) =>
      node.fields.variables.map((field) => field.accept(_propertyVisitor));
}

/// A visitor that extracts comments and the name of a class field or method as
/// a [PropertyInfo].
///
/// Only uses [_filePath] to store in the returned [PropertyInfo] to document
/// the file it was extracted from.
class _MemberDocExtraction extends SimpleAstVisitor<PropertyInfo> {
  final String _filePath;

  _MemberDocExtraction(this._filePath);

  @override
  visitMethodDeclaration(MethodDeclaration node) => extractProperty(node);

  @override
  visitVariableDeclaration(VariableDeclaration node) => extractProperty(node);

  /// Extracts information for documenentation from a [MethodDeclaration] or
  /// [VariableDeclaration].
  PropertyInfo extractProperty(Declaration node) {
    return PropertyInfo()
      ..name = (node as dynamic /* MethodDeclaration | VariableDeclaration */)
          .name
          .name
      ..comment = g3docMarkdownToHtml(parseComment(node.documentationComment))
      ..classPath = _filePath;
  }
}

final RegExp _singleLineCommentStart = RegExp(r'^///? ?(.*)');
final RegExp _multiLineCommentStartEnd =
    RegExp(r'^/\*\*? ?([\s\S]*)\*/$', multiLine: true);
final RegExp _multiLineCommentLineStart = RegExp(r'^[ \t]*\* ?(.*)');

/// Pulls the raw text out of a comment (i.e. removes the comment
/// characters).
String parseComment(Comment commentNode) {
  if (commentNode == null) {
    return '';
  }

  // Handle ///-style comments
  if (commentNode.tokens
      .every((t) => _singleLineCommentStart.hasMatch(t.lexeme))) {
    return commentNode.tokens
        .map((t) => _singleLineCommentStart.firstMatch(t.lexeme)[1])
        .join('\n');
  }

  // Handle /* */-style comments
  String comment = commentNode.tokens.single.lexeme;
  Match match = _multiLineCommentStartEnd.firstMatch(comment);
  if (match != null) {
    comment = match[1];
    var sb = StringBuffer();
    List<String> lines = comment.split('\n');
    for (int index = 0; index < lines.length; index++) {
      String line = lines[index].trimRight();
      if (index == 0) {
        sb.write(line); // Add the first line unprocessed.
        continue;
      }
      sb.write('\n');
      match = _multiLineCommentLineStart.firstMatch(line);
      if (match != null) {
        sb.write(match[1]);
      } else {
        sb.write(line);
      }
    }
    return sb.toString().trim();
  }
  throw ArgumentError('Invalid comment $comment');
}
