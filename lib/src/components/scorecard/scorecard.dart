// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/browser/events/events.dart';
import '../../utils/color/color.dart';
import '../../utils/color/palette.dart';
import '../focus/keyboard_only_focus_indicator.dart';
import '../material_icon/material_icon.dart';
import '../material_ripple/material_ripple.dart';

/// ACUX standalone scorecard component.
///
/// This component is meant to be reused/embedded in larger components.
///
/// __Example usage:__
///
///      <acx-scorecard
///          label="Estimated earnings"
///          value="$158.22"
///          description="+$24.20 (15%)"
///          suggestionAfter="of last quarter"
///          changeType="POSITIVE">
///      </acx-scorecard>
///
/// To make a scorecard `selectable`, simply flip on the flag. Then [selected]
/// can be used to change and be notified of changes to the selection state:
///
///     <acx-scorecard
///         selectable
///         label="Estimated earnings"
///         value="$158.22"
///         [(selected)]="isSelected">
///     </acx-scorecard>
///
/// To right-align the text in a scorecard add the CSS class 'right-align':
///
///     <acx-scorecard class="right-align"></acx-scorecard>
///
/// Content projection can also be used with the <name> element to insert custom
/// content into the label area, with <value> to insert custom content into
/// the value area, or with <description> to insert custom content into the
/// description area:
///
///     <acx-scorecard ...>
///       <name>Estimated earnings <i>(NEW)</i></name>
///       <value><glyph icon="mode_edit"></glyph></value>
///       <description><b>On track</b></description>
///     </acx-scorecard>
///
/// __Inputs:__
///
/// - `label: String` -- The title of the scorecard.
/// - `value: String` -- The value of the scorecard.
/// - `description: String` -- Short description of the scorecard.
/// - `changeGlyph: bool` -- Whether to display a small change arrow glyph in
///   the description.
/// - `suggestionBefore: String` -- Suggestion text before the description.
/// - `suggestionAfter: String` -- Suggestion text after the description.
/// - `extraBig: bool` -- Whether to use a larger class style.
/// - `changeType: String` -- The type of change: POSITIVE, NEGATIVE, NEUTRAL.
/// - `selectable: bool` -- Whether a scorecard is selectable.
/// - `selected: bool` -- Whether the scorecard is selected.
/// - `selectedColor: Color` -- Color to apply to the selected scorecard.
///
/// __Outputs:__
///
/// - `selectedChange` -- Fired when selection state changes.
@Component(
    selector: 'acx-scorecard',
    directives: const [MaterialIconComponent, MaterialRippleComponent, NgIf],
    templateUrl: 'scorecard.html',
    host: const {
      'class': 'themeable',
      '[attr.tabindex]': 'selectable ? 0 : null',
      '[attr.role]': 'selectable ? "button" : null',
    },
    styleUrls: const ['scorecard.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ScorecardComponent extends KeyboardOnlyFocusIndicatorDirective {
  static const changeTypePositive = 'POSITIVE';
  static const changeTypeNegative = 'NEGATIVE';
  static const changeTypeNeutral = 'NEUTRAL';

  final StreamController<bool> _selectionController =
      new StreamController<bool>.broadcast(sync: true);

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
        throw new ArgumentError.value(changeType, 'changeType');
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

  /// Whether the selection state of the scorecard can be changed by clicking.
  @HostBinding('class.selectable')
  bool get selectable => _selectable;

  @Input()
  set selectable(bool selectable) {
    _selectable = selectable;

    // Normally OnPush will markForCheck() automatically when an input changes.
    // However, that's only if the input changes within the Angular zone.
    // Scoreboard changes this input outside of the Angular zone, so we
    // explicitly markForCheck() here to cover that case.
    _changeDetector.markForCheck();
  }

  /// The [Color] to apply to the scorecard background when it is selected.
  @Input()
  Color selectedColor = chartingPalette[0];

  /// Fired when the selection state changes.
  @Output()
  Stream<bool> get selectedChange => _selectionController.stream;

  /// What `style.background`. is set on the host component.
  ///
  /// A [selected] and [selectable] scorecard uses [selectedColor].
  @HostBinding('style.background')
  String get backgroundStyle => selected ? selectedColor.hexString : 'inherit';

  @HostListener('click')
  void handleClick() {
    hideOutline();
    if (selectable) {
      selected = !selected;
      _selectionController.add(selected);
    }
  }

  @HostListener('keypress', const [r'$event'])
  void handleKeypress(KeyboardEvent event) {
    int keyCode = event.keyCode;
    if (selectable && (keyCode == KeyCode.ENTER || isSpaceKey(event))) {
      event.preventDefault();
      handleClick();
    }
  }
}
