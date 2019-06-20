// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:quiver/strings.dart' show isBlank;
import 'package:angular_components/utils/angular/properties/properties.dart'
    show getInt;

/// Provides computation of tabindex for components which actively maintain
/// a tab index.
///
/// Use this if your component needs to suppress its tab index when disabled but
/// you want to support a custom tab index via host element.
abstract class HasTabIndex {
  String get hostTabIndex => '0';
  bool get disabled;

  String _tabIndex;

  /// Use this method if you want to manually compute and cache the tab index.
  void updateTabIndex() {
    _tabIndex = _computeTabIndex();
  }

  @HostBinding('attr.tabindex')
  String get tabIndex => _tabIndex ?? _computeTabIndex();

  String _computeTabIndex() {
    if (disabled) {
      return '-1';
    } else if (hostTabIndex == null) {
      return null;
    } else if (!isBlank(hostTabIndex)) {
      assert(getInt(hostTabIndex) != null);
      return hostTabIndex;
    }
    throw 'Host tabIndex should either be null or a value';
  }
}
