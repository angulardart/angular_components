// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' show isEmpty, isNotEmpty;

import '../../utils/disposer/disposer.dart';
import '../focus/focus.dart';
import '../forms/error_renderer.dart' show ErrorFn;
import '../mixins/focusable_mixin.dart';
import 'deferred_validator.dart';

export '../forms/error_renderer.dart' show ErrorFn;

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
    implements Focusable, AfterViewInit, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final _disposer = new Disposer.oneShot();

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

  /// Enable native validation (e.g. for type="url").
  bool useNativeValidation = true;

  bool _pristine = true;
  NgControl _cd;

  /// Controls what section of the BottomPanel is displayed.
  BottomPanelState bottomPanelState = BottomPanelState.empty;

  /// Error message to be displayed in case of invalid input.
  String _errorMsg;
  String get errorMsg => _errorMsg;
  @Input()
  set errorMsg(String msg) {
    _errorMsg = msg;
    updateBottomPanelState();
  }

  /// Error to be displayed.
  ///
  /// Higher precendent than all other errors which may be on this input.
  String _error;
  String get error => _error;
  @Input()
  set error(String error) {
    _error = error;
    updateBottomPanelState();
  }

  /// The label for this input. It disappears when user inputs text.
  @Input()
  String label;

  /// The hint text to be shown on the input. Not shown during an error.
  String _hintText;
  String get hintText => _hintText;
  @Input()
  set hintText(value) {
    _hintText = value;
    updateBottomPanelState();
  }

  /// Custom error message to show when the field is required and blank.
  String _requiredErrorMsg = defaultEmptyMessage;
  String get requiredErrorMsg => _requiredErrorMsg;
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
  @Input()
  int maxCount;

  /// Custom validation function to be used to validate input.
  /// Returns error string to be used in case of error or null otherwise.
  /// This validation would over-ride default validation logic.
  /// But character counter (if exists) validation would be done before this.
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

  /// Display error message and character counter below the input.
  @Input()
  bool displayBottomPanel = true;

  /// A function which takes in an error map, and returns another map, replacing
  /// errors with human readable text.
  ///
  /// WARNING: The API of this mechanism is still in flux and there will be
  /// breaking changes. Be careful relying on it.
  @Input()
  ErrorFn errorRenderer;

  /// Custom character counter function to be used.
  CharacterCounter _characterCounter;
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

  /// The label will "float" above the text input instead of disappearing.
  @Input()
  bool floatingLabel = false;

  /// Whether or not this input is disabled.
  @Input()
  bool disabled = false;

  /// Whether or not the hint text will be displayed when the input is not
  /// focused.
  bool get showHintOnlyOnFocus => _showHintOnlyOnFocus;
  @Input()
  set showHintOnlyOnFocus(bool value) {
    _showHintOnlyOnFocus = value;
    updateBottomPanelState();
  }

  /// Input is a required field if attribute is present.
  bool get required => _required;
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

  final _keypressController =
      new StreamController<String>.broadcast(sync: true);

  /// Publishes events whenever input text changes (each keypress).
  @Output('inputKeyPress')
  Stream<String> get onKeypress => _keypressController.stream;

  final _changeController = new StreamController<String>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  @Output('change')
  Stream<String> get onChange => _changeController.stream;

  final _blurController =
      new StreamController<FocusEvent>.broadcast(sync: true);

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

  String get ariaLabel => label;

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

  String msgCharacterCounter(int currentCount, int maxCount) => Intl.message(
      '$currentCount / $maxCount',
      name: 'BaseMaterialInput_msgCharacterCounter',
      args: [currentCount, maxCount],
      desc: 'Character counter shown below a text box in the format "12 / 25"',
      examples: const {'currentCount': 12, 'maxCount': 25});

  static String get defaultEmptyMessage => Intl.message('Enter a value',
      desc: 'Error message when the input is empty and required.');
}
