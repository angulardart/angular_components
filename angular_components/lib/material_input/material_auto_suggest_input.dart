// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/input_wrapper.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/material_select_base.dart';
import 'package:angular_components/material_select/material_select_dropdown_item.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_components/mixins/highlight_assistant_mixin.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/a11y/active_item_directive.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/highlight_provider.dart';
import 'package:angular_components/model/ui/template_support.dart';
import 'package:angular_components/stop_propagation/stop_propagation.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/async/async.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

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
@Component(
  selector: 'material-auto-suggest-input',
  providers: [
    Provider(HasDisabled, useExisting: MaterialAutoSuggestInputComponent),
    Provider(HasRenderer, useExisting: MaterialAutoSuggestInputComponent),
    Provider(SelectionContainer,
        useExisting: MaterialAutoSuggestInputComponent),
    Provider(HighlightProvider, useExisting: MaterialAutoSuggestInputComponent),
    Provider(DropdownHandle, useExisting: MaterialAutoSuggestInputComponent),
    Provider(HasComponentRenderer,
        useExisting: MaterialAutoSuggestInputComponent),
    Provider(HasFactoryRenderer,
        useExisting: MaterialAutoSuggestInputComponent),
    Provider(Focusable, useExisting: MaterialAutoSuggestInputComponent),
    Provider(PopupSizeProvider, useExisting: MaterialAutoSuggestInputComponent)
  ],
  directives: [
    ActiveItemDirective,
    ButtonDirective,
    CachingDeferredContentDirective,
    DynamicComponent,
    FocusTrapComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialIconComponent,
    materialInputDirectives,
    MaterialListComponent,
    MaterialSelectDropdownItemComponent,
    MaterialPopupComponent,
    MaterialSpinnerComponent,
    MaterialTooltipDirective,
    PopupSourceDirective,
    NgFor,
    NgIf,
    StopPropagationDirective,
  ],
  templateUrl: 'material_auto_suggest_input.html',
  styleUrls: [
    'material_auto_suggest_input.scss.css',
    'material_input_wrapper.scss.css'
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialAutoSuggestInputComponent extends MaterialSelectBase
    with MaterialInputWrapper, KeyboardHandlerMixin, HighlightAssistantMixin
    implements
        ControlValueAccessor,
        Focusable,
        AfterChanges,
        OnInit,
        OnDestroy,
        HasRenderer,
        HasComponentRenderer,
        HasFactoryRenderer,
        DropdownHandle,
        PopupSizeProvider {
  /// How to automatically position the dropdown popup by default.
  ///
  /// We do not want to cover the input area.
  static const List<RelativePosition> _defaultPopupPositions = [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight,
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];

  final String popupId;
  final String inputId;

  /// Keeps track of the item matching the filter as the suggestions are
  /// being updated.
  final ActiveItemModel activeModel;

  bool _isInitialized = false;

  /// Whether to clear the input text once the item is selected from the menu.
  ///
  /// Defaults to false.
  // TODO(google): rename this to shouldClearInputOnSelection.
  @Input()
  bool shouldClearOnSelection = false;

  /// Whether to clear the selected value from the selection model when the
  /// input text changes.
  ///
  /// Defaults to true.
  @Input()
  bool shouldClearSelectionOnInput = true;

  /// Whether to cause dropdown to be closed on activation.
  ///
  /// Defaults to true.
  @Input()
  bool closeOnActivate = true;

  /// Whether to hide the checkbox before the selection item for multi-select.
  ///
  /// Defaults to false.
  @Input()
  bool hideCheckbox = false;

  /// Whether the popup should automatically reposition itself based on space
  /// available relative to the viewport.
  ///
  /// Defaults to true.
  @Input()
  bool enforceSpaceConstraints = true;

  /// Whether to clamp the popup position so that it never goes offscreen.
  ///
  /// Defaults to false.
  @Input()
  bool constrainToViewport = false;

  bool _showPopup = false;
  bool _focusPending = false;
  MaterialInputComponent _input;
  _InputChangeCallback _callback;
  bool _sorted = true;
  List _suggestions = [];
  bool _refreshOptions = false;

  /// The current text being displayed.
  String _inputText = '';

  /// Publishes events when input text changes.
  final _inputChange = StreamController<String>.broadcast(sync: true);

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
  ///
  /// Defaults to false.
  @Input()
  bool initialActivateSelection = false;

  int _limit = 10;

  /// Allow filtering of suggestions as the user is typing.
  ///
  /// When `false` always show the full list of suggestions.
  /// Defaults to true.
  @Input()
  bool filterSuggestions = true;

  /// Whether to close on enter even for string non matching options.
  ///
  /// Defaults to false.
  @Input()
  bool closeOnEnter = false;

  /// A custom CSS class for suggestion popup contents.
  @Input()
  String popupShadowCssClass = '';

  /// Whether or not the suggestion popup width is at least as wide as the input
  /// width.
  ///
  /// Defaults to false.
  @Input()
  bool popupMatchInputWidth = false;

  /// The preferred positions for the dropdown popup.
  List<RelativePosition> _popupPositions = _defaultPopupPositions;

  /// Listener for selection model changes.
  StreamSubscription _selectionListener;

  /// Listener for selection options changes.
  StreamSubscription _optionsListener;

  StreamController _selectionChangeController;

  /// Direction of popup scaling.
  ///
  /// Valid values are `x`, `y`, or `null`.
  @Input()
  String slide;

  /// Show or hide the trailing close icon.
  ///
  /// Clicking on the icon clears the input text and hides the popup.
  /// Defaults to false.
  @Input()
  bool showClearIcon = false;

  /// Tooltip shown on clear icon.
  @Input()
  String clearIconTooltip;

  bool get hasClearIconTooltip => clearIconTooltip?.isNotEmpty ?? false;

  /// Text to show if the options list is empty and not loading.
  @Input()
  String emptyPlaceholder = '';

  // The fields below are deprecated.

  @Deprecated('Use [options] instead')
  @Input()
  set suggestions(List value) {
    _suggestions = value;
    _refreshOptions = true;
  }

  List get suggestion => _suggestions;

  // Override renderer here to just add the @Input annotation and keep the
  // angular dependency out of models.
  /// A simple function to render the an item to string.
  @override
  @Input()
  set itemRenderer(ItemRenderer<dynamic> value) => super.itemRenderer = value;

  // Override renderer here to just add the @Input annotation and keep the
  // angular dependency out of models.
  @override
  @Input()
  @Deprecated('Use factoryRenderer instead as it is tree shakeable.')
  set componentRenderer(ComponentRenderer value) =>
      super.componentRenderer = value;

  /// [FactoryRenderer] used to display the item.
  @override
  @Input()
  set factoryRenderer(FactoryRenderer value) => super.factoryRenderer = value;

  @Deprecated('Caller should call .sort() on the options instead.')
  @Input()
  set sorted(bool value) {
    _sorted = value;
    _refreshOptions = true;
  }

  bool get sorted => _sorted;

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
      MaterialAutoSuggestInputComponent.protected(cd,
          idGenerator ?? SequentialIdGenerator.fromUUID(), popupSizeDelegate);

  MaterialAutoSuggestInputComponent.protected(this._cd, IdGenerator idGenerator,
      [this._popupSizeDelegate])
      : activeModel = ActiveItemModel(idGenerator, loop: true),
        popupId = idGenerator.nextId(),
        inputId = idGenerator.nextId() {
    if (_cd != null) {
      _cd.valueAccessor = this;
    }
    selection = SelectionModel.single();
  }

  /// Publishes events when input text changes (on keypress.)
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
  ngAfterChanges() {
    // If either the suggestions were changed or the value of sort was changed,
    // rebuild the list of options.
    if (_refreshOptions) {
      var optionsList = List.from(_suggestions);
      if (_sorted) {
        optionsList.sort();
      }
      options =
          StringSelectionOptions(optionsList, toFilterableString: itemRenderer);
      _refreshOptions = false;
    }
  }

  /// Emits the selected value(s) whenever selection changes.
  ///
  /// For single select, it will either be the selected value or null.
  /// For multi select, it will a list of selected values or an empty list.
  @Output()
  Stream get selectionChange {
    if (_selectionChangeController == null) {
      _selectionChangeController = new StreamController();
    }
    return _selectionChangeController.stream;
  }

  /// Sets the selected value or selection model for the input.
  ///
  /// Accepts either a [SelectionModel], a selected value or null.
  @Input('selection')
  set selectionInput(dynamic value) {
    if (value is SelectionModel) {
      selection = value;
    } else if (value == null) {
      selection.clear();
    } else {
      assert(
          isSingleSelect,
          'Passing selected value through `selection` input is only supported '
          'for single select.');
      selection.select(value);
    }
  }

  @override
  set selection(SelectionModel selection) {
    super.selection = selection;

    if (isSingleSelect && selection.selectedValues.isNotEmpty) {
      _lastSelectedItem = selection.selectedValues.first;
      if (_isInitialized) {
        inputText = itemRenderer(_lastSelectedItem);
      }
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
          _lastSelectedItem = selectedItem;
          inputText =
              _lastSelectedItem != null ? itemRenderer(_lastSelectedItem) : '';
        }
      }
      if (_selectionChangeController != null) {
        if (isSingleSelect) {
          _selectionChangeController.add(selection.selectedValues.isNotEmpty
              ? selection.selectedValues.first
              : null);
        } else {
          _selectionChangeController.add(selection.selectedValues);
        }
      }
    });
  }

  /// Sets the available options for the input.
  ///
  /// Accepts either a [SelectionOptions] or a [List]. If a [List] is passed,
  /// the [StringSelectionOptions] class will be used to create the selection
  /// options.
  @Input('selectionOptions')
  set selectionOptionsInput(dynamic value) {
    if (value == null) return;
    if (value is SelectionOptions) {
      options = value;
    } else if (value is List) {
      options = StringSelectionOptions(value, toFilterableString: itemRenderer);
    } else {
      throw ArgumentError('Unsupported selection options type.');
    }
  }

  @override
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

  /// How many suggestions to show.
  ///
  /// If the limit is less than 1, it is assumed to be mean no limit.
  /// See filter method in [Filterable]. Defaults to 10.
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

  @Deprecated('Use labelFactory instead.')
  @Input()
  ComponentRenderer labelRenderer;

  /// Custom factory for rendering suggestion labels.
  @Input()
  FactoryRenderer labelFactory;

  // Whether a custom label render is used.
  bool get hasCustomLabelRenderer =>
      labelRenderer != null || labelFactory != null;

  /// An option is disabled if the options implements Selectable, but the [item]
  /// is not selectable.
  bool isOptionDisabled(Object item) {
    // TODO: Verify if this can be simplified to .isDisabledIn.
    //
    // The prior code did a check for `!= SelectableOption.Selected`. It is
    // possible there are existing users that are relying on `.Hidden` to mean
    // disabled, for example.
    return !Selectable.isSelectableIn(options, item, true);
  }

  /// Whether to highlight options.
  /// Default value is `true`.
  @Input()
  bool highlightOptions = true;

  @override
  ComponentRenderer get componentRenderer => highlightOptions &&
          super.componentRenderer == null &&
          super.factoryRenderer == null
      ? highlightComponentRenderer
      : super.componentRenderer;

  @override
  FactoryRenderer get factoryRenderer => highlightOptions &&
          super.factoryRenderer == null &&
          super.componentRenderer == null
      ? highlightFactoryRenderer
      : super.factoryRenderer;

  final _showPopupController = StreamController<bool>.broadcast(sync: true);

  /// Publishes event when the showPopup changes.
  @Output()
  Stream<bool> get showPopupChange => _showPopupController.stream;

  bool get showPopup => _showPopup && !disabled;

  /// Used to control the visibility of the suggestion popup.
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

  /// When turned on and no suggestions available, show loading indicator in the
  /// suggestions dropdown.
  @Input()
  bool loading = false;

  bool get showEmptyPlaceholder =>
      emptyPlaceholder.isNotEmpty &&
      options.optionsList.isEmpty &&
      !showLoadingSpinner;

  List<RelativePosition> get popupPositions => _popupPositions;

  /// List of positions to try and draw the suggest popup.
  ///
  /// See [MaterialPopupComponent] for more information.
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
    if (_setInputText(inputText) && _callback != null) {
      _callback(_inputText);
    }
  }

  /// Returns true if [inputText] was changed.
  bool _setInputText(String inputText) {
    inputText ??= '';

    if (inputText == _inputText) {
      return false;
    }

    if (shouldClearSelectionOnInput &&
        !shouldClearOnSelection &&
        _lastSelectedItem != null) {
      // deselect previously selected item as the component was not asked to
      // clear the text upon selection, indicating that the selection is bound
      // to the text.
      // TODO(google): Should we clear the selection if they erase even a letter?
      if (inputText != itemRenderer(_lastSelectedItem)) {
        selection.deselect(_lastSelectedItem);
        _lastSelectedItem = null;
      }
    }
    _inputText = inputText;
    _inputChange.add(inputText);
    _filterSuggestions();
    return true;
  }

  /// Fired when the close icon is clicked.
  @Output('clear')
  Stream<void> get onClear => _onClear.stream;
  final _onClear = StreamController<void>.broadcast(sync: true);

  void onClearIcon() {
    _onClear.add(null);
    showPopup = false;
    inputText = '';
  }

  bool _isFocused = false;

  /// Fired when the input gains focus
  @Output('focus')
  Stream<html.FocusEvent> get onFocus => _onFocus.stream;
  final _onFocus = StreamController<html.FocusEvent>.broadcast(sync: true);

  void handleFocus(html.FocusEvent event) {
    if (_isFocused) return;

    showPopup = true;
    _onFocus.add(event);
    _isFocused = true;
  }

  /// Fired when the input gains blur or auto suggest item get selected.
  @Output('blur')
  Stream<void> get onBlur => _onBlur.stream;
  final _onBlur = StreamController<void>.broadcast(sync: true);

  void handleBlur(html.FocusEvent event) {
    _isFocused = false;
    if ((!showPopup || !hasOptions) && _onBlur != null) {
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
      if (item != null) {
        if (!isOptionDisabled(item)) {
          onListItemSelected(item);
        }
      } else if (closeOnEnter) {
        showPopup = false;
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
    if (showPopup) {
      showPopup = false;
      event.stopPropagation();
      // If the popup was clicked, giving it focus, return focus to the input
      // combo box. But avoid the side-effects of handleFocus.
      _isFocused = true;
      focus();
    }
  }

  /// Act as a validator.
  /// TODO(google): Please don't add validation support this way.
  call(_) {
    // material-auto-suggest-input doesn't support validation yet
    return null;
  }

  @override
  void writeValue(newValue) {
    _setInputText(newValue as String);
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
  ngOnInit() {
    _isInitialized = true;
    scheduleMicrotask(() {
      if (inputText.isEmpty && _lastSelectedItem != null) {
        _setInputText(itemRenderer(_lastSelectedItem));
      }
    });
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
  num getMinHeight(num positionY, num viewportHeight) {
    return _popupSizeDelegate?.getMinHeight(positionY, viewportHeight);
  }

  @override
  num getMinWidth(num positionX, num viewportWidth) {
    return _popupSizeDelegate?.getMinWidth(positionX, viewportWidth);
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

  @override
  void onDisabledChanged(bool isDisabled) {
    disabled = isDisabled;
  }
}
