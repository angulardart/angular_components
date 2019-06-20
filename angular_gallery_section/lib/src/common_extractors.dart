// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/analyzer.dart';
import 'package:build/build.dart';

/// [AstVisitor] to extract a [SimpleStringLiteral]s, [AdjacentStrings] or
/// [SimpleIdentifier]s.
class StringExtractor extends SimpleAstVisitor<String> {
  @override
  visitSimpleStringLiteral(SimpleStringLiteral node) => node.value;

  @override
  visitAdjacentStrings(AdjacentStrings node) =>
      node.strings.map((literal) => literal.accept(this)).join('');

  @override
  visitStringInterpolation(StringInterpolation node) {
    log.severe('The example gallery generator does support String '
        'interpolation in annotations.');
    return null;
  }

  @override
  visitSimpleIdentifier(SimpleIdentifier node) => node.name;
}

/// [AstVisitor] to extract a [BooleanLiteral].
class BoolExtractor extends SimpleAstVisitor<bool> {
  @override
  visitBooleanLiteral(BooleanLiteral node) => node.value;
}

/// [AstVisitor] to extract a [ListLiteral].
class ListStringExtractor extends SimpleAstVisitor<Iterable<String>> {
  @override
  visitListLiteral(ListLiteral node) =>
      node.elements.map((element) => element.accept(StringExtractor()));
}

/// [AstVisitor] to extract a [MapLiteral] and [MapLiteralEntry].
class MapStringExtractor extends SimpleAstVisitor<Map<String, String>> {
  @override
  visitSetOrMapLiteral(SetOrMapLiteral node) =>
      Map.fromEntries(node.elements.map((collectionElement) {
        var entry = collectionElement as MapLiteralEntry;
        return MapEntry(entry.key.accept(StringExtractor()),
            entry.value.accept(StringExtractor()));
      }));
}
