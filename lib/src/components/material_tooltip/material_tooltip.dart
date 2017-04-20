// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Components and Directives in the Material Tooltip Package.
///
/// - `MaterialTooltipDirective`
/// - `MaterialInkTooltipComponent`
/// - `MaterialTooltipTargetDirective`
/// - `MaterialPaperTooltipComponent`
/// - `MaterialTooltipSourceDirective`
///
/// see [module.dart](https://github.com/dart-lang/angular_components/blob/master/lib/src/components/material_tooltip/lib/module.dart)
/// for bindings which must be provided in app which use any Material Tooltip
/// component.

export 'src/icon_tooltip.dart' show MaterialIconTooltipComponent;
export 'src/ink_tooltip.dart';
export 'src/paper_tooltip.dart' show MaterialPaperTooltipComponent;
export 'src/tooltip.dart';
export 'src/tooltip_controller.dart' show Tooltip;
export 'src/tooltip_source.dart';
export 'src/tooltip_target.dart';
