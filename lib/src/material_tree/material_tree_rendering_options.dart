// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/selection/selection_options.dart';

/// An object to customize material tree rendering.
abstract class MaterialTreeRenderingOptions {
  MaterialTreeRenderingOptions();

  /// checks whether an option group should be expanded.
  bool shouldExpand(OptionGroup group, int index);

  /// Returns how many options to show initially and hide the rest behind a
  /// "View more" link.
  int maxInitialOptionsShown(OptionGroup group, int index);
}
