// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../model/selection/selection_model.dart';
import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/disposer/disposer.dart';
import '../focus/focus.dart';
import './material_radio.dart';

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
///
/// __Example usage:__
///
/// Checked status is set on individual radio, only listen to selection at
/// group level.
///
/// ```html
///   <material-radio-group [selectionModel]="mySingleSelectionModel">
///     <material-radio [checked]="true"
///                     [value]="option0">default choice
///     </material-radio>
///     <material-radio [checked]="false"
///                     [value]="option1">alternative choice
///     </material-radio>
///   </material-radio-group>
/// ```
///
/// Selection of the value is done at group level, can also be done
/// via [ngModel].
///
/// ```html
///   <material-radio-group [(selected)]="selectedOption">
///     <material-radio [value]="option0">default choice
///     </material-radio>
///     <material-radio [value]="option1">alternative choice
///     </material-radio>
///   </material-radio-group>
/// ```
@Component(
    selector: 'material-radio-group',
    host: const {
      'role': 'radiogroup',
      'tabindex': '-1',
    },
    template: '<ng-content></ng-content>',
    styleUrls: const ['material_radio_group.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialRadioGroupComponent implements ControlValueAccessor, OnDestroy {
  final _disposer = new Disposer.oneShot();
  final ManagedZone _managedZone;
  final NgControl cd;
  List<MaterialRadioComponent> _children;

  MaterialRadioGroupComponent(this._managedZone, @Self() @Optional() this.cd) {
    _disposer.addStreamSubscription(componentSelection.selectionChanges
        .listen((List<SelectionChangeRecord<MaterialRadioComponent>> changes) {
      // Need to uncheck if selection change was made via user action.
      for (var change in changes) {
        for (MaterialRadioComponent item in change.removed) {
          item.checked = false;
        }
      }
      // In case this was programmatically selected, thus won't get updated
      // by focus calls.
      _resetTabIndex();
      MaterialRadioComponent selectedComponent =
          componentSelection.selectedValues.isEmpty
              ? null
              : componentSelection.selectedValues.first;
      _selected = selectedComponent == null ? null : selectedComponent.value;
      if (valueSelection != null) {
        valueSelection.select(_selected);
      }
      _onChange.add(_selected);
    }));

    _disposer.addStreamSubscription(
        focusSelection.selectionChanges.listen((List changes) {
      _resetTabIndex();
    }));

    // When NgControl is present on the host element, the component
    // participates in the Forms API.
    cd?.valueAccessor = this;
  }

  @ContentChildren(MaterialRadioComponent)
  set list(QueryList components) {
    _disposer.addStreamSubscription(components.changes.listen((_) {
      _children = new List.from(components);
      for (var child in _children) {
        _disposer
          ..addStreamSubscription(child.focusmove.listen(_moveFocus))
          ..addStreamSubscription(child.selectionmove.listen(_moveSelection));
      }
      if (_preselectedValue != null) {
        // Since this is updating children that were already dirty-checked,
        // need to delay this change until next angular cycle.
        _managedZone.onTurnDone.first.then((_) {
          // Initialize preselect now, this will trigger tabIndex reset.
          selected = _preselectedValue;
          // The preselected value should be used only once.
          _preselectedValue = null;
        });
      } else {
        // Initialize tabIndex.
        _resetTabIndex();
      }
    }));
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  @override
  writeValue(dynamic newValue) {
    // Need to ignore the null on init.
    if (newValue == null) return;
    selected = newValue;
  }

  @override
  registerOnChange(callback) {
    _disposer
        .addStreamSubscription(onChange.listen((value) => callback(value)));
  }

  // onTouched API is not supported for now.
  @override
  registerOnTouched(callback) {
    // not implemented
  }

  void _resetTabIndex() {
    // Since this is updating children that were already dirty-checked,
    // need to delay this change until next angular cycle.
    _managedZone.onTurnDone.first.then((_) {
      // Disable everything first.
      for (var child in _children) {
        child.tabbable = false;
      }
      MaterialRadioComponent selectedComponent =
          componentSelection.selectedValues.isEmpty
              ? null
              : componentSelection.selectedValues.first;
      if (selectedComponent != null) {
        // Only selected is tabbable.
        selectedComponent.tabbable = true;
      } else if (focusSelection.isEmpty) {
        // When not focused, set both first and last as tabbable, so either can
        // catch focus depending on direction of tab cycle. Though they will get
        // disbled onFocus, so will tab out of the group properly.
        List<MaterialRadioComponent> focusables = _getFocusableChildren();
        if (focusables.isNotEmpty) {
          focusables.first.tabbable = true;
          focusables.last.tabbable = true;
        }
      }
    });
  }

  /// Published when selection changes
  @Output('selectedChange')
  Stream<Object> get onChange => _onChange.stream;
  final _onChange = new StreamController<Object>.broadcast();

  /// Selection model containing value object.
  @Input('selectionModel')
  SelectionModel valueSelection;

  /// Internal selection model containing the radio component.
  SelectionModel<MaterialRadioComponent> componentSelection =
      new SelectionModel<MaterialRadioComponent>.withList();

  /// Internal selection model to keep track of radio currently in focus.
  SelectionModel<MaterialRadioComponent> focusSelection =
      new SelectionModel.withList();

  // Keep the preselected value until children are loaded.
  dynamic _preselectedValue;

  ///  Value of currently selected radio.
  @Input()
  set selected(dynamic newValue) {
    if (_children != null) {
      for (var child in _children) {
        child.checked = (child.value == newValue);
      }
    } else {
      _preselectedValue = newValue;
    }
  }

  dynamic _selected;
  dynamic get selected => _selected;

  void _moveFocus(FocusMoveEvent event) => _move(event);
  void _moveSelection(FocusMoveEvent event) => _move(event, true);

  List<MaterialRadioComponent> _getFocusableChildren(
      [MaterialRadioComponent source]) {
    List<MaterialRadioComponent> focusableChildren = new List();
    for (var child in _children) {
      // Make sure current focus is in the list even if it's disabled.
      if (!child.disabled || child == source) {
        focusableChildren.add(child);
      }
    }
    return focusableChildren;
  }

  // Move focus and selection via keyboard event. Need to wrap, also jump over
  // disabled siblings.
  void _move(FocusMoveEvent event, [bool moveSelection = false]) {
    MaterialRadioComponent source = event.focusItem;
    // Siblings can be disabled, so we have to discount those when applying
    // offset.
    List<MaterialRadioComponent> focusableChildren =
        _getFocusableChildren(source);

    // Force focus on the child and check it if necessary.
    int index = focusableChildren.indexOf(source);
    int newIndex = (index + event.offset) % focusableChildren.length;
    if (moveSelection) {
      focusableChildren[newIndex].checked = true;
      focusableChildren[newIndex].focus();
    } else {
      focusableChildren[newIndex].focus();
    }
  }
}
