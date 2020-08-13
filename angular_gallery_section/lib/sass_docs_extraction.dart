// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:sass/src/ast/sass.dart';
import 'package:angular_gallery_section/g3doc_markdown.dart';
import 'package:angular_gallery_section/components/gallery_component/documentation_info.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as path_utils;

/// Collects documentation information from a Sass file identified by [assetId].
///
/// Assigns [name] as a readable identifier for the docs. Will read [assetId]
/// with [assetReader]. Does not collect documentation for variables, functions
/// and mixins when their name starts with an underscore.
Future<SassDocInfo> extractSassDocs(
    String name, AssetId assetId, AssetReader assetReader) async {
  var libraryDoc = '';
  final contents = await assetReader.readAsString(assetId);
  final stylesheet = Stylesheet.parseScss(contents);
  final variableDeclarations = <SassVariableInfo>[];
  final functionRules = <SassCallableInfo>[];
  final mixinRules = <SassCallableInfo>[];

  final first = stylesheet.children.firstWhere((_) => true, orElse: () => null);
  if (first is SilentComment) {
    final second =
        stylesheet.children.skip(1).firstWhere((_) => true, orElse: () => null);
    if (second is! VariableDeclaration &&
        second is! FunctionRule &&
        second is! MixinRule) {
      libraryDoc = _formatComment(first);
    }
  }

  for (var node in stylesheet.children) {
    // Collect the variables, functions and mixins that do not have names
    // starting with an underscore.
    if (node is VariableDeclaration && !node.name.startsWith('_')) {
      variableDeclarations.add(SassVariableInfo(
          node.name, node.expression.toString(), _formatComment(node.comment)));
    } else if (node is FunctionRule && !node.name.startsWith('_')) {
      functionRules.add(_extractCallable(node));
    } else if (node is MixinRule && !node.name.startsWith('_')) {
      mixinRules.add(_extractCallable(node));
    }
  }

  return SassDocInfo(name, path_utils.assetToPath(assetId.toString()),
      libraryDoc, variableDeclarations, functionRules, mixinRules);
}

/// Gathers the information needed to document a [callable] (function or
/// mixin).
///
/// Skips arguments when their names starts with an underscore.
SassCallableInfo _extractCallable(CallableDeclaration callable) {
  final args = callable.arguments.arguments
      .map((arg) => SassArgumentInfo(arg.name, arg.defaultValue?.toString()));
  var restArg = callable.arguments.restArgument;
  restArg = restArg != null && !restArg.startsWith('_') ? restArg : null;
  return SassCallableInfo(
      callable.name,
      args.where((arg) => !arg.name.startsWith('_')),
      restArg,
      _formatComment(callable.comment));
}

/// Extracts any documentation (triple slash) comments from [silentComment].
///
/// The comment text is assumed to be markdown and converted to HTML.
String _formatComment(SilentComment silentComment) {
  if (silentComment?.docComment == null) return '';

  return g3docMarkdownToHtml(silentComment.docComment);
}
