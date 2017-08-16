// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';

import '../../../laminate/enums/alignment.dart';
import '../../../laminate/popup/popup.dart' show PopupSource;
import '../../content/deferred_content.dart';
import '../../content/deferred_content_aware.dart';
import '../../material_popup/material_popup.dart';
import '../module.dart';
import 'tooltip_controller.dart';
import 'tooltip_target.dart';

@Injectable()
getTooltipHandle(MaterialPaperTooltipComponent tooltip) =>
    tooltip.tooltipHandle;

/// A paper based overlay meant to convey long-form contextual information about
/// its target element.
///
/// The target for a tooltip card may be any element, such as a button, input,
/// link, etc. The target may also be the `help_outline` icon, which acts as a
/// proxy for the actual target.
///
/// See the Material spec and usage guidelines
/// [https://material.io/guidelines/components/tooltips.html#tooltips-usage]
/// Use this component in conjunction with the [MaterialTooltipTargetDirective].
///
/// This component supports deferred content.
///
/// If your tooltip content is another component, use the
/// [DeferredContentDirective] to load your component only when it is visible.
///
///
/// __Supported Content:__
///
/// The following selectors are automatically styled to tooltip spec:
///
/// - `header`
/// - `footer`
/// - `*` - Non header/footer content is given the tooltip body style.
@Component(
    selector: 'material-tooltip-card',
    providers: const [
      tooltipControllerBinding,
      const Provider(Tooltip, useFactory: getTooltipHandle),
      const Provider(DeferredContentAware,
          useExisting: MaterialPaperTooltipComponent)
    ],
    directives: const [DeferredContentDirective, NgIf, MaterialPopupComponent],
    template: '''
<material-popup *ngIf="popupSource != null"
                [visible]="showPopup"
                enforceSpaceConstraints
                trackLayoutChanges
                [preferredPositions]="preferredPositions"
                [offsetX]="offsetX"
                [offsetY]="offsetY"
                [autoDismiss]="false"
                [source]="popupSource"
                role="tooltip">
  <div class="paper-container"
       (mouseover)="onMouseOver()"
       (mouseleave)="onMouseLeave()">
    <div class="header"><ng-content select="header"></ng-content></div>
    <div class="body"><ng-content></ng-content></div>
    <div class="footer"><ng-content select="footer"></ng-content></div>
  </div>
</material-popup>''',
    styleUrls: const ['paper_tooltip.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialPaperTooltipComponent implements DeferredContentAware, Tooltip {
  PopupSource _tooltipSource;
  PopupSource get popupSource => _tooltipSource;

  /// Positions where to try to show the tooltip.
  @Input()
  List<RelativePosition> preferredPositions = _defaultPositions;

  /// The x-offset to where the tooltip will be ultimately positioned.
  @Input('offsetX')
  int offsetX = 0;

  /// The y-offset to where the tooltip will be ultimately positioned.
  @Input('offsetY')
  int offsetY = 0;

  bool get showPopup => _showPopup;

  final StreamController<bool> _visibleCtrl =
      new StreamController<bool>.broadcast(sync: true);
  @override
  Stream<bool> get contentVisible => _visibleCtrl.stream;

  bool _showPopup = false;

  final TooltipController _tooltipController;
  final ChangeDetectorRef _changeDetector;

  MaterialPaperTooltipComponent(this._tooltipController, this._changeDetector);

  @ViewChild(MaterialPopupComponent)
  set popupChild(MaterialPopupComponent popup) {
    if (popup == null) return;
    _visibleCtrl.addStream(popup.contentVisible);
  }

  @override
  void deactivate({bool immediate: false}) {
    _showPopup = false;
    _changeDetector.markForCheck();
  }

  @override
  void activate() {
    _showPopup = true;
    _changeDetector.markForCheck();
  }

  void onMouseOver() {
    _tooltipController.keepOpen(this);
  }

  void onMouseLeave() {
    _tooltipController.deactivate(this);
  }

  // Proxy control of this tooltip via the tooltip controller.
  Tooltip _controllerProxy;
  Tooltip get tooltipHandle =>
      _controllerProxy ??= _tooltipController.proxyFor(this);

  /// The element at which this tooltip is targeted.
  @Input('for')
  set tooltipRef(TooltipTarget target) {
    if (target == null) return;
    _tooltipSource = target;
    target.setTooltip(tooltipHandle);
  }
}

/// [RelativePosition] list for the ink tooltip.
const _defaultPositions = const [
  RelativePosition.OffsetBottomRight,
  RelativePosition.OffsetTopLeft,
  RelativePosition.OffsetBottomLeft,
  RelativePosition.OffsetTopRight,
];
