// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.laminate.popup.src.popup_event;

import 'dart:async';
import 'dart:math';

import './popup_ref.dart';
import '../../../model/action/async_action.dart';

/// An event fired from a popup instance.
abstract class PopupEvent<V> implements AsyncAction<V> {
  /// Whether this is an open event.
  bool get isOpen;

  /// Whether this is a close event.
  bool get isClose;

  /// The source of this event.
  PopupRef get source;

  /// The size of the popup when opened.
  ///
  /// Will only be non-null if not cancelled and [isOpen].
  Future<Rectangle> size();
}

/// Returns the size.
typedef Future<Rectangle> AsyncMeasureSize();

/// An implementation of [PopupEvent] that should not be publicly exported.
class AsyncPopupEvent<V> extends DelegatingAsyncAction<V>
    implements PopupEvent<V> {
  @override
  final AsyncAction<V> delegate;

  // TODO(google): Switch this to an enum instead.
  @override
  final bool isOpen;

  /// A callback that can return the popup content's size, asynchronously, in
  /// the next DOM read queue.
  final AsyncMeasureSize _asyncMeasureSize;

  /// The size of the content. Will be non-null if not cancelled and [isOpen].
  final onSizeCompleter = new Completer<Rectangle>.sync();

  /// Create a new open event.
  AsyncPopupEvent.open(this.delegate, this.source, this._asyncMeasureSize)
      : isOpen = true;

  /// Create a new close event.
  AsyncPopupEvent.close(this.delegate, this.source, this._asyncMeasureSize)
      : isOpen = false;

  @override
  bool get isClose => !isOpen;

  @override
  Future<Rectangle> size() => _asyncMeasureSize();

  @override
  final PopupRef source;
}
