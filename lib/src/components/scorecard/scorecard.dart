// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

import '../focus/keyboard_only_focus_indicator.dart';
import '../glyph/glyph.dart';
import '../material_ripple/material_ripple.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/browser/events/events.dart';
import '../../utils/color/color.dart';
import '../../utils/color/palette.dart';

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
/// Content projection can also be used with the <name> element to insert DOM
/// into the label area:
///
///     <acx-scorecard ...>
///         <name>Estimated earnings <i>(NEW)</i></name>
///     </acx-scorecard>
@Component(
    selector: 'acx-scorecard',
    directives: const [MaterialRippleComponent, NgIf, GlyphComponent],
    templateUrl: 'scorecard.html',
    host: const {
      '[attr.tabindex]': 'selectable ? 0 : null',
      '[attr.role]': 'selectable ? "button" : null',
      '(keyup)':
          'resetOutline()', // handled by [KeyboardOnlyFocusIndicatorDirective]
      '(blur)':
          'resetOutline()', // handled by [KeyboardOnlyFocusIndicatorDirective]
      '(mousedown)':
          'hideOutline()', // handled by [KeyboardOnlyFocusIndicatorDirective]
      '(click)':
          'hideOutline()', // handled by [KeyboardOnlyFocusIndicatorDirective]
    },
    styleUrls: const ['scorecard.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ScorecardComponent extends KeyboardOnlyFocusIndicatorDirective {
  final StreamController<bool> _selectionController =
      new LazyStreamController<bool>.broadcast(sync: true);

  bool _isChangePositive = false;
  bool _isChangeNegative = false;
  bool _isChangeNeutral = true;
  bool _selectable = false;
  bool _extraBig = false;
  bool _changeGlyph = false;

  ElementRef _ref;
  HtmlElement get element => _ref.nativeElement;
  ScorecardComponent(ElementRef ref, Renderer renderer, DomService domService)
      : super(ref, renderer, domService) {
    this._ref = ref;
  }

  /// The title of the scorecard.
  @Input()
  @Deprecated('Use label instead')
  String title;

  /// The title of the scorecard.
  String get label => title;
  @Input()
  void set label(String value) {
    title = value;
  }

  /// The value displayed to the user.
  @Input()
  String value;

  /// Whether to display a small change arrow glyph in the description;
  /// optional.
  bool get changeGlyph => _changeGlyph;
  @Input()
  set changeGlyph(bool value) {
    _changeGlyph = getBool(value);
  }

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
  get extraBig => _extraBig;
  @Input()
  set extraBig(value) {
    _extraBig = getBool(value);
  }

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
    switch ((changeType ?? 'NEUTRAL').toUpperCase()) {
      case 'POSITIVE':
        _isChangePositive = true;
        break;
      case 'NEGATIVE':
        _isChangeNegative = true;
        break;
      case 'NEUTRAL':
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
  set selectable(selectable) {
    _selectable = getBool(selectable);
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
