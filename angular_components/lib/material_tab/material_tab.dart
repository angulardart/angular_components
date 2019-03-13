// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/content/deferred_content_aware.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/utils/id_generator/id_generator.dart';

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
@Component(
  selector: 'material-tab',
  providers: [
    ExistingProvider(Tab, MaterialTabComponent),
    ExistingProvider(DeferredContentAware, MaterialTabComponent),
  ],
  template: '''
        <div class="tab-content" *ngIf="active">
          <ng-content></ng-content>
        </div>''',
  styleUrls: ['material_tab.scss.css'],
  directives: [NgIf],
)
class MaterialTabComponent extends RootFocusable
    implements Tab, DeferredContentAware {
  @HostBinding('attr.role')
  static const hostRole = 'tabpanel';

  final String _uuid;
  final _visible = StreamController<bool>.broadcast(sync: true);

  MaterialTabComponent(HtmlElement element, @Optional() IdGenerator idGenerator)
      : _uuid = (idGenerator ?? SequentialIdGenerator.fromUUID()).nextId(),
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
  @HostBinding('class.material-tab')
  bool get active => _active;
  bool _active = false;

  /// HTML ID for the panel.
  @HostBinding('attr.id')
  String get panelId => 'panel-$_uuid';

  /// HTML ID for the tab.
  @HostBinding('attr.aria-labelledby')
  @override
  String get tabId => 'tab-$_uuid';
}
