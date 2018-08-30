// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

/// The model that keeps the details for all of the gallery information
class GalleryInfo {
  /// A list of Doc attributes pull Dart doc comments from.
  ///
  /// Specify docs in the order that they should be displayed.
  final List<Doc> docs;

  /// A list of example component examples to include in the section.
  ///
  /// Specify demos in the order that they should be displayed.
  final List<Demo> demos;

  /// A list of latency test names to include in charts on the API page.
  ///
  /// Specify the latency names in the order they should be displayed.
  final List<String> benchmarks;

  /// A list of owners for the components in this section.
  final List<String> owners;

  /// A list of UX owners for the components in this section.
  final List<String> uxOwners;

  /// Titles and urls of related documents.
  final Map<String, String> relatedUrls;

  /// True if automatically generated documentation for inputs and outputs
  /// should be displayed.
  final bool showGeneratedDocs;

  const GalleryInfo(
      {this.docs = const [],
      this.demos = const [],
      this.benchmarks = const [],
      this.owners = const [],
      this.uxOwners = const [],
      this.relatedUrls = const {},
      this.showGeneratedDocs = true});
}

class Doc {
  final String name;
  final String selector;
  final String exportAs;
  final String path;
  final String comment;
  final List<Property> inputs;
  final List<Property> outputs;
  const Doc(this.name, this.selector, this.exportAs, this.path, this.comment,
      this.inputs, this.outputs);
}

class Demo {
  final ComponentFactory demoFactory;
  final String name;
  final String path;
  const Demo(this.demoFactory, this.name, this.path);
}

class Property {
  final String annotation;
  final String name;
  final String bindingAlias;
  final String type;
  final String comment;
  final String classPath;
  final bool deprecated;
  final String deprecatedMessage;

  const Property(this.annotation, this.name, this.bindingAlias, this.type,
      this.comment, this.classPath, this.deprecated, this.deprecatedMessage);
}
