// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library angular_components.scaffolding.gallery_section.components.gallery_component;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:js/js.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_gallery/gallery/gallery_tokens.dart';
import 'package:angular_gallery_section/components/gallery_component/documentation_component.dart';
import 'package:angular_gallery_section/components/gallery_component/gallery_info.dart';

/// The gallery component details page that encompass the component's dart docs,
/// the different demos examples and the benchmark latency.
@Component(
  selector: 'gallery-component',
  directives: [
    ButtonDirective,
    DynamicComponent,
    NgFor,
    NgIf,
    documentationComponentDirectives,
  ],
  providers: [popupBindings],
  templateUrl: 'gallery_component.html',
  styleUrls: ['gallery_component.scss.css'],
  exports: [DocType],
)
class GalleryComponent {
  /// The base model for the gallery that gathers all of the details needed by
  /// the template.
  @Input()
  GalleryInfo model;

  /// The beginning of a custom url used for the bug link on components.
  ///
  /// Should contain any custom url parameters. A title will be appended.
  final String _bugUrl;

  /// The beginning of the link to the source code for all components.
  final String _sourcecodeUrl;

  /// Used to disable latency charts in testing environments where they can't
  /// load successfully.
  final latencyChartsEnabled =
      !window.location.href.contains('enableLatencyCharts=false');

  GalleryComponent(@bugUrl this._bugUrl, @sourcecodeUrl this._sourcecodeUrl);

  bool get showToc =>
      (model.docs.length + model.demos.length + model.benchmarks.length) > 1;

  String getDocId(DocInfo doc) => '${doc.name.replaceAll(' ', '_')}Doc';

  String getDemoId(Demo demo) => '${demo.name}Demo';

  void scroll(String locator) => querySelector(locator).scrollIntoView();

  String getTeamsLink(String ldap) => 'http://who/$ldap';

  /// Reformats a library path name to a link path that can be used by
  /// CodeSearch.
  String getCodeSearchLink(String componentPath) =>
      componentPath.contains('example')
          ? '$_sourcecodeUrl/examples/$componentPath'
          : '$_sourcecodeUrl$componentPath';
}

/// Applies code highlighting on `<pre><code>` elements within [htmlFragment].
///
/// Relies on syntax highlighting from highlight.js
/// https://github.com/highlightjs/highlight.js which must be loaded in the page
/// first.
String applyHighlighting(String htmlFragment) {
  // Create a temporary document containing the fragment.
  final fragment = DocumentFragment.html(htmlFragment,
      treeSanitizer: _NullNodeTreeSanitizer());

  // Add syntax highlighting css classes.
  fragment
      .querySelectorAll('pre code')
      .forEach((block) => highlightBlock(block));

  return fragment.innerHtml;
}

@JS('hljs.highlightBlock')
external highlightBlock(block);

/// A [NodeTreeSanitizer] that provides no sanitization.
class _NullNodeTreeSanitizer implements NodeTreeSanitizer {
  @override
  void sanitizeTree(Node node) {
    // Do no sanitization.
  }
}
