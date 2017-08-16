// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';

import '../../model/selection/select.dart';
import '../../model/selection/selection_container.dart';
import '../../model/selection/selection_model.dart';
import '../../model/ui/has_renderer.dart';
import '../../model/ui/template_support.dart';
import '../../utils/angular/properties/properties.dart';
import '../material_list/material_list.dart';
import 'material_select_base.dart';
import 'material_select_item.dart';

/// Material Select is a container for selecting items from a collection,
/// marking selected options with a check icon.
///
/// Options can be specified manually (in your template), or via a
/// [SelectionOptions] instance. Options can be marked as selected via template
/// or by checking against a selection model.
///
/// __Properties:__
///
///  - `options: SelectionOptions` - The [SelectionOptions] instance providing
///    options to render.
///  - `width: int` - The width of the rendered list, from 1 to 5.
///  - `itemRenderer: ItemRenderer` - A rendering function to render selection
///    options, if given a `value`.
///  - `disabled: bool` - Whether the select should be shown as disabled.
///    Optional. Defaults to false.
@Component(
  selector: 'material-select',
  host: const {'role': 'listbox', '[attr.aria-disabled]': 'disabledStr'},
  // Inputs for [MaterialSelectBase]
  // TODO(google).
  inputs: const ['options', 'width', 'componentRenderer'],
  providers: const [
    const Provider(HasRenderer, useExisting: MaterialSelectComponent),
    const Provider(SelectionContainer, useExisting: MaterialSelectComponent)
  ],
  directives: const [
    MaterialListComponent,
    MaterialSelectItemComponent,
    NgIf,
    NgFor
  ],
  templateUrl: 'material_select.html',
  styleUrls: const ['material_select.scss.css'],
)
class MaterialSelectComponent extends MaterialSelectBase implements OnDestroy {
  QueryList<SelectionItem> _selectItems;
  StreamSubscription _selectItemsSub;

  /// Function for use by NgFor for optionGroup to avoid recreating the
  /// DOM for the optionGroup.
  final Function trackByIndexFn = indexIdentityFn;

  bool _disabled = false;

  /// The [SelectionModel] for this container.
  @Input()
  set selection(value) {
    super.selection = value;
    _refreshItems();
  }

  @override
  SelectionModel get selection => super.selection;

  /// If selectionOptions implements Selectable, it is called to decided
  /// whether an item is disabled.
  bool isOptionDisabled(Object item) {
    if (options is Selectable) {
      return (options as Selectable).getSelectable(item) !=
          SelectableOption.Selectable;
    }
    return false;
  }

  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }

  bool get disabled => _disabled;

  String get disabledStr => '$_disabled';

  @override
  ItemRenderer get itemRenderer => _itemRenderer;
  ItemRenderer _itemRenderer;

  @Input()
  set itemRenderer(ItemRenderer value) {
    _itemRenderer = value;
    _refreshItems();
  }

  @ContentChildren(SelectionItem)
  set selectItems(QueryList<SelectionItem> value) {
    _cancelSelectItemSub();
    if (value != null) {
      // ContentChildren call is inside change detection. We can't alter
      // state inside change detector therefore schedule a microtask.
      scheduleMicrotask(() {
        _selectItems = value;
        _selectItemsSub = _selectItems.changes.listen((_) => _refreshItems());
        _refreshItems();
      });
    }
  }

  @override
  void ngOnDestroy() {
    _cancelSelectItemSub();
  }

  void _cancelSelectItemSub() {
    _selectItemsSub?.cancel();
    _selectItemsSub = null;
  }

  void _refreshItems() {
    if (_selectItems == null) return;
    if (selection != null) {
      for (SelectionItem item in _selectItems) {
        item.selection = selection;
      }
    }
    if (itemRenderer != null) {
      for (SelectionItem item in _selectItems) {
        item.itemRenderer = itemRenderer;
      }
    }
  }
}
