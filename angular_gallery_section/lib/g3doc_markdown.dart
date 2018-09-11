// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:markdown/markdown.dart';

/// A wrapper for [markdownToHtml] that includes g3doc's shortlinks syntaxes.
String g3docMarkdownToHtml(String markdown) {
  if (markdown.isEmpty) return markdown;

  // Taken directly from http://cs/symbol:kAfterHostName.
  String _afterHostName = r'[\w!#-&(-;=?@^\|-~]*[\w!#$%&(*+/=@^_`|~-]';

  // This list is based off of the g3doc autolinking source code:
  // http://cs/f:render_links.cc.
  var inlineSyntaxes = [
    G3docLinkSyntax(r'\b(?:b/|bug(?:\s+|/))(\d+)\b', 'http://b/$_sub'),
    // TODO(google) hotlist links.
    G3docLinkSyntax(
        r'\b(?:changelist\s+|cr/|cl(?:\s+|/))(\d+)\b', 'http://cl/$_sub'),
    // TODO(google): o/ links.
    G3docLinkSyntax(
        '\\b(?:teams|who)/($_afterHostName)\\b', 'http://teams/$_sub'),
    G3docLinkSyntax('\\bg/($_afterHostName)\\b', 'http://g/$_sub'),
    // TODO(google): plzr/ links.
    // TODO(google): g3doc/, mdb/ links.
    G3docLinkSyntax('\\bgo(?:to)?/($_afterHostName)\\b', 'http://go/$_sub'),
    G3docLinkSyntax('\\bcs/($_afterHostName)\\b', 'http://cs/$_sub'),
    WrappedG3docLinkSyntax(r'\b(TODO\()(b/(\d+))(\))', 'http://b/$_sub'),
    WrappedG3docLinkSyntax(r'\b(TODO\()((\d+))(\))', 'http://b/$_sub'),
    WrappedG3docLinkSyntax(
        '\\b(TODO\\()(($_afterHostName))(\\))', 'http://teams/$_sub'),
    // TODO(google): launch/, ariane/ links.
    // TODO(google): google3/, depot/, java/com/google, javatests/com/google,
    //                 j/c/g, jt/c/g links.
  ];

  return markdownToHtml(markdown,
      extensionSet: ExtensionSet.gitHubFlavored,
      inlineSyntaxes: inlineSyntaxes,
      linkResolver: dartDocLinkResolver);
}

// A substitution string for simple substitution.
const String _sub = '__SUB__';

/// A Markdown link resolver to render Dartdoc links.
///
/// Replaces Dartdoc linked types, properties, etc that appear in square
/// brackets with a code element.
/// Example: [Foo] -> <code>Foo</code>
/// TODO(google) Revisit this after dartdoc issue is resolved.
Node dartDocLinkResolver(String text, [_]) =>
    text.isEmpty ? null : Element.text('code', text);

/// An inline Markdown syntax extension for g3doc-style shortlinks.
///
/// The g3doc autolinks are documented here:
/// http://g3doc/corp/g3doc/docs/reference/markdown.md?cl=head#shortlinks
class G3docLinkSyntax extends InlineSyntax {
  final String substitution;

  /// Initializes a G3docLinkSyntax that replaces [pattern] with [substitution].
  ///
  /// [pattern] needs to have one matching group which contains the "id" of
  /// the shortlink. This id will replace [_sub] in [substitution] to form
  /// the final link destination.
  G3docLinkSyntax(String pattern, this.substitution) : super(pattern);

  @override
  bool onMatch(InlineParser parser, Match match) {
    var text = match[0];
    var id = match[1];
    var url = substitution.replaceFirst(_sub, id);
    var anchor = Element.text('a', text);
    anchor.attributes['href'] = url;
    parser.addNode(anchor);

    return true;
  }
}

/// An inline Markdown syntax extension for wrapped g3doc-style shortlinks.
///
/// The g3doc autolinks are documented here:
/// http://g3doc/corp/g3doc/docs/reference/markdown.md?cl=head#shortlinks
class WrappedG3docLinkSyntax extends InlineSyntax {
  final String substitution;

  /// Initializes a WrappedG3docLinkSyntax that replaces a part of [pattern]
  /// with [substitution].
  ///
  /// [pattern] needs to have four matching groups. The first and fourth will be
  /// left alone as plain text. The second will be the text to be turned into a
  /// link. The third contains the "id" of the shortlink. This id will replace
  /// [_sub] in [substitution] to form the final link destination.
  WrappedG3docLinkSyntax(String pattern, this.substitution) : super(pattern);

  @override
  bool onMatch(InlineParser parser, Match match) {
    var leftText = match[1];
    var linkText = match[2];
    var id = match[3];
    var rightText = match[4];
    var url = substitution.replaceFirst(_sub, id);
    var anchor = Element.text('a', linkText);
    anchor.attributes['href'] = url;
    parser.addNode(Text(leftText));
    parser.addNode(anchor);
    parser.addNode(Text(rightText));

    return true;
  }
}
