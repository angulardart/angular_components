// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_gallery_section/components/gallery_component/documentation_info.dart';

// This needs to be a seperate build target for the builders but all runtime
// uses can access it via this export.
export 'package:angular_gallery_section/components/gallery_component/documentation_info.dart';

/// The model that keeps the details for all of the gallery information
class GalleryInfo {
  /// The docs to show in the gallery page in the order that they should appear.
  final List<DocInfo> docs;

  /// A list of example component examples to include in the section.
  ///
  /// Specify demos in the order that they should be displayed.
  final List<Demo> demos;

  // Component example to include at the top of the gallery section.
  final Demo mainDemo;

  /// The embed URLs for benchmark charts to display in this section.
  ///
  /// The charts are displayed in the order they are specified here.
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
      this.mainDemo,
      this.benchmarks = const [],
      this.owners = const [],
      this.uxOwners = const [],
      this.relatedUrls = const {},
      this.showGeneratedDocs = true});
}

class Demo {
  final ComponentFactory demoFactory;
  final String name;
  final String path;
  const Demo(this.demoFactory, this.name, this.path);
}
