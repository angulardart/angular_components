// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/material_tooltip/module.dart' as tooltip;
import 'package:angular_gallery_section/annotation/gallery_section_config.dart';
import 'package:angular_gallery_section/components/content/delayed_content.dart';
import 'package:angular_components/theme/dark_theme.dart';

@GallerySectionConfig(
  displayName: 'Material Tooltip',
  docs: [
    MaterialTooltipDirective,
    MaterialPaperTooltipComponent,
    MaterialTooltipTargetDirective,
    ClickableTooltipTargetDirective,
    MaterialInkTooltipComponent,
    MaterialIconTooltipComponent
  ],
  demos: [MaterialTooltipExampleComponent],
)
class MaterialTooltipExamples {}

@Component(
  selector: 'material-tooltip-example',
  providers: [
    popupBindings,
    tooltip.materialTooltipBindings,
  ],
  directives: [
    ClickableTooltipTargetDirective,
    DarkThemeDirective,
    DeferredContentDirective,
    DelayedContentComponent,
    MaterialIconComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialButtonComponent,
    MaterialIconTooltipComponent,
    MaterialInkTooltipComponent,
    MaterialInputComponent,
    MaterialPaperTooltipComponent,
    MaterialPopupComponent,
    MaterialTooltipDirective,
    MaterialTooltipTargetDirective,
    MaterialTooltipSourceDirective
  ],
  templateUrl: 'material_tooltip_example.html',
  styleUrls: ['material_tooltip_example.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: true,
)
class MaterialTooltipExampleComponent {
  final preferredTooltipPositions = const [RelativePosition.OffsetBottomRight];

  /// The following messages would come from `Intl.message`.
  String get tooltipMsg => 'A message that appears in a tooltip.';
  String get longString => 'Number of opportunities linked to this objective '
      'with positive deal value in the current quarter';
}
