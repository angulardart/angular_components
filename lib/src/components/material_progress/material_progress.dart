// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    templateUrl: 'material_progress.html',
    styleUrls: const ['material_progress.scss.css'])
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
