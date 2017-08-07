// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../laminate/overlay/module.dart' show overlayContainerToken;
import './material_expansionpanel.dart';

/// A directive that automatically collapses [MaterialExpansionPanel].
///
/// When a [MaterialExpansionPanel] is expanded, any click outside of it will
/// automatically collapses the panel.
///
/// __Example Usage:__
///
///     <material-expansionpanel autoDismissable>
///     </material-expansionpanel>
///
@Directive(
    selector: 'material-expansionpanel[autoDismissable]',
    host: const {'(expandedChange)': r'onExpandedChanged($event)'})
class MaterialExpansionPanelAutoDismiss implements OnDestroy {
  final MaterialExpansionPanel _expansionPanel;

  /// The root node that all spawned elements will belong to.
  ///
  /// E.g. modal, dialog, popups.
  final Element _overlayContainerToken;
  final HtmlElement _element;

  StreamController<Event> _clicksOutsideController;
  StreamSubscription<Event> _clicksOutsideSubscription;
  StreamSubscription<MouseEvent> _mouseUpListener;

  MaterialExpansionPanelAutoDismiss(
      this._expansionPanel,
      @Optional() @Inject(overlayContainerToken) this._overlayContainerToken,
      this._element) {
    _clicksOutsideController = new StreamController.broadcast(
        sync: true,
        onListen: () {
          _mouseUpListener = document.onMouseUp.listen(_onMouseUp);
        },
        onCancel: () {
          _mouseUpListener.cancel();
          _mouseUpListener = null;
        });
  }

  /// Handles expanded status changes from the panel.
  void onExpandedChanged(bool expand) {
    _clicksOutsideSubscription?.cancel();
    if (expand) {
      _clicksOutsideSubscription = _clicksOutsideController.stream
          .listen((e) => _expansionPanel.collapse(byUserAction: false));
    }
  }

  @override
  void ngOnDestroy() {
    _clicksOutsideSubscription?.cancel();
  }

  void _onMouseUp(MouseEvent e) {
    var node = e.target as Element;
    while (node != null) {
      var tagName = node.tagName.toLowerCase();
      if (node == this._element) {
        // Excludes elements belonging to this panel.
        return;
      } else if (node == _overlayContainerToken) {
        // Excludes elements spawned by portals.
        return;
      } else if (tagName == 'body') {
        // Fires for these elements that can reach the 'body'.
        //
        // Choosing 'body' but not 'html' is because we want to exclude
        // browser scroll-bars which are direct children of 'html'.
        _clicksOutsideController.add(e);
        return;
      } else if (tagName == 'material-button' ||
          tagName == 'dropdown-button' ||
          tagName == 'input' ||
          tagName == 'a') {
        // Excludes any clickable elements.
        return;
      }
      node = node.parent;
    }
    // Treats clicks on dangling elements as inside the panel.
    //
    // E.g. clicks on the header of [MaterialExpansionPanel] with
    // 'hideExpandedHeader' set to true would result in the header being
    // removed from DOM immediately.
  }
}
