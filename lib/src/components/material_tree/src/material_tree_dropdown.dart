// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../../laminate/enums/alignment.dart';
import '../../../model/selection/select.dart';
import '../../../model/selection/selection_container.dart';
import '../../../model/selection/selection_model.dart';
import '../../../model/ui/has_renderer.dart';
import '../../../utils/browser/dom_service/dom_service.dart';
import '../../content/deferred_content.dart';
import '../../focus/keyboard_only_focus_indicator.dart';
import '../../glyph/glyph.dart';
import '../../material_popup/material_popup.dart';
import '../../mixins/material_dropdown_base.dart';
import './material_tree_filter.dart';
import './material_tree_root.dart';
import 'material_tree_impl.dart';

/// A button-triggered dropdown containing a [MaterialTreeComponent].
@Component(
    selector: 'material-tree-dropdown',
    inputs: const [
      // SelectionContainer
      'componentRenderer',
      'itemRenderer',
      'options',
      'selection',
    ],
    directives: const [
      DeferredContentDirective,
      GlyphComponent,
      KeyboardOnlyFocusIndicatorDirective,
      MaterialPopupComponent,
      MaterialTreeComponent,
      MaterialTreeFilterComponent,
      NgIf,
      PopupSourceDirective
    ],
    viewProviders: const [
      const Provider(MaterialTreeRoot,
          useExisting: MaterialTreeDropdownComponent)
    ],
    preserveWhitespace: false,
    templateUrl: 'material_tree_dropdown.html',
    styleUrls: const ['material_tree_dropdown.scss.css'])
class MaterialTreeDropdownComponent extends SelectionContainer
    with DropdownHandle, MaterialTreeRoot
    implements OnInit {
  // Popup positioning to use when filtering is enabled.
  static const List /*RelativePosition | List<RelativePosition>*/
      _popupPositionsOffset = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomEdge,
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopEdge
  ];

  // Popup positioning to use when filtering is disabled.
  static const List<RelativePosition> _popupPositionsInline =
      RelativePosition.InlinePositions;

  static const String _DEFAULT_PLACEHOLDER = 'Select';

  final DomService _domService;
  bool _expandAll = false;
  String _placeholder = _DEFAULT_PLACEHOLDER;
  bool _visible = false;

  @ViewChild('materialTreeFilter')
  MaterialTreeFilterComponent materialTreeFilterComponent;

  @Input()
  set expandAll(bool value) {
    _expandAll = value;
  }

  @Input()
  bool showFilterInsidePopup = false;

  bool get showFilterInsideButton =>
      supportsFiltering && !showFilterInsidePopup;

  Filterable get filterableOptions => options is Filterable
      ? options as Filterable
      : throw new StateError(
          'The SlectionOptions provided should implement Filterable');

  bool get expandAll => _expandAll || isFiltered;

  String get placeholder {
    if (selection is! MultiSelectionModel && selection.isNotEmpty) {
      return (itemRenderer ??
          defaultItemRenderer)(selection.selectedValues.first);
    }
    return _placeholder;
  }

  @override
  final bool optimizeForDropdown = true;

  MaterialTreeDropdownComponent(this._domService) {
    selection = const SelectionModel();
  }

  @Input()
  set placeholder(String placeholder) {
    _placeholder = placeholder ?? _DEFAULT_PLACEHOLDER;
  }

  List /*RelativePosition | List<RelativePosition>*/ get popupPositions {
    return showFilterInsideButton
        ? _popupPositionsOffset
        : _popupPositionsInline;
  }

  bool get visible => _visible;

  @Input()
  set visible(bool val) {
    if (_visible != val) {
      _visible = val;
      if (supportsFiltering) {
        materialTreeFilterComponent?.focus();
      }
    }
  }

  @override
  void open() {
    visible = true;
  }

  @override
  void close() {
    visible = false;
  }

  @override
  void toggle() {
    visible = !visible;
  }

  @override
  ngOnInit() {
    if (visible && supportsFiltering) {
      _domService.nextFrame.then(([num _]) {
        materialTreeFilterComponent?.focus();
      });
    }
  }
}
