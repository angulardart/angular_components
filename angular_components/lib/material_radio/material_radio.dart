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
import 'package:angular_components/material_radio/material_radio_group.dart';
import 'package:angular_components/material_ripple/material_ripple.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_components/utils/browser/events/events.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

const Icon uncheckedIcon = Icon('radio_button_unchecked');
const Icon checkedIcon = Icon('radio_button_checked');

/// A radio button with material style. Usually used together with
/// `material-radio-group`. Once checked, same radio button can not be unchecked
/// via user action.
///
/// Keyboard interaction for focus is a little unusual, so we are managing our
/// own streams instead of using FocusItemDirective.
///
/// __Attributes:__
///
/// - `no-ink` -- set this attribute to disable the ripple effect on the chip.
@Component(
    selector: 'material-radio',
    directives: [MaterialIconComponent, MaterialRippleComponent, NgIf],
    providers: [ExistingProvider(HasDisabled, MaterialRadioComponent)],
    templateUrl: 'material_radio.html',
    styleUrls: ['material_radio.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialRadioComponent extends RootFocusable
    implements
        ControlValueAccessor<bool>,
        HasDisabled,
        FocusableItem,
        OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final MaterialRadioGroupComponent _group;
  final HtmlElement _root;
  final _disposer = Disposer.oneShot();

  MaterialRadioComponent(
      this._root,
      this._changeDetector,
      @Host() @Optional() this._group,
      @Self() @Optional() NgControl cd,
      @Attribute('role') String role)
      : this.role = role ?? 'radio',
        super(_root) {
    // When NgControl is present on the host element, the component
    // participates in the Forms API.
    cd?.valueAccessor = this;
  }

  @visibleForTemplate
  @HostBinding('class')
  static const hostClass = 'themeable';

  @HostBinding('attr.role')
  final String role;

  @override
  void writeValue(bool isChecked) {
    checked = isChecked;
  }

  @override
  void registerOnChange(ChangeFunction<bool> callback) {
    _disposer.addStreamSubscription(onChecked.listen(callback));
  }

  // onTouched API is not supported for now.
  @override
  void registerOnTouched(_) {}

  @override
  void onDisabledChanged(bool isDisabled) {
    disabled = isDisabled;
    _changeDetector.markForCheck();
  }

  /// Value this radio represents, used in selection model with radio-group.
  @Input()
  dynamic value;

  /// Whether the radio should not respond to events, and have a style that
  /// suggests that interaction is not allowed.
  @Input()
  @HostBinding('class.disabled')
  @HostBinding('attr.aria-disabled')
  bool disabled = false;

  /// Published when the radio selection state changes.
  @Output('checkedChange')
  Stream<bool> get onChecked => _onChecked.stream;
  final _onChecked = StreamController<bool>.broadcast();

  /// Whether the radio should be preselected.
  @Input()
  set checked(bool isChecked) {
    if (_checked == isChecked) return;
    _checked = isChecked;
    _changeDetector.markForCheck();

    if (_group != null) {
      if (isChecked) {
        _group.componentSelection.select(this);
      } else {
        _group.componentSelection.deselect(this);
      }
    }
    _onChecked.add(_checked);
  }

  @HostBinding('attr.aria-checked')
  bool get checked => _checked;
  bool _checked = false;

  /// Current icon, depends on the state of [checked].
  @visibleForTemplate
  Icon get icon => _checked ? checkedIcon : uncheckedIcon;

  /// Current tab index, depends on state of [disabled] and selection status
  /// if in group.
  @HostBinding('attr.tabindex')
  @visibleForTesting
  @visibleForTemplate
  int get tabIndex => disabled ? -1 : _enabledTabIndex;

  int _enabledTabIndex = 0;

  @override
  set tabbable(bool isTabbable) {
    _enabledTabIndex = isTabbable ? 0 : -1;
    _changeDetector.markForCheck();
  }

  final _focusMoveCtrl = StreamController<FocusMoveEvent>.broadcast(sync: true);
  final _selectionMoveCtrl =
      StreamController<FocusMoveEvent>.broadcast(sync: true);

  @override
  Stream<FocusMoveEvent> get focusmove => _focusMoveCtrl.stream;
  Stream<FocusMoveEvent> get selectionmove => _selectionMoveCtrl.stream;

  // Capture keydown to forward event to radio group when cycling focus.
  @HostListener('keydown')
  @visibleForTemplate
  void handleKeyDown(KeyboardEvent event) {
    if (event.target != _root) return;
    var focusEvent = FocusMoveEvent.fromKeyboardEvent(this, event);

    if (focusEvent == null) return;
    if (event.ctrlKey) {
      _focusMoveCtrl.add(focusEvent);
    } else {
      _selectionMoveCtrl.add(focusEvent);
    }
    // Required to prevent window from scrolling.
    event.preventDefault();
  }

  // Capture keyup when we are the target of event.
  @HostListener('keyup')
  @visibleForTemplate
  void handleKeyUp(KeyboardEvent event) {
    if (event.target != _root) return;
    _isKeyboardEvent = true;
  }

  bool _isFocused = false;
  bool _isKeyboardEvent = false;

  /// Whether focus should be drawn.
  @visibleForTemplate
  bool get showFocus => _isFocused && _isKeyboardEvent;

  @HostListener('focus')
  @visibleForTesting
  @visibleForTemplate
  void onFocus() {
    _isFocused = true;
    if (_group != null) _group.focusSelection.select(this);
  }

  @HostListener('blur')
  @visibleForTemplate
  @visibleForTesting
  void onBlur() {
    _isFocused = false;
    if (_group != null) _group.focusSelection.deselect(this);
  }

  @visibleForTesting
  void select() {
    if (!disabled) checked = true;
  }

  @HostListener('click')
  @visibleForTemplate
  void handleClick() {
    _isKeyboardEvent = false;
    select();
  }

  @HostListener('keypress')
  @visibleForTemplate
  void handleKeyPress(KeyboardEvent event) {
    if (event.target != _root || !isSpaceKey(event)) return;
    // Required to prevent window from scrolling.
    event.preventDefault();
    _isKeyboardEvent = true;
    select();
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  // Unimplemented in M1.
  Future get focusDelegate async => null;
  String radioGroupName;
}
