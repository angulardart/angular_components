// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:quiver/strings.dart' show isNotEmpty;

import '../../utils/angular/properties/properties.dart';
import '../../utils/angular/reference/reference.dart';
import '../focus/focus.dart';
import '../glyph/glyph.dart';
import 'base_material_input.dart';
import 'deferred_validator.dart';
import 'material_input_default_value_accessor.dart';
import 'material_input_multiline.dart';

export 'package:angular_forms/angular_forms.dart' show NgModel;

export 'base_material_input.dart' show ValidityCheck, CharacterCounter;
export 'material_input_default_value_accessor.dart';
export 'material_input_multiline.dart';

/// A list of all material input directives.
const materialInputDirectives = const [
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MaterialInputBlurValueAccessor,
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
/// __Example usage:__
///
///     @Component(
///       selector: 'my-component',
///       template: '''
///         <material-input label="Your Name"></material-input>
///         <material-input multiline label="Enter multiple lines here">
///         </material-input>
///         <material-input [(ngModel)]="text"></material-input>
///       ''',
///       directives: [materialInputDirectives]
///     )
///     class MyComponent {}
///
/// __Attributes:__
///
/// - `type` -- The type of the input. Defaults to "text". Other supported
///   values are "email", "password", "url", "number", "tel", and "search".
///   (Inputs of type "number" also use [materialNumberInputDirectives])
/// - `multiple` -- Whether the user can enter multiple values, separated by
///   commas. This attribute only applies when type = "email", otherwise it is
///   ignored.
///
/// __Inputs:__
///
/// - `error` -- The error to be shown on the input. Has a higher precedent than
///   all other errors.
/// - `errorMsg` -- The error msg to be shown on the input if the max characters
///   are hit.
/// - `multiline: bool` -- Whether or not the input supports multiple lines.
/// - `label: String` -- The label to give the input. This is the default text
///   that shows up if nothing's entered into the text box.
/// - `floatingLabel: bool` -- Whether or not the label "floats". If false, the
///   label disappears when text is entered into the box. If true, it instead
///   "floats" up above the input.
/// - `hintText: String` -- The hint to be shown on the input. This text will
///    not be displayed if there is an error message on the input.
/// - `showHintOnlyOnFocus: bool` -- Whether or not the hint text will be
///    displayed when the input is not focused. Defaults to false.
/// - `required: bool` -- Whether or not the input is required. If there's no
///   input text, a required input will show a validation error when it's first
///   focused.
/// - `disabled: bool` -- Whether or not the input is disabled. Disabled inputs
///   are grayed out and have a dashed underline.
/// - `maxCount: int` -- The maximum length of the input.
/// - DEPRECATED: `checkValid: ValidityCheck` -- A custom validation function.
///   This function should take in the input text, and return a string
///   containing an error message, or `null` if the input is valid. Note: With
///   OnPush the validator will not be run on each digest. It is important for
///   the function to change whenever state of the validation function changes.
/// - `rightAlign: bool` -- Whether or not the input text should be
///   right-aligned. Defaults to false.
/// - `characterCounter: CharacterCounter` -- A custom character counter
///   function. Takes in the input text; returns how many characters the text
///   should be considered as.
/// - `leadingText: String` -- Any text to show at the leading edge of the
///   input -- e.g. a currency symbol or similar.
/// - `trailingText: String` -- Any text to show at the trailing edge of the
///   input -- e.g. a currency symbol or similar.
/// - `leadingGlyph: String` -- Any symbol to show at the leading edge of the
///   input -- e.g. a URL link icon or similar.
/// - `trailingGlyph: String` -- Any symbol to show at the trailing edge of the
///   input -- e.g. a URL link icon or similar.
/// - `displayBottomPanel: bool` -- Whether to display error, hint text, and
///   character counter panel.
/// - `rows` -- If the input is multiline, how many lines there are.
/// - `maxRows` -- If the input is multiline, the max number of lines.
///
/// __Outputs:__
///
/// - `inputKeyPress: String` -- Fired when the input text changes -- i.e., on
///   every keypress.
/// - `change: String` -- Publishes the input text whenever a conceptual "change
///   event" happens -- i.e., when the input loses focus, or when the user hits
///   enter.
/// - `focus: FocusEvent` -- Fired when the input is focused.
/// - `blur: FocusEvent` -- Fired when this input loses focus.
///
@Component(
    selector: 'material-input:not(material-input[multiline])',
    changeDetection: ChangeDetectionStrategy.OnPush,
    host: const {'class': 'themeable', '(focus)': 'focus()', 'tabIndex': '-1'},
    providers: const [
      DeferredValidator,
      const Provider(NG_VALIDATORS,
          useExisting: DeferredValidator, multi: true),
      const Provider(ReferenceDirective, useExisting: MaterialInputComponent),
      const Provider(Focusable, useExisting: MaterialInputComponent),
      const Provider(BaseMaterialInput, useExisting: MaterialInputComponent)
    ],
    templateUrl: 'material_input.html',
    styleUrls: const ['material_input.scss.css'],
    directives: const [
      DefaultValueAccessor,
      FocusableDirective,
      GlyphComponent,
      NgFor,
      NgIf,
      NgModel,
      NgSwitch,
      NgSwitchWhen,
    ],
    preserveWhitespace: false)
class MaterialInputComponent extends BaseMaterialInput
    implements Focusable, ReferenceDirective, AfterViewInit, OnDestroy {
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
  ElementRef get inputRef => inputEl;

  /// Type of input. It can be one of the following:
  /// {"text", "email", "password", "url", "number", "tel", "search"}
  String type;

  /// Whether the user can enter multiple values, separated by commas. Only
  /// applies when type = "email", otherwise it is ignored.
  bool multiple = false;

  /// Any persistent text to show before the input box.
  /// Available only for single line input.
  @Input()
  String leadingText;
  bool get hasLeadingText => isNotEmpty(leadingText);

  /// Any persistent glyph to show before the input box.
  /// Available only for single line input.
  @Input()
  String leadingGlyph;
  bool get hasLeadingGlyph => isNotEmpty(leadingGlyph);

  /// Any persistent text to show after the input box.
  /// Available only for single line input.
  @Input()
  String trailingText;
  bool get hasTrailingText => isNotEmpty(trailingText);

  /// Any persistent glyph to show after the input box.
  /// Available only for single line input.
  @Input()
  String trailingGlyph;
  bool get hasTrailingGlyph => isNotEmpty(trailingGlyph);

  /// Whether the input contents should be always right aligned.
  /// Default value is `false`.
  @Input()
  bool rightAlign = false;

  MaterialInputComponent(
      @Attribute('type') String type,
      @Attribute('multiple') String multiple,
      @Self() @Optional() NgControl cd,
      ChangeDetectorRef changeDetector,
      DeferredValidator validator)
      : super(cd, changeDetector, validator) {
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
    if (multiple != null) {
      this.multiple = getBool(multiple);
    }
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
