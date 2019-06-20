// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/model/ui/accepts_width.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';

import 'material_list_size.dart';

export 'material_list_size.dart';

/// Material List is a container component for a set of items with which the
/// user is intended to interact.
///
/// It forms the basis for selection and menu components.
/// The `MaterialListComponent` class acts as the root node for a list
/// providing styling and the ability to collect item events.
///
/// __Attributes:__
///
/// - `size: string {x-small, small, medium, large, x-large}` Sizes for the
///   list, resulting in the width being 64px * {1.5, 3, 5, 6, 7} respectively.
///   The default size is "auto" which sizes the list to its contents.
/// - `min-size: string {x-small, small, medium, large, x-large}` Minimum size
///   for the list, resulting in the width at least the specified width.
@Component(
  selector: 'material-list',
  styleUrls: ['material_list.scss.css'],
  directives: [NgClass],
  template: '<ng-content></ng-content>',
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialListComponent implements AcceptsWidth {
  /// Preset width, 1 through 5. By default, the material list will expand to
  /// the full width of its parent.
  ///
  /// Note: The spec clearly lays out predefined
  /// list sizes so use the default, expanding size, sparingly.
  /// Each width multiplies the base block width (64px on desktop and tablet) by
  /// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
  /// Set to 0 to have the list expand to the full width of its parent.
  @HostBinding('attr.size')
  @Input()
  String size = MaterialListSize.auto;

  @Deprecated('Use size input instead.')
  @Input()
  set width(val) {
    val = getInt(val);
    if (val >= 0 && val < MaterialListSize.values.length) {
      size = MaterialListSize.values[val];
    }
  }

  /// Role to apply to the material-list.
  ///
  /// Defaults to 'list'
  @HostBinding('attr.role')
  @Input()
  String role = 'list';
}
