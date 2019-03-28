// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_components/utils/browser/events/events.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

const Icon uncheckedIcon = Icon('check_box_outline_blank');
const Icon checkedIcon = Icon('check_box');
const Icon indeterminateIcon = Icon('indeterminate_check_box');

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
/// __Attributes:__
///
/// - `no-ink` -- set this attribute to disable the ripple effect on the chip.
///
@Component(
  selector: 'material-checkbox',
  providers: [ExistingProvider(HasDisabled, MaterialCheckboxComponent)],
  directives: [MaterialIconComponent, MaterialRippleComponent, NgIf],
  templateUrl: 'material_checkbox.html',
  styleUrls: ['material_checkbox.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialCheckboxComponent
    implements ControlValueAccessor<bool>, HasDisabled, Focusable, OnDestroy {
  @visibleForTemplate
  @HostBinding('class')
  static const hostClass = 'themeable';

  final ChangeDetectorRef _changeDetector;
  final HtmlElement _root;
  final String _defaultTabIndex;

  @HostBinding('attr.role')
  final String role;
  Function _onTouched;

  MaterialCheckboxComponent(
      this._root,
      this._changeDetector,
      @Self() @Optional() NgControl cd,
      @Attribute('tabindex') String hostTabIndex,
      @Attribute('role') String role)
      : _defaultTabIndex =
            hostTabIndex?.isNotEmpty ?? false ? hostTabIndex : '0',
        this.role = role ?? 'checkbox' {
    // When NgControl is present on the host element, the component
    // participates in the Forms API.
    if (cd != null) {
      cd.valueAccessor = this;
    }
    _syncAriaChecked();
  }

  @override
  void writeValue(bool isChecked) {
    // Need to ignore the null on init.
    if (isChecked == null) return;
    _setStates(checked: isChecked, emitEvent: false);
  }

  @override
  void registerOnChange(callback) {
    onChecked.listen((checked) => callback(checked));
  }

  @override
  void registerOnTouched(callback) {
    _onTouched = callback;
  }

  /// Fired when checkbox is checked or unchecked, but not when set
  /// indeterminate. Sends the state of [checked].
  @Output('checkedChange')
  Stream<bool> get onChecked => _onChecked.stream;
  final _onChecked = StreamController<bool>.broadcast();

  /// Fired when checkbox goes in and out of indeterminate state, but not when
  /// set to checked.
  ///
  /// Sends the state of [indeterminate].
  @Output('indeterminateChange')
  Stream<bool> get onIndeterminate => _onIndeterminate.stream;
  final _onIndeterminate = StreamController<bool>.broadcast();

  /// Fired when checkbox state changes, sends [checkedStr], i.e. ARIA state.
  @Output('change')
  Stream<String> get onChange => _onChange.stream;
  final _onChange = StreamController<String>.broadcast();

  /// Determines the state to go into when [indeterminate] state is toggled.
  ///
  /// `true` will go to checked and `false` will go to unchecked.
  @Input()
  bool indeterminateToChecked = false;

  /// Whether the checkbox should not respond to events, and have a style that
  /// suggests that interaction is not allowed.
  @HostBinding('class.disabled')
  @HostBinding('attr.aria-disabled')
  @Input()
  bool disabled = false;

  // Current tab index.
  @HostBinding('attr.tabindex')
  @visibleForTemplate
  String get tabIndex => disabled ? "-1" : _defaultTabIndex;

  /// Current state of the checkbox. This is user set-able state, via
  /// [toggleChecked()], so when checked, the [indeterminate] state gets
  /// cleared.
  ///
  /// `true` is CHECKED and `false` is not.
  @Input()
  set checked(bool newValue) {
    if (_checked == newValue) return;
    _setStates(checked: newValue);
  }

  /// Whether button is checked.
  bool get checked => _checked;
  bool _checked = false;

  /// Whether the checkbox can be changed by user interaction.
  @Input()
  bool readOnly = false;

  var _focused = false;
  var _isKeyboardEvent = false;

  /// Whether focus should be drawn.
  @visibleForTemplate
  bool get showFocus => _focused && _isKeyboardEvent;

  /// ARIA-checked state, like icon, has 3 states.
  @visibleForTemplate
  String get checkedStr => _checkedStr;
  String _checkedStr = uncheckedAriaState;

  /// Alternative state of the checkbox, not user set-able state. Between
  /// [checked] and [indeterminate], only one can be true, though both can be
  /// false.
  ///
  /// `true` is INDETERMINATE and `false` is not.
  @Input()
  set indeterminate(bool newValue) {
    if (_indeterminate == newValue) return;
    _setStates(indeterminate: newValue);
  }

  bool get indeterminate => _indeterminate;
  bool _indeterminate = false;

  /// Actually update the state variables.
  ///
  /// If both parameters are provided, then set them as presented, otherwise we
  /// will clear the other one if necessary. Events are only fired if there was
  /// a change and [emitEvent] is true.
  void _setStates(
      {bool checked = false,
      bool indeterminate = false,
      bool emitEvent = true}) {
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

    if (emitEvent && _checked != prevChecked) {
      _onChecked.add(_checked);
    }

    if (emitEvent && _indeterminate != prevIndeterminate) {
      _onIndeterminate.add(_indeterminate);
    }

    if (_checkedStr != prevState) {
      _syncAriaChecked();
      _onChange.add(_checkedStr);
    }
  }

  void _syncAriaChecked() {
    if (_root == null) return;
    _root.attributes['aria-checked'] = _checkedStr;
    _changeDetector?.markForCheck();
  }

  /// Current icon, depends on the state of [checked] and [indeterminate].
  @visibleForTemplate
  Icon get icon => _icon;
  Icon _icon = uncheckedIcon;

  /// Color of the checkbox and ripple when checked.
  ///
  /// Example: '#FF00FF'. By default it is $mat-blue-500. Note that the
  /// themeColor is applied to the checkbox even when the box is unchecked,
  /// which deviates from the standard material spec. Use mixin to set
  /// themeColor unless you want this behavior.
  @visibleForTemplate
  @Input()
  String themeColor;

  /// Color of the ripple.
  ///
  /// When the checkbox is unchecked, the ripple color does not follow theme
  /// color.
  @visibleForTemplate
  String get rippleColor => checked ? themeColor : '';

  /// Label for the checkbox, alternatively use content.
  @Input()
  String label;

  /// Id for the checkbox label and content.
  @visibleForTemplate
  @HostBinding('attr.aria-labelledby')
  final contentId = SequentialIdGenerator.fromUUID().nextId();

  /// Toggles checkbox via user action.
  ///
  /// When it is indeterminate, toggle can go to checked or unchecked, depending
  /// on state [indeterminateToChecked].
  @visibleForTesting
  void toggleChecked() {
    if (disabled || readOnly) return;
    if (!indeterminate && !checked) {
      _setStates(checked: true);
    } else if (checked) {
      _setStates();
    } else {
      assert(indeterminate);
      _setStates(checked: indeterminateToChecked);
    }
  }

  @override
  void focus() {
    if (disabled) return;

    // Set to true so that the focus indicator is rendered.
    _isKeyboardEvent = true;

    _root.focus();
  }

  // Capture keyup when we are the target of event.
  @HostListener('keyup')
  @visibleForTemplate
  void handleKeyUp(KeyboardEvent event) {
    if (event.target != _root) return;
    _isKeyboardEvent = true;
  }

  @HostListener('click')
  @visibleForTemplate
  void handleClick(MouseEvent mouseEvent) {
    if (disabled) return;
    _isKeyboardEvent = false;
    toggleChecked();
  }

  @HostListener('mousedown')
  @visibleForTemplate
  void handleMouseDown(MouseEvent mouseEvent) {
    // This removes the text selection behavior of mousedown.
    if (readOnly) {
      mouseEvent.preventDefault();
    }
  }

  @HostListener('keypress')
  @visibleForTemplate
  void handleKeyPress(KeyboardEvent event) {
    if (disabled) return;
    if (event.target != _root) return;
    if (isSpaceKey(event)) {
      // Required to prevent window from scrolling.
      event.preventDefault();
      _isKeyboardEvent = true;
      toggleChecked();
    }
  }

  // Triggered on focus.
  @HostListener('focus')
  @visibleForTemplate
  void handleFocus(_) {
    _focused = true;
  }

  // Triggered on blur.
  @HostListener('blur')
  @visibleForTemplate
  void handleBlur(Event event) {
    _focused = false;
    _onTouched?.call();
  }

  @override
  void onDisabledChanged(bool isDisabled) {
    disabled = isDisabled;
    _changeDetector?.markForCheck();
  }

  /// Unimplemented for M1.
  Future focusDelegate;
  void ngOnDestroy() {}
}
