// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components;

import 'app_layout/material_persistent_drawer.dart';
import 'app_layout/material_stackable_drawer.dart';
import 'app_layout/material_temporary_drawer.dart';
import 'auto_dismiss/auto_dismiss.dart';
import 'button_decorator/button_decorator.dart';
import 'content/deferred_content.dart';
import 'dynamic_component/dynamic_component.dart';
import 'focus/focus.dart';
import 'focus/focus_activable_item.dart';
import 'focus/focus_item.dart';
import 'focus/focus_list.dart';
import 'focus/focus_trap.dart';
import 'focus/keyboard_only_focus_indicator.dart';
import 'glyph/glyph.dart';
import 'highlighted_text/highlighted_text.dart';
import 'highlighted_text/highlighted_value.dart';
import 'laminate/components/modal/modal.dart';
import 'laminate/popup/popup.dart';
import 'material_button/material_button.dart';
import 'material_button/material_fab.dart';
import 'material_checkbox/material_checkbox.dart'
    show MaterialCheckboxComponent;
import 'material_chips/material_chip.dart';
import 'material_chips/material_chips.dart';
import 'material_datepicker/date_input.dart';
import 'material_datepicker/date_range_editor.dart';
import 'material_datepicker/date_range_input.dart';
import 'material_datepicker/material_calendar_picker.dart';
import 'material_datepicker/material_date_range_picker.dart';
import 'material_datepicker/material_date_time_picker.dart';
import 'material_datepicker/material_datepicker.dart';
import 'material_datepicker/material_month_picker.dart';
import 'material_datepicker/material_time_picker.dart';
import 'material_datepicker/module.dart';
import 'material_dialog/material_dialog.dart';
import 'material_expansionpanel/material_expansionpanel.dart';
import 'material_expansionpanel/material_expansionpanel_auto_dismiss.dart';
import 'material_expansionpanel/material_expansionpanel_set.dart';
import 'material_icon/material_icon.dart';
import 'material_input/material_auto_suggest_input.dart';
import 'material_input/material_input.dart' hide materialInputErrorKey;
import 'material_input/material_input_default_value_accessor.dart';
import 'material_input/material_input_multiline.dart';
import 'material_input/material_number_accessor.dart';
import 'material_input/material_number_validators.dart';
import 'material_input/material_percent_directive.dart';
import 'material_list/material_list.dart';
import 'material_list/material_list_item.dart';
import 'material_menu/dropdown_menu.dart';
import 'material_menu/material_fab_menu.dart';
import 'material_menu/material_menu.dart';
import 'material_menu/menu_item_affix_list.dart';
import 'material_menu/menu_item_groups.dart';
import 'material_menu/menu_popup.dart';
import 'material_menu/menu_root.dart';
import 'material_popup/material_popup.dart';
import 'material_progress/material_progress.dart';
import 'material_radio/material_radio.dart';
import 'material_radio/material_radio_group.dart';
import 'material_ripple/material_ripple.dart';
import 'material_select/display_name.dart';
import 'material_select/dropdown_button.dart';
import 'material_select/material_dropdown_select.dart';
import 'material_select/material_dropdown_select_accessor.dart';
import 'material_select/material_select.dart';
import 'material_select/material_select_dropdown_item.dart';
import 'material_select/material_select_item.dart';
import 'material_select/material_select_searchbox.dart';
import 'material_slider/material_slider.dart';
import 'material_spinner/material_spinner.dart';
import 'material_stepper/material_step.dart';
import 'material_stepper/material_stepper.dart';
import 'material_tab/fixed_material_tab_strip.dart';
import 'material_tab/material_tab.dart';
import 'material_tab/material_tab_panel.dart';
import 'material_tab/tab_button.dart';
import 'material_toggle/material_toggle.dart';
import 'material_tooltip/material_tooltip.dart';
import 'material_tree/material_tree.dart';
import 'material_yes_no_buttons/material_yes_no_buttons.dart';
import 'reorder_list/reorder_list.dart';
import 'scorecard/scoreboard.dart';
import 'scorecard/scorecard.dart';
import 'stop_propagation/stop_propagation.dart';
import 'theme/dark_theme.dart';

export 'annotations/rtl_annotation.dart';
export 'app_layout/material_drawer_base.dart';
export 'app_layout/material_persistent_drawer.dart';
export 'app_layout/material_stackable_drawer.dart';
export 'app_layout/material_temporary_drawer.dart';
export 'auto_dismiss/auto_dismiss.dart';
export 'button_decorator/button_decorator.dart';
export 'content/deferred_content.dart';
export 'content/deferred_content_aware.dart';
export 'dynamic_component/dynamic_component.dart';
export 'focus/focus.dart';
export 'focus/focus_activable_item.dart';
export 'focus/focus_item.dart';
export 'focus/focus_list.dart';
export 'focus/focus_trap.dart';
export 'focus/keyboard_only_focus_indicator.dart';
export 'forms/error_renderer.dart';
export 'glyph/glyph.dart';
export 'highlighted_text/highlighted_text.dart';
export 'highlighted_text/highlighted_value.dart';
export 'laminate/components/modal/modal.dart';
export 'laminate/enums/alignment.dart';
export 'laminate/overlay/module.dart';
export 'laminate/popup/module.dart';
export 'laminate/popup/popup.dart';
export 'material_button/material_button.dart';
export 'material_button/material_button_base.dart';
export 'material_button/material_fab.dart';
export 'material_checkbox/material_checkbox.dart'
    show MaterialCheckboxComponent;
export 'material_chips/material_chip.dart';
export 'material_chips/material_chips.dart';
export 'material_datepicker/calendar.dart';
export 'material_datepicker/comparison.dart';
export 'material_datepicker/date_input.dart';
export 'material_datepicker/date_range_editor.dart';
export 'material_datepicker/date_range_input.dart';
export 'material_datepicker/material_calendar_picker.dart';
export 'material_datepicker/material_date_range_picker.dart';
export 'material_datepicker/material_date_time_picker.dart';
export 'material_datepicker/material_datepicker.dart';
export 'material_datepicker/material_month_picker.dart';
export 'material_datepicker/material_time_picker.dart';
export 'material_datepicker/model.dart';
export 'material_datepicker/module.dart';
export 'material_datepicker/next_prev_buttons.dart';
export 'material_datepicker/preset.dart';
export 'material_dialog/material_dialog.dart';
export 'material_expansionpanel/material_expansionpanel.dart';
export 'material_expansionpanel/material_expansionpanel_auto_dismiss.dart';
export 'material_expansionpanel/material_expansionpanel_set.dart';
export 'material_icon/material_icon.dart';
export 'material_input/base_material_input.dart';
export 'material_input/deferred_validator.dart';
export 'material_input/input_wrapper.dart';
export 'material_input/material_auto_suggest_input.dart';
export 'material_input/material_input.dart' hide materialInputErrorKey;
export 'material_input/material_input_default_value_accessor.dart';
export 'material_input/material_input_error_keys.dart';
export 'material_input/material_input_multiline.dart';
export 'material_input/material_number_accessor.dart';
export 'material_input/material_number_validators.dart';
export 'material_input/material_percent_directive.dart';
export 'material_list/material_list.dart';
export 'material_list/material_list_item.dart';
export 'material_list/material_list_size.dart';
export 'material_menu/dropdown_menu.dart';
export 'material_menu/material_fab_menu.dart';
export 'material_menu/material_menu.dart';
export 'material_menu/menu_item_affix_list.dart';
export 'material_menu/menu_item_groups.dart';
export 'material_menu/menu_popup.dart';
export 'material_menu/menu_popup_wrapper.dart';
export 'material_popup/material_popup.dart';
export 'material_progress/material_progress.dart';
export 'material_radio/material_radio.dart';
export 'material_radio/material_radio_group.dart';
export 'material_ripple/material_ripple.dart';
export 'material_select/activation_handler.dart';
export 'material_select/display_name.dart';
export 'material_select/dropdown_button.dart';
export 'material_select/material_dropdown_select.dart';
export 'material_select/material_dropdown_select_accessor.dart';
export 'material_select/material_select.dart';
export 'material_select/material_select_base.dart';
export 'material_select/material_select_dropdown_item.dart';
export 'material_select/material_select_item.dart';
export 'material_select/material_select_searchbox.dart';
export 'material_select/shift_click_selection.dart';
export 'material_slider/material_slider.dart';
export 'material_spinner/material_spinner.dart';
export 'material_stepper/common.dart';
export 'material_stepper/material_step.dart';
export 'material_stepper/material_stepper.dart';
export 'material_tab/fixed_material_tab_strip.dart';
export 'material_tab/material_tab.dart';
export 'material_tab/material_tab_panel.dart';
export 'material_tab/tab_button.dart';
export 'material_tab/tab_change_event.dart';
export 'material_tab/tab_mixin.dart';
export 'material_toggle/material_toggle.dart';
export 'material_tooltip/material_tooltip.dart';
export 'material_tooltip/module.dart';
export 'material_tree/material_tree.dart';
export 'material_yes_no_buttons/material_yes_no_buttons.dart';
export 'mixins/button_wrapper.dart';
export 'mixins/focusable_mixin.dart';
export 'mixins/has_tab_index.dart';
export 'mixins/highlight_assistant_mixin.dart';
export 'mixins/material_dropdown_base.dart';
export 'mixins/track_layout_changes.dart';
export 'model/date/date.dart';
export 'model/selection/select.dart';
export 'model/selection/selection_model.dart';
export 'model/selection/selection_options.dart';
export 'model/selection/string_selection_options.dart';
export 'model/ui/display_name.dart';
export 'model/ui/has_renderer.dart';
export 'model/ui/icon.dart';
export 'reorder_list/reorder_events.dart';
export 'reorder_list/reorder_list.dart';
export 'scorecard/scoreboard.dart';
export 'scorecard/scorecard.dart';
export 'stop_propagation/stop_propagation.dart';
export 'theme/dark_theme.dart';
export 'theme/module.dart';
export 'utils/async/async.dart';

/// A convenience list of all Directives exposed by this package.
@Deprecated('List the directives used by your app for smaller code size.')
const List<dynamic> materialDirectives = [
  AutoDismissDirective,
  AutoFocusDirective,
  ButtonDirective,
  CachingDeferredContentDirective,
  CheckNonNegativeValidator,
  ClickableTooltipTargetDirective,
  DarkThemeDirective,
  DateInputDirective,
  DateRangeEditorComponent,
  DateRangeInputComponent,
  DeferredContentDirective,
  displayNameRendererDirective,
  DropdownSelectValueAccessor,
  DropdownButtonComponent,
  DropdownMenuComponent,
  DynamicComponent,
  FixedMaterialTabStripComponent,
  FocusActivableItemDirective,
  FocusItemDirective,
  FocusListDirective,
  FocusableDirective,
  FocusTrapComponent,
  GlyphComponent,
  HighlightedTextComponent,
  HighlightedValueComponent,
  KeyboardOnlyFocusIndicatorDirective,
  LowerBoundValidator,
  MaterialAutoSuggestInputComponent,
  MaterialButtonComponent,
  MaterialCalendarPickerComponent,
  MaterialCheckboxComponent,
  MaterialChipComponent,
  MaterialChipsComponent,
  MaterialDatepickerComponent,
  MaterialDateRangePickerComponent,
  MaterialDateTimePickerComponent,
  MaterialDialogComponent,
  MaterialDropdownSelectComponent,
  MaterialExpansionPanel,
  MaterialExpansionPanelAutoDismiss,
  MaterialExpansionPanelSet,
  MaterialFabComponent,
  MaterialFabMenuComponent,
  MaterialIconComponent,
  MaterialIconTooltipComponent,
  MaterialInkTooltipComponent,
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MenuItemAffixListComponent,
  MenuItemGroupsComponent,
  MaterialListComponent,
  MaterialListItemComponent,
  MaterialMenuComponent,
  MaterialMonthPickerComponent,
  MaterialMultilineInputComponent,
  materialNumberInputDirectives,
  MaterialPaperTooltipComponent,
  MaterialPercentInputDirective,
  MaterialPersistentDrawerDirective,
  MaterialPopupComponent,
  MaterialProgressComponent,
  MaterialRadioComponent,
  MaterialRadioGroupComponent,
  MaterialRippleComponent,
  MaterialSelectComponent,
  MaterialSelectDropdownItemComponent,
  MaterialSelectItemComponent,
  MaterialSelectSearchboxComponent,
  MaterialSliderComponent,
  MaterialSpinnerComponent,
  MaterialStackableDrawerComponent,
  MaterialStepperBackButtonTextDirective,
  MaterialStepperComponent,
  MaterialTabComponent,
  MaterialTabPanelComponent,
  MaterialTimePickerComponent,
  MaterialTemporaryDrawerComponent,
  MaterialTreeComponent,
  MaterialTreeDropdownComponent,
  MaterialToggleComponent,
  MaterialTooltipDirective,
  MaterialTooltipSourceDirective,
  MaterialTooltipTargetDirective,
  MaterialYesNoButtonsComponent,
  MenuPopupComponent,
  MenuRootDirective,
  MultiDropdownSelectValueAccessor,
  ModalComponent,
  NgModel,
  PositiveNumValidator,
  PopupSourceDirective,
  ReorderItemDirective,
  ReorderListComponent,
  ScoreboardComponent,
  ScorecardComponent,
  StepDirective,
  StopPropagationDirective,
  SummaryDirective,
  TabButtonComponent,
  UpperBoundValidator,
];

/// A convenience list of all providers exposed by this package.
const List<dynamic> materialProviders = [
  datepickerBindings,
];
