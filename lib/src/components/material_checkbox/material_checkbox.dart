// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular2/angular2.dart';

import '../glyph/glyph.dart';
import '../material_ripple/material_ripple.dart';
import '../../model/ui/icon.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/events/events.dart';

const Icon uncheckedIcon = const Icon('check_box_outline_blank');
const Icon checkedIcon = const Icon('check_box');
const Icon indeterminateIcon = const Icon('indeterminate_check_box');

const uncheckedAriaState = 'false';
const checkedAriaState = 'true';
const indeterminateAriaState = 'mixed';

/// `material-checkbox` is a button that can be either checked or unchecked.
///
/// User can tap the checkbox to check or uncheck it.  Usually you use
/// checkboxes to allow user to select multiple options from a set.  If you
/// have a single ON/OFF option, avoid using a single checkbox and use
/// `material-toggle` instead.
///
/// We are not extending ButtonDecorator because we need to override several
/// attributes, including role, tabindex, but most importantly because checkbox
/// should only be interactible with SPACE, while button is for both SPACE and
/// ENTER.
///
/// __Properties:__
///
/// - `checked: bool` -- Whether the checkbox should be selected.
/// - `disabled: bool` -- Whether the checkbox should not respond to events, and
///   have a style that suggests that interaction is not allowed.
/// - `indeterminate: bool` -- Whether the checkbox should be set to mixed
///   state.
/// - `indeterminateToChecked: bool` -- Whether the checkbox should go to
///    checked state or unchecked when toggled from indeterminate state.
/// - `label: String` -- Label for the checkbox, alternatively use content.
/// - `themeColor: String` -- Color of the checkbox and ripple when checked.
///    Example: '#FF00FF'. By default it is $mat-blue-500.
///    Note that the themeColor is applied to the checkbox even when the box is
///    unchecked, which deviates form the standard material spec. Use mixin to
///    set themeColor unless you want this behavior.
///
/// __Attributes:__
///
/// - `no-ink` -- set this attribute to disable the ripple effect on the chip.
///
/// __Events:__
///
/// - `change: String` -- Published when state changes, i.e. icon changes.
/// - `checked: bool` -- Published when the check state changes.
/// - `indeterminate: bool` -- Published when the indeterminate state changes.
///
/// TODO(google): restore example usage (latest ng2 tries to eval example code)
///
@Component(
    selector: 'material-checkbox',
    inputs: const [
      'checked',
      'disabled',
      'indeterminate',
      'indeterminateToChecked',
      'label',
      'themeColor'
    ],
    outputs: const [
      'onChange: change',
      'onChecked: checkedChange',
      'onIndeterminate: indeterminateChange'
    ],
    host: const {
      'class': 'themeable',
      '(click)': r'handleClick($event)',
      '(keypress)': r'handleKeyPress($event)',
      '(keyup)': r'handleKeyUp($event)',
      '(focus)': r'handleFocus($event)',
      '(blur)': r'handleBlur($event)',
      '[class.disabled]': 'disabled',
      '[attr.aria-disabled]': 'disabled',
      '[attr.role]': 'role != null ? role : "checkbox"',
      '[attr.tabindex]': 'tabIndex',
      '[attr.aria-label]': 'label',
    },
    directives: const [GlyphComponent, MaterialRippleComponent, NgIf],
    preserveWhitespace: false,
    templateUrl: 'material_checkbox.html',
    styleUrls: const ['material_checkbox.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialCheckboxComponent implements ControlValueAccessor {
  final ChangeDetectorRef _changeDetector;
  final ElementRef _root;
  final String _defaultTabIndex;
  final String role;

  MaterialCheckboxComponent(
      this._root,
      this._changeDetector,
      @Self() @Optional() NgControl cd,
      @Attribute('tabindex') String hostTabIndex,
      @Attribute('role') this.role)
      : _defaultTabIndex =
            hostTabIndex?.isNotEmpty ?? false ? hostTabIndex : "0" {
    // When NgControl is present on the host element, the component
    // participates in the Forms API.
    if (cd != null) {
      cd.valueAccessor = this;
    }
    _syncAriaChecked();
  }

  @override
  writeValue(newValue) {
    // Need to ignore the null on init.
    if (newValue == null) return;
    checked = newValue as bool;
  }

  @override
  void registerOnChange(callback) {
    onChecked.listen((checked) => callback(checked));
  }

  // onTouched API is not supported for now.
  @override
  void registerOnTouched(callback) {
    // not implemented
  }

  /// Fired when checkbox is checked or unchecked, but not when set
  /// indeterminate. Sends the state of [checked].
  final onChecked = new LazyEventEmitter.broadcast(sync: false);

  /// Fired when checkbox goes in and out of indeterminate state, but not when
  /// set to checked. Sends the state of [indeterminate];
  final onIndeterminate = new LazyEventEmitter();

  /// Fired when checkbox state changes, sends [checkedStr], i.e. ARIA state.
  final onChange = new LazyEventEmitter();

  /// Determines the state to go into when [indeterminate] state is toggled.
  /// `true` will go to checked and `false` will go to unchecked.
  bool indeterminateToChecked = false;

  bool disabled = false;

  // Current tab index
  String get tabIndex => disabled ? "-1" : _defaultTabIndex;

  /// Current state of the checkbox. This is user set-able state, via
  /// [toggleChecked()], so when checked, the [indeterminate] state gets
  /// cleared.
  /// `true` is CHECKED and `false` is not.
  set checked(bool newValue) {
    if (_checked == newValue) return;
    _setStates(checked: newValue);
  }

  /// Whether button is checked.
  bool get checked => _checked;
  bool _checked = false;

  var _focused = false;
  var _isKeyboardEvent = false;

  /// Whether focus should be drawn.
  bool get showFocus => _focused && _isKeyboardEvent;

  /// ARIA-checked state, like icon, has 3 states.
  String get checkedStr => _checkedStr;
  String _checkedStr = uncheckedAriaState;

  /// Alternative state of the checkbox, not user set-able state. Between
  /// [checked] and [indeterminate], only one can be true, though both can be
  /// false.
  /// `true` is INDETERMINATE and `false` is not.
  set indeterminate(bool newValue) {
    if (_indeterminate == newValue) return;
    _setStates(indeterminate: newValue);
  }

  bool get indeterminate => _indeterminate;
  bool _indeterminate = false;

  /// Actually update the state variables. If both parameters are provided, then
  /// set them as presented, otherwise we will clear the other one if necessary.
  /// Events are only fired if there was a change.
  void _setStates({bool checked: false, bool indeterminate: false}) {
    // At most one can be true.
    assert(!checked || !indeterminate);

    final bool prevChecked = _checked;
    final bool prevIndeterminate = _indeterminate;
    final String prevState = _checkedStr;

    _checked = checked;
    _indeterminate = indeterminate;

    _checkedStr = indeterminate
        ? indeterminateAriaState
        : _checked ? checkedAriaState : uncheckedAriaState;

    _icon = _indeterminate
        ? indeterminateIcon
        : _checked ? checkedIcon : uncheckedIcon;

    if (_checked != prevChecked) {
      onChecked.add(_checked);
    }

    if (_indeterminate != prevIndeterminate) {
      onIndeterminate.add(_indeterminate);
    }

    if (_checkedStr != prevState) {
      _syncAriaChecked();
      onChange.add(_checkedStr);
    }
  }

  void _syncAriaChecked() {
    Element elm = _root?.nativeElement;
    if (elm == null) return;
    elm.attributes['aria-checked'] = _checkedStr;
    _changeDetector?.markForCheck();
  }

  /// Current icon, depends on the state of [checked] and [indeterminate].
  Icon get icon => _icon;
  Icon _icon = uncheckedIcon;

  /// Color of the checkbox.
  String themeColor;

  /// Color of the ripple.
  ///
  /// When the checkbox is unchecked, the ripple color does not follow theme
  /// color.
  String get rippleColor => checked ? themeColor : '';

  /// Label for the checkbox.
  String label;

  /// Toggles checkbox via user action. When it is indeterminate, toggle
  /// can go to checked or unchecked, depending on state
  /// [indeterminateToChecked].
  // Visible for testing.
  void toggleChecked() {
    if (disabled) return;
    if (!indeterminate && !checked) {
      _setStates(checked: true);
    } else if (checked) {
      _setStates();
    } else {
      assert(indeterminate);
      _setStates(checked: indeterminateToChecked);
    }
  }

  // Capture keyup when we are the target of event.
  void handleKeyUp(KeyboardEvent event) {
    if (event.target != _root.nativeElement) return;
    _isKeyboardEvent = true;
  }

  void handleClick(MouseEvent mouseEvent) {
    if (disabled) return;
    _isKeyboardEvent = false;
    toggleChecked();
  }

  void handleKeyPress(KeyboardEvent event) {
    if (disabled) return;
    if (event.target != _root.nativeElement) return;
    if (isSpaceKey(event)) {
      // Required to prevent window from scrolling.
      event.preventDefault();
      _isKeyboardEvent = true;
      toggleChecked();
    }
  }

  // Triggered on focus.
  void handleFocus(_) {
    _focused = true;
  }

  // Triggered on blur.
  void handleBlur(_) {
    _focused = false;
  }
}
