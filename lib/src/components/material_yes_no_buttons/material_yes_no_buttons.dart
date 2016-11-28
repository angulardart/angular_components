// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';

import '../material_button/material_button.dart';
import '../material_spinner/material_spinner.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';

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
  final yes = new LazyEventEmitter();

  /// The callback that is to be invoked, when no button is pressed.
  ///
  /// Published events are either KeyboardEvent or MouseEvent
  @Output()
  final no = new LazyEventEmitter();

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

  bool _yesHighlighted = false;

  /// Whether the yes button should be highlighted.
  ///
  /// Default value is `false`.
  bool get yesHighlighted => _yesHighlighted;
  @Input()
  set yesHighlighted(value) {
    _yesHighlighted = getBool(value);
  }

  bool _raised = false;

  /// Whether the buttons should be raised.
  ///
  /// Default value is `false`.
  bool get raised => _raised;
  @Input()
  set raised(value) {
    _raised = getBool(value);
  }

  bool _yesRaised = false;

  /// Whether the yes button should be raised.
  ///
  /// Default value is `false`.
  bool get yesRaised => _yesRaised;
  @Input()
  set yesRaised(value) {
    _yesRaised = getBool(value);
  }

  bool _disabled = false;

  /// Whether the buttons should be disabled.
  ///
  /// Default value is `false`
  bool get disabled => _disabled;
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }

  bool _yesDisabled = false;

  /// Whether the yes button should be disabled.
  ///
  /// Default value is `false`
  bool get yesDisabled => _yesDisabled;
  @Input()
  set yesDisabled(value) {
    _yesDisabled = getBool(value);
  }

  bool _noDisplayed = true;

  /// Whether the no button is displayed.
  ///
  /// Default value is `true`
  bool get noDisplayed => _noDisplayed;
  @Input()
  set noDisplayed(value) {
    _noDisplayed = getBool(value);
  }

  bool _pending = false;

  /// When pending is `true`, the yes and no buttons are
  /// hidden, and a spinner is shown.
  ///
  /// This should be used to indicate asynchronous actions, such as saving or
  /// validating input.
  ///
  /// Default value is `false`
  bool get pending => _pending;
  @Input()
  set pending(value) {
    _pending = getBool(value);
  }

  @ViewChild('yesButton')
  MaterialButtonComponent yesButton;

  @ViewChild('noButton')
  MaterialButtonComponent noButton;

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

/// Base implementation of directive to listen to keyup events.
///
/// By default it listens only on the element itself, but if an ancestor has the
/// `keyupBoundary` directive, it will listen on the whole subtree.
abstract class BoundaryAwareKeyUpDirective implements OnDestroy {
  StreamSubscription _subscription;

  BoundaryAwareKeyUpDirective(
      ElementRef element, @Optional() KeyUpBoundaryDirective boundary) {
    final Stream<KeyboardEvent> keyUpStream =
        boundary?.keyUpStream ?? _keyUpEventStream(element);
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

  KeyUpBoundaryDirective(ElementRef element)
      : keyUpStream = _keyUpEventStream(element);
}

/// If attached to the yes-no buttons it will listen for escape `keyup` event
/// and trigger [no] action on it.
@Directive(selector: 'material-yes-no-buttons[escCancels]')
class EscapeCancelsDirective extends BoundaryAwareKeyUpDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get noButton => _yesNo.noButton;

  EscapeCancelsDirective(this._yesNo, ElementRef element,
      @Optional() KeyUpBoundaryDirective boundary)
      : super(element, boundary);

  @override
  bool _isKeyUpMatching(KeyboardEvent event) {
    if (event.keyCode != KeyCode.ESC) return false;
    // Make sure the no button is visible and enabled
    if (noButton == null || noButton.disabled) return false;

    return true;
  }

  @override
  void _onMatchingKeyUp(KeyboardEvent event) => _yesNo.no.add(true);
}

/// If attached to the yes-no buttons it will listen for enter`keyup` event
/// and trigger [yes] action on it.
@Directive(selector: 'material-yes-no-buttons[enterAccepts]')
class EnterAcceptsDirective extends BoundaryAwareKeyUpDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get yesButton => _yesNo.yesButton;
  MaterialButtonComponent get noButton => _yesNo.noButton;

  EnterAcceptsDirective(this._yesNo, ElementRef element,
      @Optional() KeyUpBoundaryDirective boundary)
      : super(element, boundary);

  @override
  bool _isKeyUpMatching(KeyboardEvent event) {
    if (event.keyCode != KeyCode.ENTER) return false;
    // Make sure the yes button is visible and enabled
    if (yesButton == null || yesButton.disabled) return false;
    // If the no button is visible, it must not be focused (otherwise enter must
    // select the no button).
    if (noButton != null && noButton.focused) return false;

    return true;
  }

  @override
  void _onMatchingKeyUp(KeyboardEvent event) => _yesNo.yes.add(true);
}

/// Returns the [Stream] of `keyup` [KeyboardEvent]s of the given [element].
Stream<KeyboardEvent> _keyUpEventStream(ElementRef element) =>
    Element.keyUpEvent.forElement(element.nativeElement);
