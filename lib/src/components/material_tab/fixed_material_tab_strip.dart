// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import '../annotations/rtl_annotation.dart';
import '../focus/focus_item.dart';
import '../focus/focus_list.dart';

import 'tab_button.dart';
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
    },
    preserveWhitespace: false,
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
  Stream<TabChangeEvent> get beforeTabChange => _beforeTabChange.stream;
  final _beforeTabChange =
      new StreamController<TabChangeEvent>.broadcast(sync: true);

  /// Stream of [TabChangeEvent] instances, published when the tab has changed.
  @Output()
  Stream<TabChangeEvent> get tabChange => _tabChange.stream;
  final _tabChange = new StreamController<TabChangeEvent>.broadcast(sync: true);

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
    _beforeTabChange.add(event);
    if (event.defaultPrevented) return;
    activeTabIndex = index;
    _tabChange.add(event);
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
