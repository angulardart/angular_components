// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/annotations/rtl_annotation.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/activation_handler.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_select_base.dart';
import 'package:angular_components/material_select/material_select_dropdown_item.dart';
import 'package:angular_components/material_select/shift_click_selection.dart';
import 'package:angular_components/mixins/button_wrapper.dart';
import 'package:angular_components/mixins/material_dropdown_base.dart';
import 'package:angular_components/mixins/selection_input_adapter.dart';
import 'package:angular_components/mixins/track_layout_changes.dart';
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/a11y/active_item_directive.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/template_support.dart';
import 'package:angular_components/utils/angular/css/css.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// See material_dropdown_select.md for an overview of the component.
/// See examples for usage.
///
/// __Attributes:__
///
/// - `buttonAriaRole` -- Aria label for the button icon.
/// - `popupClass` -- Class to be added to the dropdown popup so that the popup
///   can be styled in an encapsulated way. See [MaterialPopup] for
///   documentation.
@Component(
  selector: 'material-dropdown-select',
  providers: [
    ExistingProvider(DropdownHandle, MaterialDropdownSelectComponent),
    ExistingProvider(HasDisabled, MaterialDropdownSelectComponent),
    ExistingProvider(HasRenderer, MaterialDropdownSelectComponent),
    ExistingProvider(DeferredContentAware, MaterialDropdownSelectComponent),
    ExistingProvider(SelectionContainer, MaterialDropdownSelectComponent),
    ExistingProvider(PopupSizeProvider, MaterialDropdownSelectComponent),
    ExistingProvider(ActivationHandler, MaterialDropdownSelectComponent),
  ],
  directives: [
    ActiveItemDirective,
    AutoFocusDirective,
    DeferredContentDirective,
    DropdownButtonComponent,
    DynamicComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialListComponent,
    MaterialPopupComponent,
    MaterialSelectDropdownItemComponent,
    NgFor,
    NgIf,
    PopupSourceDirective,
  ],
  directiveTypes: [
    Typed<MaterialSelectDropdownItemComponent<String>>(on: 'deselectItem'),
    Typed<MaterialSelectDropdownItemComponent<String>>(on: 'emptyGroupLabel'),
    Typed<MaterialSelectDropdownItemComponent>.of([#T]),
  ],
  viewProviders: [
    FactoryProvider<ActiveItemModel>(ActiveItemModel, fromDropdown,
        deps: [MaterialDropdownSelectComponent])
  ],
  templateUrl: 'material_dropdown_select.html',
  styleUrls: ['material_dropdown_select.scss.css'],
  visibility: Visibility.all, // injected by directives
)
class MaterialDropdownSelectComponent<T> extends MaterialSelectBase<T>
    with
        MaterialDropdownBase,
        SelectionInputAdapter<T>,
        MaterialButtonWrapper,
        TrackLayoutChangesMixin,
        KeyboardHandlerMixin,
        ActivateItemOnKeyPressMixin<T>,
        ShiftClickSelectionMixin<T>
    implements PopupSizeProvider, AfterChanges, OnDestroy {
  /// Function for use by NgFor for optionGroup.
  ///
  /// Avoids recreating the DOM for the optionGroup.
  final Function trackByIndexFn = indexIdentityFn;

  /// Keeps track of the active item.
  final ActiveItemModel activeModel;

  /// The id for the contained material-list.
  final String listId;

  /// The ARIA role to be used for the internal dropdown button.
  ///
  /// If not provided, will use the default role for [DropdownButtonComponent]:
  /// 'button'.
  final String buttonAriaRole;

  /// The id of an element that describes the selection in the dropdown button.
  ///
  /// For example, a text element that says "results per page" for a dropdown
  /// with numerical options.
  @Input()
  String buttonAriaLabelledBy;

  /// One or more space-delimited ids of elements that provide additional
  /// description for the dropdown select.
  ///
  /// For example, the id of a text element that says "Select a foo to use with
  /// your bar."
  @Input()
  String buttonAriaDescribedBy;

  /// Listener for options changes.
  StreamSubscription<List<OptionGroup<T>>> _optionsListener;

  /// Listener for selection changes.
  StreamSubscription<List<SelectionChangeRecord<T>>> _selectionListener;

  /// If a parent provides a [PopupSizeProvider], the provider will be used
  /// instead of the implementation of this class.
  final PopupSizeProvider _popupSizeDelegate;

  /// Text label for select item that deselects the current selection.
  @Input()
  String deselectLabel;

  /// An error displayed below the dropdown button.
  @Input()
  String error;

  /// Whether to show the bottom border of the dropdown button.
  @Input()
  bool showButtonBorder;

  bool _deselectOnActivate = true;

  /// Whether to deselect a selected option on click or enter/space key.
  ///
  /// Single selection model only. Defaults to true.
  @Input()
  set deselectOnActivate(bool value) {
    _deselectOnActivate = value;
  }

  bool get deselectOnActivate => isMultiSelect || _deselectOnActivate;

  /// Factory that returns a component to be used for rendering group labels.
  @Input()
  FactoryRenderer labelFactory;

  // Whether a custom label render is used.
  bool get hasCustomLabelRenderer => labelFactory != null;

  /// Whether to activate (visually focus but not select) the first available
  /// option when the dropdown opens.
  @Input()
  bool activateFirstOption = false;

  /// CSS classes from the root element, passed to the popup to allow scoping of
  /// mixins.
  ///
  /// Only visible for the template.
  final String popupClassName;

  String _ariaActiveDescendant;

  final ChangeDetectorRef _changeDetector;

  bool _disabledChanged = false;

  @override
  set disabled(bool value) {
    super.disabled = value;
    _disabledChanged = true;
  }

  MaterialDropdownSelectComponent(
      @Optional() IdGenerator idGenerator,
      @Optional() @SkipSelf() this._popupSizeDelegate,
      @Optional() @Inject(rtlToken) bool rtl,
      @Attribute('popupClass') String popupClass,
      @Attribute('buttonAriaRole') this.buttonAriaRole,
      this._changeDetector,
      HtmlElement element)
      : activeModel = ActiveItemModel(idGenerator),
        popupClassName = constructEncapsulatedCss(popupClass, element.classes),
        listId = (idGenerator ?? SequentialIdGenerator.fromUUID()).nextId() {
    isRtl = rtl;
    preferredPositions = RelativePosition.overlapAlignments;
    iconName = 'arrow_drop_down';
  }

  @ViewChild(DropdownButtonComponent)
  DropdownButtonComponent dropdownButton;

  // The id of the currently selected item, or the first item if none are
  // selected.
  String get ariaActiveDescendant {
    if (!visible) return '';

    if (_ariaActiveDescendant != null) return _ariaActiveDescendant;

    if (options != null) {
      return activeModel.activeId;
    }

    return '';
  }

  /// The id of the active element of the dropdown.
  @Input()
  set ariaActiveDescendant(String id) {
    _ariaActiveDescendant = id;
  }

  /// Whether to focus the options list by default when the popup opens.
  ///
  /// Should be set to false when another element in the popup is focused on
  /// open, e.g. a search box.
  @Input()
  bool listAutoFocus = true;

  @Input()
  @override
  @Deprecated('Use factoryRenderer it allows for more tree-shakable code.')
  set componentRenderer(ComponentRenderer value) {
    super.componentRenderer = value;
  }

  /// Function that returns a component factory to render the Item.
  ///
  /// The resulting component must implement RendersValue.
  @Input()
  @override
  set factoryRenderer(FactoryRenderer<RendersValue, T> value) {
    super.factoryRenderer = value;
  }

  /// Function to convert an option object to string.
  @Input()
  @override
  set itemRenderer(ItemRenderer<T> value) {
    super.itemRenderer = value;
  }

  /// Width of the dropdown/list, default none, valid values are 0-5.
  @Input()
  @override
  set width(value) {
    super.width = value;
  }

  /// Whether the dropdown is visible.
  @override
  set visible(bool value) {
    _changeDetector.markForCheck();
    super.visible = value;
    resetEnteredKeys();
    if (value) {
      // Ensure that the current active item matches the current value.
      // For instance it is cleared on mouse out.
      // Note we don't allow deactivation because some teams incorrectly use
      // activeItemLabel instead of selectedItemLabel, and this breaks them.
      // TODO(google): remove allowDeactivate when client tests are fixed.
      _setInitialActiveItem(allowDeactivate: false);
    }
  }

  /// Sets the available options for the selection component.
  ///
  /// Accepts either a [SelectionOptions] or a [List]. If a [List] is passed,
  /// the [StringSelectionOptions] class will be used to create the selection
  /// options.
  @Input('options')
  @override
  set optionsInput(dynamic value) {
    super.optionsInput = value;
  }

  @override
  set options(SelectionOptions<T> newOptions) {
    _changeDetector.markForCheck();
    super.options = newOptions;

    _updateActiveModel();
    _setInitialActiveItem();

    _optionsListener?.cancel();
    _optionsListener = options?.stream?.listen((_) {
      _changeDetector.markForCheck();
      _updateActiveModel();
      _setInitialActiveItem();
    });
  }

  /// Event that fires when the dropdown button is focused.
  @Output()
  Stream<FocusEvent> get focus => _focus.stream;
  final StreamController<FocusEvent> _focus =
      StreamController<FocusEvent>.broadcast(sync: true);

  /// Event that fires when the dropdown button is blurred.
  @Output()
  Stream<FocusEvent> get blur => _blur.stream;
  final StreamController<FocusEvent> _blur =
      StreamController<FocusEvent>.broadcast(sync: true);

  void onFocus(FocusEvent event) {
    _focus.add(event);
  }

  void onBlur(FocusEvent event) {
    _blur.add(event);
  }

  @override
  set selection(SelectionModel<T> newSelection) {
    _changeDetector.markForCheck();
    super.selection = newSelection;
    _setInitialActiveItem();

    _selectionListener?.cancel();
    _selectionListener = selection?.selectionChanges?.listen((changes) {
      _changeDetector.markForCheck();
      // Update active item if new items are selected.
      var added =
          changes.last.added.isNotEmpty ? changes.last.added.first : null;
      if (added != null && !activeModel.isActive(added)) {
        activeModel.activate(added);
      }
      emitSelectionChange();
    });
  }

  void _updateActiveModel() {
    var items = List<dynamic>.from(options?.optionsList ?? []);
    if (showDeselectItem) {
      items.insert(0, deselectLabel);
    }
    activeModel.items = items;
  }

  void _setInitialActiveItem({bool allowDeactivate = true}) {
    if (selection == null || selection.selectedValues.isEmpty) {
      if (allowDeactivate) activeModel.activate(null);
    } else if (activeModel.activeItem == null ||
        (showDeselectItem && activeModel.activeItem == deselectLabel) ||
        !selection.isSelected(activeModel.activeItem)) {
      // If the current active item is not selected, activate the first selected
      // item.
      activeModel.activate(selection.selectedValues.first);
    }
    if (activateFirstOption && activeModel.activeItem == null) {
      activeModel.activateFirst();
    }
  }

  void _handleNavigationKey(KeyboardEvent event, Function activateFunction) {
    if (disabled) return;
    event.preventDefault();
    activateFunction();
    // Only select if the popup is not visible.
    if (!visible && selection != null && isSingleSelect) {
      var item = activeModel.activeItem;
      if (item == deselectLabel) {
        deselectCurrentSelection();
      } else if (item != null && !isOptionDisabled(item)) {
        selection.select(item);
      }
    }
    if (!visible) {
      open();
    }
  }

  @override
  void handleUpKey(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activatePrevious);
  }

  @override
  void handleDownKey(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activateNext);
  }

  @override
  void handleLeftKey(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activatePrevious);
  }

  @override
  void handleRightKey(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activateNext);
  }

  @override
  void handlePageUp(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activateFirst);
  }

  @override
  void handlePageDown(KeyboardEvent event) {
    _handleNavigationKey(event, activeModel.activateLast);
  }

  void _handleKeyboardTrigger() {
    if (disabled) return;
    if (!visible) {
      open();
    } else {
      var item = activeModel.activeItem;
      if (item != null && selection != null) {
        if (item == deselectLabel) {
          deselectCurrentSelection();
        } else if (!selection.isSelected(item)) {
          if (!isOptionDisabled(item)) {
            selection.select(item);
          }
        } else if (deselectOnActivate) {
          selection.deselect(item);
        }
      }
      if (isSingleSelect) {
        close();
        dropdownButton.focus();
      }
    }
  }

  @override
  void handleEnterKey(KeyboardEvent event) {
    _handleKeyboardTrigger();
  }

  @override
  void handleSpaceKey(KeyboardEvent event) {
    // Prevent any scrolling.
    event?.preventDefault();
    _handleKeyboardTrigger();
  }

  void handleClick(UIEvent event) {
    // Ignore keyboard events caught by button decorator.
    if (event is! MouseEvent) return;
    if (!disabled) toggle();
  }

  @override
  void handleCharCodeKey(KeyboardEvent event) {
    if (itemRenderer != null && options != null && !disabled) {
      // Don't activate or select if the widget is disabled.
      // Don't select if the selection model is multi-select.
      activateOnKeyPress(activeModel, event.charCode, options, itemRenderer,
          !visible && isSingleSelect ? selection : null);
    }
  }

  @override
  void ngAfterChanges() {
    if (_disabledChanged && disabled) {
      close();
    }
    _disabledChanged = false;
  }

  @override
  void ngOnDestroy() {
    _optionsListener?.cancel();
    _selectionListener?.cancel();
  }

  @override
  num getMinHeight(num positionY, num viewportHeight) =>
      _popupSizeDelegate?.getMinHeight(positionY, viewportHeight);

  @override
  num getMinWidth(num positionX, num viewportWidth) =>
      _popupSizeDelegate?.getMinWidth(positionX, viewportWidth);

  @override
  num getMaxHeight(num positionY, num viewportHeight) {
    if (_popupSizeDelegate != null) {
      return _popupSizeDelegate.getMaxHeight(positionY, viewportHeight);
    } else {
      // The default max height for dropdown select's popup.
      return 400;
    }
  }

  @override
  num getMaxWidth(num positionX, num viewportWidth) {
    if (_popupSizeDelegate != null) {
      return _popupSizeDelegate.getMaxWidth(positionX, viewportWidth);
    } else {
      // The default max width for dropdown select's popup. This was previously
      // max width for material list.
      return 448;
    }
  }

  /// If selectionOptions implements Selectable, it is called.
  bool isOptionDisabled(T item) {
    // TODO: Verify if this can be simplified to .isDisabledIn.
    //
    // The prior code did a check for `!= SelectableOption.Selected`. It is
    // possible there are existing users that are relying on `.Hidden` to mean
    // disabled, for example.
    return !Selectable.isSelectableIn(options, item);
  }

  /// Whether to hide [item].
  bool isOptionHidden(T item) {
    return Selectable.isHiddenIn(options, item, false);
  }

  /// Whether to show select item that deselects the current selection.
  bool get showDeselectItem =>
      !isMultiSelect && deselectLabel?.isNotEmpty == true;

  bool get isDeselectItemSelected => selection.isEmpty;

  void deselectCurrentSelection() {
    if (selection.isNotEmpty) {
      selection.deselect(selection.selectedValues.single);
    }
  }
}

// TODO(google): Move it to a common home to increase reusability.
// TODO(google): Better comparison of characters to better support i18n.
class ActivateItemOnKeyPressMixin<T> {
  static final Map<int, String> _charCodeMap = <int, String>{};

  String _enteredKeys = '';

  /// Activates an item in the ActiveItemModel based on the key passed in.
  /// If the current item already matches, it will select the next item that
  /// matches.
  void activateOnKeyPress(
      ActiveItemModel activeModel,
      int charCode,
      SelectionOptions options,
      ItemRenderer<T> itemRenderer,
      SelectionModel selection) {
    // Guard against being called when not all data is initialized.
    if (itemRenderer == null || options == null) return;

    String key = _charCodeToString(charCode);
    var optionsList = options.optionsList;
    // Cached map of options to search strings.
    var searchMap = <dynamic, String>{};

    var startsWith = (option, String keys) {
      if (option == null) return false;
      var searchString = searchMap[option];
      if (searchString == null) {
        searchString = itemRenderer(option).toLowerCase();
        searchMap[option] = searchString;
      }
      return searchString.startsWith(keys);
    };
    var maybeSelectOption = (option, String keys) {
      if (Selectable.isSelectableIn(options, option) &&
          startsWith(option, keys)) {
        activeModel.activate(option);
        selection?.select(option);
        _enteredKeys = keys;
        return true;
      }
      return false;
    };

    // If there's previously entered keys, try to match multiple keys.
    if (_enteredKeys.isNotEmpty) {
      var keys = _enteredKeys + key;
      for (var option in optionsList) {
        if (maybeSelectOption(option, keys)) return;
      }
    }

    // If there is already an active item then check if the key code matches
    // it and also matches the next item then select the next item.
    if (startsWith(activeModel.activeItem, key)) {
      if (maybeSelectOption(activeModel.peekNext, key)) return;
    }

    for (var option in optionsList) {
      if (maybeSelectOption(option, key)) return;
    }

    resetEnteredKeys();
  }

  void resetEnteredKeys() {
    _enteredKeys = '';
  }

  /// Utility method to convert a charCode to a lower case character.
  String _charCodeToString(int charCode) {
    String key = _charCodeMap[charCode];
    if (key == null) {
      key = String.fromCharCode(charCode).toLowerCase();
      _charCodeMap[charCode] = key;
    }
    return key;
  }
}

ActiveItemModel fromDropdown(MaterialDropdownSelectComponent dropdown) =>
    dropdown.activeModel;
