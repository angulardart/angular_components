// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/material_tab/fixed_material_tab_strip.dart';
import 'package:angular_components/material_tab/material_tab.dart';
import 'package:angular_components/material_tab/tab_change_event.dart';

/// A component that creates a tab panel with navigation bar on the top.
// TODO(google): Support Scrolling tab strip in addition to fixed with an
// attribute.
@Component(
  selector: 'material-tab-panel',
  directives: [FixedMaterialTabStripComponent],
  templateUrl: 'material_tab_panel.html',
  styleUrls: ['material_tab_panel.scss.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialTabPanelComponent implements AfterContentInit {
  @HostBinding('class')
  static const hostClass = 'themeable';

  final ChangeDetectorRef _changeDetector;
  bool _initialized = false;
  Tab _previousActiveTab;

  /// Stream of [TabChangeEvent] instances, published before the tab has
  /// changed.
  ///
  /// Calling [TabChangeEvent#preventDefault] will prevent the tab from
  /// changing.
  @Output()
  Stream<TabChangeEvent> get beforeTabChange => _beforeTabChange.stream;
  final _beforeTabChange =
      StreamController<TabChangeEvent>.broadcast(sync: true);

  /// Stream of [TabChangeEvent] instances, published when the tab has changed.
  @Output()
  Stream<TabChangeEvent> get tabChange => _tabChange.stream;
  final _tabChange = StreamController<TabChangeEvent>.broadcast(sync: true);

  /// Whether to center-align the tab buttons.
  ///
  /// Otherwise, buttons are aligned from the left end (LTR).
  @Input()
  bool centerTabs = false;

  /// Index of the active panel, 0-based.
  ///
  /// Default is 0.
  @Input()
  set activeTabIndex(index) {
    // Tabs are already initialized; this is a programmatic tab change.
    if (_tabs != null) {
      _setActiveTab(index, true);
    } else {
      // Tab buttons are not initialized; this is the initial value being set.
      _activeTabIndex = index;
    }
  }

  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  MaterialTabPanelComponent(this._changeDetector);

  @override
  void ngAfterContentInit() {
    _initialized = true;
    _initTabs();
  }

  @ContentChildren(Tab)
  set tabs(List<Tab> tabs) {
    _previousActiveTab = (_tabs != null) ? _activeTab : null;
    _tabs = tabs;
    // TODO(google): Remove if setting of content children occur after
    // child is initialized.
    if (_initialized) _initTabs();
  }

  void _initTabs() {
    _tabLabels = _tabs.map((t) => t.label).toList();
    _tabIds = _tabs.map((t) => t.tabId).toList();

    // Setting the active tab needs to happen in the next turn as it is changing
    // the state of the tab.
    scheduleMicrotask(() {
      _changeDetector.markForCheck(); // call early so we can return early.
      // Look for the previously active tab.
      if (_previousActiveTab != null) {
        _activeTabIndex = _tabs.indexOf(_previousActiveTab);
        _previousActiveTab = null;
        if (_activeTabIndex == -1) {
          // Couldn't find previous tab. Just activate the first tab.
          _activeTabIndex = 0;
        } else {
          // The previous tab was found. No need to activate it as it is active.
          return;
        }
      }
      _activeTab.activate();
    });
  }

  List<Tab> _tabs;
  Tab get _activeTab => _tabs[_activeTabIndex];

  List<String> _tabLabels;
  List<String> get tabLabels => _tabLabels;

  List<String> _tabIds;
  List<String> get tabIds => _tabIds;

  void _setActiveTab(int i, bool focusTab) {
    assert(i >= 0 && i < _tabs.length);
    _activeTab?.deactivate();
    _activeTabIndex = i;
    _activeTab.activate();
    _changeDetector.markForCheck();

    if (!focusTab) return;
    _activeTab.focus();
  }

  /// Fires beforeTabChange event.
  void onBeforeTabChange(TabChangeEvent e) {
    _beforeTabChange.add(e);
  }

  /// Fires tabChange event.
  void onTabChange(TabChangeEvent e) {
    activeTabIndex = e.newIndex;
    _tabChange.add(e);
  }
}
