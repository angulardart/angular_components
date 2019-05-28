// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_radio/material_radio.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// Group containing multiple material radio buttons, enforcing that only one
/// value in the group is selected.
///
/// You can get the value via both [selected] and [ngModel], but you should
/// avoid using both, because ngModel is also getting the value by listening
/// to [onChange], so the values may appear out of sync.
///
/// Preselect of value at group level is done via managed zone, so if it's
/// possible to set it at radio level, do that instead.
///
/// Per accessibility guide line:
/// - SPACE selects
/// - Arrow keys moves focus to next / previous options and selects it
/// - CTL + arrow keys moves focus without selecting
/// - Focus will wrap around to first / last option when navigating with arrows
/// - When navigating with TAB, if nothing is selected, focus goes to first or
///   last option that's not disabled, depending on direction, otherwise focus
///   goes to the selected (except when disabled, then skips group entirely);
///   and jumps out of the group on second tab.
@Component(
  selector: 'material-radio-group',
  template: '<ng-content></ng-content>',
  styleUrls: ['material_radio_group.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  visibility: Visibility.all, // Injected by members of the group.
)
class MaterialRadioGroupComponent
    implements ControlValueAccessor<dynamic>, OnDestroy, AfterContentInit {
  final NgZone _ngZone;
  final _disposer = Disposer.oneShot();

  List<MaterialRadioComponent> _radioComponents = <MaterialRadioComponent>[];

  MaterialRadioGroupComponent(this._ngZone, @Self() @Optional() NgControl cd) {
    // When NgControl is present on the host element, the component participates
    // in the Forms API.
    cd?.valueAccessor = this;

    _disposer.addStreamSubscription(
        componentSelection.selectionChanges.listen((checkedChanges) {
      // Need to uncheck if selection change was made via user action.
      for (var checkedChange in checkedChanges) {
        for (var radioComponent in checkedChange.removed) {
          radioComponent.checked = false;
        }
      }
      // In case this was programmatically selected, thus won't get updated
      // by focus calls.
      _resetTabIndex();
      _selected = _selectedRadioComponent?.value;
      if (_valueSelection != null && _selected != null) {
        _valueSelection.select(_selected);
      }
      _onChange.add(_selected);
    }));

    _disposer.addStreamSubscription(focusSelection.selectionChanges.listen((_) {
      _resetTabIndex();
    }));
  }

  @HostBinding('attr.role')
  static const role = 'radiogroup';

  @HostBinding('attr.tabindex')
  static const tabIndex = -1;

  @ContentChildren(MaterialRadioComponent)
  set radioComponents(List<MaterialRadioComponent> radioComponents) {
    _radioComponents = radioComponents;
    for (var radioComponent in _radioComponents) {
      _disposer
        ..addStreamSubscription(radioComponent.focusmove.listen(_moveFocus))
        ..addStreamSubscription(
            radioComponent.selectionmove.listen(_moveSelection));
    }
  }

  @override
  void writeValue(dynamic selectedValue) {
    if (selectedValue != null) selected = selectedValue;
  }

  @override
  void registerOnChange(ChangeFunction<dynamic> callback) {
    _disposer.addStreamSubscription(onChange.listen(callback));
  }

  // onTouched API is not supported for now.
  @override
  void registerOnTouched(_) {}

  @override
  void onDisabledChanged(bool isDisabled) {}

  void _resetTabIndex() {
    // Since this is updating children that were already dirty-checked,
    // need to delay this change until next angular cycle.
    _ngZone.runAfterChangesObserved(() {
      if (_radioComponents == null) return; // Component was destroyed.
      // Disable everything first.
      for (var radioComponent in _radioComponents) {
        radioComponent.tabbable = false;
      }

      var selectedRadioComponent = _selectedRadioComponent;
      if (selectedRadioComponent != null) {
        // Only selected is tabbable.
        selectedRadioComponent.tabbable = true;
      } else if (focusSelection.isEmpty) {
        // When not focused, set both first and last as tabbable, so either can
        // catch focus depending on direction of tab cycle. Though they will get
        // disbled onFocus, so will tab out of the group properly.
        var focusables = _getFocusableChildren();
        if (focusables.isNotEmpty) {
          focusables
            ..first.tabbable = true
            ..last.tabbable = true;
        }
      }
    });
  }

  /// Published when selection changes. Prefer `(ngModelChange)`.
  @Output('selectedChange')
  Stream<dynamic> get onChange => _onChange.stream;
  final _onChange = StreamController<dynamic>.broadcast();

  /// Selection model containing value object.
  @Input('selectionModel')
  set valueSelection(SelectionModel value) {
    if (_valueSelection == value) return;
    _selectionSubscription?.cancel();
    _valueSelection = value;
    _selectionSubscription = _valueSelection?.selectionChanges?.listen((_) {
      selected = _valueSelection.selectedValues
          .firstWhere((_) => true, orElse: () => null);
    });
  }

  SelectionModel _valueSelection;
  StreamSubscription<List<SelectionChangeRecord<dynamic>>>
      _selectionSubscription;

  /// Internal selection model containing the radio component.
  final componentSelection = SelectionModel<MaterialRadioComponent>.single();

  MaterialRadioComponent get _selectedRadioComponent {
    if (componentSelection.selectedValues.isEmpty) return null;
    return componentSelection.selectedValues.single;
  }

  /// Internal selection model to keep track of radio currently in focus.
  final focusSelection = SelectionModel<MaterialRadioComponent>.single();

  // Keep the preselected value until children are loaded.
  dynamic _preselectedValue;
  bool _isContentInit = false;

  /// Value of currently selected radio. Prefer `[ngModel]`.
  @Input()
  set selected(dynamic selectedValue) {
    if (_radioComponents != null && _isContentInit) {
      for (var radioComponent in _radioComponents) {
        radioComponent.checked = (radioComponent.value == selectedValue);
      }
      // Ensure we don't overwrite the value in the initial callback.
      _preselectedValue = null;
    } else {
      _preselectedValue = selectedValue;
    }
  }

  dynamic _selected;
  dynamic get selected => _selected;

  void _moveFocus(FocusMoveEvent event) => _move(event);
  void _moveSelection(FocusMoveEvent event) => _move(event, true);

  List<MaterialRadioComponent> _getFocusableChildren(
      [MaterialRadioComponent source]) {
    // Make sure current focus is in the list even if it's disabled.
    return _radioComponents
        .where((radioComponent) =>
            !radioComponent.disabled || radioComponent == source)
        .toList();
  }

  // Move focus and selection via keyboard event. Need to wrap, also jump over
  // disabled siblings.
  void _move(FocusMoveEvent event, [bool moveSelection = false]) {
    MaterialRadioComponent source = event.focusItem;

    // Siblings can be disabled, so we have to discount those when applying
    // offset.
    final focusableChildren = _getFocusableChildren(source);

    // Force focus on the child and check it if necessary.
    final index = focusableChildren.indexOf(source);
    final newIndex = (index + event.offset) % focusableChildren.length;
    if (moveSelection) focusableChildren[newIndex].checked = true;
    focusableChildren[newIndex].focus();
  }

  @override
  void ngAfterContentInit() {
    _isContentInit = true;
    if (_preselectedValue != null) {
      // Since this is updating children that were already dirty-checked,
      // need to delay this change until next angular cycle.
      _ngZone.runAfterChangesObserved(() {
        if (_preselectedValue == null) return; // Overridden before callback.
        // Initialize preselect now, this will trigger tabIndex reset.
        selected = _preselectedValue;
        // The preselected value should be used only once.
        _preselectedValue = null;
      });
    } else {
      // Initialize tabIndex.
      _resetTabIndex();
    }
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _selectionSubscription?.cancel();
  }
}
