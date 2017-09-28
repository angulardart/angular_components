// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../model/selection/selection_model.dart';
import '../../model/ui/has_renderer.dart';
import '../../utils/disposer/disposer.dart';
import './material_chip.dart';

/// A __chips__ collection widget, displaying a list of objects as Chips.
///
/// __Example usage:__
///
///     <!-- Selection Model -->
///     <material-chips [selectionModel]="mySelectedChips">
///     </material-chips>
///
///
///     <!-- Static Chips -->
///     <material-chips>
///       <material-chip>My Chip</material-chip>
///       <material-chip>Another Chip</material-chip>
///     </material-chips>
///
/// __Inputs:__
///
/// - `itemRenderer: ItemRenderer` -- A rendering function to render selection
///    models as a string.
/// - `removeable` -- Whether the chips can be removed.
/// - `selectionModel: SelectionModel` -- The selection model this component
///   controls.
@Component(
    selector: 'material-chips',
    providers: const [
      const Provider(HasRenderer, useExisting: MaterialChipsComponent)
    ],
    preserveWhitespace: false,
    templateUrl: 'material_chips.html',
    styleUrls: const ['material_chips.scss.css'],
    directives: const [MaterialChipComponent, NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush)
class MaterialChipsComponent implements HasRenderer, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final Disposer _disposer = new Disposer.multi();

  /// Whether the chips can be removed.
  @Input()
  bool removable = true;

  /// The list of `HasUIDisplayName` objects to render.
  //  TODO(google): update this to be selection, not selectionModel, in order
  //  to match SelectionModel properties from other components
  SelectionModel _selectionModel = const SelectionModel();

  @Input()
  set selectionModel(SelectionModel model) {
    _selectionModel = model;
    _disposer
      ..dispose()
      ..addDisposable(_selectionModel.selectionChanges.listen((_) {
        _changeDetector.markForCheck();
      }));
  }

  SelectionModel get selectionModel => _selectionModel;

  ///  A function to render items as a string.
  ///
  /// Note: this `ItemRenderer` is only used when a `SelectionModel` is also
  /// provided. If chips are manually rendered, the `itemRenderer` property will
  /// also need to be manually set on them.
  ///
  /// Note about OnPush: If `ItemRenderer` is not a pure function and has
  /// internal state that may render the same item differently, the reference
  /// itself must change in order to take effect.
  @Input()
  @override
  set itemRenderer(ItemRenderer value) {
    _itemRenderer = value;
  }

  ItemRenderer _itemRenderer = _defaultItemRenderer;
  @override
  ItemRenderer get itemRenderer => _itemRenderer;

  Iterable get selectedItems => selectionModel.selectedValues;

  /// Default item renderer if none is provided by the user of this widget.
  static String _defaultItemRenderer(Object value) => value?.toString();

  MaterialChipsComponent(this._changeDetector);

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
