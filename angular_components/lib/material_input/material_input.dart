// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/utils/angular/reference/reference.dart';

import 'base_material_input.dart';
import 'deferred_validator.dart';
import 'material_input_default_value_accessor.dart';
import 'material_input_multiline.dart';

export 'package:angular_forms/angular_forms.dart' show NgModel;

export 'base_material_input.dart' show ValidityCheck, CharacterCounter;
export 'material_input_default_value_accessor.dart';
export 'material_input_multiline.dart';

/// A list of all material input directives.
const materialInputDirectives = [
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MaterialInputBlurValueAccessor,
  MaterialInputChangeValueAccessor,
  MaterialMultilineInputComponent,
  NgModel
];

/// Key used in the Control's error map, when there is an error.
const String materialInputErrorKey = 'material-input-error';

/// `material-input` is a single- or multi-line text field where user can enter
/// input. It can optionally have a label.
/// NOTE: Clients must declare materialInputDirectives in their directives list
/// instead of MaterialInputComponent.
///
/// __Attributes:__
///
/// - `type` -- The type of the input. Defaults to "text". Other supported
///   values are "email", "password", "url", "number", "tel", and "search".
///   (Inputs of type "number" also use [materialNumberInputDirectives])
/// - `multiple` -- Whether the user can enter multiple values, separated by
///   commas. This attribute only applies when type = "email", otherwise it is
///   ignored.
/// - `role` -- The role attribute for the input element.
@Component(
  selector: 'material-input:not(material-input[multiline])',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    DeferredValidator,
    ExistingProvider.forToken(NG_VALIDATORS, DeferredValidator),
    ExistingProvider(ReferenceDirective, MaterialInputComponent),
    ExistingProvider(Focusable, MaterialInputComponent),
    ExistingProvider(HasDisabled, MaterialInputComponent),
    ExistingProvider(BaseMaterialInput, MaterialInputComponent),
  ],
  templateUrl: 'material_input.html',
  styleUrls: ['material_input.scss.css'],
  directives: [
    DefaultValueAccessor,
    FocusableDirective,
    MaterialIconComponent,
    NgFor,
    NgIf,
    NgModel,
    NgSwitch,
    NgSwitchWhen,
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialInputComponent extends BaseSingleLineInputComponent
    implements Focusable, ReferenceDirective, AfterViewInit, OnDestroy {
  @HostBinding('class')
  static const hostClass = 'themeable';

  @HostBinding('tabIndex')
  static const hostTabIndex = -1;

  MaterialInputComponent(
      @Attribute('type') String type,
      @Attribute('multiple') String multiple,
      @Self() @Optional() NgControl cd,
      ChangeDetectorRef changeDetector,
      DeferredValidator validator)
      : super(type, multiple, cd, changeDetector, validator);
}
