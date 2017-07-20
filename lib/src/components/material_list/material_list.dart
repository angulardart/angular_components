// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import '../../model/ui/accepts_width.dart';
import '../../utils/angular/properties/properties.dart';

import 'material_list_size.dart';

export 'material_list_size.dart';

/// Material List is a container component for a set of items with which the
/// user is intended to interact.
///
/// It forms the basis for selection and menu components.
/// The `MaterialListComponent` class acts as the root node for a list
/// providing styling and the ability to collect item events.
///
///
/// __Example usage:__
///     <material-list size="medium">
///       <material-list-item>Item 1</material-list-item>
///       <material-list-item>Item 2</material-list-item>
///     </material-list>
///
/// ## List Item Grouping
///
/// Wrap `material-list-item` elements in a container with attribute
/// `group` for a divider line between other groupings.
///
///     <material-list>
///       <div group>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///       </div>
///       <material-list-item>Item</material-list-item>
///       <material-list-item>Item</material-list-item>
///       <div group>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///       </div>
///     <material-list>
///
/// ## List Item Group Labels
///
/// Denote the label for a list item group using the `label` attribute.
///
///     <material-list>
///       <div group>
///         <div label>My Menu Group</div>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///         <material-list-item>Item</material-list-item>
///       </div>
///     </material-list>
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
    styleUrls: const ['material_list.scss.css'],
    directives: const [NgClass],
    host: const {'[attr.size]': 'size'},
    template: '<ng-content></ng-content>',
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialListComponent implements AcceptsWidth {
  @Input()
  String size = MaterialListSize.auto;

  /// Preset width, 1 through 5. By default, the material list will expand to
  /// the full width of its parent. Note: The spec clearly lays out predefined
  /// list sizes so use the default, expanding size, sparingly.
  /// Each width multiplies the base block width (64px on desktop and tablet) by
  /// [1.5, 3, 5, 6, 7], respectively to obtain a predictable width.
  /// Set to 0 to have the list expand to the full width of its parent.
  @Deprecated('Use size attribute instead.')
  @Input()
  set width(val) {
    val = getInt(val);
    if (val >= 0 && val < MaterialListSize.values.length) {
      size = MaterialListSize.values[val];
    }
  }
}
