// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components;

import 'package:angular2/angular2.dart' show Provider;
import 'src/all_components.dart';
export 'src/all_components.dart';

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
  InputTextModel,
  MaterialButtonComponent,
  MaterialCheckboxComponent,
  MaterialChipComponent,
  MaterialChipsComponent,
  MaterialExpansionPanel,
  MaterialExpansionPanelSet,
  MaterialFabComponent,
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MaterialProgressComponent,
  MaterialRadioComponent,
  MaterialRadioGroupComponent,
  MaterialRippleComponent,
  MaterialSpinnerComponent,
  MaterialTabComponent,
  MaterialTabPanelComponent,
  MaterialToggleComponent,
  MaterialYesNoButtonsComponent,
  MultilineMaterialInputComponent,
  ReorderItemDirective,
  ReorderListComponent,
  ScorecardComponent
];

/// A convenience list of all providers exposed by this package.
const List<List<Provider>> materialProviders = const <List<Provider>>[
  rippleBindings
];
