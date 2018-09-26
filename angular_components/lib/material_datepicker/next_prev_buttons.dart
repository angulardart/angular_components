// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' show Event;

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/src/material_datepicker/sequential.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

export 'package:angular_components/src/material_datepicker/sequential.dart';

/// Next/prev buttons.
///
/// __Example Usage:__
///
///     <next-prev-buttons [model]="dateRange"
///                        [nextLabel]="nextDateRangeMsg"
///                        [prevLabel]="prevDateRangeMsg">
///     </next-prev-buttons>
///
// TODO(google): Use material-button instead of button. Maybe pull out an
// icon-button component.
@Component(
  selector: 'next-prev-buttons',
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: r'''
<button class="prev"
        [class.disabled]="isPrevDisabled"
        attr.aria-disabled="{{isPrevDisabled}}"
        attr.tabindex="{{isPrevDisabled ? -1 : 0}}"
        (click)="prev()">
  <material-icon icon="navigate_before"
                 [attr.aria-label]="prevLabel">
  </material-icon>
</button>
<button class="next"
        [class.disabled]="isNextDisabled"
        attr.aria-disabled="{{isNextDisabled}}"
        attr.tabindex="{{isNextDisabled ? -1 : 0}}"
        (click)="next()">
  <material-icon icon="navigate_next"
                 [attr.aria-label]="nextLabel">
  </material-icon>
</button>
''',
  styleUrls: ['next_prev_buttons.scss.css'],
  directives: [MaterialIconComponent],
)
class NextPrevComponent implements OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final Disposer _modelListeners = Disposer.multi();
  Sequential _model;
  bool _hasNext = false;
  bool _hasPrev = false;

  NextPrevComponent(this._changeDetector);

  @HostListener('click')
  @HostListener('keypress')
  void stopPropagation(Event e) => e.stopPropagation();

  /// Something that can logically move to a next/prev value.
  @Input()
  set model(Sequential newModel) {
    _modelListeners.dispose();
    _model = newModel;
    _hasNext = newModel?.hasNext?.value ?? false;
    _hasPrev = newModel?.hasPrev?.value ?? false;

    if (newModel != null) {
      _modelListeners
        ..addStreamSubscription(newModel.hasNext.stream.listen((newValue) {
          _hasNext = newValue;
          _changeDetector.markForCheck();
        }))
        ..addStreamSubscription(newModel.hasPrev.stream.listen((newValue) {
          _hasPrev = newValue;
          _changeDetector.markForCheck();
        }));
    }
  }

  /// The aria-label to use on the next button. Defaults to a generic
  /// "Next" message.
  @Input()
  String nextLabel = _genericNextMsg;

  /// The aria-label to use on the prev button. Defaults to a generic "Previous"
  /// message.
  @Input()
  String prevLabel = _genericPrevMsg;

  bool get hasNext => _hasNext;
  bool get hasPrev => _hasPrev;

  void next() {
    if (!isNextDisabled) _model.next();
  }

  void prev() {
    if (!isPrevDisabled) _model.prev();
  }

  /// Whether changing the selection should be disabled.
  @Input()
  bool disabled = false;

  /// Whether the prev button is disabled.
  bool get isPrevDisabled => disabled || !hasPrev;

  /// Whether the next button is disabled.
  bool get isNextDisabled => disabled || !hasNext;

  static final _genericNextMsg = Intl.message('Next',
      name: '_genericNextMsg',
      meaning: 'For a button which moves to the next item',
      desc: 'Label for a button to move to the next item of some series.');

  static final _genericPrevMsg = Intl.message('Previous',
      name: '_genericPrevMsg',
      meaning: 'For a button which moves to the previous item',
      desc: 'Label for a button to move to the previous item of some series.');

  @override
  void ngOnDestroy() {
    _modelListeners.dispose();
  }
}
