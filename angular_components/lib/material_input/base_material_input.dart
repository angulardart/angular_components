// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' show isEmpty, isNotEmpty;
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/forms/error_renderer.dart' show ErrorFn;
import 'package:angular_components/mixins/focusable_mixin.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'deferred_validator.dart';

export 'package:angular_components/forms/error_renderer.dart' show ErrorFn;

/// Key used in the Control's error map, when there is an error.
const String materialInputErrorKey = 'material-input-error';

typedef String ValidityCheck(String inputText);
typedef int CharacterCounter(String inputText);

/// Represents which label should be shown in the BottomPanel
enum BottomPanelState {
  empty,
  error,
  hint,
}

/// Base class for behavior that is shared between material input components.
class BaseMaterialInput extends FocusableMixin
    implements HasDisabled, Focusable, AfterViewInit, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final _disposer = Disposer.oneShot();

  /// Template accessors for the BottomPanelState
  final emptyState = BottomPanelState.empty;
  final errorState = BottomPanelState.error;
  final hintState = BottomPanelState.hint;

  bool _invalid = false;
  // Error message coming from the browser.
  String _validationMessage;
  // Error message resulting from local validation.
  String _localValidationMessage;

  bool _required = false;
  bool _showHintOnlyOnFocus = false;
  bool _disabled = false;

  /// Enable native validation (e.g. for type="url").
  bool useNativeValidation = true;

  bool _pristine = true;
  NgControl _cd;

  /// Controls what section of the BottomPanel is displayed.
  BottomPanelState bottomPanelState = BottomPanelState.empty;

  String _errorMsg;
  String get errorMsg => _errorMsg;

  /// The error msg to be shown on the input if it has more than [maxCount]
  /// characters.
  @Input()
  set errorMsg(String msg) {
    _errorMsg = msg;
    updateBottomPanelState();
  }

  String _error;
  String get error => _error;

  /// Error to be displayed.
  ///
  /// Higher precendent than all other errors which may be on this input.
  @Input()
  set error(String error) {
    _error = error;
    updateBottomPanelState();
  }

  /// The label for this input.
  ///
  /// This is the default text that shows up if nothing's entered into the text
  /// box. It disappears when user inputs text.
  @Input()
  String label;

  /// The label to be used for assistive technologies.
  ///
  /// Use [label] instead of this when a visible label is desired.
  @Input()
  String inputAriaLabel;

  String _hintText;
  String get hintText => _hintText;

  /// The hint to be shown on the input.
  ///
  /// This text will not be displayed if there is an error message on the input.
  @Input()
  set hintText(value) {
    _hintText = value;
    updateBottomPanelState();
  }

  String _requiredErrorMsg = defaultEmptyMessage;
  String get requiredErrorMsg => _requiredErrorMsg;

  /// Custom error message to show when the field is required and blank.
  @Input()
  set requiredErrorMsg(String value) {
    _requiredErrorMsg = value;
    if (_cd?.control != null) {
      // Validator was changed. Rerun validation as required message may
      // have changed.
      _cd.control.updateValueAndValidity();
    }
  }

  /// Maximum allowed characters for character counting input box.
  ///
  /// Character count always is displayed when the value is non-null.
  @Input()
  int maxCount;

  ValidityCheck _checkValid;
  ValidityCheck get checkValid => _checkValid;
  @Deprecated('Use angular2 forms API instead')
  @Input()
  set checkValid(ValidityCheck validFn) {
    if (validFn == _checkValid) return; // Identical doesn't work on functions
    _checkValid = validFn;
    _changeDetector.markForCheck();
    if (_cd?.control != null) {
      // Validator was changed. Rerun validation.
      _cd.control.updateValueAndValidity();
    }
    updateBottomPanelState();
  }

  int _inputTextLength = 0;
  int get inputTextLength => _inputTextLength;

  String _inputText = '';
  String get inputText => _inputText;
  set inputText(String value) {
    _inputText = value;
    updateInputTextLength();
    _changeDetector.markForCheck();
  }

  /// Whether to display error, hint text, and character counter panel.
  @Input()
  bool displayBottomPanel = true;

  /// A function which takes in an error map, and returns another map, replacing
  /// errors with human readable text.
  ///
  /// WARNING: The API of this mechanism is still in flux and there will be
  /// breaking changes. Be careful relying on it.
  @Input()
  ErrorFn errorRenderer;

  CharacterCounter _characterCounter;

  /// A custom character counter function.
  ///
  /// Takes in the input text; returns how many characters the text should be
  /// considered as.
  @Input()
  set characterCounter(CharacterCounter counterFn) {
    _characterCounter = counterFn;
    updateInputTextLength();
  }

  void updateInputTextLength() {
    if (_inputText == null) {
      _inputTextLength = 0;
    } else {
      _inputTextLength = _characterCounter != null
          ? _characterCounter(_inputText)
          : _inputText.length;
    }
  }

  /// Display character count even if maxCount is null.
  @Input()
  bool showCharacterCount = false;

  BaseMaterialInput(@Self() @Optional() this._cd, this._changeDetector,
      DeferredValidator validator) {
    var call = this.call;
    validator.add(call);
    _disposer.addFunction(() {
      // Kill the validator's handle on the input so that it can be GC'ed
      validator.remove(call);
    });
  }

  @override
  void ngAfterViewInit() {
    if (_cd?.control != null) {
      _disposer.addStreamSubscription(_cd.control.valueChanges.listen((value) {
        _changeDetector.markForCheck();
      }));
      _disposer
          .addStreamSubscription(_cd.control.statusChanges.listen((status) {
        _changeDetector.markForCheck();
        updateBottomPanelState();
      }));
    }
  }

  // Angular2 Forms API methods.
  // Act as forms validator (previously NgValidator)
  Map<String, dynamic> call(AbstractControl _) {
    return _isLocallyValid(true);
  }

  Map<String, dynamic> _isLocallyValid(bool fromFormsApi) {
    // Do local validation here. This simply counts as ONE OF the Validators
    // attached to this component. If there is a Control then it will use this
    // one and maybe others.

    // In forms API we always have an error but it is not always shown,
    // for non-forms input we preserve the previous functionality.
    // TODO(google): Cleanup when using forms API everywhere.
    if (required && isEmpty(inputText) && (fromFormsApi || !_pristine)) {
      _localValidationMessage = requiredErrorMsg;
      return {materialInputErrorKey: _localValidationMessage};
    }
    if (maxCount != null && inputTextLength > maxCount) {
      _localValidationMessage = _errorMsg;
      return {materialInputErrorKey: _localValidationMessage};
    }
    if (checkValid != null) {
      var _checkValidMessage = checkValid(inputText);
      if (_checkValidMessage != null) {
        _localValidationMessage = _checkValidMessage;
        return {materialInputErrorKey: _localValidationMessage};
      } // fallthrough
    }
    if (_invalid && useNativeValidation) {
      _localValidationMessage = _validationMessage;
      return {materialInputErrorKey: _localValidationMessage};
    }

    _localValidationMessage = null;
    return null;
  }

  /// Whether or not the label "floats".
  ///
  /// If false, the label disappears when text is entered into the box. If true,
  /// it instead "floats" up above the input.
  @Input()
  bool floatingLabel = false;

  bool get disabled => _disabled;

  /// Whether or not this input is disabled (readonly input.)
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;
    _changeDetector.markForCheck();
  }

  bool get showHintOnlyOnFocus => _showHintOnlyOnFocus;

  /// Whether or not the hint text will be displayed when the input is not
  /// focused.
  ///
  /// Defaults to false.
  @Input()
  set showHintOnlyOnFocus(bool value) {
    _showHintOnlyOnFocus = value;
    updateBottomPanelState();
  }

  bool get required => _required;

  /// Whether or not the input is required.
  ///
  /// If there's no input text, a required input will show a validation error
  /// when it's first blured.
  @Input()
  set required(bool required) {
    var prev = _required;
    _required = required;
    if (prev != _required && _cd != null) {
      // Required value changed and we are using a control. Force revalidation
      // on the control.
      _cd.control.updateValueAndValidity();
    }
  }

  final _keypressController = StreamController<String>.broadcast(sync: true);

  /// Publishes events whenever input text changes (each keypress).
  @Output('inputKeyPress')
  Stream<String> get onKeypress => _keypressController.stream;

  final _changeController = StreamController<String>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('change')
  Stream<String> get onChange => _changeController.stream;

  final _blurController = StreamController<FocusEvent>.broadcast(sync: true);

  /// Publishes events when a blur event is fired.
  @Output('blur')
  Stream<FocusEvent> get onBlur => _blurController.stream;

  /// Whether the input box is focused.
  bool focused = false;

  /// Whether underline of the input box is animated.
  bool get underlineAnimated => focused;

  /// Whether the floating label is visible.
  bool get floatingLabelVisible => floatingLabel;

  /// Whether the floating label is animated to float above the input box.
  bool get labelAnimated => floatingLabelVisible && (focused || hasVisibleText);

  /// Whether to reverse the animation of the label floating above.
  bool get labelAnimationReset =>
      floatingLabelVisible && !focused && !hasVisibleText;

  bool get invalid {
    if (_error?.isNotEmpty ?? false) return true;
    // If there is a Control, then it is already using this as a Validator, and
    // possibly others.
    if (_cd?.control != null) {
      // Show errors only when a control is invalid, and a user has interacted
      // with it. This conforms to the material spec:
      // https://material.google.com/patterns/errors.html
      return !_cd.valid && (_cd.touched || _cd.dirty);
    }
    // otherwise, just do our local validation
    return _isLocallyValid(false) != null;
  }

  bool get hasVisibleText => inputText?.isNotEmpty ?? false;

  bool get labelVisible => floatingLabelVisible || !hasVisibleText;

  String get ariaLabel => inputAriaLabel ?? label;

  String get errorMessage {
    if (_error?.isNotEmpty ?? false) return _error;
    // if there is a Control, then all error messages will be in the Control's
    // error map
    if (_cd != null && _cd.control?.errors != null) {
      Map<String, dynamic> errorMap = _cd.control.errors;
      if (errorRenderer != null) errorMap = errorRenderer(errorMap);
      var stringValue = errorMap.values.firstWhere(
          ((v) => (v is String) && v.isNotEmpty),
          orElse: () => null);
      if (stringValue != null) {
        return stringValue as String;
      }
      for (var key in errorMap.keys) {
        if ("required" == key) {
          // Angular2 forms required validator.
          return requiredErrorMsg;
        }
        if ("maxlength" == key) {
          // Angular2 forms max length validator.
          return _errorMsg;
        }
        // TODO(google): Support angular2 forms min length validator
      }
      // fallthrough
    }

    // if no Control message, return the [_localValidationMessage]
    return _localValidationMessage ?? '';
  }

  /// The underlying input element.
  ///
  /// Exact type will vary based on the implementation.
  ///
  /// If you find the need to use this element in application code, you
  /// may be building new functionality that all ACX users could benefit
  /// from! If that's the case, please consider contributing your changes
  /// back upstream. Feel free to contact acx-widgets@ for more guidance.
  ElementRef get inputRef => null;

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  void inputFocusAction(event) {
    focused = true;
    handleFocus(event);
    updateBottomPanelState();
  }

  void inputBlurAction(event, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    focused = false;
    _blurController.add(event);
    updateBottomPanelState();
  }

  void inputChange(newValue, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    inputText = newValue;
    _changeController.add(newValue);
    updateBottomPanelState();
  }

  void inputKeypress(newValue, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    inputText = newValue;
    _keypressController.add(newValue);
    // If this update is removed, ensure that the test logic of 'error message
    // updated with input change' works manually.
    updateBottomPanelState();
  }

  void _validate(valid, validationMessage) {
    _invalid = !valid;
    _validationMessage = validationMessage;
  }

  void updateBottomPanelState() {
    var oldState = bottomPanelState;
    if (invalid && isNotEmpty(errorMessage)) {
      bottomPanelState = BottomPanelState.error;
    } else if ((!showHintOnlyOnFocus || focused) && isNotEmpty(_hintText)) {
      bottomPanelState = BottomPanelState.hint;
    } else {
      bottomPanelState = BottomPanelState.empty;
    }

    if (oldState != bottomPanelState) {
      _changeDetector.markForCheck();
    }
  }

  /// Selects all of the input's content.
  void selectAll() {
    inputRef.nativeElement.select();
  }

  /// The message to display when character counter is shown.
  ///
  /// The character count in the form "[currentCount] / [maxCount]", such as
  /// `12 / 25`, when [maxCount] is non-null; otherwise simply "[currentCount]".
  String msgCharacterCounter(int currentCount, int maxCount) => maxCount == null
      ? '$currentCount'
      : _msgCharacterCounter(currentCount, maxCount);

  static String _msgCharacterCounter(int currentCount, int maxCount) =>
      Intl.message('$currentCount / $maxCount',
          name: 'BaseMaterialInput__msgCharacterCounter',
          args: [currentCount, maxCount],
          desc:
              'Character counter shown below a text box in the format "12 / 25"',
          examples: const {'currentCount': 12, 'maxCount': 25});

  static final defaultEmptyMessage = Intl.message('Enter a value',
      desc: 'Error message when the input is empty and required.');
}
