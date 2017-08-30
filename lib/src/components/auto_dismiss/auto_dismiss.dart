// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/browser/events/events.dart';

/// A directive that publishes a (dismiss) event when the user clicks outside of
/// it.
///
/// Note: For [MaterialExpansionPanel] please consider using the dedicated
///       directive [MaterialExpansionPanelAutoDismiss].
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
    visibility: Visibility.none)
class AutoDismissDirective {
  final Stream _click;
  final NgZone _zone;

  AutoDismissDirective(HtmlElement element, this._zone)
      : _click = triggersOutside(element);

  bool _ignoreClicks = false;
  bool _autoDismissable = false;
  bool get autoDismissable => _autoDismissable;

  /// Boolean indicating if the dismiss event be published.
  @Input()
  set autoDismissable(bool b) {
    _autoDismissable = b;

    // If a click set autoDismissable to `true`, then we don't want the same
    // click to dismiss right away. Stop listening for clicks until we see a
    // click event, or until the next event loop.
    _ignoreClicks = _autoDismissable;
    _click.first.then(_listenForClicks);
    // Run the timer outside of Angular so that it doesn't trigger a new digest
    // cycle.
    _zone.runOutsideAngular(() => Timer.run(_listenForClicks));
  }

  /// Event which is published when the user clicks outside of the element.
  @Output()
  Stream get dismiss => _click.where((_) => _autoDismissable && !_ignoreClicks);

  _listenForClicks([_]) => _ignoreClicks = false;
}
