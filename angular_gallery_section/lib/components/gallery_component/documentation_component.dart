// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
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

  DocumentationComponent();
}

/// Displays documentation for dart files in the gallery application.
///
/// Docs are expected to be generated for Angular @Components and @Directives.
@Component(
  selector: 'documentation-component[dart]',
  directives: [
    NgFor,
    NgIf,
  ],
  templateUrl: 'dart_doc_component.html',
  styleUrls: ['documentation_component.scss.css'],
)
class DartDocComponent extends DocumentationComponent {
  DartDocComponent() : super();

  /// The documentation to display.
  @Input()
  DartDocInfo doc;
}

/// Displays a single piece of documentation.
///
/// Typically used for the generated HTML from a markdown README.
@Component(
  selector: 'documentation-component[markdown]',
  template: '<div>{{doc.contents}}</div>',
  styleUrls: ['documentation_component.scss.css'],
)
class MarkdownDocComponent extends DocumentationComponent {
  MarkdownDocComponent() : super();

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
  ],
  templateUrl: 'sass_doc_component.html',
  styleUrls: ['documentation_component.scss.css'],
)
class SassDocComponent extends DocumentationComponent {
  SassDocComponent() : super();

  /// The documentation to display.
  @Input()
  SassDocInfo doc;
}
