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

import '../annotations/rtl_annotation.dart';
import '../focus/focus_item.dart';
import '../focus/focus_list.dart';
import '../../utils/async/async.dart';

import 'src/tab_button.dart';
import 'tab_change_event.dart';

/// A tab strip component with Tab-styled buttons and active tab indicator.
///
/// This is the Fixed tab strip from the material spec which has equal sized
/// tab buttons, and no scrolling.
///
/// Note: To achieve a quality user experience, users of the tab strip must
/// set focus to newly revealed content so that 1) the tab does not retain the
/// focus style, and 2) screen-readers can reckon what has changed.
@Component(
    selector: 'material-tab-strip',
    directives: const [
      FocusListDirective,
      FocusItemDirective,
      TabButtonComponent,
      NgFor
    ],
    host: const {
      'class': 'themeable',
      'role': 'tablist',
      'aria-multiselectable': 'false'
    },
    templateUrl: 'fixed_material_tab_strip.html',
    styleUrls: const ['fixed_material_tab_strip.scss.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class FixedMaterialTabStripComponent {
  final int _transitionAmount;
  final ChangeDetectorRef _changeDetector;
  int _activeTabIndex = 0;
  String _tabIndicatorTransform;
  List<String> _tabLabels;

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

  /// Index of the active panel, 0-based.
  ///
  /// Default is 0.
  @Input()
  set activeTabIndex(int value) {
    if (_activeTabIndex != value) {
      _activeTabIndex = value;
      _updateTabIndicatorTransform();
      _changeDetector.markForCheck();
    }
  }

  int get activeTabIndex => _activeTabIndex;

  /// List of tab button labels.
  @Input()
  set tabLabels(List<String> labels) {
    _tabLabels = labels;
    _updateTabIndicatorTransform();
  }

  List<String> get tabLabels => _tabLabels;

  /// List of tab button ids.
  @Input()
  List<String> tabIds;

  FixedMaterialTabStripComponent(
      this._changeDetector, @Optional() @Inject(rtlToken) bool isRtl)
      : _transitionAmount = _calculateTransitionAmount(isRtl ?? false) {
    _updateTabIndicatorTransform();
  }

  static int _calculateTransitionAmount(bool isRtl) {
    return isRtl ? -100 : 100;
  }

  String get tabIndicatorTransform => _tabIndicatorTransform;

  void switchTo(int index) {
    if (index == activeTabIndex) return;
    var event = new TabChangeEvent(activeTabIndex, index);
    beforeTabChange.add(event);
    if (event.defaultPrevented) return;
    activeTabIndex = index;
    tabChange.add(event);
  }

  String activeStr(int index) {
    return '${activeTabIndex == index}';
  }

  String tabId(int index) => tabIds?.elementAt(index);

  void _updateTabIndicatorTransform() {
    var width = _tabLabels != null ? 1 / _tabLabels.length : 0;
    var location = _activeTabIndex * width * _transitionAmount;
    _tabIndicatorTransform = 'translateX($location%) scaleX($width)';
  }
}
