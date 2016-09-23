// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library angular2_material;

import 'package:angular2/angular2.dart' show Provider;

import 'src/components/annotations/rtl_annotation.dart';
export 'src/components/annotations/rtl_annotation.dart';
import 'src/components/button_decorator/button_decorator.dart';
export 'src/components/button_decorator/button_decorator.dart';
import 'src/components/content/deferred_content.dart';
export 'src/components/content/deferred_content.dart';
import 'src/components/content/deferred_content_aware.dart';
export 'src/components/content/deferred_content_aware.dart';
import 'src/components/focus/focus.dart';
export 'src/components/focus/focus.dart';
import 'src/components/focus/focus_activable_item.dart';
export 'src/components/focus/focus_activable_item.dart';
import 'src/components/focus/focus_item.dart';
export 'src/components/focus/focus_item.dart';
import 'src/components/focus/focus_list.dart';
export 'src/components/focus/focus_list.dart';
import 'src/components/focus/keyboard_only_focus_indicator.dart';
export 'src/components/focus/keyboard_only_focus_indicator.dart';
import 'src/components/glyph/glyph.dart';
export 'src/components/glyph/glyph.dart';
import 'src/components/material_button/material_button.dart';
export 'src/components/material_button/material_button.dart';
import 'src/components/material_button/material_button_base.dart';
export 'src/components/material_button/material_button_base.dart';
import 'src/components/material_button/material_fab.dart';
export 'src/components/material_button/material_fab.dart';
import 'src/components/material_checkbox/material_checkbox.dart'
    show MaterialCheckboxComponent;
export 'src/components/material_checkbox/material_checkbox.dart'
    show MaterialCheckboxComponent;
import 'src/components/material_chips/material_chip.dart';
export 'src/components/material_chips/material_chip.dart';
import 'src/components/material_chips/material_chips.dart';
export 'src/components/material_chips/material_chips.dart';
import 'src/components/material_expansionpanel/material_expansionpanel.dart';
export 'src/components/material_expansionpanel/material_expansionpanel.dart';
import 'src/components/material_expansionpanel/material_expansionpanel_set.dart';
export 'src/components/material_expansionpanel/material_expansionpanel_set.dart';
import 'src/components/material_progress/material_progress.dart';
export 'src/components/material_progress/material_progress.dart';
import 'src/components/material_radio/material_radio.dart';
export 'src/components/material_radio/material_radio.dart';
import 'src/components/material_radio/material_radio_group.dart';
export 'src/components/material_radio/material_radio_group.dart';
import 'src/components/material_ripple/material_ripple.dart';
export 'src/components/material_ripple/material_ripple.dart';
import 'src/components/material_ripple/module.dart';
export 'src/components/material_ripple/module.dart';
import 'src/components/material_ripple/src/wave.dart';
export 'src/components/material_ripple/src/wave.dart';
import 'src/components/material_spinner/material_spinner.dart';
export 'src/components/material_spinner/material_spinner.dart';
import 'src/components/material_tab/fixed_material_tab_strip.dart';
export 'src/components/material_tab/fixed_material_tab_strip.dart';
import 'src/components/material_tab/material_tab.dart';
export 'src/components/material_tab/material_tab.dart';
import 'src/components/material_tab/material_tab_panel.dart';
export 'src/components/material_tab/material_tab_panel.dart';
import 'src/components/material_tab/src/navigation_bar.dart';
export 'src/components/material_tab/src/navigation_bar.dart';
import 'src/components/material_tab/src/tab_button.dart';
export 'src/components/material_tab/src/tab_button.dart';
import 'src/components/material_tab/src/tab_mixin.dart';
export 'src/components/material_tab/src/tab_mixin.dart';
import 'src/components/material_tab/tab_change_event.dart';
export 'src/components/material_tab/tab_change_event.dart';
import 'src/components/material_toggle/material_toggle.dart';
export 'src/components/material_toggle/material_toggle.dart';
import 'src/components/material_yes_no_buttons/material_yes_no_buttons.dart';
export 'src/components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'src/components/reorder_list/reorder_list.dart';
export 'src/components/reorder_list/reorder_list.dart';
import 'src/components/scorecard/scoreboard.dart';
export 'src/components/scorecard/scoreboard.dart';
import 'src/components/scorecard/scorecard.dart';
export 'src/components/scorecard/scorecard.dart';
import 'src/components/scorecard/src/scorecard_bar.dart';
export 'src/components/scorecard/src/scorecard_bar.dart';
import 'src/components/theme/dark_theme.dart';
export 'src/components/theme/dark_theme.dart';
import 'src/components/theme/module.dart';
export 'src/components/theme/module.dart';

/// A convenience list of all Directives exposed by this package.
const List<Type> materialDirectives = const [
  CachingDeferredContentDirective,
  DeferredContentDirective,
  FixedMaterialTabStripComponent,
  FocusActivableItemDirective,
  FocusItemDirective,
  FocusListDirective,
  FocusableDirective,
  GlyphComponent,
  MaterialButtonComponent,
  MaterialCheckboxComponent,
  MaterialChipComponent,
  MaterialChipsComponent,
  MaterialExpansionPanel,
  MaterialExpansionPanelSet,
  MaterialFabComponent,
  MaterialProgressComponent,
  MaterialRadioComponent,
  MaterialRadioGroupComponent,
  MaterialRippleComponent,
  MaterialSpinnerComponent,
  MaterialTabComponent,
  MaterialTabPanelComponent,
  MaterialToggleComponent,
  MaterialYesNoButtonsComponent,
  ReorderItemDirective,
  ReorderListComponent,
  ScorecardComponent
];

/// A convenience list of all bindings exposed by this package.
const List<List<Provider>> materialBindings = const <List<Provider>>[
  rippleBindings
];

