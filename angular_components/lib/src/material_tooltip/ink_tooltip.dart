// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart' show PopupSource;
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_tooltip/module.dart';
import 'package:angular_components/utils/angular/css/css.dart';

import 'tooltip_controller.dart';
import 'tooltip_target.dart';

/// An ink-based overlay meant to deliver contextual information about the
/// element it targets.
///
/// It is a "small" tooltip in that it ought to be one or two lines, at most,
/// and has a maximum width of `320px`.
///
/// Typically, the tooltips are associated with an icon or a button and provide
/// a label or brief helper text about that element. This component should be
/// used with a [TooltipTarget] component which controls its visibility
/// and provides the underlying [HtmlElement] at which the tooltip is targeted.
///
/// Use this component in conjunction with the [MaterialTooltipTargetDirective].
///
/// Consider using [MaterialTooltipDirective] instead; usage is much simpler and
/// it enforces text-only small tooltips.
@Component(
  selector: 'material-tooltip-text',
  providers: [tooltipControllerBinding],
  template: r'''
        <material-popup *ngIf="popupSource != null"
                        ink
                        role="tooltip"
                        [autoDismiss]="false"
                        enforceSpaceConstraints
                        [matchMinSourceWidth]="false"
                        class="aacmtit-ink-tooltip-shadow {{popupClassName}}"
                        trackLayoutChanges
                        [preferredPositions]="positions"
                        [source]="popupSource"
                        [visible]="showPopup">
          <div *deferredContent class="ink-container"
               (mouseover)="onMouseOver()"
               (mouseleave)="onMouseLeave()">
            {{text}}<ng-content></ng-content>
          </div>
        </material-popup>''',
  styleUrls: ['ink_tooltip.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [DeferredContentDirective, NgIf, MaterialPopupComponent],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
)
class MaterialInkTooltipComponent implements Tooltip {
  final TooltipController _tooltipController;
  final ChangeDetectorRef _changeDetector;

  PopupSource _tooltipSource;
  PopupSource get popupSource => _tooltipSource;

  /// Positions at which the tooltip should try to show.
  @Input()
  List<RelativePosition> positions = RelativePosition.AdjacentBottomEdge;

  // Proxy control of this tooltip via the tooltip controller.
  Tooltip _controllerProxy;

  bool _showPopup = false;
  bool get showPopup => _showPopup;

  /// Text content of the tooltip.
  @Input()
  String text;

  /// Classname applied to material-popup for use with mixins.
  ///
  /// Left modifiable so that it can be set by the [MaterialTooltipDirective].
  String popupClassName;

  MaterialInkTooltipComponent(this._tooltipController, this._changeDetector,
      HtmlElement hostElement, @Attribute('tooltipClass') String tooltipClass)
      : popupClassName =
            constructEncapsulatedCss(tooltipClass, hostElement.classes);

  @override
  void activate() {
    _showPopup = true;
    _changeDetector.markForCheck();
  }

  @override
  void deactivate({bool immediate = false}) {
    _showPopup = false;
    _changeDetector.markForCheck();
  }

  void onMouseOver() {
    _tooltipController.keepOpen(this);
  }

  void onMouseLeave() {
    _tooltipController.deactivate(this);
  }

  /// The element at which this tooltip is targeted.
  ///
  /// This is typically set in the template by using a var ref. For example:
  /// ```html
  ///   <span tooltipTarget #target="tooltipTarget">Tip</span>
  ///   <material-tooltip-text [for]="target">My tooltip</material-tooltip-text>
  /// ```
  @Input('for')
  set tooltipRef(TooltipTarget target) {
    if (target == null) return;
    _tooltipSource = target;
    target.setTooltip(tooltipHandle);
  }

  Tooltip get tooltipHandle =>
      _controllerProxy ??= _tooltipController.proxyFor(this);
}
