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

import 'package:angular2/angular2.dart';

import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/async/async.dart';

import 'material_tab.dart';
import 'fixed_material_tab_strip.dart';
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
///       </my-panel>
///     </material-tab-panel>
// TODO(google): Support Scrolling tab strip in addition to fixed with an
// attribute.
@Component(
    selector: 'material-tab-panel',
    directives: const [FixedMaterialTabStripComponent],
    host: const {'class': 'themeable'},
    templateUrl: 'material_tab_panel.html',
    styleUrls: const ['material_tab_panel.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialTabPanelComponent implements AfterContentInit {
  final ChangeDetectorRef _changeDetector;

  /// Stream of [TabChangeEvent] instances, published before the tab has
  /// changed.
  ///
  /// Calling [TabChangeEvent#preventDefault] will prevent the tab from
  /// changing.
  @Output()
  final beforeTabChange = new LazyEventEmitter<TabChangeEvent>();

  /// Stream of [TabChangeEvent] instances, published when the tab has changed.
  @Output()
  final tabChange = new LazyEventEmitter<TabChangeEvent>();

  final ManagedZone _managedZone;

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

  MaterialTabPanelComponent(this._managedZone, this._changeDetector);

  @ContentChildren(Tab)
  QueryList<Tab> tabQuery;
  List<Tab> _tabs;
  Tab get _activeTab => _tabs[_activeTabIndex];

  List<String> _tabLabels;
  List<String> get tabLabels => _tabLabels;

  List<String> _tabIds;
  List<String> get tabIds => _tabIds;

  @override
  void ngAfterContentInit() {
    _managedZone.onTurnDone.first.then((_) {
      _tabs = new List.from(tabQuery);
      _tabLabels = _tabs.map((t) => t.label).toList();
      _tabIds = _tabs.map((t) => t.tabId).toList();

      _setActiveTab(_activeTabIndex, false);
    });
  }

  void _setActiveTab(int i, bool focusTab) {
    assert(i >= 0 && i < _tabs.length);
    _activeTab?.deactivate();
    _activeTabIndex = i;
    _activeTab.activate();
    _changeDetector.markForCheck();

    if (!focusTab) return;
    /// Focus at the end of the turn, as the tab panel element is not
    /// immediately available in the DOM to focus.
    _managedZone.onTurnDone.first.then((_) {
      _activeTab.focus();
    });
  }

  /// Fires beforeTabChange event.
  void onBeforeTabChange(TabChangeEvent e) {
    beforeTabChange.add(e);
  }

  /// Fires tabChange event.
  void onTabChange(TabChangeEvent e) {
    activeTabIndex = e.newIndex;
    tabChange.add(e);
  }
}
