// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:observable/observable.dart';
import 'package:quiver/core.dart' as qc;
import 'package:angular_components/dynamic_component/dynamic_component.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_menu/affix/base_affix.dart';
import 'package:angular_components/model/menu/menu_item_affix.dart';

/// Renders the list of menu item affixes.
///
/// An affix can be a text or an icon component. This component also listens
/// on any affix list changes.
// TODO(google): move component management to common utils if useful to others
@Component(
    selector: 'menu-item-affix-list',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: [
      DynamicComponent,
      NgFor,
      NgIf,
    ],
    providers: [
      ExistingProvider(HasDisabled, MenuItemAffixListComponent),
    ],
    template: '<template #loadPoint></template>',
    styleUrls: ['menu_item_affix_list.scss.css'])
class MenuItemAffixListComponent implements HasDisabled, OnDestroy {
  final ChangeDetectorRef _cdRef;

  StreamSubscription _itemChangeStreamSub;

  final _affixComponentRefs = <_AffixRef>[];

  ObservableList<MenuItemAffix> _items;

  @ViewChild('loadPoint', read: ViewContainerRef)
  @visibleForTemplate
  ViewContainerRef viewRef;

  bool _disabled = false;

  MenuItemAffixListComponent(this._cdRef);

  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _updateItemProperties();
  }

  bool get disabled => _disabled;

  /// Observable list of affix items.
  @Input()
  set items(ObservableList<MenuItemAffix> items) {
    _itemChangeStreamSub?.cancel();

    _itemChangeStreamSub = items?.listChanges?.listen((change) {
      _updateVisibleItems(change);
      _cdRef.markForCheck();
    });

    _initializeItems(items.whereType<BaseMenuItemAffixModel>());
  }

  bool get hasAffixes => _items?.isNotEmpty ?? false;

  @override
  void ngOnDestroy() {
    _clearChildren();
    _itemChangeStreamSub?.cancel();
  }

  void _clearChildren() {
    viewRef.clear();
    for (final ref in _affixComponentRefs.expand((ref) => ref.componentRef)) {
      ref.destroy();
    }
    _affixComponentRefs.clear();
  }

  void _updateVisibleItems(Iterable<ListChangeRecord<MenuItemAffix>> changes) {
    // For each change, apply the removed entries, then apply the added entries.
    for (final change in changes) {
      final start = change.index;

      if (change.removed.isNotEmpty) {
        final end = start + change.removed.length;
        final removed = _affixComponentRefs.sublist(start, end);

        for (final toRemove in removed) {
          if (toRemove.componentRef.isPresent) {
            toRemove.componentRef.value.destroy();
          }
        }

        _affixComponentRefs.removeRange(start, end);
      }

      if (change.addedCount > 0) {
        final allAdded =
            change.added.whereType<BaseMenuItemAffixModel>().toList().reversed;
        for (final toAdd in allAdded) {
          _affixComponentRefs.insert(
              start, _createComponentRef(toAdd, index: start));
        }
      }
    }
  }

  void _initializeItems(Iterable<BaseMenuItemAffixModel> items) {
    _clearChildren();
    _affixComponentRefs
        .addAll(items.map((affix) => _createComponentRef(affix)));
  }

  void _updateItemProperties() {
    for (final ref in _affixComponentRefs) {
      if (ref.componentRef.isPresent) {
        ref.componentRef.value.instance.disabled = disabled;
      }
    }
  }

  _AffixRef _createComponentRef(BaseMenuItemAffixModel affix,
      {int index = -1}) {
    if (!affix.isVisible) return _AffixRef.hidden(affix);

    return _AffixRef(
        affix,
        viewRef.createComponent(affix.componentFactory, index)
          ..location.classes.add('affix')
          ..instance.value = affix
          ..instance.disabled = disabled);
  }
}

class _AffixRef {
  final BaseMenuItemAffixModel affix;
  final qc.Optional<ComponentRef<BaseAffixComponent>> componentRef;

  _AffixRef(this.affix, ComponentRef<BaseAffixComponent> componentRef)
      : componentRef = qc.Optional.of(componentRef);
  _AffixRef.hidden(this.affix) : componentRef = qc.Optional.absent();
}
