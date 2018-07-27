// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:quiver/strings.dart' show isNotEmpty;
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/angular/reference/reference.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

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
    Provider(NG_VALIDATORS, useExisting: DeferredValidator, multi: true),
    Provider(ReferenceDirective, useExisting: MaterialInputComponent),
    Provider(Focusable, useExisting: MaterialInputComponent),
    Provider(HasDisabled, useExisting: MaterialInputComponent),
    Provider(BaseMaterialInput, useExisting: MaterialInputComponent)
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
class MaterialInputComponent extends BaseMaterialInput
    implements Focusable, ReferenceDirective, AfterViewInit, OnDestroy {
  @HostBinding('class')
  static const hostClass = 'themeable';

  @HostBinding('tabIndex')
  static const hostTabIndex = -1;

  ChangeDetectorRef _changeDetector;

  /// TODO(google): The following value could be set in the base class, but
  /// there is currently no working way to set ViewChild values on the base
  /// class.
  @ViewChild(FocusableDirective)
  @override
  set focusable(Focusable value) {
    super.focusable = value;
  }

  @ViewChild('inputEl')
  ElementRef inputEl;

  @ViewChild('popupSourceEl')
  ElementRef popupSourceEl;

  /// Container element for popup positioning.
  @override
  ElementRef get elementRef => popupSourceEl;

  /// The underlying <input> element.
  ///
  /// If you find the need to use this element in application code, you
  /// may be building new functionality that all ACX users could benefit
  /// from! If that's the case, please consider contributing your changes
  /// back upstream. Feel free to contact acx-widgets@ for more guidance.
  @override
  ElementRef get inputRef => inputEl;

  /// Type of input.
  ///
  /// It can be one of the following:
  /// {"text", "email", "password", "url", "number", "tel", "search"}
  String type;

  /// Whether the user can enter multiple values, separated by commas.
  ///
  /// Only applies when type = "email", otherwise it is ignored.
  bool multiple = false;

  /// The role to assign to the inner input element.
  final String inputRole;
  final labelId = new SequentialIdGenerator.fromUUID().nextId();
  // Overriden to add a HostListener event.
  @HostListener('focus')
  @override
  void focus() => super.focus();

  bool get hasLeadingText => isNotEmpty(leadingText);
  String get leadingText => _leadingText;
  String _leadingText;

  /// Any text to show at the leading edge of the input -- e.g. a currency
  /// symbol or similar.
  @Input()
  set leadingText(String value) {
    _leadingText = value;
    // Possibly set by a directive and not a template. So default change
    // detection doesn't work without calling markForCheck.
    _changeDetector.markForCheck();
  }

  /// Any symbol to show at the leading edge of the input -- e.g. a URL link
  /// icon or similar.
  @Input()
  String leadingGlyph;
  bool get hasLeadingGlyph => isNotEmpty(leadingGlyph);

  String get trailingText => _trailingText;
  String _trailingText;
  bool get hasTrailingText => isNotEmpty(trailingText);

  /// Any text to show at the trailing edge of the input -- e.g. a currency
  /// symbol or similar.
  @Input()
  set trailingText(String value) {
    _trailingText = value;
    // Possibly set by a directive and not a template. So default change
    // detection doesn't work without calling markForCheck.
    _changeDetector.markForCheck();
  }

  /// Any symbol to show at the trailing edge of the input -- e.g. a URL link
  /// icon or similar.
  @Input()
  String trailingGlyph;
  bool get hasTrailingGlyph => isNotEmpty(trailingGlyph);

  /// Aria label used for the trailing glyph.
  @Input()
  String trailingGlyphAriaLabel;

  /// Aria label used for the leading glyph.
  @Input()
  String leadingGlyphAriaLabel;

  bool get rightAlign => _rightAlign;
  bool _rightAlign = false;

  /// Whether the input contents should be always right aligned.
  ///
  /// Default value is `false`.
  @Input()
  set rightAlign(bool value) {
    _rightAlign = value;
    // Possibly set by a directive and not a template. So default change
    // detection doesn't work without calling markForCheck.
    _changeDetector.markForCheck();
  }

  /// The ID of an element which should be assigned to the inner input element's
  /// aria-owns attribute.
  @Input()
  String inputAriaOwns;

  /// The ID of an element which should be assigned to the inner input element's
  /// aria-activedescendant attribute.
  @Input()
  String inputAriaActivedescendent;

  /// The value for the input element's aria-haspopup attribute, indicating that
  /// the element referred to by inputAriaOwns is expandable.
  ///
  /// If the element referred to by [inputAriaOwns] is expandable, this should
  /// be either "true" or the role of the owned element.
  @Input()
  String inputAriaHasPopup;

  /// Whether or not the expandable element referred to by [inputAriaOwns] is
  /// currently visible.
  @Input()
  bool inputAriaExpanded;

  /// The autocomplete method applied to the inner input element.
  ///
  /// This can be used in conjunction with [inputRole] values of "combobox" or
  /// "textbox". If this is "list" or "both", [inputAriaHasPopup] should be
  /// set to "true".
  @Input()
  String inputAriaAutocomplete;

  MaterialInputComponent(
      @Attribute('type') String type,
      @Attribute('multiple') String multiple,
      @Attribute('role') this.inputRole,
      @Self() @Optional() NgControl cd,
      this._changeDetector,
      DeferredValidator validator)
      : super(cd, _changeDetector, validator) {
    if (type == null) {
      this.type = 'text';
    } else if (const ['number', 'tel'].contains(type)) {
      // For number and telephone, the browser-default validation has to be
      // locale-aware and/or format-aware. Using 'text' here, so that we
      // don't use (broken) browser-default validation. Users can still
      // provide custom validation for these.
      this.type = 'text';
    } else {
      this.type = type;
    }
    this.multiple = attributeToBool(multiple);
  }

  bool get numeric => type == "number";

  @override
  bool get labelVisible => !(numeric && invalid) && super.labelVisible;

  @override
  void ngOnDestroy() {
    super.ngOnDestroy();
    inputEl = null;
    popupSourceEl = null;
  }
}
