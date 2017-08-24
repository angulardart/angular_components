// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../utils/angular/properties/properties.dart';
import '../../utils/angular/reference/reference.dart';
import '../../utils/browser/dom_service/angular_2.dart';
import '../focus/focus.dart';
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
  host: const {'class': 'themeable', '(focus)': 'focus()', 'tabIndex': '-1'},
  providers: const [
    DeferredValidator,
    const Provider(NG_VALIDATORS, useExisting: DeferredValidator, multi: true),
    const Provider(ReferenceDirective,
        useExisting: MaterialMultilineInputComponent),
    const Provider(Focusable, useExisting: MaterialMultilineInputComponent),
    const Provider(BaseMaterialInput,
        useExisting: MaterialMultilineInputComponent)
  ],
  templateUrl: 'material_input_multiline.html',
  styleUrls: const [
    'material_input.scss.css',
    'material_input_multiline.scss.css'
  ],
  directives: const [
    DefaultValueAccessor,
    FocusableDirective,
    NgFor,
    NgIf,
    NgModel,
    NgSwitch,
    NgSwitchWhen,
  ],
  preserveWhitespace: false,
)
class MaterialMultilineInputComponent extends BaseMaterialInput
    implements ReferenceDirective, AfterViewInit, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;

  @ViewChild('textareaEl')
  ElementRef textareaEl;

  /// The underlying <textarea> element.
  ///
  /// If you find the need to use this element in application code, you
  /// may be building new functionality that all ACX users could benefit
  /// from! If that's the case, please consider contributing your changes
  /// back upstream. Feel free to contact acx-widgets@ for more guidance.
  ElementRef get inputRef => textareaEl;

  /// The initial/minimum number of rows for multiline input.
  /// Default value is 1.
  int _rows = 1;

  /// The maximum number of rows for multiline input to grow before it scrolls.
  /// 0 means no maximum. Default Value is 0.
  int _maxRows = 0;

  /// Line height of the textarea. This is updated at run time.
  int _inputLineHeight = 16;

  MaterialMultilineInputComponent(
      @Self() @Optional() NgControl cd,
      ChangeDetectorRef changeDetector,
      DeferredValidator validator,
      this._domService)
      : _changeDetector = changeDetector,
        super(cd, changeDetector, validator);

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

  /// Text used to size the multiline textarea.
  String get mirrorText => (inputText ?? '') + '\n';

  @ViewChild('lineHeightMeasure')
  set lineHeightMeasure(ElementRef value) {
    // There's currently no strong use case of line height changing after it's
    // been measured. So we only measure it once when the view is rendered.
    _domService.scheduleRead(() {
      var isDestroyed = textareaEl == null;
      if (isDestroyed) return;

      var height = (value.nativeElement as Element).clientHeight;
      if (height != 0) {
        _inputLineHeight = height;
        _changeDetector
          ..markForCheck()
          // TODO(google): remove after the bug is fixed.
          ..detectChanges();
      }
    });
  }

  int get minInputHeight => rows * _inputLineHeight;
  int get maxInputHeight => _maxRows > 0 ? _maxRows * _inputLineHeight : null;

  int get rows => _rows;

  @Input()
  set rows(dynamic value) {
    _rows = getInt(value);
    _changeDetector.markForCheck();
  }

  int get maxRows => _maxRows;

  @Input()
  set maxRows(dynamic value) {
    _maxRows = getInt(value);
    _changeDetector.markForCheck();
  }

  @override
  void ngOnDestroy() {
    super.ngOnDestroy();
    textareaEl = null;
    popupSourceEl = null;
  }
}
