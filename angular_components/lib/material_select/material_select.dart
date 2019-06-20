// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/model/ui/template_support.dart';

import 'material_select_base.dart';
import 'material_select_item.dart';

/// Material Select is a container for selecting items from a collection,
/// marking selected options with a check icon.
///
/// Options can be specified manually (in your template), or via a
/// [SelectionOptions] instance. Options can be marked as selected via template
/// or by checking against a selection model.
@Component(
  selector: 'material-select',
  providers: [
    ExistingProvider(HasDisabled, MaterialSelectComponent),
    ExistingProvider(HasRenderer, MaterialSelectComponent),
    ExistingProvider(SelectionContainer, MaterialSelectComponent),
  ],
  directives: [
    FocusItemDirective,
    FocusListDirective,
    MaterialListComponent,
    MaterialSelectItemComponent,
    NgIf,
    NgFor
  ],
  directiveTypes: [
    Typed<MaterialSelectItemComponent>.of([#T]),
  ],
  templateUrl: 'material_select.html',
  styleUrls: ['material_select.scss.css'],
)
class MaterialSelectComponent<T> extends MaterialSelectBase<T>
    implements HasDisabled, OnInit {
  @HostBinding('attr.role')
  static const hostRole = 'listbox';

  List<SelectionItem<T>> _selectItems;

  /// Function for use by NgFor for optionGroup to avoid recreating the
  /// DOM for the optionGroup.
  final Function trackByIndexFn = indexIdentityFn;

  bool _listAutoFocus = false;
  int _autoFocusIndex;

  @HostBinding('attr.aria-multiselectable')
  @override
  bool get isMultiSelect => super.isMultiSelect;

  /// The [SelectionOptions] instance providing options to render.
  @Input()
  @override
  set options(SelectionOptions<T> value) {
    super.options = value;
  }

  /// The width of the rendered list, from 1 to 5.
  @Input()
  @override
  set width(value) {
    super.width = value;
  }

  /// The label which will be set to select group's aria-labelledby.
  @Input()
  String ariaLabelledBy;

  /// The description which will be set to select groups' aria-describedby.
  @Input()
  String ariaDescribedBy;

  @Deprecated('Use factoryRenderer instead it is more tree-shakable')
  @Input()
  @override
  set componentRenderer(ComponentRenderer value) {
    super.componentRenderer = value;
  }

  /// Used to create a [ComponentFactory] that must override [RendersValue]
  /// from a given option allowing for a more expressive option.
  @Input()
  @override
  set factoryRenderer(FactoryRenderer<RendersValue, T> value) {
    super.factoryRenderer = value;
  }

  /// The [SelectionModel] for this container.
  @Input()
  @override
  set selection(SelectionModel<T> value) {
    super.selection = value;
    _refreshItems();
  }

  @override
  SelectionModel<T> get selection => super.selection;

  /// If selectionOptions implements Selectable, it is called to decided
  /// whether an item is disabled.
  bool isOptionDisabled(T item) {
    // TODO: Verify if this can be simplified to .isDisabledIn.
    //
    // The prior code did a check for `!= SelectableOption.Selected`. It is
    // possible there are existing users that are relying on `.Hidden` to mean
    // disabled, for example.
    return !Selectable.isSelectableIn(options, item, true);
  }

  /// Whether the select should be shown as disabled.
  ///
  /// Defaults to false.
  @Input()
  bool disabled = false;

  @HostBinding('attr.aria-disabled')
  String get disabledStr => '$disabled';

  @override
  ItemRenderer<T> get itemRenderer => _itemRenderer;
  ItemRenderer<T> _itemRenderer;

  /// A rendering function to render selection options to a String, if given a
  /// `value`.
  @Input()
  set itemRenderer(ItemRenderer<T> renderer) {
    _itemRenderer = renderer;
    _refreshItems();
  }

  /// Whether to auto-focus the list as soon as it appears.
  ///
  /// Must be enabled before the component is initialized. If an item is
  /// initially selected, that item will be focused, otherwise the first item is
  /// focused. Only supported when selectable options are provided in [options].
  @Input()
  set listAutoFocus(bool value) {
    _listAutoFocus = value;
  }

  int get autoFocusIndex => _autoFocusIndex;

  @ContentChildren(SelectionItem)
  set selectItems(List<SelectionItem<T>> value) {
    if (value != null) {
      // ContentChildren call is inside change detection. We can't alter
      // state inside change detector therefore schedule a microtask.
      scheduleMicrotask(() {
        _selectItems = value;
        _refreshItems();
      });
    }
  }

  @override
  void ngOnInit() {
    if (!_listAutoFocus || options == null) return;
    _autoFocusIndex = selection.isNotEmpty
        ? options.optionsList.indexOf(selection.selectedValues.first)
        : 0;
  }

  void _refreshItems() {
    if (_selectItems == null) return;
    if (selection != null) {
      for (SelectionItem<T> item in _selectItems) {
        item.selection = selection;
      }
    }
    if (itemRenderer != null) {
      for (SelectionItem<T> item in _selectItems) {
        item.itemRenderer = itemRenderer;
      }
    }
  }
}
