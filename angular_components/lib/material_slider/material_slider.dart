// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/check.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';

/// A [material slider](https://material.io/guidelines/components/sliders.html)
/// which works for integer values.
///
/// The slider can be controlled by dragging it with the mouse, or by using the
/// keyboard. In LTR, Left/down arrow keys decrease the value by 1, up/right
/// keys increase by 1, page up increases by 10% (rounded up) and page down
/// decreases by 10% (rounded up). In RTL, the keys have the opposite effect.
///
/// WARNING when using double values floating point math can cause the values
/// to be non-exact. If displaying the value to the user consider formatting
/// the result.
@Component(
  selector: 'material-slider',
  providers: [ExistingProvider(HasDisabled, MaterialSliderComponent)],
  templateUrl: 'material_slider.html',
  styleUrls: ['material_slider.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: [
    NgIf,
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialSliderComponent implements AfterChanges, HasDisabled {
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;

  MaterialSliderComponent(this._changeDetector, this._domService);

  /// String value to be passed to aria-disabled.
  @HostBinding('attr.aria-disabled')
  String get disabledStr => '$disabled';

  /// True if the slider disabled.
  @HostBinding('class.is-disabled')
  @HostBinding('attr.aria-disabled')
  @Input()
  bool disabled = false;

  bool _isTwoSided = false;

  /// True if the slider is 2 sided.
  bool get isTwoSided => _isTwoSided;
  @Input()
  set isTwoSided(bool isTwoSided) {
    _isTwoSided = isTwoSided;
  }

  /// The current value of the input [value] element.
  ///
  /// When [isTwoSided] is true, then this represents the current value of the
  /// right slider knob. Must be between [min] and [max], inclusive, a multiple
  /// of [step], and greater than [leftValue].
  @Input()
  num value = 0;

  final _changeController = StreamController<num>.broadcast(sync: true);

  /// Publishes events when the value of the [value] input is changed by the
  /// user.
  @Output()
  Stream<num> get valueChange => _changeController.stream;

  num _leftValue = 0;

  /// The current value of the [leftValue] input in a 2 sided slider, defaults
  /// to 0.
  ///
  /// When [isTwoSided] is true, then this represents the current value of the
  /// left slider knob. Must be between [min] and [max], inclusive, a multiple
  /// of [step] and less than or equal to [value].
  num get leftValue => isTwoSided ? _leftValue : min;
  @Input()
  set leftValue(int val) {
    if (isTwoSided) {
      _leftValue = val;
    }
  }

  final _leftChangeController = StreamController<num>.broadcast(sync: true);

  /// Publishes events when the value of the [leftValue] input is changed
  /// by the user in a 2 sided slider.
  @Output()
  Stream<num> get leftValueChange => _leftChangeController.stream;

  /// The minimum progress value.
  ///
  /// Defaults to 0, must be strictly smaller than max.
  @Input()
  num min = 0;

  /// The maximum progress value.
  ///
  /// Defaults to 100, must be strictly larger than min.
  @Input()
  num max = 100;

  /// The step size of the input.
  ///
  /// Must be a positive number and a divisor of (max - min).
  @Input()
  num step = 1;

  /// The current progress of the [value] input in percent.
  double get progressPercent => (100.0 * (value - min) / (max - min));

  /// The current progress of the [leftValue] input in percent.
  double get leftProgressPercent =>
      isTwoSided ? (100.0 * (leftValue - min) / (max - min)) : 0;

  /// Verifies that the input values of this control are consistent.
  @override
  void ngAfterChanges() {
    assert(() {
      checkArgument(min < max, message: 'Failed assertion: ${min} < ${max}');
      checkArgument(step > 0, message: 'Failed assertion: ${step} > 0');
      checkArgument(_divisible(max - min, step),
          message: 'Failed assertion: (${max} - ${min}) % ${step} ~ 0.');
      checkArgument(value >= min,
          message: 'Failed assertion: ${value} >= ${min}');
      checkArgument(value <= max,
          message: 'Failed assertion: ${value} <= ${max}');
      checkArgument(_divisible(value - min, step),
          message: 'Failed assertion: (${value} - ${min}) % ${step} ~ 0.');

      if (isTwoSided) {
        checkArgument(leftValue <= value,
            message: 'Failed assertion: ${leftValue} <= ${value}');
        checkArgument(leftValue >= min,
            message: 'Failed assertion: ${leftValue} >= ${min}');
        // Redundant check but done for consistency.
        checkArgument(leftValue <= max,
            message: 'Failed assertion: ${leftValue} <= ${max}');
        checkArgument(_divisible(leftValue - min, step),
            message:
                'Failed assertion: (${leftValue} - ${min}) % ${step} ~ 0.');
      }
      return true;
    }());
  }

  bool _divisible(num value, num step) {
    if (step is int) {
      return value % step == 0;
    } else {
      final epsilon = 1e-10;
      double remainder = value % step;
      if (remainder < epsilon) return true;
      if (step - remainder < epsilon) return true;
      return false;
    }
  }

  @ViewChild('container')
  Element container;

  /// Whether the current user locale is RTL.
  bool get isRtl => Bidi.isRtlLanguage(Intl.defaultLocale ?? '');

  /// True if mouse click event on left knob of a 2 sided slider.
  bool isLeftKnobSelected = false;

  /// True if mouse click event on right knob.
  bool isRightKnobSelected = false;

  /// Updates the current value to reflect the given slider position, if needed.
  void _setValueToMousePosition(int position) {
    _domService.scheduleRead(() {
      final containerWidth = container.clientWidth;
      if (containerWidth == 0) return;
      final containerLeft =
          container.getBoundingClientRect().left + window.scrollX;
      final fractionOfTrackLtr = (position - containerLeft) / containerWidth;
      final fractionOfTrack =
          isRtl ? 1.0 - fractionOfTrackLtr : fractionOfTrackLtr;
      final scaledValue = (fractionOfTrack * (max - min));
      final halfStep = step / 2;
      // Clamp to the closest step value.
      final unboundedValue = min +
          (scaledValue ~/ step) * step +
          (scaledValue.remainder(step) > halfStep ? step : 0);
      final newValue = math.max(min, math.min(max, unboundedValue));
      // Adjust left knob in 2 sided slider
      if (isLeftKnobSelected ||
          (newValue < leftValue && !isRightKnobSelected)) {
        if (newValue != leftValue) {
          // Prevent left knob value from being greater than right knob value
          leftValue = _getValidLeftValue(value, newValue);
          _leftChangeController.add(leftValue);
        }
      } else {
        // Adjust right knob in 1 or 2 sided slider.
        if (newValue != value) {
          // Prevent right knob value from being less than left knob value
          value = _getValidRightValue(leftValue, newValue);
          _changeController.add(value);
        }
      }
    });
  }

  /// Whether the user is currently dragging either slider knob.
  bool isDragging = false;

  /// Handles mouse down events on either slider knob or the slider track.
  void mouseDown(MouseEvent event) {
    if (disabled) return;
    if (event.button != 0) return;
    event.preventDefault();
    _setValueToMousePosition(event.page.x);
    isDragging = true;
    _changeDetector.markForCheck();
    final mouseMoveSubscription = document.onMouseMove.listen((event) {
      event.preventDefault();
      _setValueToMousePosition(event.page.x);
    });
    document.onMouseUp.take(1).listen((event) {
      event.preventDefault();
      mouseMoveSubscription.cancel();
      isLeftKnobSelected = false;
      isRightKnobSelected = false;
      isDragging = false;
      _changeDetector.markForCheck();
    });
  }

  /// Handles touch start events on either slider knob.
  void touchStart(TouchEvent event) {
    if (disabled) return;
    event.preventDefault();
    final touch = event.targetTouches.first;
    _setValueToMousePosition(touch.page.x);
    isDragging = true;
    _changeDetector.markForCheck();
    final touchMoveSubscription = document.onTouchMove.listen((event) {
      event.preventDefault();
      final touch = event.targetTouches.first;
      _setValueToMousePosition(touch.page.x);
    });
    document.onTouchEnd.take(1).listen((event) {
      event.preventDefault();
      touchMoveSubscription.cancel();
      isLeftKnobSelected = false;
      isRightKnobSelected = false;
      isDragging = false;
      _changeDetector.markForCheck();
    });
  }

  /// Handles key press events on either slider knob.
  ///
  /// [isLeftKnob] true indicates that the event ocurred on the left knob.
  void knobKeyDown(KeyboardEvent event, {bool isLeftKnobPressed = false}) {
    if (disabled) return;
    var currValue = isLeftKnobPressed ? leftValue : value;
    var newValue = currValue;
    final bigStepSize = ((max - min) / 10.0).ceil();
    final sign = isRtl ? -1 : 1;
    switch (event.keyCode) {
      case KeyCode.DOWN:
      case KeyCode.LEFT:
        newValue = math.max(min, math.min(max, currValue - step * sign));
        break;
      case KeyCode.UP:
      case KeyCode.RIGHT:
        newValue = math.max(min, math.min(max, currValue + step * sign));
        break;
      case KeyCode.PAGE_UP:
        newValue = math.max(min, math.min(max, currValue + step * bigStepSize));
        break;
      case KeyCode.PAGE_DOWN:
        newValue = math.max(min, math.min(max, currValue - step * bigStepSize));
        break;
    }
    if (isLeftKnobPressed) {
      if (newValue != leftValue) {
        leftValue = _getValidLeftValue(value, newValue);
        _leftChangeController.add(leftValue);
      }
    } else if (newValue != value) {
      value = _getValidRightValue(leftValue, newValue);
      _changeController.add(value);
    }
  }

  /// Returns a value that is valid for right knob depending on language
  /// direction.
  num _getValidRightValue(double valA, double valB, {isRtl = false}) =>
      isRtl ? math.min(valA, valB) : math.max(valA, valB);

  /// Returns a value that is valid for left knob depending on language
  /// direction.
  num _getValidLeftValue(double valA, double valB, {isRtl = false}) =>
      isRtl ? math.max(valA, valB) : math.min(valA, valB);
}
