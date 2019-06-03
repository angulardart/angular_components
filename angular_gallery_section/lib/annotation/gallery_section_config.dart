// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An annotation for configuring a section in an Angular component gallery.
///
/// A section is typically equivalent to a package that contains one or a few
/// related components.
class GallerySectionConfig {
  /// The name of the component which is being demonstrated, to be listed in a
  /// gallery's navigation menu.
  final String displayName;

  /// The name of the navigation group this component belongs to.
  final String group;

  /// A list of resources to pull documentation from this can be dart documents
  /// from classes or functions, or an asset id of markdown files.
  ///
  /// Specify docs in the order that they should be displayed. Asset id must be
  /// a String of the form 'package|path/to/asset.md'.
  final List<dynamic /* Type | Function | String*/ > docs;

  /// A list of example component classes to include in the section.
  ///
  /// Specify demos in the order that they should be displayed.
  final List<Type> demos;

  /// A main example component class to include at the top of the section.
  ///
  /// This should be used for a focused demo and more detailed examples should
  /// be added in the demos section.
  final Type mainDemo;

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

  const GallerySectionConfig(
      {this.displayName,
      this.group,
      this.docs,
      this.demos,
      this.mainDemo,
      this.benchmarks,
      this.owners,
      this.uxOwners,
      this.relatedUrls,
      this.showGeneratedDocs});
}
