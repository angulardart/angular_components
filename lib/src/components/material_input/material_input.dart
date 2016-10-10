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

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' show isEmpty, isNotEmpty;

import '../focus/focus.dart';
import '../glyph/glyph.dart';
import '../../model/observable/observable.dart';
import '../../utils/angular/reference/reference.dart';
import '../../utils/async/async.dart';
import '../../utils/disposer/disposer.dart';

import 'base_material_input.dart';
import 'deferred_validator.dart';
import 'material_input_default_value_accessor.dart';
import 'material_input_multiline.dart';

export 'base_material_input.dart' show ValidityCheck, CharacterCounter;
export 'material_input_default_value_accessor.dart';
export 'material_input_multiline.dart';

/// A list of all material input directives.
const materialInputDirectives = const [
  MaterialInputComponent,
  MaterialInputDefaultValueAccessor,
  MultilineMaterialInputComponent,
  InputTextModel
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
///     @Component({
///       selector: 'my-component',
///       template: '''
///         <material-input label="Your Name"></material-input>
///         <material-input multiline label="Enter multiple lines here">
///         </material-input>
///         <material-input [(inputText)]="text"></material-input>
///       ''',
///       directives: [materialInputDirectives]
///     })
///     class MyComponent {}
///
/// __Attributes:__
///
/// - `type` -- The type of the input. Defaults to "text". Other supported
///   values are "email", "password", "url", "number", "tel", and "search".
///   (Inputs of type "number" also use [MaterialNumberInputValidatorDirective])
///
/// __Inputs:__
///
/// - `error` -- The error to be shown on the input. Has a higher precedent than
///   all other errors.
/// - `errorMsg` -- The error msg to be shown on the input if the max characters
///   are hit or the msg for an invalid number in the case of type = "number"
/// - `multiline: bool` -- Whether or not the input supports multiple lines.
/// - `label: String` -- The label to give the input. This is the default text
///   that shows up if nothing's entered into the text box.
/// - `floatingLabel: bool` -- Whether or not the label "floats". If false, the
///   label disappears when text is entered into the box. If true, it instead
///   "floats" up above the input.
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
/// - `displayBottomPanel: bool` -- Whether to display error and character
///    counter panel
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
    inputs: const [
      'error',
      'errorMsg',
      'label',
      'floatingLabel',
      'required',
      'requiredErrorMsg',
      'disabled',
      'maxCount',
      // Deprecated: Use Angular2 Forms API instead.
      'checkValid',
      'rightAlign',
      'characterCounter',
      'leadingText',
      'trailingText',
      'leadingGlyph',
      'trailingGlyph',
      'displayBottomPanel',
      'rows',
      'maxRows',
    ],
    outputs: const [
      'onKeypress: inputKeyPress',
      'onChange: change',
      'onFocus: focus',
      'onBlur: blur',
    ],
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
    ])
class MaterialInputComponent extends BaseMaterialInput
    implements Focusable, ReferenceDirective, AfterViewInit, OnDestroy {
  /// TODO(google): The following value could be set in the base class, but
  /// there is currently no working way to set ViewChild values on the base
  /// class.
  @ViewChild(FocusableDirective)
  set focusable(FocusableDirective value) {
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

  /// Any persistent text to show before the input box.
  /// Available only for single line input.
  String leadingText;
  bool get hasLeadingText => isNotEmpty(leadingText);

  /// Any persistent glyph to show before the input box.
  /// Available only for single line input.
  String leadingGlyph;
  bool get hasLeadingGlyph => isNotEmpty(leadingGlyph);

  /// Any persistent text to show after the input box.
  /// Available only for single line input.
  String trailingText;
  bool get hasTrailingText => isNotEmpty(trailingText);

  /// Any persistent glyph to show after the input box.
  /// Available only for single line input.
  String trailingGlyph;
  bool get hasTrailingGlyph => isNotEmpty(trailingGlyph);

  /// Whether the input contents should be always right aligned.
  /// Default value is `false`.
  bool rightAlign = false;

  MaterialInputComponent(
      @Attribute('type') String type,
      @Self() @Optional() NgControl cd,
      NgZone zone,
      ChangeDetectorRef changeDetector,
      DeferredValidator validator)
      : super(cd, zone, changeDetector, validator) {
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

/// A default locale-aware validator for number inputs.
///
/// __Example usage:__
///     <material-input floatingLabel
///                     label="Type positive numbers from 10 to 99999"
///                     type="number"
///                     [(numericValue)]="numericValue"
///                     [checkInteger]="true"
///                     [checkPositive]="true"
///                     [lowerBound]="10"
///                     [upperBound]="99999">
///     </material-input>
///
/// __Inputs:__
///   - `numericValue: num` -- The initial value of the number input.
///   - `checkPositive: bool`-- Whether to check if the input is positive.
///     Default to false (i.e. won't check if the input is positive).
///   - `lowerBound: num`-- Check if the input is not lower than the bound. If
///     the property is not set, the check will be skip.
///   - `upperBound: num`-- Check if the input is not larger than the bound. If
///     the property is not set, the check will be skip.
///
/// __Outputs:__
///   - `numericValue: num` -- Fired when the value of input changes.
///
@Directive(selector: 'material-input[type=number]', inputs: const [
  'numericValue',
  'checkInteger',
  'checkPositive',
  'lowerBound',
  'upperBound',
  'errorMsg',
], outputs: const [
  'numericValueChange'
])
class MaterialNumberInputValidatorDirective implements OnDestroy {
  final NumberFormat _numberFormat;
  final MaterialInputComponent _input;
  StreamSubscription _inputTextChangeSubscription;
  NumberValidator _validator;

  MaterialNumberInputValidatorDirective(this._input)
      : _numberFormat = new NumberFormat.decimalPattern(Intl.defaultLocale) {
    _validator = new NumberValidator(false, false, null, null, _input.errorMsg);
    _input.checkValid = _validator;
    _inputTextChangeSubscription = _input.onKeypress.listen((inputText) {
      numericValue = _parseNumericValue(inputText);
    });
  }

  set checkInteger(bool isInteger) {
    _validator = new NumberValidator(isInteger, _validator._checkPositive,
        _validator._lowerBound, _validator._upperBound, _validator._errorMsg);
    _input.checkValid = _validator;
  }

  set checkPositive(bool isNonNegative) {
    _validator = new NumberValidator(_validator._checkInteger, isNonNegative,
        _validator._lowerBound, _validator._upperBound, _validator._errorMsg);
    _input.checkValid = _validator;
  }

  set lowerBound(num lowerBound) {
    _validator = new NumberValidator(
        _validator._checkInteger,
        _validator._checkPositive,
        lowerBound,
        _validator._upperBound,
        _validator._errorMsg);
    _input.checkValid = _validator;
  }

  set upperBound(num upperBound) {
    _validator = new NumberValidator(
        _validator._checkInteger,
        _validator._checkPositive,
        _validator._lowerBound,
        upperBound,
        _validator._errorMsg);
    _input.checkValid = _validator;
  }

  set errorMsg(String message) {
    _validator = new NumberValidator(
        _validator._checkInteger,
        _validator._checkPositive,
        _validator._lowerBound,
        _validator._upperBound,
        message);
    _input.checkValid = _validator;
  }

  final _numericValueController =
      new LazyStreamController<num>.broadcast(sync: true);
  Stream<num> get numericValueChange => _numericValueController.stream;
  num _numericValue;
  num get numericValue => _numericValue;
  set numericValue(num numericValue) {
    if (_numericValue != numericValue) {
      _numericValue = numericValue;
      _numericValueController.add(_numericValue);
      if (_parseNumericValue(_input.inputText) != _numericValue) {
        // If the numeric value of the current input text doesn't equal to the
        // new numeric value, update the input text accordingly.
        _input.inputText =
            _numericValue == null ? '' : _numberFormat.format(_numericValue);
      }
    }
  }

  // Parses numeric value from the given input text. Returns null if it is not
  // parsable.
  num _parseNumericValue(String inputText) {
    try {
      return _numberFormat.parse(inputText);
    } on FormatException {
      return null;
    }
  }

  @override
  void ngOnDestroy() {
    _inputTextChangeSubscription.cancel();
  }
}

/// A pure validator function used to validate a number input.
// TODO(google): Move this to forms validation when input is using a control
// natively.
class NumberValidator {
  final NumberFormat _numberFormat =
      new NumberFormat.decimalPattern(Intl.defaultLocale);
  final bool _checkInteger;
  final bool _checkPositive;
  final num _lowerBound;
  final num _upperBound;
  final String _errorMsg;

  NumberValidator(this._checkInteger, this._checkPositive, this._lowerBound,
      this._upperBound, this._errorMsg);

  // Parses numeric value from the given input text. Returns null if it is not
  // parsable.
  num _parseNumericValue(String inputText) {
    try {
      return _numberFormat.parse(inputText);
    } on FormatException {
      return null;
    }
  }

  String call(String inputText) {
    if (inputText == null || inputText.isEmpty) {
      return null;
    }
    var number = _parseNumericValue(inputText);
    if (number == null) {
      return _errorMsg ?? inputIsNotNumberMsg();
    }
    if (_checkInteger &&
        inputText.contains(_numberFormat.symbols.DECIMAL_SEP)) {
      return _errorMsg ?? numberIsNotIntegerMsg();
    }
    if (_checkPositive && number <= 0) {
      return _errorMsg ?? numberIsNotPositiveMsg();
    }
    if (_lowerBound != null && number < _lowerBound) {
      return _errorMsg ?? numberIsTooSmallMsg(_lowerBound);
    }
    if (_upperBound != null && number > _upperBound) {
      return _errorMsg ?? numberIsTooLargeMsg(_upperBound);
    }
    return null;
  }

  static String inputIsNotNumberMsg() => Intl.message('Enter a number',
      name: 'inputIsNotNumberMsg',
      desc: 'Error message when input is not a number.',
      meaning: 'Error message when input is not a number.');

  static String numberIsNotIntegerMsg() => Intl.message('Enter an integer',
      name: 'numberIsNotIntegerMsg',
      desc: 'Error message when input number is not an integer.',
      meaning: 'Error message when input number is not an integer.');

  static String numberIsNotPositiveMsg() =>
      Intl.message('Enter a number greater than 0',
          name: 'numberIsNotPositiveMsg',
          desc: 'Error message when input number is not positive.');

  static String numberIsTooSmallMsg(num _lowerBound) =>
      Intl.message('Enter a number $_lowerBound or greater',
          name: 'numberIsTooSmallMsg',
          args: [_lowerBound],
          desc: 'Error message when input number is too small.',
          examples: const {'_lowerBound': 42});

  static String numberIsTooLargeMsg(num _upperBound) =>
      Intl.message('Enter a number $_upperBound or smaller',
          name: 'numberIsTooLargeMsg',
          args: [_upperBound],
          desc: 'Error message when number input is too large.',
          examples: const {'_upperBound': 42});
}

/// A default directive for URL inputs.
///
/// NOTE: The directive verifies if the input text is a valid URL
///       (only no protocol, http:// or https:// are acceptable).
///
/// __Example usage:__
///     <material-input type="url"
///                     (urlValueChange)="urlValue=$event">
///     </material-input>
///
@Directive(selector: 'material-input[type=url]', providers: const [
  DeferredValidator,
  const Provider(NG_VALIDATORS, useExisting: DeferredValidator, multi: true)
])
class MaterialUrlInputDirective implements Validator, OnDestroy {
  static final String _defaultProtocol = 'http://';

  /// Empty url optional - still valid.
  static final Uri _emptyUri = Uri.parse("");

  final _disposer = new Disposer.oneShot();

  /// Emits events when the value of URL input changes.
  final ObservableReference<Uri> _uriValue = new ObservableReference<Uri>(null);
  Uri get uriValue => _uriValue.value;
  String get urlValue => _uriValue.value?.toString();

  /// Fires event when the value of URL input changes. If protocol is absent in
  /// the input text, 'http://' will be prepended.
  @Output()
  Stream<String> get urlValueChange =>
      _uriValue.stream.map((uri) => uri?.toString());

  MaterialUrlInputDirective(DeferredValidator validator,
      @Host() MaterialInputComponent materialInput) {
    validator.add(this);
    materialInput.useNativeValidation = false;
    _disposer.addFunction(() {
      validator.remove(this);
    });
  }

  @override
  Map<String, dynamic> validate(AbstractControl c) {
    return _updateValueAndValidation(c);
  }

  /// Performs validation.
  ///
  /// Required for [DeferredValidator] API.
  Map<String, dynamic> call(AbstractControl c) => validate(c);

  /// Validates url input.
  ///
  /// Valid urls consist of http or https protocol (or no protocol,
  /// [_defaultProtocol] is prepended in that case) and at least a valid host.
  /// Will return null if the url is invalid.
  Uri _validateUrl(String inputText) {
    if (isEmpty(inputText)) return _emptyUri;
    Uri uri = _tryParse(inputText);

    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      // No protocol://, prepend with [_defaultProtocol].
      uri = _tryParse(_defaultProtocol + inputText);
    }

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        isEmpty(uri.host)) {
      return null;
    }
    return uri;
  }

  Uri _tryParse(String inputText) {
    try {
      return Uri.parse(inputText);
    } on FormatException {
      return null;
    }
  }

  /// Validates the input, returns error dictionary or null when there are no
  /// errors. Updates the [_uriValue] observable as well.
  Map<String, dynamic> _updateValueAndValidation(AbstractControl c) {
    final uri = _validateUrl(c.value);
    _uriValue.value = uri;
    if (uri == null) {
      return {materialInputErrorKey: _invalidUrlMsg};
    } else {
      return null;
    }
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  String get _invalidUrlMsg => Intl.message('Please enter a URL.',
      name: '_invalidUrlMsg',
      desc: "Error message when the user specified a value "
          "which doesn't look like a URL.");
}
