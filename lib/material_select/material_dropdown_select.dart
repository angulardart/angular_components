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
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
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
import 'package:angular_components/mixins/track_layout_changes.dart';
import 'package:angular_components/model/a11y/active_item.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/template_support.dart';
import 'package:angular_components/utils/angular/css/css.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// Material Dropdown Select is a button-triggered dropdown.
///
/// The `material-dropdown-select` component combines the APIs of
/// `material-select`, and `material-button-dropdown`.
///
/// When used with a single selection model, the dropdown closes upon selection.
/// When using a multi-selection model, the user must close the dropdown by
/// clicking outside of it.
///
/// Selection options may be declared manually by passing `material-select-item`
/// elements. When using the declarative API, the `SelectionModel` and
/// `SelectionOptions` are not injected, so marking the item as selected is not
/// automatic.
///
/// If an `OptionGroup` is empty and has an `emptyLabel` defined, the dropdown
/// will include it with the other groups. If `emptyLabel` is not defined for
/// an empty group it will not appear in the list.
///
/// Supports async suggestions through the [ObserveAware] interface implemented
/// by [SelectionOptions].
///
/// The material-select has a fixed max height and auto overflow. We can add a
/// property for custom max height once there's a use case.
///
/// See
/// https://github.com/dart-lang/angular_components_example/tree/master/example/material_select_example
/// for example usage.
///
/// __Example usage:__
///
///     <material-dropdown-select
///       [buttonText]="buttonText"
///       [selection]="singleSelectModel"
///       [options]="options"
///       [itemRenderer]="itemRenderer"
///       [preferredPositions]="preferredPositions">
///     </material-dropdown-select>
///
/// __Properties:__
///
/// - `selection: SelectionModel` -- The selection model this component
///   controls.
/// - `options: SelectionOptions` -- The options to use for this selection
///   model.
/// - `componentRenderer: ComponentRenderer` -- Function that returns a
///   component to render the Item. The component must implement RendersValue.
/// - `itemRenderer: ItemRenderer` -- Function to convert an option object to
///   string.
/// - `width: int` -- Width of the dropdown/list, default none, valid values are
///   0-5.
/// - `visible: bool` -- Whether the dropdown is visible.
/// - `buttonText: String` -- Text on trigger button.
/// - `buttonAriaLabel: String` -- Aria label for trigger button.
/// - `ariaActiveDescendant: String` -- The id of the selected item in the
///    dropdown when using content projection.
///  - `showButtonBorder: bool` - Whether to show the bottom border of the
///   dropdown button.
/// - `iconName: String` -- Icon to use on button, `arrow_drop_down` by default.
/// - `icon-label: String` -- Aria label for the button icon.
/// - `disabled: bool` -- Whether the control is disabled.
/// - `icon: Icon` -- `Icon` model instance.
/// - `autoDismiss: bool` -- Whether the popup should close when the document
///   pressed.
/// - `popupMatchInputWidth: bool` -- Whether or not the popup width is at least
///   as wide as the select width.
/// - `preferredPositions: List` -- A manual list of preferred auto-alignments
///   for the dropdown popup.
/// - `slide: String` -- Direction of popup scaling. Valid values are `x`, `y`,
///   or `null`.
/// - `deselectOnActivate: bool` -- Whether to deselect a selected option on
///   click or enter/space key. Single selection model only. Defaults to true.
/// - `deselectLabel: String` -- Adds a select item that deselects the current
///   selection.
/// - `labelRenderer: ComponentRenderer` -- Function that returns a component
///   to be used for rendering group labels.
@Component(
  selector: 'material-dropdown-select',
  providers: const [
    const Provider(DropdownHandle,
        useExisting: MaterialDropdownSelectComponent),
    const Provider(HasRenderer, useExisting: MaterialDropdownSelectComponent),
    const Provider(DeferredContentAware,
        useExisting: MaterialDropdownSelectComponent),
    const Provider(SelectionContainer,
        useExisting: MaterialDropdownSelectComponent),
    const Provider(PopupSizeProvider,
        useExisting: MaterialDropdownSelectComponent),
    const Provider(ActivationHandler,
        useExisting: MaterialDropdownSelectComponent),
  ],
  directives: const [
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
  templateUrl: 'material_dropdown_select.html',
  styleUrls: const ['material_dropdown_select.scss.css'],
  visibility: Visibility.all, // injected by directives
)
class MaterialDropdownSelectComponent extends MaterialSelectBase
    with
        MaterialDropdownBase,
        MaterialButtonWrapper,
        TrackLayoutChangesMixin,
        KeyboardHandlerMixin,
        ActivateItemOnKeyPressMixin,
        ShiftClickSelectionMixin
    implements PopupSizeProvider, OnChanges, OnDestroy {
  /// Function for use by NgFor for optionGroup.
  ///
  /// Avoids recreating the DOM for the optionGroup.
  final Function trackByIndexFn = indexIdentityFn;

  /// Keeps track of the active item.
  final ActiveItemModel activeModel;

  /// The id for the contained material-list.
  final String listId;

  /// Listener for options changes.
  StreamSubscription _optionsListener;

  /// Listener for selection changes.
  StreamSubscription _selectionListener;

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

  /// If true triggering a select item component will deselect the currently
  /// selected single select value.
  @Input()
  set deselectOnActivate(bool value) {
    _deselectOnActivate = value;
  }

  bool get deselectOnActivate => isMultiSelect || _deselectOnActivate;

  @Input()
  @Deprecated(
      'Use labelFactory instead it allows for better tree-shakable code.')
  ComponentRenderer labelRenderer;

  /// Factory used to create labels for the dropdown.
  @Input()
  FactoryRenderer labelFactory;

  // Whether a custom label render is used.
  bool get hasCustomLabelRenderer =>
      labelRenderer != null || labelFactory != null;

  /// CSS classes from the root element, passed to the popup to allow scoping of
  /// mixins.
  ///
  /// Only visible for the template.
  final String popupClassName;

  /// The id of the active element of the dropdown.
  String _ariaActiveDescendant;

  MaterialDropdownSelectComponent(
      @Optional() IdGenerator idGenerator,
      @Optional() @SkipSelf() this._popupSizeDelegate,
      @Optional() @Inject(rtlToken) bool rtl,
      @Attribute('popupClass') String popupClass,
      HtmlElement element)
      : activeModel = new ActiveItemModel(idGenerator),
        popupClassName = constructEncapsulatedCss(popupClass, element.classes),
        listId =
            (idGenerator ?? new SequentialIdGenerator.fromUUID()).nextId() {
    isRtl = rtl;
    preferredPositions = RelativePosition.overlapAlignments;
    iconName = 'arrow_drop_down';
  }

  /// The id of the currently selected item, or the first item if none are
  /// selected.
  String get ariaActiveDescendant {
    if (!visible) return '';

    if (_ariaActiveDescendant != null) return _ariaActiveDescendant;

    if (options != null) {
      if (isDeselectItemSelected) return activeModel.id(deselectLabel);
      return activeModel.activeId;
    }

    return '';
  }

  @Input()
  set ariaActiveDescendant(String id) {
    _ariaActiveDescendant = id;
  }

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
  set factoryRenderer(FactoryRenderer value) {
    super.factoryRenderer = value;
  }

  // Ideally, [value] would be a [ItemRenderer<T>], where T is also the type
  // parameter of the SelectionOptions and the SelectionModel, as parent
  // components typically use a function that accepts a specific type (T).
  //
  // However, we don't have a T. Angular doesn't support injecting a
  // type-annotated component yet, and setters, like [itemRenderer], cannot
  // be type-annotated. This forces us to accept a plain old [Function] as
  // [value], in order to avoid uses_dynamic_as_bottom errors. (Basically, a
  // function like [MaterialTimePicker]'s `String renderTime(DateTime time)`
  // cannot work as a [ItemRenderer], since it expects DateTime, not dynamic.)
  @Input()
  @override
  set itemRenderer(Function value) {
    super.itemRenderer = (item) => value(item);
  }

  @Input()
  @override
  set width(value) {
    super.width = value;
  }

  @override
  set visible(bool value) {
    super.visible = value;
    resetEnteredKeys();
  }

  @Input()
  @override
  set options(SelectionOptions newOptions) {
    super.options = newOptions;

    _updateActiveModel();
    _setInitialActiveItem();

    _optionsListener?.cancel();
    _optionsListener = options?.stream?.listen((_) {
      _updateActiveModel();
      _setInitialActiveItem();
    });
  }

  @Output()
  Stream<FocusEvent> get focus => _focus.stream;
  StreamController<FocusEvent> _focus =
      new StreamController<FocusEvent>.broadcast(sync: true);

  @Output()
  Stream<FocusEvent> get blur => _blur.stream;
  StreamController<FocusEvent> _blur =
      new StreamController<FocusEvent>.broadcast(sync: true);

  void onFocus(FocusEvent event) {
    _focus.add(event);
  }

  void onBlur(FocusEvent event) {
    _blur.add(event);
  }

  @Input()
  @override
  set selection(SelectionModel newSelection) {
    super.selection = newSelection;
    _setInitialActiveItem();

    _selectionListener?.cancel();
    _selectionListener = selection?.selectionChanges?.listen((changes) {
      // Update active item if new items are selected.
      var added =
          changes.last.added.isNotEmpty ? changes.last.added.first : null;
      if (added != null && !activeModel.isActive(added)) {
        activeModel.activate(added);
      }
    });
  }

  void _updateActiveModel() {
    var items = new List<dynamic>.from(options?.optionsList ?? []);
    if (showDeselectItem) {
      items.insert(0, deselectLabel);
    }
    activeModel.items = items;
  }

  void _setInitialActiveItem() {
    if (selection == null || selection.selectedValues.isEmpty) {
      activeModel.activate(null);
    } else if (activeModel.activeItem == null ||
        (showDeselectItem && activeModel.activeItem == deselectLabel) ||
        !selection.isSelected(activeModel.activeItem)) {
      // If the current active item is not selected, activate the first selected
      // item.
      activeModel.activate(selection.selectedValues.first);
    }
  }

  void _handleNavigationKey(KeyboardEvent event, Function activateFunction) {
    if (disabled) return;
    event.preventDefault();
    activateFunction();
    // Only select if the popup is not visible.
    if (!visible &&
        selection != null &&
        isSingleSelect &&
        activeModel.activeItem != null) {
      selection.select(activeModel.activeItem);
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
          selection.select(item);
        } else if (deselectOnActivate) {
          selection.deselect(item);
        }
      }
      if (isSingleSelect) close();
    }
  }

  @override
  void handleEnterKey(KeyboardEvent event) {
    _handleKeyboardTrigger();
  }

  @override
  void handleSpaceKey(KeyboardEvent event) {
    _handleKeyboardTrigger();
  }

  void handleClick(UIEvent event) {
    // Ignore keyboard events caught by button decorator.
    if (event is! MouseEvent) return;
    if (!disabled) toggle();
  }

  @override
  void handleEscapeKey(KeyboardEvent event) {
    if (visible) {
      close();
      event.stopPropagation();
    }
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
  ngOnChanges(Map<String, SimpleChange> changes) {
    if (changes.containsKey('disabled') && disabled) {
      close();
    }
  }

  @override
  ngOnDestroy() {
    _optionsListener?.cancel();
    _selectionListener?.cancel();
  }

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
  bool isOptionDisabled(Object item) {
    if (options is Selectable) {
      return (options as Selectable).getSelectable(item) !=
          SelectableOption.Selectable;
    }
    return false;
  }

  /// Whether to hide [item].
  bool isOptionHidden(Object item) {
    if (options is Selectable) {
      return (options as Selectable).getSelectable(item) ==
          SelectableOption.Hidden;
    }
    return false;
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
class ActivateItemOnKeyPressMixin {
  static Map<int, String> _charCodeMap = <int, String>{};

  String _enteredKeys = '';

  /// Activates an item in the ActiveItemModel based on the key passed in.
  /// If the current item already matches, it will select the next item that
  /// matches.
  void activateOnKeyPress(
      ActiveItemModel activeModel,
      int charCode,
      SelectionOptions options,
      ItemRenderer itemRenderer,
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
      if (startsWith(option, keys)) {
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
      key = new String.fromCharCode(charCode).toLowerCase();
      _charCodeMap[charCode] = key;
    }
    return key;
  }
}
