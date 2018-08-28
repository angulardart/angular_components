// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'material_expansionpanel.dart';

/// A directive which will turn a set of [MaterialExpansionPanel]s into an
/// accordion widget, thus only allowing only one [MaterialExpansionPanel] to be
/// open at a time.
///
/// [MaterialExpansionPanelSet] must be used with [MaterialExpansionPanel] as
/// direct children. For example, the set will *not* work for the following
/// scenario:
///
/// ```dart
/// @Component(
///   selector: 'middle-man',
///   template: '<material-expansionpanel></material-expansionpanel>',
///   directives: [MaterialExpansionPanel],
/// )
/// class MiddleManComponent {}
///
/// <material-expansionpanel-set>
///   <middle-man></middle-man>
///   <middle-man></middle-man>
/// </material-expansionpanel-set>
/// ```
///
@Directive(selector: 'material-expansionpanel-set')
class MaterialExpansionPanelSet implements OnDestroy {
  final _panelDisposer = Disposer.multi();
  MaterialExpansionPanel _openPanel;
  List<MaterialExpansionPanel> _panels;

  @ContentChildren(MaterialExpansionPanel, descendants: false)
  set panels(List<MaterialExpansionPanel> panels) {
    _panels = panels;
    _onPanelsChange();
  }

  void _onPanelsChange() {
    _panelDisposer.dispose();
    _openPanel = null;

    for (final panel in _panels) {
      if (panel.isExpanded) {
        if (_openPanel != null) {
          throw StateError('Should only have one panel open at a time');
        }
        _openPanel = panel;
      }

      _panelDisposer
        ..addStreamSubscription((panel.isExpandedChange.listen((isExpanded) {
          if (isExpanded) _setOpenPanel(panel);
        })))
        ..addStreamSubscription(panel.open.listen((action) {
          _onPanelOpen(panel, action);
        }))
        ..addStreamSubscription(panel.close.listen((action) {
          _onPanelClose(panel, action);
        }))
        ..addStreamSubscription(panel.cancel.listen((action) {
          _onPanelClose(panel, action);
        }));

      if (panel.closeOnSave) {
        _panelDisposer.addStreamSubscription(panel.save.listen((action) {
          _onPanelClose(panel, action);
        }));
      }
    }
  }

  void _onPanelOpen(
      MaterialExpansionPanel panel, AsyncAction<bool> action) async {
    if (_openPanel == null) _setOpenPanel(panel);

    if (_openPanel.activeSaveCancelAction) {
      // Do not open the new panel, when the currently opened panel has an
      // in-progress action.
      action.cancel();
      return;
    }

    action.cancelIf(_openPanel.collapse(byUserAction: false).then((success) {
      if (success) _setOpenPanel(panel);
      return !success;
    }));
  }

  void _onPanelClose(
      MaterialExpansionPanel panel, AsyncAction<bool> action) async {
    final wasCollapseSucessful = await action.onDone;
    if (wasCollapseSucessful && _openPanel == panel) _setOpenPanel(null);
  }

  void _setOpenPanel(MaterialExpansionPanel panel) {
    if (_openPanel == panel) return;
    _openPanel = panel;
    for (final panel in _panels) {
      if (panel != _openPanel) panel.anotherExpanded = _openPanel != null;
    }
  }

  @override
  void ngOnDestroy() {
    _panelDisposer.dispose();
  }
}
