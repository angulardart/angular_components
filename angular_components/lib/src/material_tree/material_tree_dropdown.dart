// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/src/material_tree/material_tree_filter.dart';
import 'package:angular_components/src/material_tree/material_tree_root.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/angular/css/css.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

import 'material_tree_impl.dart';

/// A button-triggered dropdown containing a [MaterialTreeComponent].
@Component(
  selector: 'material-tree-dropdown',
  directives: [
    DeferredContentDirective,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialIconComponent,
    MaterialPopupComponent,
    MaterialTreeComponent,
    MaterialTreeFilterComponent,
    NgIf,
    PopupSourceDirective
  ],
  directiveTypes: [
    Typed<MaterialTreeComponent>.of([#T]),
  ],
  providers: [
    ExistingProvider(Focusable, MaterialTreeDropdownComponent),
    ExistingProvider(MaterialTreeRoot, MaterialTreeDropdownComponent)
  ],
  templateUrl: 'material_tree_dropdown.html',
  styleUrls: ['material_tree_dropdown.scss.css'],
  visibility: Visibility.all, // injected by clients
)
class MaterialTreeDropdownComponent<T>
    with DropdownHandle, MaterialTreeRoot<T>, SelectionContainer<T>
    implements OnInit, Focusable {
  // Popup positioning to use when filtering is enabled.
  static const List<Object /*RelativePosition | List<RelativePosition>*/ >
      _popupPositionsOffset = [
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
  List<RelativePosition> _customPopupPositions;

  @ViewChild(MaterialTreeFilterComponent)
  MaterialTreeFilterComponent materialTreeFilterComponent;

  /// Fired when the dropdown's visibility changes.
  @Output()
  Stream<bool> get visibleChange => _visibleStream.stream;

  final _visibleStream = StreamController<bool>.broadcast(sync: true);

  /// CSS classes from the root element, passed to the popup to allow scoping of
  /// mixins.
  ///
  /// Only visible for the template.
  final String popupClassName;

  /// Whether to always expand an option group.
  @Input()
  set expandAll(bool value) {
    _expandAll = value;
  }

  /// Place the filter input inside of the popup.
  @Input()
  bool showFilterInsidePopup = false;

  /// When `true` expand all items when the tree is being filtered.
  @Input()
  bool shouldExpandAllWhenFiltered = true;

  /// Whether the widgets supports the selection of non-leaf nodes
  ///
  /// When `false`, and the widget is using a single selection model clicking
  /// the widget should toggle expansion when a non-leaf node is clicked. When
  /// `true` the widget should select non-leaf nodes when clicked and only
  /// toggle expansion when the expansion icon is clicked.
  @Input()
  bool allowParentSingleSelection = false;

  /// Whether clicking on a selected item should deselect it. (Only applicable
  /// when hierarchy is supported.)
  @Input()
  bool allowDeselectInHierarchy = true;

  /// Function to convert the selected value to a string to be displayed as the
  /// button text.
  @Input()
  ItemRenderer labelRenderer;

  bool get showFilterInsideButton =>
      supportsFiltering && !showFilterInsidePopup;

  Filterable get filterableOptions => options is Filterable
      ? options as Filterable
      : throw StateError(
          'The SelectionOptions provided should implement Filterable');

  bool get expandAll =>
      _expandAll || (isFiltered && shouldExpandAllWhenFiltered);

  /// Returns the text to be displayed in the button or in the filter (if
  /// enabled).
  ///
  /// If a value has been selected for a single-select dropdown, this will
  /// render the selected value with [labelRenderer], [itemRenderer], or
  /// [defaultItemRenderer] in that order of preference.
  String get placeholder {
    if (selection is! MultiSelectionModel && selection.isNotEmpty) {
      return (labelRenderer ?? (itemRenderer ?? defaultItemRenderer))(
          selection.selectedValues.first);
    }
    return _placeholder;
  }

  @override
  final bool optimizeForDropdown = true;

  MaterialTreeDropdownComponent(this._domService,
      @Attribute('popupClass') String popupClass, HtmlElement element)
      : popupClassName = constructEncapsulatedCss(popupClass, element.classes) {
    selection = SelectionModel<T>.empty();
  }

  @Deprecated('Use [factoryRenderer] instead')
  @Input()
  @override
  set componentRenderer(ComponentRenderer value) {
    super.componentRenderer = value;
  }

  /// Specifies the factoryRenderer to use to determine the factory for
  /// rendering an item.
  @Input()
  @override
  set factoryRenderer(FactoryRenderer<RendersValue, T> value) {
    super.factoryRenderer = value;
  }

  /// A simple function to render the item to string.
  @Input()
  @override
  set itemRenderer(ItemRenderer<T> value) {
    super.itemRenderer = value;
  }

  /// The available options for this contianer.
  @Input()
  @override
  set options(SelectionOptions<T> value) {
    super.options = value;
  }

  /// The selection model this container represents.
  @Input()
  @override
  set selection(SelectionModel<T> value) {
    super.selection = value;
  }

  /// Placeholder to be used for the dropdown text when nothing is selected.
  @Input()
  set placeholder(String placeholder) {
    _placeholder = placeholder ?? _DEFAULT_PLACEHOLDER;
  }

  /// List of positions to try and draw the options popup.
  ///
  /// If left unset or if explicitly set to null, [_defaultPopupPositions] will
  /// be used. See [MaterialPopupComponent] for more information.
  @Input()
  set popupPositions(List<RelativePosition> positions) {
    _customPopupPositions = positions;
  }

  List /*RelativePosition | List<RelativePosition>*/ get popupPositions =>
      _customPopupPositions ?? _defaultPopupPositions;

  /// Default positions to uses when [_customPopupPositions] is null.
  ///
  /// Returns offset positioning when the filter is enabled and inline
  /// positioning when the filter is disabled.
  List /*RelativePosition | List<RelativePosition>*/
      get _defaultPopupPositions => showFilterInsideButton
          ? _popupPositionsOffset
          : _popupPositionsInline;

  bool get visible => _visible;

  /// Whether to show the dropdown or not.
  @Input()
  set visible(bool val) {
    if (_visible != val) {
      _visible = val;
      _visibleStream.add(val);
      if (showFilterInsidePopup && !_visible) {
        materialTreeFilterComponent?.clear();
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
    _maybeFocusFilterComponent();
  }

  @override
  void focus() {
    open();
    _maybeFocusFilterComponent();
  }

  Future _maybeFocusFilterComponent() async {
    if (visible && supportsFiltering) {
      await _domService.nextFrame;
      materialTreeFilterComponent?.focus();
    }
  }
}
