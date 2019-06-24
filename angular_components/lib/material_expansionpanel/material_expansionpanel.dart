// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/angular/id/id.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposable_callback.dart';
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
///  - `forceContentWhenClosed` -- Keeps expansion panel content in the DOM when
///    the expansion panel is closed. This should only be used in rare
///    circumstances.
///
/// __Content Reference:__
///
/// - `focusOnOpen` -- Mark a Focusable or DOM element with #focusOnOpen in the
///   content to have that item be focused when the expansion panel opens.
///
@Component(
  selector: 'material-expansionpanel',
  directives: [
    AutoIdDirective,
    ButtonDirective,
    DeferredContentDirective,
    MaterialIconComponent,
    MaterialSaveCancelButtonsDirective,
    MaterialYesNoButtonsComponent,
    NgIf,
    EnterAcceptsDirective,
    KeyboardOnlyFocusIndicatorDirective,
    KeyUpBoundaryDirective
  ],
  providers: [
    ExistingProvider(DeferredContentAware, MaterialExpansionPanel),
    ExistingProvider(HasDisabled, MaterialExpansionPanel),
    ExistingProvider(FocusableItem, MaterialExpansionPanel),
    ExistingProvider(Focusable, MaterialExpansionPanel),
  ],
  templateUrl: 'material_expansionpanel.html',
  styleUrls: ['material_expansionpanel.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  visibility: Visibility.all, // injected
)
class MaterialExpansionPanel
    implements
        DeferredContentAware,
        HasDisabled,
        OnInit,
        OnDestroy,
        FocusableItem {
  final NgZone _ngZone;
  final ChangeDetectorRef _changeDetector;
  final DomService _domService;
  final _disposer = Disposer.oneShot();
  final _defaultExpandIcon = 'expand_less';
  final bool shouldExpandOnLeft;
  final bool forceContentWhenClosed;
  final _pendingExpandedPanelHeightReads = <Completer<String>>[];

  bool initialized = false;

  MaterialExpansionPanel(
      this._ngZone,
      this._changeDetector,
      this._domService,
      @Attribute('shouldExpandOnLeft') String expandOnLeft,
      @Attribute('forceContentWhenClosed') String forceContent)
      : shouldExpandOnLeft = expandOnLeft != null,
        forceContentWhenClosed = forceContent != null;

  /// Set the auto focus child so that we can focus on it when the panel opens.
  ///
  /// Unfortunately, this only selects the first [AutoFocusDirective] in the
  /// contents of the expansion panel, which means that if there is another
  /// [AutoFocusDirective] in an <ng-content> that is not the .content, that
  /// will get focused instead of the [AutoFocusDirective] inside the .content.
  @visibleForTemplate
  @ContentChild(AutoFocusDirective)
  AutoFocusDirective autoFocusChild;

  Focusable _focusOnOpenChild;

  /// Sets the focus child so that we can focus on it when the panel opens.
  @ContentChild('focusOnOpen')
  @Input('focusOnOpen')
  set focusOnOpenChild(dynamic element) {
    if (element is Focusable) {
      _focusOnOpenChild = element;
    } else if (element is ElementRef) {
      _focusOnOpenChild = RootFocusable(element.nativeElement);
    } else {
      assert(
          element == null,
          'Warning expansion panel content has a #focus'
          'child which is not an Element, or Focusable');
    }
  }

  HtmlElement _mainPanel;
  @ViewChild('mainPanel')
  set mainPanel(HtmlElement mainPanel) {
    _mainPanel = mainPanel;
    _ngZone.runOutsideAngular(() {
      _disposer.addStreamSubscription(_mainPanel.onTransitionEnd
          .where((e) => e.eventPhase == Event.AT_TARGET)
          .listen((_) {
        // Clear height override so it will match the active child's height.
        _mainPanel.style.height = '';
        // If we just finished closing, let deferred content stop rendering
        // the panel body.
        if (!isExpanded) {
          _ngZone.run(() => _contentVisible.add(false));
        }
      }));
    });

    final transitionCheck = DisposableCallback(() {
      // If we don't have a transition (because style mixins/overrides/disabled
      // in tests) just forward the isExpanded change event so deferredContent
      // can disappear.
      if (!_mainPanelHasHeightTransition) {
        _disposer.addStreamSubscription(isExpandedChange.listen((expanded) {
          // Just check for false (closed). Open (true) is always done first.
          if (!expanded) _contentVisible.add(false);
        }));
      }
    });
    _domService.scheduleRead(transitionCheck);
    _disposer.addDisposable(transitionCheck);
  }

  HtmlElement _headerPanel;
  @ViewChild('headerPanel')
  set headerPanel(HtmlElement headerPanel) {
    _headerPanel = headerPanel;
    _ngZone.runOutsideAngular(() {
      _disposer.addStreamSubscription(_headerPanel.onTransitionEnd
          .where((e) => e.eventPhase == Event.AT_TARGET)
          .listen((_) {
        // Clear height override so it will match the active child's height.
        _headerPanel.style.height = '';
      }));
    });
  }

  HtmlElement _mainContent;
  @ViewChild('mainContent')
  set mainContent(HtmlElement mainContent) {
    _mainContent = mainContent;
    if (_mainContent == null) return;
    _completeExpandedPanelHeightReadsIfPossible();
  }

  void _completeExpandedPanelHeightReadsIfPossible() {
    if (_mainContent == null || _contentWrapper == null) return;
    if (_pendingExpandedPanelHeightReads.isNotEmpty) {
      var height = _readMainContentHeight();
      for (var completer in _pendingExpandedPanelHeightReads) {
        completer.complete(height);
      }
      _pendingExpandedPanelHeightReads.clear();
    }
  }

  HtmlElement _headerContent;
  @ViewChild('headerContent')
  set headerContent(HtmlElement headerContent) =>
      _headerContent = headerContent;

  HtmlElement _actionContent;
  @ViewChild('action')
  set actionContent(HtmlElement headerContent) =>
      _actionContent = headerContent;

  HtmlElement _contentWrapper;
  @ViewChild('contentWrapper')
  set contentWrapper(HtmlElement contentWrapper) {
    _contentWrapper = contentWrapper;
    _completeExpandedPanelHeightReadsIfPossible();
  }

  /// If true, after a successful save, the panel will attempt to close.
  @Input()
  bool closeOnSave = true;

  final ObservableReference<bool> _isExpanded = ObservableReference(false);
  bool get isExpanded => _isExpanded.value;

  /// If true, the panel is expanded by default, if false, the panel is closed.
  @Input('expanded')
  set isExpanded(bool value) {
    if (value == isExpanded) return;
    if (value) {
      expand(byUserAction: false);
    } else {
      collapse(byUserAction: false);
    }
  }

  /// Event fired when the panel is either collapsed or expanded.
  @Output('expandedChange')
  Stream<bool> get isExpandedChange => _isExpanded.stream;

  /// Event fired when the panel is collapsed or expanded by the user.
  @Output('expandedChangeByUser')
  Stream<bool> get isExpandedChangeByUserAction =>
      _isExpandedChangeByUserAction.stream;
  final _isExpandedChangeByUserAction =
      StreamController<bool>.broadcast(sync: true);

  @override
  Stream<bool> get contentVisible => _contentVisible.stream;
  final _contentVisible = StreamController<bool>.broadcast(sync: true);

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

  String _groupAriaLabel;

  /// Aria label used to describe the header.
  @Input()
  set groupAriaLabel(String groupAriaLabel) {
    _groupAriaLabel = groupAriaLabel;
  }

  String get groupAriaLabel => _groupAriaLabel == null ? name : _groupAriaLabel;

  /// Level of the heading.
  ///
  /// If null, the heading will not have role="heading".
  @Input()
  int headerAriaLevel;

  @visibleForTemplate
  String get headerRole => headerAriaLevel == null ? 'none' : 'heading';

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

  String get closePanelMsg => groupAriaLabel == null && name == null
      ? _closePanelMsg
      : _namedPanelMsg(groupAriaLabel);

  String get openPanelMsg => groupAriaLabel == null && name == null
      ? _openPanelMsg
      : _namedPanelMsg(groupAriaLabel);

  String get headerMsg {
    if (disabled || _groupAriaLabel != null) {
      return groupAriaLabel;
    } else {
      return isExpanded ? closePanelMsg : openPanelMsg;
    }
  }

  static final _closePanelMsg = Intl.message('Hide panel',
      name: '_closePanelMsg',
      desc: 'ARIA label for a button that hides the panel.');

  static final _openPanelMsg = Intl.message('Show panel',
      name: '_openPanelMsg',
      desc: 'ARIA label for a button that shows the panel.');

  String _namedPanelMsg(String panelName) => Intl.message('$panelName panel',
      name: '_namedPanelMsg',
      args: [panelName],
      desc: 'ARIA label for a button that shows or hides the panel.',
      examples: const {'panelName': 'Conversions'});

  static final expandAriaMsg = Intl.message('Expand',
      desc: 'Aria label used for the button used to expand the panel.');

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

  @override
  void focus() {
    _expandCollapseButton?.focus();
  }

  final _focusMoveCtrl = StreamController<FocusMoveEvent>.broadcast(sync: true);
  @override
  Stream<FocusMoveEvent> get focusmove => _focusMoveCtrl.stream;

  @HostListener('keydown')
  void keydown(KeyboardEvent event) {
    var focusEvent = FocusMoveEvent.fromKeyboardEvent(this, event);
    if (focusEvent != null) {
      _focusMoveCtrl.add(focusEvent);
    }
  }

  @override
  set tabbable(bool value) {
    // We don't implement this as we still want the individual panels to be
    // tabbable.
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
        _isExpanded.value = false;
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
      _isExpanded.value = false;
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
    if (isExpanded == expand) {
      return Future.value(true);
    }
    var actionCtrl = AsyncActionController<bool>();
    stream.add(actionCtrl.action);
    var stateWasInitialized = initialized;
    actionCtrl.execute(() {
      // Update our state before redrawing. State changes need to occur before
      // follow ups (animation or autofocus) so that styles and deferred content
      // can update.
      _isExpanded.value = expand;
      if (expand) _contentVisible.add(true);
      if (byUserAction) _isExpandedChangeByUserAction.add(expand);
      _changeDetector.markForCheck();
      if (expand) {
        _domService.scheduleWrite(() {
          if (autoFocusChild != null) {
            autoFocusChild.focus();
          } else if (byUserAction && _focusOnOpenChild != null) {
            _focusOnOpenChild.focus();
          }
        });
      }
      if (stateWasInitialized) _transitionHeightChange(expand);
      return true;
    }, valueOnCancel: false);
    return actionCtrl.action.onDone;
  }

  bool get headerHidden => isExpanded && hideExpandedHeader;

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

    // If the header has to disappear, animate that transition as well
    if (hideExpandedHeader) {
      // Make current height explicit as a starting point for animation.
      _headerPanel.style.height = '${_headerPanel.scrollHeight}px';

      // On next frame, set target height for animation.
      if (expand) {
        _domService.nextFrame.then((_) {
          _headerPanel.style.height = '';
        });
      } else {
        _readExpandedHeaderHeight().then((expandedHeaderHeight) {
          _headerPanel.style.height = expandedHeaderHeight;
        });
      }
    }
  }

  /// Reads the DOM state to calculate the height of the "expanded" panel in its
  /// current condition.
  ///
  /// This defined end point will be used to animate expansion.
  Future<String> _readExpandedPanelHeight() {
    final completeExpandedHeight = Completer<String>();

    _domService.scheduleRead(() {
      if (_mainContent != null && _contentWrapper != null) {
        completeExpandedHeight.complete(_readMainContentHeight());
      } else {
        _pendingExpandedPanelHeightReads.add(completeExpandedHeight);
      }
    });

    return completeExpandedHeight.future;
  }

  String _readMainContentHeight() {
    final contentHeight = _mainContent.scrollHeight;
    var expandedPanelHeight = '';

    // Do our best to make sure that onTransitionEnd will fire later.
    final hasHeightTransition =
        contentHeight > 0 && _mainPanelHasHeightTransition;

    if (hasHeightTransition) {
      // If the content-wrapper has a top margin, it is not reflected in the
      // scroll height.
      final topMargin = _contentWrapper.getComputedStyle().marginTop;
      expandedPanelHeight = 'calc(${contentHeight}px + ${topMargin})';
    }
    return expandedPanelHeight;
  }

  bool get _mainPanelHasHeightTransition {
    final mainPanelStyle = _mainPanel.getComputedStyle();
    // Do our best to make sure that onTransitionEnd will fire later.
    return mainPanelStyle.transition.contains('height');
  }

  /// Reads the DOM state to calculate the height of the header in its
  /// current condition.
  ///
  /// This defined end point will be used to animate expansion.
  Future<String> _readExpandedHeaderHeight() {
    final completeExpandedHeight = Completer<String>();

    _domService.scheduleRead(() {
      final contentHeight =
          max(_headerContent.scrollHeight, _actionContent?.scrollHeight ?? 0);
      var expandedHeaderHeight = '';

      final headerPanelStyle = _headerPanel.getComputedStyle();
      // Do our best to make sure that onTransitionEnd will fire later.
      final hasHeightTransition =
          contentHeight > 0 && headerPanelStyle.transition.contains('height');

      if (hasHeightTransition) expandedHeaderHeight = '${contentHeight}px';

      completeExpandedHeight.complete(expandedHeaderHeight);
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
