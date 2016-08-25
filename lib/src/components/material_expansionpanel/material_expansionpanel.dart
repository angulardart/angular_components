// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';

import '../button_decorator/button_decorator.dart';
import '../content/deferred_content_aware.dart';
import '../glyph/glyph.dart';
import '../material_yes_no_buttons/material_yes_no_buttons.dart';
import '../../model/action/async_action.dart';
import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/angular/properties/properties.dart';
import '../../utils/async/async.dart';
import '../../utils/disposer/disposer.dart';

/// A material-styled expansion-panel.
///
/// One or more panels are grouped together in a expansion-panel-set. When a
/// panel is clicked on, it expands into an expansion drawer. A panel consists
/// of a name, a value, optional secondary text, and the expanded drawer
/// contents.
///
/// Content element with attribute `value` will be used as the "value" of the
/// panel contents when it is in a collapsed state
///
/// Interactions with a panel are done through the parent expansion-set. The set
/// takes into account the state of the other panels in the set, and issues the
/// appropriate actions onto each individual panel.
///
/// TODO(ananthmohan): Keyboard/accessibility inputs
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
    ],
    providers: const [
      const Provider(DeferredContentAware, useExisting: MaterialExpansionPanel)
    ],
    templateUrl: 'material_expansionpanel.html',
    styleUrls: const ['material_expansionpanel.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialExpansionPanel
    implements DeferredContentAware, OnInit, OnDestroy {
  final ManagedZone _managedZone;
  final ChangeDetectorRef _changeDetector;
  final _disposer = new Disposer.oneShot();

  MaterialExpansionPanel(this._managedZone, this._changeDetector);

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
  final isExpandedChange = new LazyEventEmitter<bool>.broadcast();

  @Output('expandedChangeByUser')
  final isExpandedChangeByUserAction = new LazyEventEmitter<bool>.broadcast();

  @override
  LazyEventEmitter<bool> get contentVisible => isExpandedChange;

  /// Whether a different panel in the set is currently expanded.
  ///
  /// This determines the color of the panel.
  bool anotherExpanded = false;

  bool _disabled = false;
  bool get disabled => _disabled;

  /// If true, the panel will remain in the collapsed state with no way to
  /// expand it, or if expanded by default, it will stay in expanded state.
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
  }

  // Whether there is an in-progress action from the save/cancel buttons
  bool _activeSaveCancelAction = false;
  bool get activeSaveCancelAction => _activeSaveCancelAction;

  /// If true, The header which displays the name of the panel is hidden when
  /// the panel is expanded.
  @Input()
  bool hideExpandedHeader = false;

  /// A short name label for the expansion panel.
  @Input()
  String name;

  /// Some optional secondary summary text that describes the state of the
  /// widget hosted inside the panel
  @Input()
  String secondaryText;

  /// Option to set if widget should show save/cancel buttons `true` by default
  @Input()
  bool showSaveCancel = true;

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

  String get closeDrawerMsg => Intl.message('Close drawer',
      name: 'closeDrawerMsg',
      meaning: 'Button to close the expansion panel drawer',
      desc: 'Aria label for an icon that closes the drawer');

  String get _openDrawerMsg => Intl.message('Open drawer',
      name: '_openDrawerMsg',
      meaning: 'Button to open the expansion panel drawer.',
      desc: 'Aria label for a button that opening the drawer.');

  String get headerMsg => _isExpanded ? closeDrawerMsg : _openDrawerMsg;

  final _openController =
      new LazyStreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _closeController =
      new LazyStreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _saveController =
      new LazyStreamController<AsyncAction<bool>>.broadcast(sync: true);
  final _cancelController =
      new LazyStreamController<AsyncAction<bool>>.broadcast(sync: true);

  /// Event fired when drawer is trying to close.
  ///
  /// This action may be cancelled.
  @Output()
  Stream<AsyncAction<bool>> get close => _closeController.stream;

  /// Event fired when drawer is trying to open.
  ///
  /// This action may be cancelled.
  @Output()
  Stream<AsyncAction<bool>> get open => _openController.stream;

  /// Event fired when drawer is saved.
  @Output()
  Stream<AsyncAction<bool>> get save => _saveController.stream;

  /// Event fired when drawer is cancelled.
  @Output()
  Stream<AsyncAction<bool>> get cancel => _cancelController.stream;

  @override
  void ngOnInit() {
    // We only focus on the relevant button when the expanded state is changed
    // by user action.
    _disposer.addStreamSubscription(isExpandedChangeByUserAction.listen((_) {
      // Wait for the button reference to be set after change detection is done
      // and buttonDirective is created.
      _managedZone.onTurnDone.first.then(([_]) {
        _expandCollapseButton.focus();
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
    if (disabled) return new Future.value(false);
    return changeState(true, byUserAction, _openController);
  }

  Future<bool> collapse({bool byUserAction: true}) {
    if (disabled) return new Future.value(false);
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
        isExpandedChange.add(false);
        isExpandedChangeByUserAction.add(false);
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
      isExpandedChange.add(false);
      isExpandedChangeByUserAction.add(false);
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
      isExpandedChange.add(expand);
      if (byUserAction) isExpandedChangeByUserAction.add(expand);
      _changeDetector.markForCheck();
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
