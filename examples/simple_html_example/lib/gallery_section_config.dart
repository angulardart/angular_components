// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_gallery_section/annotation/gallery_section_config.dart'
    show GallerySectionConfig;
import 'package:angular_components/simple_html/simple_html.dart'
    show SimpleHtmlComponent;

import 'basic_example/simple_html_example.dart';
import 'custom_whitelist_example/simple_html_custom_whitelist_example.dart';

@GallerySectionConfig(
  displayName: 'Simple HTML',
  docs: [
    "package:angular_components/simple_html/README.md",
    SimpleHtmlComponent,
  ],
  demos: [
    SimpleHtmlExampleComponent,
    SimpleHtmlCustomWhitelistExampleComponent,
  ],
)
class SimpleHtmlExamples {}
