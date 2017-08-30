// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular_components;

import 'package:angular/angular.dart' show Provider;

import 'src/all_components.dart';

export 'src/all_components.dart';

/// A convenience list of all Directives exposed by this package.
const List<dynamic> materialDirectives = const [
  AutoDismissDirective,
  AutoFocusDirective,
  CachingDeferredContentDirective,
  ClickableTooltipTargetDirective,
  DarkThemeDirective,
  DeferredContentDirective,
  DisplayNameRendererDirective,
  FixedMaterialTabStripComponent,
  FocusActivableItemDirective,
  FocusItemDirective,
  FocusListDirective,
  FocusableDirective,
  FocusTrapComponent,
  GlyphComponent,
  MaterialButtonComponent,
  MaterialCheckboxComponent,
  MaterialChipComponent,
  MaterialChipsComponent,
  MaterialDialogComponent,
  MaterialDropdownSelectComponent,
  MaterialExpansionPanel,
  MaterialExpansionPanelSet,
  MaterialFabComponent,
  MaterialIconComponent,
  MaterialIconTooltipComponent,
  MaterialInkTooltipComponent,
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MaterialListComponent,
  MaterialListItemComponent,
  MaterialMultilineInputComponent,
  MaterialPaperTooltipComponent,
  MaterialPersistentDrawerDirective,
  MaterialTemporaryDrawerComponent,
  MaterialPopupComponent,
  MaterialProgressComponent,
  MaterialRadioComponent,
  MaterialRadioGroupComponent,
  MaterialRippleComponent,
  MaterialSelectComponent,
  MaterialSelectItemComponent,
  MaterialSelectSearchboxComponent,
  MaterialSpinnerComponent,
  MaterialTabComponent,
  MaterialTabPanelComponent,
  MaterialToggleComponent,
  MaterialTooltipDirective,
  MaterialTooltipSourceDirective,
  MaterialTooltipTargetDirective,
  MaterialYesNoButtonsComponent,
  ModalComponent,
  NgModel,
  PopupSourceDirective,
  ReorderItemDirective,
  ReorderListComponent,
  ScorecardComponent,
];

/// A convenience list of all providers exposed by this package.
const List<List<Provider>> materialProviders = const <List<Provider>>[
  popupBindings,
];
