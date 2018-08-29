// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:observable/observable.dart';
import 'package:angular_components/laminate/overlay/zindexer.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_menu/dropdown_menu.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/model/menu/selectable_menu.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/ui/icon.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

@Component(
  selector: 'material-menu-demo',
  providers: [popupBindings, ClassProvider(ZIndexer)],
  directives: [
    DropdownMenuComponent,
    MaterialIconComponent,
    MaterialMenuComponent,
  ],
  templateUrl: 'material_menu_demo.html',
  styleUrls: ['material_menu_demo.scss.css'],
)
class MaterialMenuDemoComponent implements OnDestroy {
  /// Stores the selected color, in an observable manner.
  final SelectionModel<String> colorSelection;

  /// Simple menu with some colors.
  final MenuModel<MenuItem> menuModel;

  /// The same as [menuModel], but with an icon.
  final MenuModel<MenuItem> menuModelWithIcon;

  /// Demonstrates the use of sub menus.
  final MenuModel<MenuItem> nestedMenuModel;

  /// Demonstrates the use of selectable sub menus.
  final MenuModel<MenuItem> selectableMenuModel;

  /// Demonstrates menu items with multiple suffixes.
  final MenuModel<MenuItem> menuModelWithAffixes;

  final Disposer _disposer;

  MaterialMenuDemoComponent._(
      this._disposer,
      this.colorSelection,
      this.menuModel,
      this.menuModelWithIcon,
      this.nestedMenuModel,
      this.selectableMenuModel,
      this.menuModelWithAffixes);

  factory MaterialMenuDemoComponent() {
    var colorSelection = SelectionModel<String>.single();
    var makeColorMenuItem = (String color, {MenuModel<MenuItem> subMenu}) =>
        ColorMenuItem(color, colorSelection, subMenu: subMenu);
    var menuModel = MenuModel<ColorMenuItem>([
      MenuItemGroup<ColorMenuItem>([
        makeColorMenuItem('red'),
        makeColorMenuItem('green'),
        makeColorMenuItem('yellow'),
        makeColorMenuItem('black'),
      ])
    ]);

    var menuModelWithIcon =
        MenuModel<MenuItem>(menuModel.itemGroups, icon: Icon('menu'));
    var nestedMenuModel = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('Basic Colors', subMenu: menuModel),
        MenuItem<ColorMenuItem>('Lights',
            subMenu: MenuModel<ColorMenuItem>([
              MenuItemGroup<ColorMenuItem>([
                makeColorMenuItem('Blue',
                    subMenu: MenuModel<ColorMenuItem>([
                      MenuItemGroup<ColorMenuItem>([
                        makeColorMenuItem('lightsteelblue'),
                        makeColorMenuItem('lightblue'),
                        makeColorMenuItem('lightskyblue'),
                      ])
                    ])),
                makeColorMenuItem('lightgreen'),
                makeColorMenuItem('lightsalmon'),
                makeColorMenuItem('lightyellow'),
              ])
            ])),
        MenuItem('Darks',
            subMenu: MenuModel<ColorMenuItem>([
              MenuItemGroup<ColorMenuItem>([
                makeColorMenuItem('darkblue'),
                makeColorMenuItem('darkmagenta'),
                makeColorMenuItem('darkkhaki'),
                makeColorMenuItem('darkolivegreen'),
              ])
            ])),
      ])
    ]);

    final disposer = Disposer.oneShot();

    final metalSelection = SelectionModel<String>.single(selected: 'O1');
    final typeSelection = SelectionModel<String>.multi();
    final planeSelection = SelectionModel<String>.multi();
    final toolSelection = SelectionModel<String>.multi();

    final chiselItem = SelectableMenuItem<String>(
        value: 'Chisels',
        subMenu: MenuModel<MenuItem>([
          MenuItemGroupWithSelection<String>(items: [
            SelectableMenuItem<String>(value: 'PMV-11'),
            SelectableMenuItem<String>(value: 'A2'),
            SelectableMenuItem<String>(value: 'O1'),
          ], selectionModel: metalSelection, label: 'Steel'),
          MenuItemGroupWithSelection<String>(items: [
            SelectableMenuItem<String>(value: 'Mortise'),
            SelectableMenuItem<String>(value: 'Bench'),
            SelectableMenuItem<String>(value: 'Paring'),
          ], selectionModel: typeSelection, label: 'Function'),
          MenuItemGroup<MenuItem>([
            MenuItem('Help',
                itemSuffixes: ObservableList.from([
                  IconAffix(
                      icon: Icon('help_outline'),
                      visibility: IconVisibility.hover)
                ]),
                action: () => window.alert('halp!')),
          ]),
        ]));

    final planeItem = SelectableMenuItem<String>(
        value: 'Planes',
        subMenu: MenuModel<MenuItem>([
          MenuItemGroupWithSelection<String>(items: [
            SelectableMenuItem<String>(
                value: 'Bench', selectableState: SelectableOption.Disabled),
            SelectableMenuItem<String>(value: 'Smoothing'),
            SelectableMenuItem<String>(value: 'Chisel'),
            SelectableMenuItem<String>(value: 'Block'),
            SelectableMenuItem<String>(
                value: 'Shoulder', selectableState: SelectableOption.Disabled),
          ], selectionModel: planeSelection),
        ]));

    disposer.addStreamSubscription(typeSelection.changes.listen((_) {
      if (typeSelection.isNotEmpty) {
        toolSelection.select('Chisels');
      } else {
        toolSelection.deselect('Chisels');
      }
    }));

    disposer.addStreamSubscription(planeSelection.changes.listen((_) {
      if (planeSelection.isNotEmpty) {
        toolSelection.select('Planes');
      } else {
        toolSelection.deselect('Planes');
      }
    }));

    var selectableMenuModel = MenuModel<MenuItem>([
      MenuItemGroupWithSelection<String>(items: [
        chiselItem,
        planeItem,
        SelectableMenuItem<String>(
            value: 'Hidden item', selectableState: SelectableOption.Hidden),
        SelectableMenuItem<String>(
            value: 'Sandpaper',
            selectableState: SelectableOption.Disabled,
            subMenu: MenuModel<MenuItem>([
              MenuItemGroup<MenuItem>([
                SelectableMenuItem<String>(value: '320'),
                SelectableMenuItem<String>(value: '150'),
              ]),
            ])),
      ], selectionModel: toolSelection, label: 'Tools'),
      MenuItemGroup<MenuItem>([
        MenuItem('Buy',
            subMenu: MenuModel<MenuItem>([
              MenuItemGroup<MenuItem>([
                MenuItem('Almost new',
                    enabled: false, action: () => window.alert('almost new!')),
                MenuItem('Used', action: () => window.alert('used!')),
                MenuItem('New', action: () => window.alert('new!')),
              ])
            ])),
        MenuItem('Advertise',
            subMenu: MenuModel<MenuItem>([
              MenuItemGroup<MenuItem>([
                MenuItem('Google',
                    enabled: false, action: () => window.alert('google!')),
                MenuItem('Facebook',
                    enabled: false, action: () => window.alert('facebook!')),
                MenuItem('Craigslist',
                    enabled: false, action: () => window.alert('craigslist!')),
              ])
            ])),
        MenuItem('Sell'),
      ], 'Unselectable group'),
    ]);

    final menuModelWithAffixes = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('With no suffixes', action: () => window.alert('1')),
        MenuItem('With an icon suffix',
            action: () => window.alert('2'),
            itemSuffixes: ObservableList.from([
              IconAffix(
                  icon: IconWithAction(
                      'delete', () => window.alert('action'), 'ariaLabel', null,
                      shouldCloseMenuOnTrigger: true))
            ])),
        MenuItem('With text suffix',
            action: () => window.alert('3'),
            itemSuffixes:
                ObservableList.from([CaptionAffix(text: 'Ctrl + V')])),
        MenuItem('With multiple suffixes',
            action: () => window.alert('4'),
            itemSuffixes: ObservableList.from([
              IconAffix(
                  icon: IconWithAction('delete', () => window.alert('action 1'),
                      'ariaLabel', null)),
              IconAffix(icon: Icon('accessible')),
              CaptionAffix(text: 'some text'),
              IconAffix(icon: Icon('autorenew')),
            ])),
      ]),
    ]);

    return MaterialMenuDemoComponent._(
        disposer,
        colorSelection,
        menuModel,
        menuModelWithIcon,
        nestedMenuModel,
        selectableMenuModel,
        menuModelWithAffixes);
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  String get selectedColor => colorSelection.selectedValues.isEmpty
      ? 'red'
      : colorSelection.selectedValues.first;
}

class ColorMenuItem extends MenuItem<ColorMenuItem> {
  ColorMenuItem(String label, SelectionModel selection,
      {Icon icon, MenuModel<MenuItem> subMenu})
      : super(label, icon: icon, subMenu: subMenu) {
    this.action = () {
      selection.select(label);
    };
  }
}
