// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

/// A "chip" widget renders an object in the 'chip' format - a rounded box with
/// a shadow, typically used in a horizontal list. Any object implementing the
/// `HasUIDisplayName` interface can be used, or no object at all.
///
/// The delete button is only shown when a selectionModel is set on the widget
/// or a removable property is true.
/// When hasLeftIcon is true, the left-icon content should be set to a
/// `MaterialIconComponent` or an SVG image.
/// Chip components are rendered in a `material-chips` component.
@Component(
  selector: 'material-chip',
  providers: [ExistingProvider(HasRenderer, MaterialChipComponent)],
  templateUrl: 'material_chip.html',
  styleUrls: ['material_chip.scss.css'],
  directives: [ButtonDirective, NgIf],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialChipComponent<T> extends RootFocusable implements HasRenderer<T> {
  @HostBinding('class')
  static const hostClass = 'themeable';

  MaterialChipComponent(Element root) : super(root);

  static final chipDeleteButtonMessage = Intl.message('Delete',
      name: 'chipDeleteButtonMessage',
      desc: 'Label for a button which removes the item when clicked.',
      meaning: 'Label for a button which removes the item when clicked.');

  /// Aria label for delete button.
  @Input()
  String deleteButtonAriaMessage = chipDeleteButtonMessage;

  /// A selection model to render as chips.
  ///
  /// This model should not be used for rendering, changes will not be
  /// reflected.
  ///
  /// Chips can be deselected from the model via user interaction unless
  /// `removable` is set to false.
  @Input()
  SelectionModel<T> selectionModel;

  /// Whether the chip should show remove button, default to true.
  @Input()
  bool removable = true;

  /// Whether the chip should show the custom icon, default to false.
  @Input()
  bool hasLeftIcon = false;

  /// An `ItemRenderer` function (takes an object and returns a string).
  ///
  /// If ItemRenderer is not state-less, and may return different values for
  /// the same input item, then the ItemRenderer reference needs to update, or
  /// that change will not be reflected.
  ///
  /// When provided, it is used to generate a label for the chip.
  @Input()
  @override
  set itemRenderer(ItemRenderer<T> value) {
    _itemRenderer = value;
    _genLabel();
  }

  ItemRenderer<T> _itemRenderer = nullRenderer;
  @override
  ItemRenderer<T> get itemRenderer => _itemRenderer;

  /// Data model to render.
  ///
  /// Provide your own label in the content of the chip, or provide an
  /// [ItemRenderer].
  @Input()
  set value(val) {
    _value = val;
    _genLabel();
  }

  dynamic _value;
  dynamic get value => _value;

  // Generates and stashes the item's label.
  void _genLabel() {
    if (_value == null) {
      _label = null;
    } else if (!identical(_itemRenderer, nullRenderer)) {
      _label = itemRenderer(_value);
    }
  }

  String _label;
  String get label => _label;

  /// Event fired when the chip is removed which returns the value of the chip.
  @Output()
  Stream get remove => _remove.stream;
  final _remove = StreamController<dynamic>(sync: true);

  void removeChip(/* MouseEvent | KeyboardEvent */ event) {
    selectionModel?.deselect(value);
    _remove.add(value);
    event.preventDefault();
    event.stopPropagation();
  }

  String _uuid;
  String get uuid {
    if (_uuid == null) {
      _uuid = _idGenerator.nextId();
    }
    return _uuid;
  }
}

final _idGenerator = SequentialIdGenerator.fromUUID();
