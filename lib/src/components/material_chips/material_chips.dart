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

import './material_chip.dart';
import '../../model/selection/selection_model.dart';
import '../../model/ui/has_renderer.dart';
import '../../utils/disposer/disposer.dart';

/// A __chips__ collection widget, displaying a list of objects as Chips.
///
/// __Example usage:__
///
///     <!-- Selection Model -->
///     <material-chips selectionModel="mySelectedChips">
///     </material-chips>
///
///
///     <!-- Static Chips -->
///     <material-chips>
///       <material-chip>My Chip</material-chip>
///       <material-chip>Another Chip</material-chip>
///     </material-chips>
///
@Component(
    selector: 'material-chips',
    providers: const [
      const Provider(HasRenderer, useExisting: MaterialChipsComponent)
    ],
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
  //  TODO(tsander): update this to be selection, not selectionModel, in order
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
  set itemRenderer(ItemRenderer value) {
    _itemRenderer = value;
  }

  ItemRenderer _itemRenderer = _defaultItemRenderer;
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
