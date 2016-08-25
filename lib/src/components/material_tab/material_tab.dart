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

import '../content/deferred_content_aware.dart';
import '../focus/focus.dart';
import '../../utils/async/async.dart';
import '../../utils/id_generator/id_generator.dart';

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
/// This component supports
/// [Deferred Content](http://go/acx-deferred-content).
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
  final _visible = new LazyStreamController<bool>.broadcast(sync: true);

  MaterialTabComponent(ElementRef element, @Optional() IdGenerator idGenerator)
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
  String get tabId => 'tab-$_uuid';
}
