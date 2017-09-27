// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../model/ui/icon.dart';
import '../../utils/async/async.dart';
import '../../utils/browser/events/events.dart';
import '../../utils/disposer/disposer.dart';
import '../focus/focus.dart';
import '../glyph/glyph.dart';
import '../material_ripple/material_ripple.dart';
import './material_radio_group.dart';

const Icon uncheckedIcon = const Icon('radio_button_unchecked');
const Icon checkedIcon = const Icon('radio_button_checked');

/// A radio button with material style. Usually used together with
/// `material-radio-group`. Once checked, same radio button can not be unchecked
/// via user action.
///
/// Keyboard interaction for focus is a little unusual, so we are managing our
/// own streams instead of using FocusItemDirective.
///
/// __attributes:__
///
/// - `no-ink` -- set this attribute to disable the ripple effect on the chip.
///
@Component(
    selector: 'material-radio',
    host: const {
      'class': 'themeable',
      '(click)': r'handleClick($event)',
      '(keypress)': r'handleKeyPress($event)',
      '(keydown)': r'handleKeyDown($event)',
      '(keyup)': r'handleKeyUp($event)',
      '(focus)': r'onFocus()',
      '(blur)': r'onBlur()',
      '[attr.role]': 'role',
      '[class.disabled]': 'disabled',
      '[attr.tabindex]': 'tabIndex',
      '[attr.aria-disabled]': 'disabled',
    },
    directives: const [GlyphComponent, MaterialRippleComponent, NgIf],
    templateUrl: 'material_radio.html',
    styleUrls: const ['material_radio.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false)
class MaterialRadioComponent extends RootFocusable
    implements ControlValueAccessor, FocusableItem, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final Disposer _disposer = new Disposer.oneShot();
  final MaterialRadioGroupComponent _group;
  final HtmlElement _root;
  final String role;

  MaterialRadioComponent(
      this._root,
      this._changeDetector,
      @Host() @Optional() this._group,
      @Self() @Optional() NgControl cd,
      @Attribute('role') String role)
      : this.role = role ?? 'radio',
        super(_root) {
    // participates in the Forms API.
    if (cd != null) {
      cd.valueAccessor = this;
    }
    _syncAriaChecked();
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  @override
  writeValue(newValue) {
    // Need to ignore the null on init.
    if (newValue == null) return;
    checked = newValue as bool;
  }

  @override
  registerOnChange(callback) {
    _disposer
        .addStreamSubscription(onChecked.listen((value) => callback(value)));
  }

  // onTouched API is not supported for now.
  @override
  registerOnTouched(callback) {
    // not implemented
  }

  /// Value this radio represents, used in selection model with radio-group.
  @Input()
  dynamic value;

  /// Whether the radio should not respond to events, and have a style that
  /// suggests that interaction is not allowed.
  @Input()
  set disabled(bool disabled) {
    if (_disabled == disabled) return;
    _disabled = disabled;
    _updateTabIndex();
  }

  bool get disabled => _disabled;
  bool _disabled = false;

  /// Published when the radio selection state changes.
  @Output('checkedChange')
  Stream<bool> get onChecked => _onChecked.stream;
  final _onChecked = new StreamController<bool>.broadcast();

  /// Whether the radio should be preselected.
  @Input()
  set checked(bool newValue) {
    if (_checked == newValue) return;
    // TODO(google): A video test fails without this MarkForCheck, but
    // it shouldn't be needed for @Inputs.
    _changeDetector.markForCheck();

    _icon = newValue ? checkedIcon : uncheckedIcon;

    if (_group != null) {
      if (newValue) {
        _group.componentSelection.select(this);
      } else {
        _group.componentSelection.deselect(this);
      }
    }

    _checked = newValue;
    _syncAriaChecked();
    _onChecked.add(_checked);
  }

  bool get checked => _checked;
  bool _checked = false;

  /// Current icon, depends on the state of [checked].
  Icon get icon => _icon;
  Icon _icon = uncheckedIcon;

  /// Current tab index, depends on state of [disabled] and selection status
  /// if in group.
  String get tabIndex => '$_tabIndex';
  int _tabIndex = 0;
  int _enabledTabIndex = 0;

  void _updateTabIndex() {
    _tabIndex = _disabled ? -1 : _enabledTabIndex;
  }

  @override
  set tabbable(bool tabbable) {
    _enabledTabIndex = tabbable ? 0 : -1;
    _updateTabIndex();
    _changeDetector.markForCheck();
  }

  final _focusMoveCtrl =
      new LazyStreamController<FocusMoveEvent>.broadcast(sync: true);
  final _selectionMoveCtrl =
      new LazyStreamController<FocusMoveEvent>.broadcast(sync: true);

  @override
  Stream<FocusMoveEvent> get focusmove => _focusMoveCtrl.stream;
  Stream<FocusMoveEvent> get selectionmove => _selectionMoveCtrl.stream;

  // Capture keydown to forward event to radio group when cycling focus.
  void handleKeyDown(KeyboardEvent event) {
    if (event.target != _root) return;
    var focusEvent = new FocusMoveEvent.fromKeyboardEvent(this, event);
    if (focusEvent != null) {
      if (event.ctrlKey) {
        _focusMoveCtrl.add(focusEvent);
      } else {
        _selectionMoveCtrl.add(focusEvent);
      }
      // Required to prevent window from scrolling.
      event.preventDefault();
    }
  }

  // Capture keyup when we are the target of event.
  void handleKeyUp(KeyboardEvent event) {
    if (event.target != _root) return;
    _isKeyboardEvent = true;
  }

  var _focused = false;
  var _isKeyboardEvent = false;

  /// Whether focuse should be drawn.
  bool get showFocus => _focused && _isKeyboardEvent;

  void onFocus() {
    _focused = true;
    if (_group != null) {
      _group.focusSelection.select(this);
    }
  }

  void onBlur() {
    _focused = false;
    if (_group != null) {
      _group.focusSelection.deselect(this);
    }
  }

  // Visible for testing.
  void select() {
    if (disabled) return;
    checked = true;
  }

  void handleClick(MouseEvent mouseEvent) {
    _isKeyboardEvent = false;
    select();
  }

  void handleKeyPress(KeyboardEvent event) {
    if (event.target != _root) return;
    if (isSpaceKey(event)) {
      // Required to prevent window from scrolling.
      event.preventDefault();
      _isKeyboardEvent = true;
      select();
    }
  }

  String get _ariaChecked => checked is bool ? '$checked' : 'mixed';

  void _syncAriaChecked() {
    if (_root == null) return;
    _root.attributes['aria-checked'] = _ariaChecked;
  }
}
