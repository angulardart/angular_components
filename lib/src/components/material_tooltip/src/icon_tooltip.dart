// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import '../../content/deferred_content_aware.dart';
import '../../focus/keyboard_only_focus_indicator.dart';
import '../../glyph/glyph.dart';
import '../../theme/dark_theme.dart';

import 'paper_tooltip.dart';
import 'tooltip_target.dart';

/// An icon that displays a paper tooltip on mouse-hover, click, enter,
/// space, and focus.
///
/// This is essentially the same as showing [MaterialTooltipCard] on a
/// [GlyphComponent], except that it shows tooltip on click (as opposed to
/// [MaterialTooltipTarget], which does not have click trigger).
///
/// __Attributes:__
///
/// - `type` -- The type of the icon. Defaults to "help" to show "help_outline"
/// glyph (a circled "?"). The other supported value is "info" for
/// "info_outline" (a circled "i").
@Component(
    selector: 'material-icon-tooltip',
    providers: const [
      AcxDarkTheme,
      const Provider(DeferredContentAware,
          useExisting: MaterialIconTooltipComponent)
    ],
    template: r'''
    <glyph [icon]="icon" [attr.size]="iconSize"
        tabindex="0" [attr.aria-label]="helpTooltipLabel"
        keyboardOnlyFocusIndicator
        clickableTooltipTarget #tooltipRef="tooltipTarget">
    </glyph>
    <material-tooltip-card [for]="tooltipRef">
      <ng-content></ng-content>
    </material-tooltip-card>''',
    styleUrls: const ['icon_tooltip.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      ClickableTooltipTargetDirective,
      GlyphComponent,
      KeyboardOnlyFocusIndicatorDirective,
      MaterialPaperTooltipComponent
    ])
class MaterialIconTooltipComponent implements DeferredContentAware {
  HtmlElement element;

  /// Icon identifier for [GlyphComponent]. See
  /// [https://www.google.com/design/icons/] for available icons.
  final String icon;

  /// Size of the icon. Must be a valid size for [GlyphComponent].
  final String iconSize;

  MaterialIconTooltipComponent(AcxDarkTheme darkTheme, HtmlElement element,
      @Attribute('type') String type, @Attribute('size') String size)
      : icon = '${type ?? "help"}_outline',
        iconSize = size ?? 'medium' {
    assert(type == 'help' || type == 'info' || type == null);
    assert(iconSize == 'x-small' ||
        iconSize == 'small' ||
        iconSize == 'medium' ||
        iconSize == 'large' ||
        iconSize == 'x-large' ||
        iconSize == '');
    this.element = element;
    darkTheme.themeElement(element);
  }

  @ViewChild('tooltipRef')
  TooltipBehavior tooltipBehavior;

  @override
  Stream<bool> get contentVisible => tooltipBehavior.tooltipActivate;

  String get helpTooltipLabel => Intl.message(
      'Mouseover, click, press Enter key or Space key on this icon for more '
      'information.',
      name: 'MaterialIconTooltipComponent_helpTooltipLabel',
      desc: 'Label for help icon which shows help content.');
}
