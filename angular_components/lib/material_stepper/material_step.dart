// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/portal/portal.dart';
import 'package:angular_components/model/action/async_action.dart';

/// A step within the stepper.
///
/// Warning: content is reparented to the stepper component itself so any
/// @ViewChild(ren) queries for content inside of a step or summary template
/// will not work in the original component.
///
@Directive(
  selector: '[step]',
  exportAs: 'step',
)
class StepDirective extends TemplatePortal {
  final _continueController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);

  final _cancelController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);

  final _jumpController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);

  /// Name shown as the title.
  @Input()
  String name;

  /// Whether the step is optional. Optional steps have an extra label denoting
  /// that they're optional and should be skip-able. Default is false.
  @Input()
  bool optional = false;

  /// Summary text shown when the step is completed in a vertical default-sized
  /// stepper. For other steppers, this doesn't apply.
  @Input()
  String completeSummary;

  /// Whether the buttons should be hidden on this step.
  @Input()
  bool hideButtons = false;

  /// Whether the cancel button should be hidden on this step.
  @Input()
  bool cancelHidden = false;

  /// Whether the step is completed.
  ///
  /// This is set when the stepper goes to the next step.
  @Input()
  bool complete = false;

  /// Whether the step is partially complete
  ///
  /// This will show the step icon with a 3/4 circle
  bool _partiallyComplete = false;
  @Input()
  set partiallyComplete(bool b) {
    assert(!b || complete == false);
    _partiallyComplete = b;
  }

  bool get partiallyComplete => _partiallyComplete;

  /// Whether the step can continue.
  ///
  /// This can be used to prevent continuing on from a step until all parts of
  /// the current step meet validation requirements.
  @Input()
  bool canContinue = true;

  bool busy = false;
  bool isLast = false;
  bool isSelectable = false;
  int index;

  /// Optional summary directive associated with this step.
  SummaryDirective summaryDirective;

  StepDirective(TemplateRef ref, ViewContainerRef viewContainerRef)
      : super(ref, viewContainerRef);

  /// The selection state of the step.
  bool active = false;

  bool get isOptional => optional;

  bool get isFirst => index == 0;

  bool get isNotSelectable => !isSelectable;

  /// Called when the Continue button is clicked.
  ///
  /// If the event handler calls `$event.cancel()`, the step won't be continued.
  @Output('continue')
  Stream<AsyncAction<bool>> get continueStream => _continueController.stream;

  /// Called when the Cancel button is clicked.
  ///
  /// If the event handler calls `$event.cancel()`, the step won't be cancelled.
  @Output('cancel')
  Stream<AsyncAction<bool>> get cancelStream => _cancelController.stream;

  /// Called when the user wants to jump to this step.
  ///
  /// If the event handler calls `$event.cancel()`, the step won't be continued.
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
///
/// Warning: content is reparented to the stepper component itself so any
/// @ViewChild(ren) queries for content inside of a step or summary template
/// will not work in the original component.
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
