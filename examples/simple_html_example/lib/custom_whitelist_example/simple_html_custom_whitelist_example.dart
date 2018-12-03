// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart' show Component, FactoryProvider;
import 'package:angular_components/simple_html/simple_html.dart'
    show SimpleHtmlComponent, simpleHtmlUriWhitelist;

import 'simple_html_custom_whitelist_example_messages.dart';

/// Domains (and paths) that can be linked to from SimpleHTML objects.
///
/// Normally this would be bound to simpleHtmlUriWhitelist by an app-level
/// provider, so that it's not repeated for every component.
List<Uri> getUriWhitelist() => List.unmodifiable(<Uri>[
      Uri.https('developers.google.com', ''),
      Uri.https('wordpress.org', 'plugins/amp/'),
    ]);

/// A component demonstrating the use of a custom URI whitelist with SimpleHTML.
@Component(
  selector: 'simple-html-custom-whitelist-example',
  directives: [SimpleHtmlComponent],
  templateUrl: 'simple_html_custom_whitelist_example.html',
  providers: [
    FactoryProvider.forToken(simpleHtmlUriWhitelist, getUriWhitelist),
  ],
)
class SimpleHtmlCustomWhitelistExampleComponent {
  // For simple messages, we can expose them directly to the template.
  static const SimpleHtmlCustomWhitelistExampleMessages messages =
      SimpleHtmlCustomWhitelistExampleMessages();

  /// Message linking to a URI which is not allowed by default, but is allowed
  /// by our custom whitelist.
  String get linkToUriAllowedByCustomWhitelist =>
      messages.linkTo("https://wordpress.org/plugins/amp/");

  /// Message linking to a URI that is on the same domain as a whitelist entry,
  /// but has the wrong path.
  String get linkToUriSimilarToWhitelistedUri =>
      messages.linkTo("https://wordpress.org/plugins/malware/");

  /// Message linking to a URI that cannot be whitelisted in any way due to
  /// its schema.
  String get linkToJavaScriptUriNeverPermitted =>
      messages.linkTo("javascript:alert(\'!\')");
}
