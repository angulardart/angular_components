// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_gallery_section/components/gallery_component/documentation_info.dart';
import 'package:angular_gallery_section/visitors/path_utils.dart' as path_utils;
import 'package:angular_components/utils/strings/string_utils.dart' as string;

final _invalidCharacters = RegExp(r'[^a-zA-Z0-9 ]');

/// Represents the values used to construct an @GallerySectionConfig annotation
/// resolved from raw Strings to the values used by the gallery generators.
class ResolvedConfig {
  String displayName;
  String group;
  Iterable<DocInfo> docs;
  Iterable<DemoInfo> demos;
  DemoInfo mainDemo;
  Iterable<String> benchmarks;
  Iterable<String> owners;
  Iterable<String> uxOwners;
  Map<String, String> relatedUrls;
  bool showGeneratedDocs;

  ResolvedConfig();

  /// A name for a Dart class that can be used if making a Component from
  /// this GalleryConfigSection.
  ///
  /// Assumes that the name displayed in the gallery is unique.
  String get classSafeName => '${string.camelCase(_cleanName(displayName))}';

  /// A name for a Component selector that can be used if making a Component
  /// from this GalleryConfigSection.
  String get selectorSafeName => '${string.hyphenate(_cleanName(displayName))}';

  /// Replaces all characters that are not letters, numbers or spaces with an
  /// underscore.
  ///
  /// Compresses contiguous whitespace down to a single space after stripping
  /// out unwanted characters.
  String _cleanName(input) {
    var stripped = input.replaceAll(_invalidCharacters, '_');
    // Compress contiguous whitespace down to a single space in final result.
    return stripped.replaceAll(RegExp(r' {2,}'), ' ');
  }

  /// Constructs a new [ResolvedConfig] from a decoded json map.
  ResolvedConfig.fromJson(Map<String, dynamic> jsonMap) {
    displayName = jsonMap['displayName'] as String;
    group = jsonMap['group'] as String;
    docs = (jsonMap['docs'] as Iterable)
        ?.map((element) => DocInfo.fromJson(element));
    demos = (jsonMap['demos'] as Iterable)
        ?.map((element) => DemoInfo.fromJson(element));
    if (jsonMap['mainDemo'] != null) {
      mainDemo = DemoInfo.fromJson(jsonMap['mainDemo']);
    }
    benchmarks = (jsonMap['benchmarks'] as Iterable)?.cast<String>();
    owners = (jsonMap['owners'] as Iterable)?.cast<String>();
    uxOwners = (jsonMap['uxOwners'] as Iterable)?.cast<String>();
    relatedUrls = (jsonMap['relatedUrls'] as Map)?.cast<String, String>();
    showGeneratedDocs = jsonMap['showGeneratedDocs'] as bool;
  }

  /// Returns a json encodeable representation of this [ResolvedConfig].
  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'group': group,
        'docs': docs?.toList(),
        'demos': demos?.toList(),
        'mainDemo': mainDemo,
        'benchmarks': benchmarks?.toList(),
        'owners': owners?.toList(),
        'uxOwners': uxOwners?.toList(),
        'relatedUrls': relatedUrls,
        'showGeneratedDocs': showGeneratedDocs,
      };
}

/// Represents the demos listed in an @GallerySectionConfig annotation resolved
/// to the values used by the gallery generators.
class DemoInfo {
  String type;
  String name;
  String selector;
  String asset;

  DemoInfo();

  /// The import to use to load this demo.
  String get import => path_utils.assetToImport(asset);

  /// The path to the file where this demo is defined.
  String get path => path_utils.assetToPath(asset);

  /// Constructs a new [DemoInfo] from a decoded json map.
  DemoInfo.fromJson(Map<String, dynamic> jsonMap) {
    type = jsonMap['type'] as String;
    name = jsonMap['name'] as String;
    selector = jsonMap['selector'] as String;
    asset = jsonMap['asset'] as String;
  }

  /// Returns a json encodeable representation of this [DemoInfo].
  Map<String, String> toJson() => {
        'type': type,
        'name': name,
        'selector': selector,
        'asset': asset,
      };
}
