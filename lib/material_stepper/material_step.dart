// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/portal/portal.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';

/// A step within the stepper.
///
/// __Example usage:__
///
/// <material-stepper>
///   <template step name="Step A">
///     <div>
///       [...]
///     </div>
///   </template>
///   <template step name="Step B">
///     <div>
///       [...]
///     </div>
///   </template>
/// <material-stepper>
///
@Directive(
  selector: '[step]',
  exportAs: 'step',
)
class StepDirective extends TemplatePortal {
  final _continueController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);

  final _cancelController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);

  final _jumpController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);

  /// Name shown as the title.
  @Input()
  String name;

  bool _optional = false;

  /// Whether the step is optional. Optional steps have an extra label denoting
  /// that they're optional and should be skip-able. Default is false.
  bool get optional => _optional;
  @Input()
  set optional(value) {
    _optional = getBool(value);
  }

  /// Summary text shown when the step is completed in a vertical default-sized
  /// stepper. For other steppers, this doesn't apply.
  @Input()
  String completeSummary;

  bool _hideButtons = false;

  /// Whether the buttons should be hidden on this step.
  bool get hideButtons => _hideButtons;
  @Input()
  set hideButtons(value) {
    _hideButtons = getBool(value);
  }

  bool _cancelHidden = false;

  /// Whether the cancel button should be hidden on this step.
  bool get cancelHidden => _cancelHidden;
  @Input()
  set cancelHidden(value) {
    _cancelHidden = getBool(value);
  }

  bool _complete = false;

  /// Whether the step is completed.
  ///
  /// This is set when the stepper goes to the next step.
  bool get complete => _complete;
  @Input()
  set complete(value) {
    _complete = getBool(value);
  }

  bool _canContinue = true;

  /// Whether the step can continue.
  ///
  /// This can be used to prevent continuing on from a step until all parts of
  /// the current step meet validation requirements.
  bool get canContinue => _canContinue;
  @Input()
  set canContinue(value) {
    _canContinue = getBool(value);
  }

  /// The selection state of the step.
  bool _active = false;
  bool busy = false;
  bool isLast = false;
  bool isSelectable = false;
  int index;

  /// Optional summary directive associated with this step.
  SummaryDirective summaryDirective;

  StepDirective(TemplateRef ref, ViewContainerRef viewContainerRef)
      : super(ref, viewContainerRef);

  set active(bool value) {
    _active = value;
  }

  bool get isOptional => optional;

  bool get active => _active;

  bool get isFirst => index == 0;

  bool get isNotSelectable => !isSelectable;

  /// Called when the Continue button is clicked. If the event handler calls
  /// $event.cancel(), the step won't be continued.
  @Output('continue')
  Stream<AsyncAction<bool>> get continueStream => _continueController.stream;

  /// Called when the Cancel button is clicked. If the event handler calls
  /// $event.cancel(), the step won't be cancelled.
  @Output('cancel')
  Stream<AsyncAction<bool>> get cancelStream => _cancelController.stream;

  @Output('jumpHere')
  Stream<AsyncAction<bool>> get jumpStream => _jumpController.stream;

  void requestStepContinue(AsyncAction<bool> action) {
    _requestStepAction(action, _continueController);
  }

  void requestStepCancel(AsyncAction<bool> action) {
    _requestStepAction(action, _cancelController);
  }

  void requestStepJump(AsyncAction<bool> action) {
    _requestStepAction(action, _jumpController);
  }

  bool get shouldShowSummary => !active && completeSummary != null && complete;

  void _requestStepAction(AsyncAction<bool> action,
      StreamController<AsyncAction<bool>> controller) {
    busy = true;
    controller.add(action);
    action.onDone.then((_) {
      busy = false;
    });
  }
}

/// A [TemplatePortal] which is used to house an optional summary view for a
/// [StepDirective].
///
/// Note: Only works with vertical orientation.
///
/// __Example usage:__
///
/// <material-stepper orientation="vertical">
///   <template step name="A" #stepA="step">Step</template>
///   <template [summary]="stepA"><h3>Summary A</h3></template>
/// </material-stepper>
///
@Directive(
  selector: '[summary]',
)
class SummaryDirective extends TemplatePortal {
  /// The [StepDirective] associated with this summary.
  @Input()
  set summary(StepDirective step) {
    assert(step != null, 'Should pass in a valid step for a summary.');
    step.summaryDirective = this;
  }

  SummaryDirective(TemplateRef ref, ViewContainerRef viewContainerRef)
      : super(ref, viewContainerRef);
}
