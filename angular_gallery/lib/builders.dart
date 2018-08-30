// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:angular_gallery/builder/gallery_app_builder.dart';
import 'package:angular_gallery/builder/gallery_lib_builder.dart';

/// Builders used to generate files in the gallery app target.
Builder galleryAppBuilder(BuilderOptions options) => MultiplexingBuilder([
      GalleryWebBuilder(options.config['galleryTitle'] ?? 'Example Gallery'),
      HomeDartBuilder(),
    ]);

/// Builder used to generate files in the gallery library target.
Builder galleryLibBuilder(BuilderOptions options) => GalleryLibBuilder(
      options.config['galleryTitle'] ?? 'Example Gallery',
      options.config['styleUrls'].cast<String>(),
      (options.config['examples'] as String).split(','),
    );
