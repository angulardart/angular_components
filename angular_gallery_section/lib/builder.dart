// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:angular_gallery_section/builder/component_api_builder.dart';
import 'package:angular_gallery_section/builder/example_app_builder.dart';
import 'package:angular_gallery_section/builder/gallery_info_builder.dart';
import 'package:angular_gallery_section/builder/gallery_section_builder.dart';
import 'package:angular_gallery_section/builder/gallery_section_summary_builder.dart';

/// Builder used to generate the json summary files about classes annotated with
/// @GallerySectionConfig to be read by the other builders that might not
/// have access to a resolver.
Builder galleryInfoBuilder(BuilderOptions options) =>
    GalleryInfoBuilder(options.config['staticImageServer']);

/// Builder used to generate the API page for the gallery from a
/// @GallerySectionConfig-annotated class.
Builder componentApiBuilder(BuilderOptions options) => ComponentApiBuilder();

/// Builder used to generate the page for a stand alone example app and a
/// summary used in building the gallery from a @GallerySectionConfig-annotated
/// class.
Builder gallerySectionBuilder(BuilderOptions options) => MultiplexingBuilder([
      GallerySectionBuilder(),
      GallerySectionSummaryBuilder(),
    ]);

Builder exampleAppBuilder(BuilderOptions options) =>
    ExampleAppBuilder(options.config['direction'] ?? 'ltr');
