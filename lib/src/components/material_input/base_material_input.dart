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
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' show isEmpty, isNotEmpty;

import '../focus/focus.dart';
import '../../utils/async/async.dart';
import '../../utils/disposer/disposer.dart';

import 'deferred_validator.dart';

/// Key used in the Control's error map, when there is an error.
const String materialInputErrorKey = 'material-input-error';

typedef String ValidityCheck(String inputText);
typedef int CharacterCounter(String inputText);

/// Base class for behavior that is shared between material input components.
class BaseMaterialInput implements Focusable, AfterViewInit, OnDestroy {
  final NgZone _zone;
  final ChangeDetectorRef _changeDetector;
  final _disposer = new Disposer.oneShot();
  bool _invalid = false;
  // Error message coming from the browser.
  String _validationMessage;
  // Error message resulting from local validation.
  String _localValidationMessage;

  FocusableDirective _focusable;
  set focusable(FocusableDirective value) {
    _focusable = value;
    if (_focusPending) {
      // Focus the object on the next turn.
      _disposer
          .addStreamSubscription(_zone.onMicrotaskEmpty.take(1).listen((_) {
        _focusable.focus();
      }));
      _focusPending = false;
    }
  }

  bool _floatingLabel = false;
  bool _required = false;

  /// Enable native validation (e.g. for type="url").
  bool useNativeValidation = true;

  bool _focusPending = false;
  bool _pristine = true;
  NgControl _cd;

  /// Error message to be displayed in case of invalid input.
  String errorMsg;

  /// Error to be displayed.
  ///
  /// Higher precendent than all other errors which may be on this input.
  String error;

  /// The label for this input. It disappears when user inputs text.
  String label;

  /// Custom error message to show when the field is required and blank.
  String requiredErrorMsg = defaultEmptyMessage;

  /// Maximum allowed characters for character counting input box.
  int maxCount;

  /// Custom validation function to be used to validate input.
  /// Returns error string to be used in case of error or null otherwise.
  /// This validation would over-ride default validation logic.
  /// But character counter (if exists) validation would be done before this.
  ValidityCheck _checkValid;
  ValidityCheck get checkValid => _checkValid;
  @Deprecated('Use angular2 forms API instead')
  set checkValid(ValidityCheck validFn) {
    if (validFn == _checkValid) return; // Identical doesn't work on functions
    _checkValid = validFn;
    _changeDetector.markForCheck();
    if (_cd?.control != null) {
      // Validator was changed. Rerun validation.
      _cd.control.updateValueAndValidity();
    }
  }

  int _inputTextLength = 0;
  int get inputTextLength => _inputTextLength;

  String _inputText = '';
  String get inputText => _inputText;
  set inputText(String value) {
    _inputText = value;

    // Update the text length.
    if (_inputText == null) {
      _inputTextLength = 0;
    } else {
      _inputTextLength = characterCounter != null
          ? characterCounter(_inputText)
          : _inputText.length;
    }

    _changeDetector.markForCheck();
  }

  /// Display error message and character counter below the input.
  bool displayBottomPanel = true;

  /// Custom character counter function to be used.
  CharacterCounter characterCounter;

  BaseMaterialInput(@Self() @Optional() this._cd, this._zone,
      this._changeDetector, DeferredValidator validator) {
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
      }));
    }
  }

  // Angular2 Forms API methods.
  // Act as forms validator (previously NgValidator)
  Map<String, dynamic> call(AbstractControl _) {
    return _isLocallyValid();
  }

  Map<String, dynamic> _isLocallyValid() {
    // Do local validation here. This simply counts as ONE OF the Validators
    // attached to this component. If there is a Control then it will use this
    // one and maybe others.

    if (required && isEmpty(inputText) && !_pristine) {
      _localValidationMessage = requiredErrorMsg;
      return {materialInputErrorKey: _localValidationMessage};
    }
    if (maxCount != null && inputTextLength > maxCount) {
      _localValidationMessage = errorMsg;
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
  bool get floatingLabel => _floatingLabel;
  set floatingLabel(isFloating) {
    _floatingLabel = isFloating != false && isFloating != null;
  }

  /// Whether or not this input is disabled.
  bool disabled = false;

  /// Input is a required field if attribute is present.
  bool get required => _required;
  set required(required) {
    var prev = _required;
    _required = required != false && required != null;
    if (prev != _required && _cd != null) {
      // Required value changed and we are using a control. Force revalidation
      // on the control.
      _cd.control.updateValueAndValidity();
    }
  }

  final _keypressController =
      new LazyStreamController<String>.broadcast(sync: true);

  /// Publishes events whenever input text changes (each keypress).
  Stream<String> get onKeypress => _keypressController.stream;

  final _changeController =
      new LazyStreamController<String>.broadcast(sync: true);

  /// Publishes events when a change event is fired. (On enter, or on blur.)
  Stream<String> get onChange => _changeController.stream;

  final _focusController =
      new LazyStreamController<FocusEvent>.broadcast(sync: true);

  /// Publishes events when a focus event is fired.
  Stream<FocusEvent> get onFocus => _focusController.stream;

  final _blurController =
      new LazyStreamController<FocusEvent>.broadcast(sync: true);

  /// Publishes events when a blur event is fired.
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
    if (error?.isNotEmpty ?? false) return true;
    // If there is a Control, then it is already using this as a Validator, and
    // possibly others.
    if (_cd != null && _cd.control != null) {
      return !_cd.control.valid;
    }
    // otherwise, just do our local validation
    return _isLocallyValid() != null;
  }

  bool get hasVisibleText => inputText?.isNotEmpty ?? false;

  bool get labelVisible => floatingLabelVisible || !hasVisibleText;

  String get ariaLabel => label;

  String get errorMessage {
    if (error?.isNotEmpty ?? false) return error;
    // if there is a Control, then all error messages will be in the Control's
    // error map
    if (_cd != null && _cd.control?.errors != null) {
      Map<String, dynamic> errorMap = _cd.control.errors;
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
          return errorMsg;
        }
        // TODO(google): Support angular2 forms min length validator
      }
      // fallthrough
    }

    // if no Control message, return the [_localValidationMessage]
    return _localValidationMessage ?? '';
  }

  bool get hasErrorMessage => isNotEmpty(errorMessage);

  /// Focuses underlying input or textarea wrapped by this component.
  ///
  /// Check out the [AutoFocusDirective] if you are looking to automatically
  /// focus this component.
  @override
  void focus() {
    if (_focusable != null) {
      _focusable.focus();
    } else {
      _focusPending = true;
    }
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _focusable = null;
  }

  void inputFocusAction(event) {
    focused = true;
    _focusController.add(event);
  }

  void inputBlurAction(event, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    focused = false;
    _blurController.add(event);
  }

  void inputChange(newValue, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    inputText = newValue;
    _changeController.add(newValue);
  }

  void inputKeypress(newValue, valid, validationMessage) {
    _validate(valid, validationMessage);
    _pristine = false;
    inputText = newValue;
    _keypressController.add(newValue);
  }

  void _validate(valid, validationMessage) {
    _invalid = !valid;
    _validationMessage = validationMessage;
  }

  String msgCharacterCounter(int currentCount, int maxCount) => Intl.message(
      '$currentCount / $maxCount',
      name: 'BaseMaterialInput_msgCharacterCounter',
      args: [currentCount, maxCount],
      desc: 'Character counter shown below a text box in the format "12 / 25"',
      examples: {'currentCount': 12, 'maxCount': 25});

  static String get defaultEmptyMessage => Intl.message('Enter a value',
      desc: 'Error message when the input is empty and required.');
}
