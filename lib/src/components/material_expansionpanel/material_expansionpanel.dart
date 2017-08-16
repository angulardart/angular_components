// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import '../../model/action/async_action.dart';
import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/browser/dom_service/dom_service.dart';
import '../../utils/disposer/disposer.dart';
import '../button_decorator/button_decorator.dart';
import '../content/deferred_content_aware.dart';
import '../focus/focus.dart';
import '../glyph/glyph.dart';
import '../material_yes_no_buttons/material_yes_no_buttons.dart';

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
/// TODO(google): Keyboard/accessibility inputs
///
/// __Example usage:__
///
///     <material-expansionpanel (save)="doSave()">
///       <my-component></my-component>
///     </material-expansionpanel>
///
///     <material-expansionpanel wide>
///       <div value class="valueClass">
///         Fancily formatted value of my panel's contents
///       </div>
///       <my-component></my-component>
///     </material-expansionpanel>
///
/// Material expansion panel also supports deferred content:
///
///     <material-expansionpanel>
///       <div *deferredContent>
///         Deferred panel contents
///       </div>
///     </material-expansionpanel>
///
/// __Attributes:__
///
///  - `wide` -- When specified the width of the panel when expanded, is
///    slightly wider then its width when collapsed.
///  - `flat` -- Indicates that the panel should not "float" or separate from
///    other panels when expanded.
///
/// __Inputs:__
///
///  - `alwaysShowExpandIcon: bool` -- If true, the expand icon is always
///    visible regardless of the expanded state or whether custom icon is used.
///  - `closeOnSave: bool` -- If true, after a successful save, the panel will
///    attempt to close.
///  - `expanded: bool` -- Determines whether the panel is expanded by default.
///    Otherwise, the panel is closed by default.
///  - `disabled: bool` -- If true, the panel will remain in the collapsed state
///    with no way to expand it, or if expanded by default, it will stay in
///    expanded state.
///  - `hideExpandedHeader: bool` -- If true, the title section of the panel is
///    hidden when the panel is expanded.
///  - `name: String` -- A short name label for the expansion panel.
///  - `secondaryText: String` -- Some optional secondary summary text that
///    describes the state of the widget hosted inside the panel.
///  - `showSaveCancel: bool` -- Determines whether to show the save/cancel
///    buttons by default.
///  - `saveText: String` -- The text to be shown on the save button (e.g.
///    "okay", "apply"). The default text is "save".
///  - `cancelText: String` -- The text to be shown on the cancel button (e.g.
///    "dismiss", "not now"). The default text is "cancel".
///  - `saveDisabled: bool` -- If true, the save button is disabled.
///  - `enterAccepts: bool` -- If true, enterAccepts is enabled.
///
/// __Events:__
///
///  - `expandedChange: bool` -- Fired when the panel is opened or closed.
///  - `open: AsyncAction<bool>` -- Fired when the panel is attempting to open.
///    Can be cancelled by `event.cancelIf(new Future.value(false));`
///  - `close: AsyncAction<bool>` -- Fired when panel is attempting to close.
///    Can be cancelled by `event.cancelIf(new Future.value(false));`
///  - `save: AsyncAction<bool>` -- Fired after user clicks on save button.
///    Use `event.defer(Future<bool>)` to indicate if the save operation was
///    successful. If save was unsuccessful, panel will not close.
///  - `cancel: AsyncAction<bool>` -- Fired after user clicks cancel button.
///    Use `event.defer(Future<bool>)` to indicate if cancel operation should
///    itself be cancelled (e.g. Have unsaved changes). If future returns false,
///    panel will not be closed.
///
@Component(
    selector: 'material-expansionpanel',
    directives: const [
      ButtonDirective,
      GlyphComponent,
      MaterialSaveCancelButtonsDirective,
      MaterialYesNoButtonsComponent,
      NgIf,
      EnterAcceptsDirective,
      KeyUpBoundaryDirective
    ],
    providers: const [
      const Provider(DeferredContentAware, useExisting: MaterialExpansionPanel)
    ],
    templateUrl: 'material_expansionpanel.html',
    styleUrls: const ['material_expansionpanel.scss.css'],
    preserveWhitespace: false,
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialExpansionPanel
    implements DeferredContentAware, OnInit, OnDestroy {
  final ManagedZone _managedZone;
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;
  final _disposer = new Disposer.oneShot();
  final _defaultExpandIcon = 'expand_less';

  MaterialExpansionPanel(
      this._managedZone, this._changeDetector, this._domService);

  /// Set the auto focus child so that we can focus on it when the panel opens.
  ///
  /// Unfortunately, this only selects the first [AutoFocusDirective] in the
  /// contents of the expansion panel, which means that if there is another
  /// [AutoFocusDirective] in an <ng-content> that is not the .content, that
  /// will get focused instead of the [AutoFocusDirective] inside the .content.
  @ContentChild(AutoFocusDirective)
  AutoFocusDirective autoFocusChild;

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

  @Output('expandedChange')
  Stream<bool> get isExpandedChange => _isExpandedChange.stream;
  final _isExpandedChange = new StreamController<bool>.broadcast(sync: true);

  @Output('expandedChangeByUser')
  Stream<bool> get isExpandedChangeByUserAction =>
      _isExpandedChangeByUserAction.stream;
  final _isExpandedChangeByUserAction =
      new StreamController<bool>.broadcast(sync: true);

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

  /// An optional glyph icon name to replace the expand arrows with a custom
  /// icon.
  ///
  /// If a custom icon is used, then the icon disappears when the panel is
  /// expanded. By default, the expand icon is "expand_less."
  String _expandIcon;
  String get expandIcon => _expandIcon ?? _defaultExpandIcon;

  @Input()
  set expandIcon(String expandIcon) => _expandIcon = expandIcon;

  /// If true, the expand icon should always be visible regardless whether a
  /// custom icon is used.
  @Input()
  bool alwaysShowExpandIcon = false;

  bool get hasCustomExpandIcon => expandIcon != _defaultExpandIcon;

  bool get shouldShowExpandIcon =>
      (hasCustomExpandIcon && isExpanded) ? alwaysShowExpandIcon : !disabled;

  bool get shouldFlipExpandIcon => hasCustomExpandIcon ? false : !isExpanded;

  bool get shouldShowHiddenHeaderExpandIcon =>
      hasCustomExpandIcon ? false : (hideExpandedHeader && !disabled);

  /// Option to set if widget should show save/cancel buttons `true` by default.
  @Input()
  bool showSaveCancel = true;

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

  String get _closePanelMsg => Intl.message('Close panel',
      name: '_closePanelMsg',
      desc: 'ARIA label for a button that closes the panel.');

  String get _openPanelMsg => Intl.message('Open panel',
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
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _closeController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _saveController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _cancelController =
      new StreamController<AsyncAction<bool>>.broadcast(sync: true);

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
      _managedZone.onTurnDone.first.then(([_]) {
        _expandCollapseButton?.focus();
      });
    }));
  }

  /// Button that expands or collapses the panel.
  ///
  /// It's either the header or the glyph icon in the content if
  /// [hideExpandedHeader] is set to `true`.
  ButtonDirective _expandCollapseButton;
  @ViewChild('expandCollapseButton', read: ButtonDirective)
  set expandCollapse(ButtonDirective button) {
    _expandCollapseButton = button;
  }

  Future<bool> expand({bool byUserAction: true}) {
    if (disabled && byUserAction) return new Future.value(false);
    return changeState(true, byUserAction, _openController);
  }

  Future<bool> collapse({bool byUserAction: true}) {
    if (disabled && byUserAction) return new Future.value(false);
    return changeState(false, byUserAction, _closeController);
  }

  Future<bool> doSave() {
    var actionCtrl = new AsyncActionController<bool>();
    _saveController.add(actionCtrl.action);
    _activeSaveCancelAction = true;
    _changeDetector.markForCheck();
    actionCtrl.execute(() {
      if (closeOnSave) {
        _isExpanded = false;
        _isExpandedChange.add(false);
        _isExpandedChangeByUserAction.add(false);
        _changeDetector.markForCheck();
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
    var actionCtrl = new AsyncActionController<bool>();
    _cancelController.add(actionCtrl.action);
    _activeSaveCancelAction = true;
    _changeDetector.markForCheck();
    actionCtrl.execute(() {
      _isExpanded = false;
      _isExpandedChange.add(false);
      _isExpandedChangeByUserAction.add(false);
      _changeDetector.markForCheck();
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
      return new Future.value(true);
    }
    var actionCtrl = new AsyncActionController<bool>();
    stream.add(actionCtrl.action);
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
      return true;
    }, valueOnCancel: false);
    return actionCtrl.action.onDone;
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
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
