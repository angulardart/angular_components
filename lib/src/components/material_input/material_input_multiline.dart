// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../focus/focus.dart';
import '../../utils/angular/reference/reference.dart';
import 'package:angular2/angular2.dart';

import 'base_material_input.dart';
import 'deferred_validator.dart';

export 'base_material_input.dart' show ValidityCheck, CharacterCounter;

/// `material-input` is a multi-line text field where user can enter
/// input, and can optionally have a label.
///
/// __Example usage:__
///
///     @Component(
///       selector: 'my-component',
///       template: '''
///         <material-input multiline [(ngModel)]="text" label="Enter text">
///         </material-input>
///       ''',
///       directives: [materialInputDirectives]
///     )
///     class MyComponent {}
///
/// __Inputs:__
///
/// - `error` -- The error to be shown on the input. Has a higher precedent than
///   all other errors.
/// - `errorMsg` -- The error msg to be shown on the input if the max characters
///   are hit
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
/// - `checkValid: ValidityCheck` -- A custom validation function. This
///   function should take in the input text, and return a string containing an
///   error message, or `null` if the input is valid. Note: With OnPush the
///   validator will not be run on each digest. It is important for the function
///   to change whenever state of the validation function changes.
/// - `characterCounter: CharacterCounter` -- A custom character counter
///   function. Takes in the input text; returns how many characters the text
///   should be considered as.
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
    selector: 'material-input[multiline]',
    changeDetection: ChangeDetectionStrategy.OnPush,
    inputs: const [
      'error',
      'errorMsg',
      'label',
      'floatingLabel',
      'hint',
      'showHintOnlyOnFocus',
      'required',
      'requiredErrorMsg',
      'disabled',
      'maxCount',
      'checkValid',
      'characterCounter',
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
      const Provider(ReferenceDirective,
          useExisting: MaterialMultilineInputComponent),
      const Provider(Focusable, useExisting: MaterialMultilineInputComponent),
      const Provider(BaseMaterialInput,
          useExisting: MaterialMultilineInputComponent)
    ],
    templateUrl: 'material_input_multiline.html',
    styleUrls: const ['material_input.scss.css'],
    directives: const [
      DefaultValueAccessor,
      FocusableDirective,
      NgFor,
      NgIf,
      NgModel,
      NgSwitch,
      NgSwitchWhen,
    ],
    preserveWhitespace: false)
class MaterialMultilineInputComponent extends BaseMaterialInput
    implements ReferenceDirective, AfterViewInit, OnDestroy {
  @ViewChild('textareaEl')
  ElementRef textareaEl;

  /// The underlying <textarea> element.
  ///
  /// If you find the need to use this element in application code, you
  /// may be building new functionality that all ACX users could benefit
  /// from! If that's the case, please consider contributing your changes
  /// back upstream. Feel free to contact acx-widgets@ for more guidance.
  ElementRef get inputRef => textareaEl;

  // This list is used to size the multiline input.
  List<String> _heightForTextArea = new List();

  /// The initial/minimum number of rows for multiline input.
  /// Default value is 1.
  int _rows = 1;

  /// The maximum number of rows for multiline input to grow before it scrolls.
  /// 0 means no maximum. Default Value is 0.
  int _maxRows = 0;

  MaterialMultilineInputComponent(@Self() @Optional() NgControl cd,
      ChangeDetectorRef changeDetector, DeferredValidator validator)
      : super(cd, changeDetector, validator);

  /// TODO(google): The following values could be set in the base class, but
  /// there is currently no working way to set ViewChild values on the base
  /// class.
  @ViewChild(FocusableDirective)
  @override
  set focusable(Focusable value) {
    super.focusable = value;
  }

  @ViewChild('popupSourceEl')
  ElementRef popupSourceEl;

  /// Container element for popup positioning.
  @override
  ElementRef get elementRef => popupSourceEl;

  List<String> get heightForTextbox {
    List<String> tokens = hasVisibleText ? inputText.split('\n') : const [''];

    // Enforce the min(default) and max heights for a multiline input.
    if (rows > 0 && tokens.length < rows) {
      // Set the min/default height.
      _heightForTextArea.length = rows;
    } else if (maxRows > 0 && tokens.length > maxRows) {
      // Set the max height.
      _heightForTextArea.length = maxRows;
    } else {
      // Let the textarea grow without bounds.
      _heightForTextArea.length = tokens.length;
    }
    return _heightForTextArea;
  }

  int get rows => _rows;

  set rows(dynamic value) {
    if (value is int) {
      _rows = value;
    } else if (value is String) {
      _rows = int.parse(value);
    }
  }

  int get maxRows => _maxRows;

  set maxRows(dynamic value) {
    if (value is int) {
      _maxRows = value;
    } else if (value is String) {
      _maxRows = int.parse(value);
    }
  }

  @override
  void ngOnDestroy() {
    super.ngOnDestroy();
    textareaEl = null;
    popupSourceEl = null;
  }
}
