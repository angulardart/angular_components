// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/browser/events/events.dart';
import 'package:angular_components/utils/color/color.dart';
import 'package:angular_components/utils/color/material_chart_colors.dart';

/// Standalone scorecard component.
///
/// This component is meant to be reused/embedded in larger components.
///
/// __ng-content:__
///
/// - `name` -- Custom content in the label area.
/// - `value` -- Custom content in the value area.
/// - `description` -- Custom content in the description area.
///   For this to show up, requires also setting the `description` attribute,
///   even if it's only set to the empty string.
@Component(
  selector: 'acx-scorecard',
  directives: [MaterialIconComponent, MaterialRippleComponent, NgIf],
  templateUrl: 'scorecard.html',
  styleUrls: ['scorecard.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class ScorecardComponent extends KeyboardOnlyFocusIndicatorDirective {
  @HostBinding('class')
  static const hostClass = 'themeable';

  static const changeTypePositive = 'POSITIVE';
  static const changeTypeNegative = 'NEGATIVE';
  static const changeTypeNeutral = 'NEUTRAL';

  final StreamController<bool> _selectionController =
      StreamController<bool>.broadcast(sync: true);

  bool _isChangePositive = false;
  bool _isChangeNegative = false;
  bool _isChangeNeutral = true;
  bool _selectable = false;

  final ChangeDetectorRef _changeDetector;
  final HtmlElement element;
  ScorecardComponent(this._changeDetector, this.element, DomService domService)
      : super(element, domService);

  /// The title of the scorecard.
  @Input()
  String label;

  /// The value displayed to the user.
  @Input()
  String value;

  /// The value displayed in a tooltip when the users hovers over the value.
  @Input()
  String tooltip;

  /// Whether to display a small change arrow glyph in the description;
  /// optional.
  @Input()
  bool changeGlyph = false;

  /// A piece of suggestion text before the description; optional.
  @Input()
  String suggestionBefore;

  /// Short description on the scorecard; optional.
  @Input()
  String description;

  /// A piece of suggestion text after the description; optional.
  @Input()
  String suggestionAfter;

  /// Whether to use the "big" class style for scorecards; optional.
  @HostBinding('class.extra-big')
  @Input()
  bool extraBig = false;

  /// Set the type of change depicted by scorecard.
  ///
  /// This determines the style of the description. Possible values are:
  /// * 'POSITIVE'
  /// * 'NEGATIVE'
  /// * 'NEUTRAL' (default)
  @Input()
  set changeType(String changeType) {
    // Reset the flags.
    _isChangePositive = _isChangeNegative = _isChangeNeutral = false;
    switch ((changeType ?? changeTypeNeutral).toUpperCase()) {
      case changeTypePositive:
        _isChangePositive = true;
        break;
      case changeTypeNegative:
        _isChangeNegative = true;
        break;
      case changeTypeNeutral:
        _isChangeNeutral = true;
        break;
      default:
        throw ArgumentError.value(changeType, 'changeType');
    }
  }

  /// Whether the [description] field should be styled as a positive change.
  @HostBinding('class.is-change-positive')
  bool get isChangePositive => _isChangePositive;

  /// Whether the [description] field should be styled as a negative change.
  @HostBinding('class.is-change-negative')
  bool get isChangeNegative => _isChangeNegative;

  /// Whether the [description] field should be styled as a neutral change.
  bool get isChangeNeutral => _isChangeNeutral;

  /// The name of the glyph icon to display next to the change description.
  String get changeGlyphIcon {
    assert(!isChangeNeutral);
    return isChangePositive ? "arrow_upward" : "arrow_downward";
  }

  /// Whether the scorecard is selected.
  @HostBinding('class.selected')
  @Input()
  bool selected = false;

  @HostBinding('class.selectable')
  bool get selectable => _selectable;

  /// Whether the selection state of the scorecard can be changed by clicking.
  @Input()
  set selectable(bool selectable) {
    _selectable = selectable;

    // Normally OnPush will markForCheck() automatically when an input changes.
    // However, that's only if the input changes within the Angular zone.
    // Scoreboard changes this input outside of the Angular zone, so we
    // explicitly markForCheck() here to cover that case.
    _changeDetector.markForCheck();
  }

  @HostBinding('attr.tabindex')
  int get hostTabIndex => selectable ? 0 : null;

  @HostBinding('attr.role')
  String get hostRole => selectable ? "button" : null;

  /// The [Color] to apply to the scorecard background when it is selected.
  @Input()
  Color selectedColor;

  /// Fired when the selection state changes.
  @Output()
  Stream<bool> get selectedChange => _selectionController.stream;

  /// What `style.background`. is set on the host component.
  ///
  /// A [selected] and [selectable] scorecard uses [selectedColor].
  @HostBinding('style.background')
  String get backgroundStyle => selected
      ? selectedColor?.hexString ?? chartingPalette[0].hexString
      : 'inherit';

  @HostListener('click')
  void handleClick() {
    hideOutline();
    if (selectable) {
      selected = !selected;
      _selectionController.add(selected);
    }
  }

  @HostListener('keypress')
  void handleKeypress(KeyboardEvent event) {
    int keyCode = event.keyCode;
    if (selectable && (keyCode == KeyCode.ENTER || isSpaceKey(event))) {
      event.preventDefault();
      handleClick();
    }
  }
}
