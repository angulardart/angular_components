// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';

import 'fixed_material_tab_strip.dart';
import 'material_tab.dart';
import 'tab_change_event.dart';

/// A component that creates a tab panel with navigation bar on the top.
///
/// Example usage:
///     <material-tab-panel>
///       <material-tab label="tab1">
///         <!-- your tab content -->
///       </material-tab>
///       <material-tab label="tab2">
///         <my-tab-panel-component *deferredContent>
///           <!-- your tab content -->
///         </my-tab-panel>
///       </material-tab>
///     </material-tab-panel>
// TODO(google): Support Scrolling tab strip in addition to fixed with an
// attribute.
@Component(
    selector: 'material-tab-panel',
    directives: const [FixedMaterialTabStripComponent],
    host: const {'class': 'themeable'},
    preserveWhitespace: false,
    templateUrl: 'material_tab_panel.html',
    styleUrls: const ['material_tab_panel.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialTabPanelComponent {
  final ChangeDetectorRef _changeDetector;

  /// Stream of [TabChangeEvent] instances, published before the tab has
  /// changed.
  ///
  /// Calling [TabChangeEvent#preventDefault] will prevent the tab from
  /// changing.
  @Output()
  Stream<TabChangeEvent> get beforeTabChange => _beforeTabChange.stream;
  final _beforeTabChange =
      new StreamController<TabChangeEvent>.broadcast(sync: true);

  /// Stream of [TabChangeEvent] instances, published when the tab has changed.
  @Output()
  Stream<TabChangeEvent> get tabChange => _tabChange.stream;
  final _tabChange = new StreamController<TabChangeEvent>.broadcast(sync: true);

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

  @ContentChildren(Tab)
  set tabs(QueryList<Tab> tabQuery) {
    _tabs = new List.from(tabQuery);
    _tabLabels = _tabs.map((t) => t.label).toList();
    _tabIds = _tabs.map((t) => t.tabId).toList();

    // Setting the active tab needs to happen in the next turn as it is changing
    // the state of the tab.
    scheduleMicrotask(() {
      _setActiveTab(_activeTabIndex, false);
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
