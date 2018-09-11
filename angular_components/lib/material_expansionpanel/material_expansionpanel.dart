// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A material-styled expansion-panel.
///
/// One or more panels are grouped together in a expansion-panel-set. When a
/// panel is clicked on, the panel contents expand. A panel consists of a name,
/// a value, optional secondary text, and the expanded panel contents.
///
/// Content element with attribute `value` will be used as the "value" of the
/// panel contents when it is in a collapsed state
///
/// Interactions with a panel are done through the parent expansion-set. The set
/// takes into account the state of the other panels in the set, and issues the
/// appropriate actions onto each individual panel.
///
/// __Attributes:__
///
///  - `wide` -- When specified the width of the panel when expanded, is
///    slightly wider then its width when collapsed.
///  - `flat` -- Indicates that the panel should not "float" or separate from
///    other panels when expanded.
///
@Component(
  selector: 'material-expansionpanel',
  directives: [
    ButtonDirective,
    MaterialIconComponent,
    MaterialSaveCancelButtonsDirective,
    MaterialYesNoButtonsComponent,
    NgIf,
    EnterAcceptsDirective,
    KeyUpBoundaryDirective
  ],
  providers: [
    Provider(DeferredContentAware, useExisting: MaterialExpansionPanel),
    Provider(HasDisabled, useExisting: MaterialExpansionPanel),
  ],
  templateUrl: 'material_expansionpanel.html',
  styleUrls: ['material_expansionpanel.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  visibility: Visibility.all, // injected
)
class MaterialExpansionPanel
    implements DeferredContentAware, HasDisabled, OnInit, OnDestroy {
  final NgZone _ngZone;
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;
  final _disposer = Disposer.oneShot();
  final _defaultExpandIcon = 'expand_less';
  final bool shouldExpandOnLeft;

  bool initialized = false;

  MaterialExpansionPanel(this._ngZone, this._changeDetector, this._domService,
      @Attribute('shouldExpandOnLeft') String expandOnLeft)
      : shouldExpandOnLeft = expandOnLeft != null;

  /// Set the auto focus child so that we can focus on it when the panel opens.
  ///
  /// Unfortunately, this only selects the first [AutoFocusDirective] in the
  /// contents of the expansion panel, which means that if there is another
  /// [AutoFocusDirective] in an <ng-content> that is not the .content, that
  /// will get focused instead of the [AutoFocusDirective] inside the .content.
  @ContentChild(AutoFocusDirective)
  AutoFocusDirective autoFocusChild;

  HtmlElement _mainPanel;
  @ViewChild('mainPanel')
  set mainPanel(HtmlElement mainPanel) {
    _mainPanel = mainPanel;
    _disposer.addStreamSubscription(_mainPanel.onTransitionEnd.listen((_) {
      // Clear height override so it will match the active child's height.
      _mainPanel.style.height = '';
    }));
  }

  HtmlElement _mainContent;
  @ViewChild('mainContent')
  set mainContent(HtmlElement mainContent) => _mainContent = mainContent;

  HtmlElement _contentWrapper;
  @ViewChild('contentWrapper')
  set contentWrapper(HtmlElement contentWrapper) {
    _contentWrapper = contentWrapper;
  }

  /// If true, after a successful save, the panel will attempt to close.
  @Input()
  bool closeOnSave = true;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  /// If true, the panel is expanded by default, if false, the panel is closed.
  @Input('expanded')
  set isExpanded(bool value) {
    if (value == _isExpanded) return;
    if (value) {
      expand(byUserAction: false);
    } else {
      collapse(byUserAction: false);
    }
  }

  /// Event fired when the panel is either collapsed or expanded.
  @Output('expandedChange')
  Stream<bool> get isExpandedChange => _isExpandedChange.stream;
  final _isExpandedChange = StreamController<bool>.broadcast(sync: true);

  /// Event fired when the panel is collapsed or expanded by the user.
  @Output('expandedChangeByUser')
  Stream<bool> get isExpandedChangeByUserAction =>
      _isExpandedChangeByUserAction.stream;
  final _isExpandedChangeByUserAction =
      StreamController<bool>.broadcast(sync: true);

  @override
  Stream<bool> get contentVisible => isExpandedChange;

  /// Whether a different panel in the set is currently expanded.
  ///
  /// This determines the color of the panel.
  bool _anotherExpanded = false;
  bool get anotherExpanded => _anotherExpanded;
  set anotherExpanded(bool anotherExpanded) {
    _anotherExpanded = anotherExpanded;
    _changeDetector.markForCheck();
  }

  bool _disabled = false;
  bool get disabled => _disabled;

  /// If true, the panel will remain in the collapsed state with no way to
  /// expand it, or if expanded by default, it will stay in expanded state.
  @Input()
  set disabled(bool value) {
    _disabled = value;
    _changeDetector.markForCheck();
  }

  /// Whether the save button is disabled.
  @Input()
  bool saveDisabled = false;

  // Whether there is an in-progress action from the save/cancel buttons
  bool _activeSaveCancelAction = false;
  bool get activeSaveCancelAction => _activeSaveCancelAction;

  /// If true, the header which displays the name of the panel is hidden when
  /// the panel is expanded.
  @Input()
  bool hideExpandedHeader = false;

  /// If true, clicking on the header does not expand or collapse the panel.
  @Input()
  bool disableHeaderExpansion = false;

  /// A short name label for the expansion panel.
  @Input()
  String name;

  /// Some optional secondary summary text that describes the state of the
  /// widget hosted inside the panel.
  @Input()
  String secondaryText;

  /// An optional icon name to replace the expand arrows with a custom icon.
  @Input()
  set expandIcon(String expandIcon) => _expandIcon = expandIcon;

  String _expandIcon;

  /// If a custom icon is used, then the icon disappears when the panel is
  /// expanded.
  ///
  /// By default, the expand icon is "expand_less."
  String get expandIcon => _expandIcon ?? _defaultExpandIcon;

  /// If true, the expand icon should always be visible regardless whether a
  /// custom icon is used.
  @Input()
  bool alwaysShowExpandIcon = false;

  /// If true, the expand icon should never be visible.
  @Input()
  bool alwaysHideExpandIcon = false;

  bool get hasCustomExpandIcon => expandIcon != _defaultExpandIcon;

  bool get shouldShowExpandIcon {
    if (alwaysHideExpandIcon) return false;
    return (hasCustomExpandIcon && isExpanded)
        ? alwaysShowExpandIcon
        : !disabled;
  }

  bool get shouldFlipExpandIcon => hasCustomExpandIcon ? false : !isExpanded;

  bool get shouldShowHiddenHeaderExpandIcon =>
      hasCustomExpandIcon || alwaysHideExpandIcon
          ? false
          : (hideExpandedHeader && !disabled);

  /// Option to set if widget should show save/cancel buttons `true` by default.
  @Input()
  bool showSaveCancel = true;

  /// Option to set if widget should show cancel button `true` by default.
  @Input()
  bool cancelDisplayed = true;

  /// If set to true, the toolbelt buttons will listen for Enter `keyup` events
  /// and trigger the `yes` action on them.
  @Input()
  bool enterAccepts = false;

  /// The text to be shown on the save button.
  ///
  /// For example: "Ok", "Apply", etc. Default value is "Save".
  @Input()
  String saveText = _msgSave;

  /// The text to be shown on the cancel button.
  ///
  /// For example: "Dismiss", "Not now", etc. Default value is "Cancel".
  @Input()
  String cancelText = _msgCancel;

  String get closePanelMsg =>
      name == null ? _closePanelMsg : _closeNamedPanelMsg(name);

  String get openPanelMsg =>
      name == null ? _openPanelMsg : _openNamedPanelMsg(name);

  String get headerMsg {
    if (disabled) {
      return name;
    } else {
      return _isExpanded ? closePanelMsg : openPanelMsg;
    }
  }

  static final _closePanelMsg = Intl.message('Close panel',
      name: '_closePanelMsg',
      desc: 'ARIA label for a button that closes the panel.');

  static final _openPanelMsg = Intl.message('Open panel',
      name: '_openPanelMsg',
      desc: 'ARIA label for a button that opens the panel.');

  String _closeNamedPanelMsg(String panelName) =>
      Intl.message('Close $panelName panel',
          name: '_closeNamedPanelMsg',
          args: [panelName],
          desc: 'ARIA label for a button that closes the panel.',
          examples: const {'panelName': 'Conversions'});

  String _openNamedPanelMsg(String panelName) =>
      Intl.message('Open $panelName panel',
          name: '_openNamedPanelMsg',
          args: [panelName],
          desc: 'ARIA label for a button that opens the panel.',
          examples: const {'panelName': 'Conversions'});

  final _openController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _closeController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _saveController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _cancelController =
      StreamController<AsyncAction<bool>>.broadcast(sync: true);

  /// Event fired when panel is trying to close.
  ///
  /// This action may be cancelled.
  @Output()
  Stream<AsyncAction<bool>> get close => _closeController.stream;

  /// Event fired when panel is trying to open.
  ///
  /// This action may be cancelled.
  @Output()
  Stream<AsyncAction<bool>> get open => _openController.stream;

  /// Event fired when panel is saved.
  @Output()
  Stream<AsyncAction<bool>> get save => _saveController.stream;

  /// Event fired when panel is cancelled.
  @Output()
  Stream<AsyncAction<bool>> get cancel => _cancelController.stream;

  void handleHeaderClick() {
    if (!disableHeaderExpansion) isExpanded ? collapse() : expand();
  }

  void handleExpandIconClick() {
    if (disableHeaderExpansion) isExpanded ? collapse() : expand();
  }

  @override
  void ngOnInit() {
    // We only focus on the relevant button when the expanded state is changed
    // by user action.
    _disposer.addStreamSubscription(isExpandedChangeByUserAction.listen((_) {
      // Wait for the button reference to be set after change detection is done
      // and buttonDirective is created.
      _ngZone.onEventDone.first.then(([_]) {
        _expandCollapseButton?.focus();
      });
    }));
    initialized = true;
  }

  /// Button that expands or collapses the panel.
  ///
  /// It's either the header or the icon in the content if
  /// [hideExpandedHeader] is set to `true`.
  ButtonDirective _expandCollapseButton;
  @ViewChild('expandCollapseButton', read: ButtonDirective)
  set expandCollapse(ButtonDirective button) {
    _expandCollapseButton = button;
  }

  Future<bool> expand({bool byUserAction = true}) {
    if (disabled && byUserAction) return Future.value(false);
    return changeState(true, byUserAction, _openController);
  }

  Future<bool> collapse({bool byUserAction = true}) {
    if (disabled && byUserAction) return Future.value(false);
    return changeState(false, byUserAction, _closeController);
  }

  Future<bool> doSave() {
    var actionCtrl = AsyncActionController<bool>();
    _saveController.add(actionCtrl.action);
    _activeSaveCancelAction = true;
    _changeDetector.markForCheck();
    final stateWasInitialized = initialized;
    actionCtrl.execute(() {
      if (closeOnSave) {
        _isExpanded = false;
        _isExpandedChange.add(false);
        _isExpandedChangeByUserAction.add(false);
        _changeDetector.markForCheck();
        if (stateWasInitialized) _transitionHeightChange(false);
      }
      return true;
    }, valueOnCancel: false);
    return actionCtrl.action.onDone.then((result) {
      _activeSaveCancelAction = false;
      _changeDetector.markForCheck();
      return result;
    });
  }

  Future<bool> doCancel() {
    var actionCtrl = AsyncActionController<bool>();
    _cancelController.add(actionCtrl.action);
    _activeSaveCancelAction = true;
    _changeDetector.markForCheck();
    final stateWasInitialized = initialized;
    actionCtrl.execute(() {
      _isExpanded = false;
      _isExpandedChange.add(false);
      _isExpandedChangeByUserAction.add(false);
      _changeDetector.markForCheck();
      if (stateWasInitialized) _transitionHeightChange(false);
      return true;
    }, valueOnCancel: false);
    return actionCtrl.action.onDone.then((result) {
      _activeSaveCancelAction = false;
      _changeDetector.markForCheck();
      return result;
    });
  }

  /// Changes the state of the panel either to expanded or not. Returns a
  /// Future<bool> that indicates whether the operation was successful. For
  /// example, trying to close a panel with unsaved changes may fail because
  /// the user has cancelled the operation.
  Future<bool> changeState(
      bool expand, bool byUserAction, StreamController stream) {
    if (_isExpanded == expand) {
      return Future.value(true);
    }
    var actionCtrl = AsyncActionController<bool>();
    stream.add(actionCtrl.action);
    var stateWasInitialized = initialized;
    actionCtrl.execute(() {
      _isExpanded = expand;
      _isExpandedChange.add(expand);
      if (byUserAction) _isExpandedChangeByUserAction.add(expand);
      _changeDetector.markForCheck();
      if (expand && autoFocusChild != null) {
        _domService.scheduleWrite(() {
          autoFocusChild.focus();
        });
      }
      if (stateWasInitialized) _transitionHeightChange(expand);
      return true;
    }, valueOnCancel: false);
    return actionCtrl.action.onDone;
  }

  /// Sets necessary explicit heights to allow CSS transitions when expanding
  /// or collapsing.
  void _transitionHeightChange(bool expand) {
    // Make current height explicit as a starting point for animation.
    _mainPanel.style.height = '${_mainPanel.scrollHeight}px';

    // On next frame, set target height for animation.
    if (expand) {
      _readExpandedPanelHeight().then((expandedPanelHeight) {
        _mainPanel.style.height = expandedPanelHeight;
      });
    } else {
      _domService.nextFrame.then((_) => _mainPanel.style.height = '');
    }
  }

  /// Reads the DOM state to calculate the height of the "expanded" panel in its
  /// current condition.
  ///
  /// This defined end point will be used to animate expansion.
  Future<String> _readExpandedPanelHeight() {
    var completeExpandedHeight = Completer<String>();

    _domService.scheduleRead(() {
      var contentHeight = _mainContent.scrollHeight;
      var expandedPanelHeight = '';

      var mainPanelStyle = _mainPanel.getComputedStyle();
      // Do our best to make sure that onTransitionEnd will fire later.
      var hasHeightTransition =
          contentHeight > 0 && mainPanelStyle.transition.contains('height');

      if (hasHeightTransition) {
        // If the content-wrapper has a top margin, it is not reflected in the
        // scroll height.
        var topMargin = _contentWrapper.getComputedStyle().marginTop;
        expandedPanelHeight = 'calc(${contentHeight}px + ${topMargin})';
      }
      completeExpandedHeight.complete(expandedPanelHeight);
    });

    return completeExpandedHeight.future;
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  static final _msgSave = Intl.message('Save',
      name: '_msgSave',
      desc: 'Text on save button.',
      meaning: 'Text on save button.');

  static final _msgCancel = Intl.message('Cancel',
      name: '_msgCancel',
      desc: 'Text on cancel button.',
      meaning: 'Text on cancel button.');
}
