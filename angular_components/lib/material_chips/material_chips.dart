// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/material_chips/material_chip.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A __chips__ collection widget, displaying a list of objects as Chips.
@Component(
  selector: 'material-chips',
  providers: [ExistingProvider(HasRenderer, MaterialChipsComponent)],
  templateUrl: 'material_chips.html',
  styleUrls: ['material_chips.scss.css'],
  directives: [MaterialChipComponent, NgFor],
  directiveTypes: [
    Typed<MaterialChipComponent>.of([#T])
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialChipsComponent<T> implements HasRenderer<T>, OnDestroy {
  final ChangeDetectorRef _changeDetector;
  final Disposer _disposer = Disposer.multi();

  /// Whether the chips can be removed.
  @Input()
  bool removable = true;

  /// The list of `HasUIDisplayName` objects to render.
  //  TODO(google): update this to be selection, not selectionModel, in order
  //  to match SelectionModel properties from other components
  SelectionModel<T> _selectionModel = const SelectionModel.empty();

  /// The selection model this component controls.
  @Input()
  set selectionModel(SelectionModel<T> model) {
    _selectionModel = model;
    _disposer
      ..dispose()
      ..addDisposable(_selectionModel.selectionChanges.listen((_) {
        _changeDetector.markForCheck();
      }));
  }

  SelectionModel<T> get selectionModel => _selectionModel;

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
  ItemRenderer<T> itemRenderer = _defaultItemRenderer;

  Iterable<T> get selectedItems => selectionModel.selectedValues;

  /// Default item renderer if none is provided by the user of this widget.
  static String _defaultItemRenderer(Object value) => value?.toString();

  MaterialChipsComponent(this._changeDetector);

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
