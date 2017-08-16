// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import '../material_button/material_button.dart';
import '../material_spinner/material_spinner.dart';

/// A component for the two buttons horizontally next to each other, like
/// yes/no, save/cancel, agree/not agree, etc.
///
/// Text on the buttons can be changed, they can also be raised.
/// The 'yes' button can be optionally highlighted.
///
/// Basic text customization can be provided with directives like
/// [MaterialSaveCancelButtonsDirective] that replaces yes/no with save/cancel.
///
/// To display buttons in reversed order add a `reverse` attribute.
@Component(
    selector: 'material-yes-no-buttons',
    directives: const [
      MaterialButtonComponent,
      MaterialSpinnerComponent,
      NgClass,
      NgIf,
    ],
    templateUrl: 'material_yes_no_buttons.html',
    styleUrls: const ['material_yes_no_buttons.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialYesNoButtonsComponent {
  /// The callback that is to be invoked, when yes button is pressed.
  ///
  /// Published events are either KeyboardEvent or MouseEvent
  @Output()
  Stream<UIEvent> get yes => _yes.stream;
  final _yes = new StreamController<UIEvent>.broadcast();

  /// The callback that is to be invoked, when no button is pressed.
  ///
  /// Published events are either KeyboardEvent or MouseEvent
  @Output()
  Stream<UIEvent> get no => _no.stream;
  final _no = new StreamController<UIEvent>.broadcast();

  /// The text to be shown on the save button.
  ///
  /// For example, `Ok`, `Apply`, etc. Default value is `yes`.
  @Input()
  String yesText = _msgYes;

  /// The text to be shown on the cancel button.
  ///
  /// For example, `Dismiss`, `Not now`, etc. Default value is `No`.
  @Input()
  String noText = _msgNo;

  /// Whether the yes button should be highlighted.
  ///
  /// Default value is `false`.
  @Input()
  bool yesHighlighted = false;

  /// Whether the buttons should be raised.
  ///
  /// Default value is `false`.
  @Input()
  bool raised = false;

  /// Whether the yes button should be raised.
  ///
  /// Default value is `false`.
  @Input()
  bool yesRaised = false;

  /// Whether the buttons should be disabled.
  ///
  /// Default value is `false`.
  @Input()
  bool disabled = false;

  /// Whether the yes button should be disabled.
  ///
  /// Default value is `false`.
  @Input()
  bool yesDisabled = false;

  /// Whether the yes button should be displayed.
  ///
  /// Default value is `true`.
  @Input()
  bool yesDisplayed = true;

  /// Whether the no button should be displayed.
  ///
  /// Default value is `true`.
  @Input()
  bool noDisplayed = true;

  /// When pending is `true`, the yes and no buttons are
  /// hidden, and a spinner is shown.
  ///
  /// This should be used to indicate asynchronous actions, such as saving or
  /// validating input.
  ///
  /// Default value is `false`
  @Input()
  bool pending = false;

  @ViewChild('yesButton')
  MaterialButtonComponent yesButton;

  @ViewChild('noButton')
  MaterialButtonComponent noButton;

  void onYes(UIEvent event) {
    _yes.add(event);
  }

  void onNo(UIEvent event) {
    _no.add(event);
  }

  static String get _msgYes => Intl.message('Yes',
      name: '_msgYes',
      desc: 'Text on yes button.',
      meaning: 'Text on yes button.');

  static String get _msgNo => Intl.message('No',
      name: '_msgNo',
      desc: 'Text on no button.',
      meaning: 'Text on no button.');
}

@Directive(selector: 'material-yes-no-buttons[saveCancel]')
class MaterialSaveCancelButtonsDirective {
  MaterialSaveCancelButtonsDirective(MaterialYesNoButtonsComponent yesNo) {
    yesNo.yesText = _msgSave;
    yesNo.noText = _msgCancel;
  }

  static String get _msgSave => Intl.message('Save',
      name: '_msgSave',
      desc: 'Text on save button.',
      meaning: 'Text on save button.');

  static String get _msgCancel => Intl.message('Cancel',
      name: '_msgCancel',
      desc: 'Text on cancel button.',
      meaning: 'Text on cancel button.');
}

@Directive(selector: 'material-yes-no-buttons[submitCancel]')
class MaterialSubmitCancelButtonsDirective
    extends MaterialSaveCancelButtonsDirective {
  MaterialSubmitCancelButtonsDirective(MaterialYesNoButtonsComponent yesNo)
      : super(yesNo) {
    yesNo.yesText = _msgSubmit;
  }

  static String get _msgSubmit => Intl.message('Submit',
      name: '_msgSubmit',
      desc: 'Text on submit button.',
      meaning: 'Text on submit button.');
}

/// Base implementation of directive to listen to keyup events.
///
/// By default it listens only on the element itself, but if an ancestor has the
/// `keyupBoundary` directive, it will listen on the whole subtree.
abstract class BoundaryAwareKeyUpDirective implements OnDestroy {
  StreamSubscription _subscription;

  BoundaryAwareKeyUpDirective(
      Element element, @Optional() KeyUpBoundaryDirective boundary) {
    final Stream<KeyboardEvent> keyUpStream =
        boundary?.keyUpStream ?? Element.keyUpEvent.forElement(element);
    _subscription =
        keyUpStream.where(_isKeyUpMatching).listen(_onMatchingKeyUp);
  }

  @override
  ngOnDestroy() {
    _subscription.cancel();
    _subscription = null;
  }

  /// Tests whether a subclass is interested in the event.
  bool _isKeyUpMatching(KeyboardEvent event);

  /// Invoked for events that passed [_isKeyUpMatching].
  void _onMatchingKeyUp(KeyboardEvent event);
}

/// Marks a subtree of the dom that should handle `keyup` events for a
/// [BoundaryAwareKeyUpDirective] implementation.
// TODO(google): move to somewhere common.
@Directive(selector: '[keyupBoundary]')
class KeyUpBoundaryDirective {
  /// Stream of `keyup` [KeyboardEvent]s of the DOM subtree.
  final Stream<KeyboardEvent> keyUpStream;

  KeyUpBoundaryDirective(Element element)
      : keyUpStream = Element.keyUpEvent.forElement(element);
}

/// If attached to the yes-no buttons it will listen for escape `keyup` event
/// and trigger [no] action on it.
@Directive(selector: 'material-yes-no-buttons[escCancels]')
class EscapeCancelsDirective extends BoundaryAwareKeyUpDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get noButton => _yesNo.noButton;

  EscapeCancelsDirective(
      this._yesNo, Element element, @Optional() KeyUpBoundaryDirective boundary)
      : super(element, boundary);

  @override
  bool _isKeyUpMatching(KeyboardEvent event) {
    if (event.keyCode != KeyCode.ESC) return false;
    // Make sure the no button is visible and enabled
    if (noButton == null || noButton.disabled) return false;

    return true;
  }

  @override
  void _onMatchingKeyUp(KeyboardEvent event) => _yesNo.onNo(event);
}

/// If attached to yes-no buttons, it will listen for Enter `keyup` events and
/// trigger the `yes` action on them.
@Directive(selector: 'material-yes-no-buttons[enterAccepts]')
class EnterAcceptsDirective extends BoundaryAwareKeyUpDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get yesButton => _yesNo.yesButton;
  MaterialButtonComponent get noButton => _yesNo.noButton;

  EnterAcceptsDirective(
      this._yesNo, Element element, @Optional() KeyUpBoundaryDirective boundary)
      : super(element, boundary);

  /// Enables the directive to be conditionally applied.
  @Input()
  bool enterAccepts = true;

  @override
  bool _isKeyUpMatching(KeyboardEvent event) {
    if (!enterAccepts) return false;
    if (event.keyCode != KeyCode.ENTER) return false;
    // Make sure the yes button is visible and enabled
    if (yesButton == null || yesButton.disabled) return false;
    // If the no button is visible, it must not be focused (otherwise enter must
    // select the no button).
    if (noButton != null && noButton.focused) return false;

    return true;
  }

  @override
  void _onMatchingKeyUp(KeyboardEvent event) => _yesNo.onYes(event);
}
