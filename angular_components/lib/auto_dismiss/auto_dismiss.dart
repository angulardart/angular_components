// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/events/events.dart';

/// A directive that publishes a (dismiss) event when a focus, click or mouseup
/// event occurs outside of it.
///
/// Note: For [MaterialExpansionPanel] please consider using the dedicated
///       directive [MaterialExpansionPanelAutoDismiss].
///
/// Note: When popups close they automatically re-focus the trigger element
///       which will call dismiss. In this case please follow best practice and
///       set [autoDismissable] to be the visibility of the popup itself.
///
/// __Example Usage:__
///
///     <div>
///       <div class="disclaimer" [class.visible]="disclaimerVisible"
///            [autoDismissable]="disclaimerVisible"
///            (dismiss)="disclaimerVisible = false">
///         Some scary disclaimery text
///       <div>
///       <button (click)="disclaimerVisible = true">Confirm</button>
///     </div>
///
@Directive(
  selector: '[autoDismissable]:not(material-expansionpanel)',
)
class AutoDismissDirective {
  final Stream _dismissEvents;
  final NgZone _zone;

  AutoDismissDirective(HtmlElement element, this._zone)
      : _dismissEvents = triggersOutside(element);

  bool _ignoreEvents = false;
  bool _autoDismissable = false;
  bool get autoDismissable => _autoDismissable;

  /// Boolean indicating if the dismiss event be published.
  @Input()
  set autoDismissable(bool b) {
    _autoDismissable = b;

    // If an event set autoDismissable to `true`, then we don't want the same
    // event to dismiss right away. Stop listening for events until we see a
    // appropriate event, or until the next event loop.
    _ignoreEvents = _autoDismissable;
    _dismissEvents.first.then(_listenForEvents);
    // Run the timer outside of Angular so that it doesn't trigger a new digest
    // cycle.
    _zone.runOutsideAngular(() => Timer.run(_listenForEvents));
  }

  /// Event which is published when a focus, mouseup, or click occurs outside of
  /// the element.
  @Output()
  Stream get dismiss =>
      _dismissEvents.where((_) => _autoDismissable && !_ignoreEvents);

  void _listenForEvents([_]) => _ignoreEvents = false;
}
