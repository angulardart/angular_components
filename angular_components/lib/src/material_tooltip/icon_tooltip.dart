// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/theme/dark_theme.dart';

import 'paper_tooltip.dart';
import 'tooltip_target.dart';

/// An icon that displays a paper tooltip on mouse-hover, click, enter,
/// space, and focus.
///
/// This is essentially the same as showing [MaterialTooltipCard] on a
/// [MaterialIconComponent], except that it shows tooltip on click (as
/// opposed to [MaterialTooltipTarget], which does not have click trigger).
///
/// __Attributes:__
///
/// - `icon` -- The name of the icon. This overrides `type`, if both are
/// provided. See [https://www.google.com/design/icons/] for available icons.
///
/// - `size` -- The size of the icon. Possible values:
///   - `x-small`, `small`, `medium`, `large` and `x-large` correspond to
///     the [MaterialIconComponent] sizes of 12px, 13px, 16px, 18px,
///     and 20px, respectively.
///   - No value defaults to `medium`.
///   - `` -- The empty String corresponds to the default size of
///   [MaterialIconComponent], which is 24px.
///
/// - `type` -- The type of the icon. Possible values:
///   - `help` -- Shows a "help_outline" icon (a circled "?"). (Default)
///   - `info` -- Shows an "info_outline" (a circled "i")
///   - `error` -- Shows an "error_outline" (a circled "!").
@Component(
  selector: 'material-icon-tooltip',
  providers: [
    AcxDarkTheme,
    ExistingProvider(DeferredContentAware, MaterialIconTooltipComponent),
  ],
  template: r'''
    <material-icon
        [attr.aria-label]="helpTooltipLabel"
        [attr.size]="iconSize"
        [icon]="icon"
        keyboardOnlyFocusIndicator
        tabindex="0"
        clickableTooltipTarget #tooltipRef="tooltipTarget">
    </material-icon>
    <material-tooltip-card
        [for]="tooltipRef"
        [preferredPositions]="preferredPositions"
        [offsetX]="offsetX"
        [offsetY]="offsetY">
      <ng-content></ng-content>
    </material-tooltip-card>''',
  styleUrls: ['icon_tooltip.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    ClickableTooltipTargetDirective,
    MaterialIconComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialPaperTooltipComponent
  ],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MaterialIconTooltipComponent implements DeferredContentAware {
  final _contentVisible = StreamController<bool>.broadcast(sync: true);

  HtmlElement element;

  /// Icon identifier for [MaterialIconComponent]. See
  /// [https://www.google.com/design/icons/] for available icons.
  final String icon;

  /// Size of the icon. Must be a valid size for [MaterialIconComponent].
  final String iconSize;

  /// Relative positions where to try to show the tooltip.
  ///
  /// Defaults to:
  ///
  /// `[RelativePosition.OffsetBottomRight,
  /// RelativePosition.OffsetTopLeft,
  /// RelativePosition.OffsetBottomLeft,
  /// RelativePosition.OffsetTopRight]`
  @Input()
  List<RelativePosition> preferredPositions = _defaultPositions;

  /// The x-offset to where the tooltip will be ultimately positioned.
  @Input('offsetX')
  int offsetX = 0;

  /// The y-offset to where the tooltip will be ultimately positioned.
  @Input('offsetY')
  int offsetY = 0;

  MaterialIconTooltipComponent(
      AcxDarkTheme darkTheme,
      this.element,
      @Attribute('icon') String icon,
      @Attribute('type') String type,
      @Attribute('size') String size)
      : icon = icon ?? '${type ?? "help"}_outline',
        iconSize = size ?? 'medium' {
    assert(type == 'help' || type == 'info' || type == 'error' || type == null);
    assert(iconSize == 'x-small' ||
        iconSize == 'small' ||
        iconSize == 'medium' ||
        iconSize == 'large' ||
        iconSize == 'x-large' ||
        iconSize == '');

    darkTheme.themeElement(element);
  }

  @ViewChild('tooltipRef')
  TooltipBehavior tooltipBehavior;

  @ViewChild(MaterialPaperTooltipComponent)
  set deferredContentAware(DeferredContentAware deferredContentAware) {
    _contentVisible.addStream(deferredContentAware.contentVisible);
  }

  @override
  Stream<bool> get contentVisible => _contentVisible.stream;

  static final helpTooltipLabel = Intl.message(
      'Mouseover, click, press Enter key or Space key on this icon for more '
      'information.',
      name: 'MaterialIconTooltipComponent_helpTooltipLabel',
      desc: 'Label for help icon which shows help content.');
}

/// [RelativePosition] list for the ink tooltip.
const _defaultPositions = [
  RelativePosition.OffsetBottomRight,
  RelativePosition.OffsetTopLeft,
  RelativePosition.OffsetBottomLeft,
  RelativePosition.OffsetTopRight,
];
