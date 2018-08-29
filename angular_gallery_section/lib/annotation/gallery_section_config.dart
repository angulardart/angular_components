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

  /// The embed URLs for benchmark charts to display in this section.
  ///
  /// The charts are displayed in the order they are specified here.
  ///
  /// TODO(google) Cleanup temporary compatability while migrating.
  /// Benchmarks can also be listed by name.
  final List<String> benchmarks;

  /// A string prefix for acx benchmarks, defaults to 'acx_benchmarks_guitar'.
  final String benchmarkPrefix;

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
      this.docs,
      this.demos,
      this.benchmarks,
      this.benchmarkPrefix,
      this.owners,
      this.uxOwners,
      this.relatedUrls,
      this.showGeneratedDocs});
}
