// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_gallery_section/components/gallery_component/gallery_info.dart';

/// A list of all documentation directives.
const documentationComponentDirectives = [
  DartDocComponent,
  MarkdownDocComponent,
  SassDocComponent,
];

class DocumentationComponent {
  @Input()
  bool showGeneratedDocs;

  final _sanitizedHtml = <String, SafeHtml>{};

  DomSanitizationService _santizationService;

  DocumentationComponent(this._santizationService);

  SafeHtml getSafeHtml(String value) {
    var html = _sanitizedHtml[value];
    if (html == null) {
      html = _santizationService.bypassSecurityTrustHtml(value);
      _sanitizedHtml[value] = html;
    }
    return html;
  }
}

/// Displays documentation for dart files in the gallery application.
///
/// Docs are expected to be generated for Angular @Components and @Directives.
@Component(
  selector: 'documentation-component[dart]',
  directives: [
    NgFor,
    NgIf,
    SafeInnerHtmlDirective,
  ],
  templateUrl: 'dart_doc_component.html',
  styleUrls: ['documentation_component.scss.css'],
)
class DartDocComponent extends DocumentationComponent {
  DartDocComponent(DomSanitizationService santizationService)
      : super(santizationService);

  /// The documentation to display.
  @Input()
  DartDocInfo doc;
}

/// Displays a single piece of documentation.
///
/// Typically used for the generated HTML from a markdown README.
@Component(
  selector: 'documentation-component[markdown]',
  directives: [SafeInnerHtmlDirective],
  template: '<div [safeInnerHtml]="getSafeHtml(doc.contents)"></div>',
  styleUrls: ['documentation_component.scss.css'],
)
class MarkdownDocComponent extends DocumentationComponent {
  MarkdownDocComponent(DomSanitizationService santizationService)
      : super(santizationService);

  /// The documentation to display.
  @Input()
  MarkdownDocInfo doc;
}

/// Displays documentation for Sass files in the gallery application.
///
/// Includes documentation for all variables, functions and mixins avaliable
/// by importing the Sass file.
@Component(
  selector: 'documentation-component[sass]',
  directives: [
    NgFor,
    NgIf,
    SafeInnerHtmlDirective,
  ],
  templateUrl: 'sass_doc_component.html',
  styleUrls: ['documentation_component.scss.css'],
)
class SassDocComponent extends DocumentationComponent {
  SassDocComponent(DomSanitizationService santizationService)
      : super(santizationService);

  /// The documentation to display.
  @Input()
  SassDocInfo doc;
}
