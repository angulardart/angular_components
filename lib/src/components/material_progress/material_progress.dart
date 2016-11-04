// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';

const String ARIA_VALUENOW_ATTR = "aria-valuenow";

/// The progress bars are for situations where the percentage completed can be
/// determined. They give users a quick sense of how much longer an operation
/// will take.
///
/// __Example usage:__
///
///    <material-progress [activeProgress]="10" [secondaryProgress]="30">
///    </material-progress>
///
@Component(
    selector: 'material-progress',
    preserveWhitespace: false,
    templateUrl: 'material_progress.html',
    styleUrls: const ['material_progress.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialProgressComponent {
  /// The current progress value.
  @Input()
  int activeProgress = 0;

  /// The "secondary" progress. Shows up behind the primary progress in a
  /// lighter color.
  @Input()
  int secondaryProgress = 0;

  /// The minimum progress value. Defaults to 0.
  @Input()
  int min = 0;

  /// The maximum progress value. Defaults to 100.
  @Input()
  int max = 100;

  /// Boolean whether the progress bar is deterministic. Default `false`
  @Input()
  bool indeterminate = false;

  String get ariaValue => indeterminate ? null : '$activeProgress';

  String get primaryTransform => 'scaleX(${_calcRatio(activeProgress)})';

  String get secondaryTransform => 'scaleX(${_calcRatio(secondaryProgress)})';

  double _calcRatio(int value) => (value.clamp(min, max) - min) / (max - min);
}
