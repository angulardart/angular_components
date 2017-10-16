// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_input/input_wrapper.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/material_select_base.dart';
import 'package:angular_components/material_select/material_select_dropdown_item.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_components/mixins/highlight_assistant_mixin.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/model/ui/highlight_provider.dart';
import 'package:angular_components/model/ui/template_support.dart';
import 'package:angular_components/stop_propagation/stop_propagation.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';
import 'package:angular_forms/angular_forms.dart';

import 'material_input.dart';

typedef String _InputChangeCallback(String inputText);

/// `material-auto-suggest-input` is an input field which provides the
/// suggestions to auto-complete the input as the user types.
///
/// The caller of this component has to provide the list of initial/unfiltered
/// suggestions which are filtered by component as user types. The filter is
/// case insensitive.
///
/// Supports async suggestions through the [ObserveAware] interface implemented
/// by [SelectionOptions].
///
/// The popup suggestion list has a max height and auto overflow. We can add a
/// property for custom max height once there's a use case.
///
/// __Example usage:__
///
///     <material-auto-suggest-input label="Type here"
///                                  [suggestions]="suggestions"
///                                  [limit]="5">
///     </material-auto-suggest-input>
///
/// __Properties:__
///
/// - `suggestions: List<String>` -- The list of suggestions to use when
///   auto-suggesting. Suggestions are matched if they contain the input text.
/// - `shouldClearOnSelection: bool` -- If the text field should be cleared on
///   selection.
/// - `limit: int` -- How many suggestions to show. If the limit is less than 1,
///   it is assumed to be mean no limit. See filter method in [Filterable].
///   Defaults to 10.
/// - `label: String` -- The label to use on the input. Passed through to
///   `material-input`.
/// - `labelRenderer: ComponentRenderer` -- Provides capability to customize the
///    suggestionOptions label with a custom component.
/// - `leadingGlyph: String` -- Any persistent glyph to show before the input.
///   Available icons are shown on this page: [https://design.google.com/icons/]
///   (https://design.google.com/icons/)
/// - `trailingGlyph: String` -- Any persistent glyph to show at the end of the
///   input; the icons available are the same as the leadingGlyph property.
/// - `inputText: String` -- The text entered into the input.
/// - `filterSuggestions: bool` -- When turn off, always show full list of
///   suggestions.
/// - `popupMatchInputWidth: bool` -- Whether or not the suggestion popup width
///   is at least as wide as the input width.
/// - `selection: SelectionModel` -- if set, auto suggest will use the
///   supplied observable SelectionModel object.
///   (default) uses a single selection model.
/// - `showClearIcon: bool` -- Show or hide the trailing close icon to clear the
///   input and hide the popup.
/// - `slide: String` -- Direction of popup scaling. Valid values are `x`, `y`,
///   or `null`.
/// - `loading: bool` -- When turned on and no suggestions available, show
///    loading indicator in the suggestions dropdown.
/// - `emptyPlaceholder: String` -- The text to display if there are no
///    suggestions to show and the suggestions are not loading.
/// - `closeOnActivate` -- Whether to close dropdown on activation.
/// - `hideCheckbox` -- Whether to hide the checkbox before the item in
///   multi-selection.
/// - `showPopup` -- Used to control the visibility of the suggestion popup.
/// - `disabled: bool` -- Whether this input is disabled.
///
/// __Events:__
///
/// - `focus: FocusEvent` -- Fired when the input gains focus
/// - `blur: FocusEvent` -- Fired when the input gains blur or auto suggest
///   item get selected.
/// - `inputTextChange: String` -- Fired when the input text changes (on
///   keypress).
/// - `clear` -- Fired when the close icon is clicked.
/// - `showPopupChange` -- Fired when the value of showPopup changes.
///
@Component(
  selector: 'material-auto-suggest-input',
  providers: const [
    const Provider(HasRenderer, useExisting: MaterialAutoSuggestInputComponent),
    const Provider(SelectionContainer,
        useExisting: MaterialAutoSuggestInputComponent),
    const Provider(HighlightProvider,
        useExisting: MaterialAutoSuggestInputComponent),
    const Provider(DropdownHandle,
        useExisting: MaterialAutoSuggestInputComponent),
    const Provider(HasComponentRenderer,
        useExisting: MaterialAutoSuggestInputComponent),
    const Provider(Focusable, useExisting: MaterialAutoSuggestInputComponent),
    const Provider(PopupSizeProvider,
        useExisting: MaterialAutoSuggestInputComponent)
  ],
  directives: const [
    ButtonDirective,
    CachingDeferredContentDirective,
    DynamicComponent,
    GlyphComponent,
    KeyboardOnlyFocusIndicatorDirective,
    materialInputDirectives,
    MaterialListComponent,
    MaterialSelectDropdownItemComponent,
    MaterialPopupComponent,
    MaterialSpinnerComponent,
    PopupSourceDirective,
    NgFor,
    NgIf,
    StopPropagationDirective,
  ],
  preserveWhitespace: false,
  templateUrl: 'material_auto_suggest_input.html',
  styleUrls: const [
    'material_auto_suggest_input.scss.css',
    'material_input_wrapper.scss.css'
  ],
)
class MaterialAutoSuggestInputComponent extends MaterialSelectBase
    with MaterialInputWrapper, KeyboardHandlerMixin, HighlightAssistantMixin
    implements
        ControlValueAccessor,
        Focusable,
        OnChanges,
        OnDestroy,
        HasRenderer,
        HasComponentRenderer,
        DropdownHandle,
        PopupSizeProvider {
  /// How to automatically position the dropdown popup by default.
  ///
  /// We do not want to cover the input area.
  static const List<RelativePosition> _defaultPopupPositions = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight,
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];

  final SelectionModel _defaultSelection = new SelectionModel.withList();

  final String popupId;
  final String inputId;

  /// Keeps track of the item matching the filter as the suggestions are
  /// being updated.
  final ActiveItemModel activeModel;

  /// Whether to clear the text once the item is selected from the menu.
  @Input()
  bool shouldClearOnSelection = false;

  /// Whether to cause dropdown to be closed on activation.
  @Input()
  bool closeOnActivate = true;

  /// Whether to hide the checkbox before the selection item for multi-select.
  @Input()
  bool hideCheckbox = false;

  bool _showPopup = false;
  bool _focusPending = false;
  MaterialInputComponent _input;
  _InputChangeCallback _callback;

  /// The current text being displayed.
  String _inputText = '';

  /// Publishes events when input text changes.
  final _inputChange = new StreamController<String>.broadcast(sync: true);

  /// The last item that was selected.  This is needed if clearOnSelection is
  /// false to determine if an item needs to be unselected.
  Object _lastSelectedItem;

  /// The last future of filtering the options.
  DisposableFuture _lastFilterFuture;

  /// Whether a filter call is scheduled.
  bool _filterScheduled = false;

  bool _isDisposed = false;

  /// The first suggestion in the popup is active and highlighted by default.
  /// Setting this to true changes behavior so that when [options] or
  /// [selection] are changed:
  /// 1) first selected value in [selection] is active in [options]
  /// 2) if [selection] has no selected values, nothing is active in [options]
  @Input()
  bool initialActivateSelection = false;

  /// How many suggestions to show at once.  This is applied after any
  /// filtering.
  int _limit = 10;

  /// Allow filtering of suggestions as the user is typing.
  @Input()
  bool filterSuggestions = true;

  /// A custom CSS class for suggestion popup contents.
  @Input()
  String popupShadowCssClass = '';

  /// Whether or not the suggestion popup width is at least as wide as the input
  /// width.
  @Input()
  bool popupMatchInputWidth = false;

  /// The preferred positions for the dropdown popup.
  List<RelativePosition> _popupPositions = _defaultPopupPositions;

  /// Listener for selection model changes.
  StreamSubscription _selectionListener;

  /// Listener for selection options changes.
  StreamSubscription _optionsListener;

  /// Direction of popup scaling.
  @Input()
  String slide;

  /// Show or hide the trailing close icon.
  ///
  /// Clicking on the icon clears the input text and hides the popup.
  @Input()
  bool showClearIcon = false;

  /// Text to show if the options list is empty and not loading.
  @Input()
  String emptyPlaceholder = '';

  // The fields below are deprecated.

  /// The list of all possible suggestions.
  @deprecated
  @Input()
  List suggestions = [];

  // Override renderer here to just add the @Input annotation and keep the
  // angular dependency out of models.
  @override
  @Input()
  set itemRenderer(ItemRenderer<dynamic> value) => super.itemRenderer = value;

  // Override renderer here to just add the @Input annotation and keep the
  // angular dependency out of models.
  @override
  @Input()
  set componentRenderer(ComponentRenderer value) =>
      super.componentRenderer = value;

  /// Sort the suggestions.
  @Deprecated('Caller should call .sort() instead.')
  @Input()
  bool sorted = true;

  /// Function for use by NgFor for optionGroup to avoid recreating the
  /// DOM for the optionGroup.
  final Function trackByIndexFn = indexIdentityFn;

  /// If a parent provides a [PopupSizeProvider], the provider will be used
  /// instead of the implementation of this class.
  final PopupSizeProvider _popupSizeDelegate;

  /// Control used to forward errors.
  NgControl _cd;

  // Use a factory as a layer of indirection, in order to resolve a default
  // IdGenerator if there is none bound.
  factory MaterialAutoSuggestInputComponent(
          @Optional() @Self() NgControl cd,
          @Optional() IdGenerator idGenerator,
          @Optional() @SkipSelf() PopupSizeProvider popupSizeDelegate) =>
      new MaterialAutoSuggestInputComponent.protected(
          cd,
          idGenerator ?? new SequentialIdGenerator.fromUUID(),
          popupSizeDelegate);

  MaterialAutoSuggestInputComponent.protected(this._cd, IdGenerator idGenerator,
      [this._popupSizeDelegate])
      : activeModel = new ActiveItemModel(idGenerator, loop: true),
        popupId = idGenerator.nextId(),
        inputId = idGenerator.nextId() {
    if (_cd != null) {
      _cd.valueAccessor = this;
    }
    selection = _defaultSelection;
  }

  /// Publishes events when input text changes.
  @Output('inputTextChange')
  Stream<String> get textChanged => _inputChange.stream;

  // Stopgap to foward errors from the control to the internal material-input
  // representation.
  // TODO(google): Migrate to using error-panel once it gets added to acx.
  String get errorText {
    if (error != null) return error;
    if (_cd?.control?.errors != null) {
      Map<String, dynamic> errorMap = _cd.control.errors;
      var stringValue = errorMap.values.firstWhere(
          ((v) => (v is String) && v.isNotEmpty),
          orElse: () => null);
      if (stringValue != null) return stringValue as String;
    }
    return null;
  }

  @override
  ngOnChanges(Map<String, SimpleChange> changes) {
    // If either the suggestions were changed or the value of sort was changed,
    // rebuild the list of options.
    if (changes.containsKey('suggestions') || changes.containsKey('sorted')) {
      var optionsList = new List.from(suggestions);
      if (sorted) {
        optionsList.sort();
      }
      options = new StringSelectionOptions(optionsList,
          toFilterableString: itemRenderer);
    }
  }

  @override
  @Input()
  set selection(SelectionModel selection) {
    super.selection = selection;

    if (isSingleSelect && selection.selectedValues.isNotEmpty) {
      _lastSelectedItem = selection.selectedValues.first;
      _inputText = itemRenderer(_lastSelectedItem);
      _filterSuggestions();
    }
    _selectionListener?.cancel();
    _selectionListener = selection.selectionChanges.listen((_) {
      // If the input fields shows the selected value then update it if the
      // selection changes or clear it if the selection model is empty.
      if (shouldClearOnSelection) {
        inputText = '';
      } else if (isSingleSelect) {
        var selectedItem = selection.selectedValues.isNotEmpty
            ? selection.selectedValues.first
            : null;
        // Make sure that the change was not caused by this component.
        if (_lastSelectedItem != selectedItem) {
          inputText = selectedItem != null ? itemRenderer(selectedItem) : '';
          _lastSelectedItem = selectedItem;
        }
      }
    });
  }

  @override
  @Input('selectionOptions')
  set options(SelectionOptions options) {
    if (options == null) return;
    super.options = options;
    _filterSuggestions();
    activeModel.items = options.optionsList;
    _optionsListener?.cancel();
    _optionsListener = options.stream.listen((_) {
      activeModel.items = options.optionsList;
      _setInitialActiveItem();
    });
  }

  @Input()
  set limit(dynamic value) {
    var newLimit = getInt(value);
    if (_limit != newLimit) {
      _limit = newLimit;
      _filterSuggestions();
    }
  }

  /// The suggestions that match the current input text.
  List<OptionGroup> get visibleSuggestionGroups => options.optionGroups;

  bool get hasOptions => options.optionsList.isNotEmpty;

  bool get showLoadingSpinner => loading && options.optionsList.isEmpty;

  /// Custom renderer for suggestion labels.
  @Input()
  ComponentRenderer labelRenderer;

  /// An option is disabled if the options implements Selectable, but the [item]
  /// is not selectable.
  bool isOptionDisabled(Object item) =>
      options is Selectable &&
      (options as Selectable).getSelectable(item) !=
          SelectableOption.Selectable;

  /// Whether to highlight options.
  /// Default value is `true`.
  @Input()
  bool highlightOptions = true;

  @override
  ComponentRenderer get componentRenderer =>
      highlightOptions && super.componentRenderer == null
          ? highlightComponentRenderer
          : super.componentRenderer;

  final _showPopupController = new StreamController<bool>.broadcast(sync: true);

  /// Publishes event when the showPopup changes.
  @Output()
  Stream<bool> get showPopupChange => _showPopupController.stream;

  bool get showPopup => _showPopup && !disabled;

  @Input()
  set showPopup(bool value) {
    if (value != _showPopup) {
      _showPopup = value;
      _showPopupController.add(_showPopup);
      _setInitialActiveItem();
    }

    if (!_showPopup && !_isFocused) {
      _onBlur.add(null);
    }
  }

  @Input()
  bool loading = false;

  bool get showEmptyPlaceholder =>
      emptyPlaceholder.isNotEmpty &&
      options.optionsList.isEmpty &&
      !showLoadingSpinner;

  List<RelativePosition> get popupPositions => _popupPositions;

  @Input()
  set popupPositions(List<RelativePosition> positions) {
    if (positions?.isNotEmpty == true) {
      _popupPositions = positions;
    } else {
      _popupPositions = _defaultPopupPositions;
    }
  }

  @override
  String get inputText => _inputText;

  /// Filters suggestion list according to input.
  @override
  set inputText(String inputText) {
    inputText ??= '';

    if (inputText == _inputText) {
      return;
    }

    if (selection != _defaultSelection &&
        !shouldClearOnSelection &&
        _lastSelectedItem != null) {
      // deselect previously selected item as the component was not asked to
      // clear the text upon selection, indicating that the selection is bound
      // to the text.
      // TODO(google): Should we clear the selection if they earse even a letter?
      if (inputText != itemRenderer(_lastSelectedItem)) {
        selection.deselect(_lastSelectedItem);
        _lastSelectedItem = null;
      }
    }
    _inputText = inputText;
    _inputChange.add(inputText);
    _filterSuggestions();
    if (_callback != null) _callback(inputText);
  }

  @Output('clear')
  Stream<Null> get onClear => _onClear.stream;
  final _onClear = new StreamController<Null>.broadcast(sync: true);

  void onClearIcon() {
    _onClear.add(null);
    showPopup = false;
    inputText = '';
  }

  bool _isFocused = false;

  @Output('focus')
  Stream<html.FocusEvent> get onFocus => _onFocus.stream;
  final _onFocus = new StreamController<html.FocusEvent>.broadcast(sync: true);

  void handleFocus(html.FocusEvent event) {
    showPopup = true;
    _onFocus.add(event);
    _isFocused = true;
  }

  @Output('blur')
  Stream<Null> get onBlur => _onBlur.stream;
  final _onBlur = new StreamController<Null>.broadcast(sync: true);

  void handleBlur(html.FocusEvent event) {
    _isFocused = false;
    if (!showPopup || !hasOptions) {
      _onBlur.add(null);
    }
  }

  /// Filter the suggestions if the flag is set and filtering is supported.
  void _filterSuggestions() {
    if (_filterScheduled || !filterSuggestions || options is! Filterable) {
      return;
    }
    _filterScheduled = true;
    scheduleMicrotask(() {
      if (_isDisposed) return;
      _filterScheduled = false;
      _lastFilterFuture?.dispose();
      _lastFilterFuture =
          (options as Filterable).filter(_inputText, limit: _limit);
    });
  }

  void _setInitialActiveItem() {
    if (!showPopup || !initialActivateSelection) return;

    if (selection == null || selection.selectedValues.isEmpty) {
      activeModel.activate(null);
    } else if (activeModel.activeItem == null ||
        !selection.isSelected(activeModel.activeItem)) {
      // If the current active item is not selected, activate the first
      // selected item.
      activeModel.activate(selection.selectedValues.first);
    }
  }

  @override
  void handleEnterKey(html.KeyboardEvent event) {
    if (!showPopup) {
      showPopup = true;
    } else {
      var item = activeModel.activeItem;
      if (item != null && !isOptionDisabled(item)) {
        onListItemSelected(item);
      }
    }
  }

  @override
  void handleUpKey(html.KeyboardEvent event) {
    if (showPopup) {
      event.preventDefault(); // Prevent input caret from jumping.
      activeModel.activatePrevious();
    }
  }

  @override
  void handleDownKey(html.KeyboardEvent event) {
    if (showPopup) {
      event.preventDefault(); // Prevent input caret from jumping.
      activeModel.activateNext();
    }
  }

  @override
  void handlePageUp(html.KeyboardEvent event) {
    if (showPopup) {
      event.preventDefault(); // Prevent page from scrolling.
      activeModel.activateFirst();
    }
  }

  @override
  void handlePageDown(html.KeyboardEvent event) {
    if (showPopup) {
      event.preventDefault(); // Prevent page from scrolling.
      activeModel.activateLast();
    }
  }

  @override
  void handleEscapeKey(html.KeyboardEvent event) {
    showPopup = false;
  }

  /// Act as a validator.
  /// TODO(google): Please don't add validation support this way.
  call(_) {
    // material-auto-suggest-input doesn't support validation yet
    return null;
  }

  @override
  void writeValue(newValue) {
    inputText = newValue as String;
  }

  @override
  void registerOnChange(callback) {
    _callback = callback as _InputChangeCallback;
  }

  @override
  void registerOnTouched(_) {
    // not implemented
  }

  @ViewChild(MaterialInputComponent)
  set input(MaterialInputComponent input) {
    _input = input;
    if (_focusPending) {
      _focusPending = false;
      _input.focus();
    }
  }

  @override
  void focus() {
    if (_input == null) {
      /// input component is not there yet, defer the focus.
      _focusPending = true;
    } else {
      _input.focus();
    }
  }

  void onListItemSelected(suggestion) {
    if (isSingleSelect) {
      showPopup = false;
    }
    if (selection.isSelected(suggestion)) {
      selection.deselect(suggestion);
    } else {
      selection.select(suggestion);
    }
  }

  @override
  ngOnDestroy() {
    _isDisposed = true;
    _selectionListener?.cancel();
    _optionsListener?.cancel();
    _lastFilterFuture?.dispose();
  }

  @override
  bool autoDismiss = true;

  @override
  void close() {
    showPopup = false;
  }

  @override
  void open() {
    showPopup = true;
  }

  @override
  void toggle() {
    showPopup = !showPopup;
  }

  @override
  num getMaxHeight(num positionY, num viewportHeight) {
    if (_popupSizeDelegate != null) {
      return _popupSizeDelegate.getMaxHeight(positionY, viewportHeight);
    } else {
      // The default max height for auto suggest input's popup.
      return 400;
    }
  }

  @override
  num getMaxWidth(num positionX, num viewportWidth) {
    if (_popupSizeDelegate != null) {
      return _popupSizeDelegate.getMaxWidth(positionX, viewportWidth);
    } else {
      // The default max height for auto suggest input's popup. This was
      // previously max width for material list.
      return 448;
    }
  }
}
