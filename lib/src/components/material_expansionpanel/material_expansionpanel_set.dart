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

import '../../model/action/async_action.dart';
import '../../utils/disposer/disposer.dart';

import 'material_expansionpanel.dart';

/// A directive which will turn a set of expansion panels into an accordian
/// widget. Thus only allowing one panel to be open at a time.
@Directive(selector: 'material-expansionpanel-set')
class MaterialExpansionPanelSet implements OnDestroy {
  final _panelDisposer = new Disposer.multi();
  final _tearDownDisposer = new Disposer.oneShot();
  MaterialExpansionPanel _openPanel;
  QueryList<MaterialExpansionPanel> _panels;

  MaterialExpansionPanelSet(
      @ContentChildren(MaterialExpansionPanel) this._panels) {
    _tearDownDisposer.addStreamSubscription(
        _panels.changes.listen((_) => _onPanelsChange()));
    _onPanelsChange();
  }

  ngOnDestroy() {
    _panelDisposer.dispose();
    _tearDownDisposer.dispose();
  }

  _onPanelsChange() {
    _panelDisposer.dispose();
    _openPanel = null;
    _panels.forEach((panel) {
      if (panel.isExpanded) {
        if (_openPanel != null) {
          throw new StateError("Should only have one panel open at a time");
        }
        _openPanel = panel;
      }
      _panelDisposer.addDisposable(
          panel.open.listen((event) => _onPanelOpen(panel, event)));
      _panelDisposer.addDisposable(
          panel.close.listen((event) => _onPanelClose(panel, event)));
      _panelDisposer.addDisposable(
          panel.cancel.listen((event) => _onPanelClose(panel, event)));
    });
  }

  _onPanelOpen(MaterialExpansionPanel panel, AsyncAction<bool> event) {
    if (_openPanel != null) {
      if (_openPanel.activeSaveCancelAction) {
        // Do not open the new panel, when the currently opened panel has an
        // in-progress action.
        event.cancel();
        return;
      }

      event.cancelIf(_openPanel.collapse(byUserAction: false).then((success) {
        if (success) {
          _setOpenPanel(panel);
        }
        return !success;
      }));
    } else {
      _setOpenPanel(panel);
    }
  }

  _onPanelClose(MaterialExpansionPanel panel, AsyncAction<bool> e) {
    e.onDone.then((success) {
      if (success && _openPanel == panel) {
        _setOpenPanel(null);
      }
    });
  }

  _setOpenPanel(MaterialExpansionPanel panel) {
    _panels.forEach((p) {
      if (p != panel) p.anotherExpanded = (panel != null);
    });
    _openPanel = panel;
  }
}
