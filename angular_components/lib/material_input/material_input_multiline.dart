// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/angular/reference/reference.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';

import 'base_material_input.dart';
import 'deferred_validator.dart';

export 'base_material_input.dart' show ValidityCheck, CharacterCounter;

/// `material-input` is a multi-line text field where user can enter
/// input, and can optionally have a label.
@Component(
  selector: 'material-input[multiline]',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    DeferredValidator,
    Provider(HasDisabled, useExisting: MaterialMultilineInputComponent),
    Provider(NG_VALIDATORS, useExisting: DeferredValidator, multi: true),
    Provider(ReferenceDirective, useExisting: MaterialMultilineInputComponent),
    Provider(Focusable, useExisting: MaterialMultilineInputComponent),
    Provider(BaseMaterialInput, useExisting: MaterialMultilineInputComponent)
  ],
  templateUrl: 'material_input_multiline.html',
  styleUrls: ['material_input.scss.css', 'material_input_multiline.scss.css'],
  directives: [
    DefaultValueAccessor,
    FocusableDirective,
    NgFor,
    NgIf,
    NgModel,
    NgSwitch,
    NgSwitchWhen,
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialMultilineInputComponent extends BaseMaterialInput
    implements ReferenceDirective, AfterViewInit, OnDestroy {
  @HostBinding('class')
  static const hostClass = 'themeable';

  @HostBinding('tabIndex')
  static const hostTabIndex = -1;

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
  @override
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

  // Overriden to add a HostListener event.
  @HostListener('focus')
  @override
  void focus() => super.focus();

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

  /// Sets height of the text area when the height does not change with the
  /// amount of text in it.
  int get textAreaHeight => rows == maxRows ? maxInputHeight : null;

  int get rows => _rows;

  /// How many rows the multiline input should have.
  ///
  /// Can either be an integer, or a string.
  @Input()
  set rows(dynamic value) {
    _rows = getInt(value);
    _changeDetector.markForCheck();
  }

  int get maxRows => _maxRows;

  /// Maximum number of lines to display.
  ///
  /// Anything more than the [maxRows] will cause the input to scroll.
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
