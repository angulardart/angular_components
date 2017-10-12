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
/// see [module.dart](https://github.com/dart-lang/angular_components/blob/master/lib/material_tooltip/module.dart)
/// for bindings which must be provided in app which use any Material Tooltip
/// component.

export 'package:angular_components/src/material_tooltip/icon_tooltip.dart'
    show MaterialIconTooltipComponent;
export 'package:angular_components/src/material_tooltip/ink_tooltip.dart';
export 'package:angular_components/src/material_tooltip/paper_tooltip.dart'
    show MaterialPaperTooltipComponent;
export 'package:angular_components/src/material_tooltip/tooltip.dart';
export 'package:angular_components/src/material_tooltip/tooltip_controller.dart'
    show Tooltip;
export 'package:angular_components/src/material_tooltip/tooltip_source.dart';
export 'package:angular_components/src/material_tooltip/tooltip_target.dart';
