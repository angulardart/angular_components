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

/// A circular spinner for an indeterminate amount of time following the
/// Material Spec for Progress & Activity.
///
/// See <http://www.google.com/design/spec/components/progress-activity.html>.
///
/// __Example usage:__
///
///     <material-spinner></material-spinner>
///
/// To change the color of the spinner, change the `border-color` in CSS:
///
///     material-spinner {
///       border-color: $mat-red;
///     }
@Component(
    selector: 'material-spinner',
    templateUrl: 'material_spinner.html',
    styleUrls: const ['material_spinner.scss.css'],
    changeDetection: ChangeDetectionStrategy.Detached)
class MaterialSpinnerComponent {}
