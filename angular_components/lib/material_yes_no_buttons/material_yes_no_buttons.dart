// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';

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
  directives: [
    AutoFocusDirective,
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    NgClass,
    NgIf,
  ],
  providers: [ExistingProvider(HasDisabled, MaterialYesNoButtonsComponent)],
  templateUrl: 'material_yes_no_buttons.html',
  styleUrls: ['material_yes_no_buttons.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialYesNoButtonsComponent implements HasDisabled {
  /// The callback that is to be invoked, when yes button is pressed.
  ///
  /// Published events are either KeyboardEvent or MouseEvent
  @Output()
  Stream<UIEvent> get yes => _yes.stream;
  final _yes = StreamController<UIEvent>.broadcast();

  /// The callback that is to be invoked, when no button is pressed.
  ///
  /// Published events are either KeyboardEvent or MouseEvent
  @Output()
  Stream<UIEvent> get no => _no.stream;
  final _no = StreamController<UIEvent>.broadcast();

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

  /// Whether the no button should be disabled.
  ///
  /// Default value is `false`.
  @Input()
  bool noDisabled = false;

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

  /// The text to be used as an ARIA label on the save button.
  ///
  /// For example, `Ok`, `Apply`, etc. Defaults to `null` so screen readers will
  /// read the button text as the label.
  @Input()
  String yesAriaLabel;

  /// The text to be used as an ARIA label on the cancel button.
  ///
  /// For example, `Dismiss`, `Not now`, etc. Defaults to `null` so screen
  /// readers will read the button text as the label.
  @Input()
  String noAriaLabel;

  /// Whether the yes button should be auto-focused.
  ///
  /// Default value is `false`.
  @Input()
  bool yesAutoFocus = false;

  /// Whether the no button should be auto-focused.
  ///
  /// Default value is `false`.
  @Input()
  bool noAutoFocus = false;

  /// The description which will be set to yes button's aria-describedby.
  @Input()
  String yesAriaDescribedBy;

  /// The description which will be set to no button's aria-describedby.
  @Input()
  String noAriaDescribedBy;

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

  static final _msgYes = Intl.message('Yes',
      name: '_msgYes',
      desc: 'Text on yes button.',
      meaning: 'Text on yes button.');

  static final _msgNo = Intl.message('No',
      name: '_msgNo',
      desc: 'Text on no button.',
      meaning: 'Text on no button.');
}

/// Provides messages from yes/no buttons to be Save/Cancel.
@Directive(
  selector: 'material-yes-no-buttons[saveCancel]',
  visibility: Visibility.all,
)
class MaterialSaveCancelButtonsDirective {
  MaterialSaveCancelButtonsDirective(MaterialYesNoButtonsComponent yesNo) {
    yesNo.yesText = _msgSave;
    yesNo.noText = _msgCancel;
  }

  static final _msgSave = Intl.message('Save',
      desc: 'Text on save button.', meaning: 'Text on save button.');

  static final _msgCancel = Intl.message('Cancel',
      desc: 'Text on cancel button.', meaning: 'Text on cancel button.');
}

/// Provides default messages from yes/no buttons to be Submit/Cancel.
@Directive(
  selector: 'material-yes-no-buttons[submitCancel]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialSubmitCancelButtonsDirective
    extends MaterialSaveCancelButtonsDirective {
  MaterialSubmitCancelButtonsDirective(MaterialYesNoButtonsComponent yesNo)
      : super(yesNo) {
    yesNo.yesText = _msgSubmit;
  }

  static final _msgSubmit = Intl.message('Submit',
      desc: 'Text on submit button.', meaning: 'Text on submit button.');
}

/// Base implementation of directive to listen to key events.
///
/// By default it listens only on the element itself, but if an ancestor has the
/// `keyupBoundary` directive, it will listen on the whole subtree.
abstract class BoundaryAwareKeyDirective implements OnDestroy {
  StreamSubscription _subscription;

  BoundaryAwareKeyDirective.keypress(
      Element element, @Optional() KeyUpBoundaryDirective boundary) {
    final stream =
        boundary?.keyPressStream ?? Element.keyPressEvent.forElement(element);
    _subscription = stream.where(_isKeyMatching).listen(_onMatchingKey);
  }

  BoundaryAwareKeyDirective.keyup(
      Element element, @Optional() KeyUpBoundaryDirective boundary) {
    final stream =
        boundary?.keyUpStream ?? Element.keyUpEvent.forElement(element);
    _subscription = stream.where(_isKeyMatching).listen(_onMatchingKey);
  }

  @override
  ngOnDestroy() {
    _subscription.cancel();
    _subscription = null;
  }

  /// Tests whether a subclass is interested in the event.
  bool _isKeyMatching(KeyboardEvent event);

  /// Invoked for events that passed [_isKeyMatching].
  void _onMatchingKey(KeyboardEvent event);
}

/// Marks a subtree of the dom that should handle key events for a
/// [BoundaryAwareKeyDirective] implementation.
// TODO(google): move to somewhere common.
// TODO(google): Rename to be more appropriate.
@Directive(
  selector: '[keyupBoundary]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class KeyUpBoundaryDirective {
  final HtmlElement _element;
  Stream<KeyboardEvent> _keyUpStream;
  Stream<KeyboardEvent> _keyPressStream;

  KeyUpBoundaryDirective(this._element);

  /// Stream of keyUp events.
  ///
  /// Use this stream when the KeyDirective you are creating cannot use a
  /// keyPress event such as for modifier keys and Esc.
  Stream<KeyboardEvent> get keyUpStream =>
      _keyUpStream ??= Element.keyUpEvent.forElement(_element);

  /// Stream of keyPress events.
  Stream<KeyboardEvent> get keyPressStream =>
      _keyPressStream ??= Element.keyPressEvent.forElement(_element);
}

/// If attached to the yes-no buttons it will listen for escape `keyup` event
/// and trigger [no] action on it.
@Directive(
  selector: 'material-yes-no-buttons[escCancels]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class EscapeCancelsDirective extends BoundaryAwareKeyDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get noButton => _yesNo.noButton;

  EscapeCancelsDirective(
      this._yesNo, Element element, @Optional() KeyUpBoundaryDirective boundary)
      : super.keyup(element, boundary);

  @override
  bool _isKeyMatching(KeyboardEvent event) {
    if (event.keyCode != KeyCode.ESC) return false;
    // Make sure the no button is visible and enabled
    if (noButton == null || noButton.disabled) return false;

    return true;
  }

  @override
  void _onMatchingKey(KeyboardEvent event) => _yesNo.onNo(event);
}

/// If attached to yes-no buttons, it will listen for Enter `keyup` events and
/// trigger the `yes` action on them.
@Directive(
  selector: 'material-yes-no-buttons[enterAccepts]',
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class EnterAcceptsDirective extends BoundaryAwareKeyDirective
    implements OnDestroy {
  final MaterialYesNoButtonsComponent _yesNo;

  MaterialButtonComponent get yesButton => _yesNo.yesButton;
  MaterialButtonComponent get noButton => _yesNo.noButton;

  EnterAcceptsDirective(
      this._yesNo, Element element, @Optional() KeyUpBoundaryDirective boundary)
      : super.keypress(element, boundary);

  /// Enables the directive to be conditionally applied.
  @Input()
  bool enterAccepts = true;

  @override
  bool _isKeyMatching(KeyboardEvent event) {
    if (!enterAccepts) return false;
    if (event.keyCode != KeyCode.ENTER || event.repeat == true) return false;
    // Make sure the yes button is visible and enabled
    if (yesButton == null || yesButton.disabled) return false;
    // If the no button is visible, it must not be focused (otherwise enter must
    // select the no button).
    if (noButton != null && noButton.focused) return false;

    return true;
  }

  @override
  void _onMatchingKey(KeyboardEvent event) => _yesNo.onYes(event);
}
