// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/feature_detector/feature_detector.dart'
    show supportsAnimationApi;

const String ARIA_VALUENOW_ATTR = "aria-valuenow";
const Map<String, double> _indeterminateTiming = const {
  'duration': 2000.0,
  'iterations': double.INFINITY
};

/// The progress bars are for situations where the percentage completed can be
/// determined. They give users a quick sense of how much longer an operation
/// will take.
///
/// __Example usage:__
///
///    <material-progress [activeProgress]="10" [secondaryProgress]="30">
///    </material-progress>
///
@Component(
  selector: 'material-progress',
  templateUrl: 'material_progress.html',
  styleUrls: const ['material_progress.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialProgressComponent implements AfterViewInit, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final HtmlElement _element;
  bool _useFancyAnimation;

  /// The current progress value.
  @Input()
  int activeProgress = 0;

  /// The "secondary" progress. Shows up behind the primary progress in a
  /// lighter color.
  @Input()
  int secondaryProgress = 0;

  /// The minimum progress value. Defaults to 0.
  @Input()
  int min = 0;

  /// The maximum progress value. Defaults to 100.
  @Input()
  int max = 100;

  /// Boolean whether the progress bar is deterministic. Default `false`
  @Input()
  set indeterminate(bool b) {
    _indeterminate = b;

    if (indeterminate) {
      _tryFancyAnimation();
    } else {
      _primaryAnimation?.cancel();
      _secondaryAnimation?.cancel();
    }
  }

  bool _indeterminate = false;
  bool get indeterminate => _indeterminate;

  // Whether or not the component's already initialized.
  bool _isInitialized = false;

  /// Whether to use the fallback indeterminate animation.
  bool get useFallbackAnimation =>
      indeterminate && (!_useFancyAnimation || !supportsAnimationApi);

  String get ariaValue => indeterminate ? null : '$activeProgress';

  String get primaryTransform => 'scaleX(${_calcRatio(activeProgress)})';

  String get secondaryTransform => 'scaleX(${_calcRatio(secondaryProgress)})';

  double _calcRatio(int value) => (value.clamp(min, max) - min) / (max - min);

  @ViewChild('primary', read: HtmlElement)
  set primary(HtmlElement value) {
    _primaryIndicator = value;
  }

  DivElement _primaryIndicator;
  Animation _primaryAnimation;

  @ViewChild('secondary', read: HtmlElement)
  set secondary(HtmlElement value) {
    _secondaryIndicator = value;
  }

  DivElement _secondaryIndicator;
  Animation _secondaryAnimation;

  MaterialProgressComponent(
      @Attribute('disable-fancy-animation') String disableFancyAnimation,
      this._changeDetector,
      this._element)
      : _useFancyAnimation = disableFancyAnimation == null;

  @override
  void ngAfterViewInit() {
    _isInitialized = true;
    if (indeterminate) _tryFancyAnimation();
  }

  @override
  void ngOnDestroy() {
    _primaryAnimation?.cancel();
    _secondaryAnimation?.cancel();
    _primaryAnimation = null;
    _secondaryAnimation = null;
    _primaryIndicator = null;
    _secondaryIndicator = null;
  }

  /// Sets up 'fancy' animation using the animation API.
  void _tryFancyAnimation() {
    if (!indeterminate ||
        !_useFancyAnimation ||
        !_isInitialized ||
        !supportsAnimationApi) return;

    final width = _element.getBoundingClientRect().width;
    if (width == 0) {
      // Fall back to the non-optimized animation if the host element does not
      // yet have a width. The non-optimized animation will automatically adjust
      // when the host element width changes.
      _useFancyAnimation = false;

      // To avoid 'expression has changed after it was checked'.
      scheduleMicrotask(_changeDetector.markForCheck);
      return;
    }

    final primaryKeyframes = [
      const {'transform': 'translateX(0px) scaleX(0)'},
      const {'transform': 'translateX(0px) scaleX(0.5)', 'offset': 0.25},
      {
        'transform': 'translateX(${0.25 * width}px) scaleX(0.75)',
        'offset': 0.5
      },
      {'transform': 'translateX(${width}px) scaleX(0)', 'offset': 0.75},
      {'transform': 'translateX(${width}px) scaleX(0)'},
    ];
    final secondaryKeyframes = [
      const {'transform': 'translateX(0px) scaleX(0)'},
      const {'transform': 'translateX(0px) scaleX(0)', 'offset': 0.6},
      const {'transform': 'translateX(0px) scaleX(0.6)', 'offset': 0.8},
      {'transform': 'translateX(${width}px) scaleX(0.1)'},
    ];
    _primaryAnimation =
        _primaryIndicator.animate(primaryKeyframes, _indeterminateTiming);
    _secondaryAnimation =
        _secondaryIndicator.animate(secondaryKeyframes, _indeterminateTiming);
  }
}
