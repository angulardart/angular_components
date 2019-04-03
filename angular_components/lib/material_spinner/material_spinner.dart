// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

/// A circular spinner for an indeterminate amount of time following the
/// Material Spec for Progress & Activity.
///
/// See <http://www.google.com/design/spec/components/progress-activity.html>.
///
/// To change the color of the spinner, change the `border-color` in CSS:
///
///     material-spinner {
///       border-color: $mat-red;
///     }
@Component(
  selector: 'material-spinner',
  templateUrl: 'material_spinner.html',
  styleUrls: ['material_spinner.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialSpinnerComponent {}
