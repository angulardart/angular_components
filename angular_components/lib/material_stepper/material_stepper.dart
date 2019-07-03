// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/laminate/portal/portal.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_stepper/common.dart';
import 'package:angular_components/material_stepper/material_step.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/utils/angular/scroll_host/angular_2.dart';
import 'package:angular_components/utils/browser/events/events.dart';

/// A material-design-styled stepper.
///
/// A stepper is a numbered indicator used to convey progress or function as a
/// navigational tool.
///
/// Warning: content is reparented to the stepper component itself so any
/// @ViewChild(ren) queries for content inside of a step or summary template
/// will not work in the original component.
///
@Component(
  selector: 'material-stepper',
  directives: [
    ButtonDirective,
    MaterialIconComponent,
    MaterialYesNoButtonsComponent,
    NgFor,
    NgIf,
    PortalHostDirective,
    StickyElementDirective,
  ],
  templateUrl: 'material_stepper.html',
  styleUrls: [
    'material_stepper.scss.css',
  ],
  // TODO(google): Change preserveWhitespace to false to improve codesize.
  preserveWhitespace: true,
  visibility: Visibility.all, // injected
)
class MaterialStepperComponent {
  @HostBinding('class')
  static const hostClass = 'themeable';

  static const defaultOrientation = horizontal;
  static const defaultSize = sizeDefault;
  List<StepDirective> steps = [];

  int _activeStepIndex;
  int get activeStepIndex => _activeStepIndex;
  set activeStepIndex(int value) {
    _activeStepIndex = value;
    _recalculatePropertiesOfSteps();
  }

  bool stepperDone = false;

  var _orientation = defaultOrientation;
  var _size = defaultSize;
  String _legalJumps;

  List<StepDirective> _stepDirectiveList;
  final _activeStepController =
      StreamController<StepDirective>.broadcast(sync: true);
  final _stepAriaLabel = <StepDirective, String>{};

  @ContentChildren(StepDirective)
  set stepsQuery(List<StepDirective> value) {
    if (_stepDirectiveList == value) return;
    _stepAriaLabel.clear();
    _stepDirectiveList = value;
    activeStepIndex ??= 0;
    scheduleMicrotask(() {
      _onStepsChange(_stepDirectiveList);
    });
  }

  /// When true, assertively announces the current step via aria live region.
  @Input()
  bool announceCurrentStep = false;

  /// Indicates whether the header, which lists the available steps,
  /// should stick to the top of the page.
  ///
  /// Applicable only to steppers with horizontal header.
  @Input()
  bool stickyHeader = false;

  /// When `true`, steps will not be unloaded from the dom when inactive, but
  /// will rather be hidden via css.
  ///
  /// This allows for fast switching between steps with DOMs that are
  /// expensive to load.
  @Input()
  bool keepInactiveStepsInDom = false;

  // Jump to step at index if possible
  Future<bool> jumpStep(int index) {
    if (steps[index].isNotSelectable) return Future.value(false);
    stepperDone = false;
    return _stepTo(index);
  }

  void stepForward(Event event, StepDirective step) {
    // Prevent event from propagating up to the stepper.  This
    // is necessary for a vertical default sized stepper with
    // all jumps allowed, so that the stepper doesn't jump back
    // to the step after clicking the continue button
    event.preventDefault();
    event.stopPropagation();

    AsyncActionController<bool> ctrl = AsyncActionController<bool>();
    step.requestStepContinue(ctrl.action);
    ctrl.execute(() {
      activeStep.complete = true;
      if (activeStep.isLast) {
        stepperDone = true;
        return true;
      }
      return _stepTo(activeStepIndex + 1);
    });
  }

  void stepBackward(Event event, StepDirective step) {
    // Prevent event from propagating up to the stepper.  This
    // is necessary for a vertical default sized stepper with
    // all jumps allowed, so that the stepper doesn't jump back
    // to the step after clicking the cancel button
    event.preventDefault();
    event.stopPropagation();

    AsyncActionController<bool> ctrl = AsyncActionController<bool>();
    step.requestStepCancel(ctrl.action);
    ctrl.execute(() {
      activeStep.complete = false;
      return _stepTo(activeStepIndex - 1);
    });
  }

  /// Text to be displayed on the button that goes back to the former step.
  /// By default, displays "Cancel".
  @Input()
  String noText = _cancelMsg;

  /// Text to be displayed on the button that goes to the next step.
  /// By default, displays "Continue".
  @Input()
  String yesText = continueMsg;

  /// Orientation in which the steps are laid out.
  ///
  /// Possible values: 'horizontal' and 'vertical' (default).
  @Input()
  set orientation(String s) {
    assert(orientations.contains(s));
    _orientation = s;
  }

  /// Size theme which in turn determines sizes of various step header elements
  /// (e.g., the step number, step name, etc.).
  ///
  /// Possible values: 'default' (default) and 'mini'.
  @Input()
  set size(String s) {
    assert(sizes.contains(s));
    _size = s;
  }

  /// For some stepper configurations, it is more natural if the step
  /// content is laid out in a separate content <div> (eg. horizontal)
  /// while for others, it is more natural if the step content is laid out
  /// together with its other DOM elements (vertical, default-size).
  bool get shouldInlineContent =>
      orientation == vertical && size == sizeDefault;

  String get orientation => _orientation;

  String get size => _size;

  /// Get the step directive that is currently active.  The stepper will
  /// only have 1 step active at a time.
  StepDirective get activeStep =>
      steps.isNotEmpty ? steps[activeStepIndex] : null;

  /// Jumps (defined as step-switches not triggered by the Continue/Cancel
  /// buttons) that are legal.
  ///
  /// Possible values:
  ///   * 'none' (default; no jumps allowed),
  ///   * 'backwards'(jumps to already completed steps allowed),
  ///   * 'all' (any jump allowed, regardless of the step state).
  @Input()
  set legalJumps(String s) {
    assert(jumps.contains(s));
    _legalJumps = s;
    _recalculatePropertiesOfSteps();
  }

  /// Get the native element for the stepper (not the stepper content).
  ///
  /// This is helpful for ensuring that animations don't go above or behind
  /// the stepper.
  @ViewChild('stepper')
  HtmlElement stepperNativeElement;

  /// Because of the button decorator enclosing the inline portal eats up
  /// SPACE and ENTER key-presses (by preventing the default on them),
  /// we are stopping those events from bubbling up.
  ///
  /// The button decorator only handles this in order to jump to the
  /// appropriate step. but, when we are already inside the step, we don't
  /// need those to "jump" to the same step there again. And hence,
  /// canceling the event from bubbling up.
  ///
  /// Without this, when you have components inside that need the default
  /// behaviour of the SPACE or ENTER key-press (example: a material-input,)
  /// those components won't behave as expected (example: can't type a space
  /// in a material-input, or a new-line in multiline material input.)
  void stopPropagationOfEnterAndSpace(KeyboardEvent keyboardEvent) {
    int keyCode = keyboardEvent.keyCode;
    if (keyCode == KeyCode.ENTER || isSpaceKey(keyboardEvent)) {
      keyboardEvent.stopPropagation();
    }
  }

  Future<bool> _stepTo(int index) {
    if (index == activeStepIndex) return Future.value(true);

    final actionController = AsyncActionController<bool>();
    steps[index].requestStepJump(actionController.action);
    actionController.execute(() {
      activeStepIndex = index;
      _activeStepController.add(activeStep);
      return true;
    }, valueOnCancel: false);
    return actionController.action.onDone;
  }

  /// Call callback when func does not return false.
  ///
  /// The current step will have its busy flag set while func is running.
  void _onStepsChange(Iterable<StepDirective> stepsQuery) {
    int i = 0;
    int len = stepsQuery.length;
    steps = stepsQuery.map((s) {
      s.index = i;
      s.isLast = i == len - 1;
      i++;
      return s;
    }).toList();
    _recalculatePropertiesOfSteps();
  }

  void _recalculatePropertiesOfSteps() {
    int i = 0;
    for (StepDirective s in steps) {
      s.active = i == activeStepIndex;

      if (s.active) {
        s.complete = false;
      }

      switch (_legalJumps) {
        case all:
          s.isSelectable = !s.active;
          break;
        case none:
          s.isSelectable = false;
          break;
        case backwards:
          s.isSelectable = i < activeStepIndex;
      }
      i++;
    }
  }

  String stepAriaLabel(StepDirective step) => _stepAriaLabel[step] ??=
      _stepAriaAnnounce(step.index + 1, steps.length, step.name);

  String get stepAriaAnnounce =>
      activeStep == null ? '' : stepAriaLabel(activeStep);

  /// Event that fires when the active step has changed.
  @Output('activeStepChanged')
  Stream<StepDirective> get activeStepChanged => _activeStepController.stream;

  static final optionalMsg = Intl.message('Optional',
      name: 'optionalMsg',
      desc: 'Label denoting that a step in a task flow is optional.');

  static final continueMsg = Intl.message('Continue',
      name: 'continueMsg',
      desc: 'Button for continuing to the next step in a task flow.');

  static final _cancelMsg = Intl.message('Cancel',
      name: '_cancelMsg',
      desc: 'Button for cancelling the current step in a task flow.');

  static String _stepAriaAnnounce(
          int currentStepNumber, int totalSteps, String stepLabel) =>
      Intl.message('Step $currentStepNumber of $totalSteps, $stepLabel',
          name: '_stepAriaAnnounce',
          args: [currentStepNumber, totalSteps, stepLabel],
          desc: 'Message announced to visually impaired users about '
              'which step of a multi step process a user is on. '
              '[REL_NOTE: xilli/03-31-19]',
          examples: const {
            'currentStepNumber': 1,
            'totalSteps': 4,
            'stepLabel': 'Select campaign settings'
          });
}

@Directive(
  selector: 'material-stepper[backButtonText]',
)
class MaterialStepperBackButtonTextDirective {
  MaterialStepperBackButtonTextDirective(MaterialStepperComponent stepper) {
    stepper.noText = _msgBack;
  }

  static final _msgBack = Intl.message('Back',
      name: '_msgBack', desc: 'Text on stepper back button between steps');
}
