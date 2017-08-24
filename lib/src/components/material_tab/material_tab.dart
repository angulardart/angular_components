// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/id_generator/id_generator.dart';
import '../content/deferred_content_aware.dart';
import '../focus/focus.dart';

/// Basic interface for a Tab.
abstract class Tab extends Focusable {
  /// The label to be shown on the tab button.
  String get label;

  /// The unique id for the tab button.
  String get tabId;

  /// Sets this tab as active.
  void activate();

  /// Sets this tab as inactive.
  void deactivate();
}

/// A Material-styled card, which is shown or hidden as part of a
/// [MaterialTabPanelComponent].
///
/// The `material-tab` component sets the button's label text via the `label`
/// property. Tab contents can be lazily instantiated by using the
/// `*deferredContent` template directive.
///
/// __Example Usage:__
///
///     <material-tab-panel>
///       <material-tab label="tab 1">
///         <my-component *deferredContent>
///           Tab #1 Contents
///         </my-component>
///       </material-tab>
///       <material-tab label="tab 2">
///         <template deferredContent>
///           Tab #2 Contents
///         </template>
///       </material-tab>
///     </material-tab-panel>
@Component(
    selector: 'material-tab',
    host: const {
      'role': 'tabpanel',
      '[attr.id]': 'panelId',
      '[attr.aria-labelledby]': 'tabId',
      '[class.material-tab]': 'active',
    },
    providers: const [
      const Provider(Tab, useExisting: MaterialTabComponent),
      const Provider(DeferredContentAware, useExisting: MaterialTabComponent)
    ],
    template: '''
        <div class="tab-content" *ngIf="active">
          <ng-content></ng-content>
        </div>''',
    styleUrls: const ['material_tab.scss.css'],
    directives: const [NgIf])
class MaterialTabComponent extends RootFocusable
    implements Tab, DeferredContentAware {
  final String _uuid;
  final _visible = new StreamController<bool>.broadcast(sync: true);

  MaterialTabComponent(HtmlElement element, @Optional() IdGenerator idGenerator)
      : _uuid = (idGenerator ?? new SequentialIdGenerator.fromUUID()).nextId(),
        super(element);

  /// The label for this tab.
  @override
  @Input()
  String label;

  @override
  void deactivate() {
    _active = false;
    _visible.add(false);
  }

  @override
  void activate() {
    _active = true;
    _visible.add(true);
  }

  @override
  Stream<bool> get contentVisible => _visible.stream;

  /// Whether the tab is active.
  bool get active => _active;
  bool _active = false;

  /// HTML ID for the panel.
  String get panelId => 'panel-$_uuid';

  /// HTML ID for the tab.
  @override
  String get tabId => 'tab-$_uuid';
}
