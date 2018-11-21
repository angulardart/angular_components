// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';
import 'package:angular_components/scorecard/scoreboard.dart';
import 'package:angular_components/scorecard/scorecard.dart';
import 'package:angular_components/utils/color/material.dart';

@GallerySectionConfig(
  displayName: 'Scorecard',
  docs: [
    ScorecardComponent,
    ScoreboardComponent,
  ],
  demos: [ScorecardDemoComponent],
)
class ScorecardGalleryConfig {}

@Component(
    selector: 'scorecard-demo',
    providers: [rtlProvider],
    directives: [
      formDirectives,
      materialNumberInputDirectives,
      NgFor,
      ScoreboardComponent,
      ScorecardComponent
    ],
    styleUrls: ['scorecard_demo.scss.css'],
    templateUrl: 'scorecard_demo.html',
    // TODO(google): Change preserveWhitespace to false to improve codesize.
    preserveWhitespace: true,
    exports: [green500])
class ScorecardDemoComponent {
  final ScoreboardType selectable = ScoreboardType.selectable;
  final ScoreboardType toggle = ScoreboardType.toggle;
  final ScoreboardType radio = ScoreboardType.radio;
  static const defaultScoreboardRange = 10;

  List<int> range = _createRange(defaultScoreboardRange);

  int _numericValue = defaultScoreboardRange;
  int get numericValue => _numericValue;
  set numericValue(int value) {
    if (value == null || value <= 0) return;
    _numericValue = value;
    range = _createRange(value);
  }

  static List<int> _createRange(int value) =>
      List.generate(value, (index) => index + 1);
}
