// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The library provides utility classes in addition to package:observe.
///
/// Objects implementing the [ObserveAware] and [ChangeAware] interfaces are
/// very similar to objects with [Observable], with a much lower verbosity
/// and smaller implementation. Classes using these may be migrated to use
/// [Observable] instead.
///
/// [ObservableReference] and [ObservableComposite] provide base classes for
/// complex domain objects that aren't able to implement [Observable].
///
/// TODO(google): check with jmesserly: how to merge these with package:observe
library angular_components.model.observable.observable;

import 'dart:async';

import 'package:angular_components/utils/disposer/disposer.dart';

/// Compares two objects for reference or content equality.
typedef EqualsFn<T> = bool Function(T a, T b);

/// Allows listening on changes.
abstract class ObserveAware<T> {
  /// Provides a stream of object values when the internals change.
  Stream<T> get stream;
}

/// Change record with previous and following values.
class Change<T> {
  final T previous;
  final T next;
  Change(this.previous, this.next);

  @override
  bool operator ==(other) =>
      (other is Change) &&
      (this.previous == other.previous) &&
      (this.next == other.next);

  @override
  int get hashCode => (next == null) ? 0 : next.hashCode;

  @override
  String toString() => 'Change($previous ==> $next)';
}

/// Allows listening on change pairs.
abstract class ChangeAware<T> extends ObserveAware<T> {
  /// Provides a stream of change pairs.
  Stream<Change<T>> get changes;
}

/// Provides notification coalesce support for the other [ChangeAware] classes.
class ChangeNotificationProvider<T> implements ChangeAware<T>, Disposable {
  final bool _coalesce;
  bool _coalesceScheduled = false;
  StreamController<T> _streamController;
  StreamController<Change<T>> _changeController;

  // temp values for coalescing changes
  T _previous;
  T _next;

  ChangeNotificationProvider(

      /// Changes are published synchronously by default. When coalesce is set,
      /// the changes in the current execution block are collected, and only the
      /// last value will be published (in an async scheduled microtask).
      this._coalesce);

  /// Provides a stream of object values when the reference changes.
  @override
  Stream<T> get stream {
    if (_streamController == null) {
      _streamController = StreamController<T>.broadcast(sync: true);
    }
    return _streamController.stream;
  }

  /// Provides a stream of change pairs.
  @override
  Stream<Change<T>> get changes {
    if (_changeController == null) {
      _changeController = StreamController<Change<T>>.broadcast(sync: true);
    }
    return _changeController.stream;
  }

  /// Whether there is a subscriber to [stream] or [changes].
  bool get hasListener => _hasStreamListener || _hasChangeListener;

  /// Notifies the streams about a new value (or forces the notification without
  /// equality check).
  void notifyChange([T previous, T next]) {
    if (_isInactive) return;
    if ((!_hasStreamListener || _streamController.isClosed) &&
        (!_hasChangeListener || _changeController.isClosed)) {
      return;
    }
    if (_coalesce) {
      _doCoalesce(previous, next);
    } else {
      _doNotifyChange(previous, next);
    }
  }

  void _doCoalesce(T previous, T next) {
    if (_coalesceScheduled) {
      // [_previous] does not need to be changed, but always update [_next] to
      // the latest value
      _next = next;
    } else {
      _previous = previous;
      _next = next;
      _coalesceScheduled = true;
      scheduleMicrotask(() {
        // Null out _previous and _next right away.
        // If we end up getting changed in _doNotifyChange, we need to keep
        // those values instead of clobbering them.
        var publishPrev = _previous;
        var publishNext = _next;
        _previous = null;
        _next = null;

        _coalesceScheduled = false;
        if (_isActive) {
          // extra check to prevent NPE after disposal
          _doNotifyChange(publishPrev, publishNext);
        }
      });
    }
  }

  void _doNotifyChange(T previous, T next) {
    if (_hasStreamListener) {
      _streamController.add(next);
    }
    if (_hasChangeListener) {
      _changeController.add(Change(previous, next));
    }
  }

  @override
  void dispose() {
    if (_streamController != null) {
      _streamController.close();
      _streamController = null;
    }
    if (_changeController != null) {
      _changeController.close();
      _changeController = null;
    }
  }

  bool get _hasStreamListener =>
      (_streamController != null) && (_streamController.hasListener);

  bool get _hasChangeListener =>
      (_changeController != null) && (_changeController.hasListener);

  bool get _isActive => _hasStreamListener || _hasChangeListener;
  bool get _isInactive => !_isActive;
}

/// A read-only 'view' of something. Allows getting the current value and
/// listening for values and changes.
abstract class ObservableView<T> extends ChangeAware<T> implements Disposable {
  T get value;

  /// Blocks until [value] is non-null, and then completes with that value.
  ///
  /// If [value] is already non-null, completes immediately.
  ///
  /// The implementation may internally subscribe to [stream], so if [stream] is
  /// single-subscription (non-broadcast), it won't be possible to listen to it
  /// separately.
  Future<T> get firstNonNull;

  /// A [Stream] of all values on this view, including the current [value] at
  /// the time the stream is listened to.
  Stream<T> get values;

  /// A [Stream] of all non-null values on this view, including the current
  /// [value] at the time the stream is listened to (if it's non-null).
  ///
  /// This interface does not guarantee that consecutive data events are
  /// distinct, but subclasses may do so.
  Stream<T> get nonNullValues;

  /// Returns a new [ObservableView] which is created by lazily calling [mapper]
  /// on this view's [value], [stream], and [changes] properties.
  ///
  /// Disposing of the mapped view doesn't affect this view in any way.
  ObservableView<M> map<M>(M Function(T) mapper);

  /// An [ObservableView] of the most-recently-published value on the given
  /// [stream].
  factory ObservableView.fromStream(Stream<T> stream, {T initialValue}) =>
      ObservableReference(initialValue)..listen(stream);
}

/// Implements methods of [ObservableView] in terms of the basic [value] and
/// [stream] properties.
abstract class ObservableViewMixin<T> implements ObservableView<T> {
  @override
  Stream<Change<T>> get changes {
    var last = value;
    // Want to do this using stream.map so that the `changes` stream has the
    // same broadcastness/syncness as the `stream` stream.
    return stream.map((v) {
      var change = Change(last, v);
      last = v;
      return change;
    });
  }

  @override
  Future<T> get firstNonNull => value != null
      ? Future.value(value)
      : stream.firstWhere((value) => value != null);

  @override
  Stream<T> get values {
    // Unlike with `changes`, we're OK here returning an async non-broadcast
    // stream instead of trying to inherit the broadcastness/syncness of the
    // underlying `stream` -- if `stream` were sync, then
    // `ref.values.asBroadcastStream()` would end up yielding the current value
    // before anything could possibly listen to it, which really defeats the
    // point of even calling `values` in the first place.

    StreamController<T> controller;
    controller = StreamController(onListen: () {
      controller.add(value);
      controller.addStream(stream).then((_) => controller.close());
    });
    return controller.stream;
  }

  @override
  Stream<T> get nonNullValues => values.where((value) => value != null);

  @override
  ObservableView<M> map<M>(M Function(T) mapper) =>
      _MappedView<T, M>(this, mapper);
}

/// An [ObservableView] that just points at an existing [ObservableView] and
/// passes it through a mapping function.
class _MappedView<I, O> extends ObservableViewMixin<O> {
  final ObservableView<I> _delegate;
  final O Function(I) _mapper;
  _MappedView(this._delegate, this._mapper);

  @override
  O get value => _mapper(_delegate.value);

  @override
  Stream<O> get stream => _delegate.stream.map(_mapper);

  @override
  void dispose() {}
}

/// A mutable object holder that allows listening on a stream of changes.
///
/// Changes to the value using `value=` are added to a broadcast stream. If the
/// new value is equivalent to the current value, nothing's added to the stream.
class ObservableReference<T> extends ChangeNotificationProvider<T>
    with ObservableViewMixin<T> {
  static bool _defaultEq(a, b) => a == b;

  final EqualsFn<T> _equalsFn;
  StreamSubscription _listenSub;
  T _value;

  /// Creates a listenable value holder, starting with the given value.
  /// Optionally takes custom equality function.
  /// Changes are published synchronously by default. When [coalesce] is set,
  /// the changes in the current execution block are collected, and only the
  /// last value will be published (in an async scheduled microtask).
  ObservableReference(this._value,
      {EqualsFn<T> equalsFn = _defaultEq, bool coalesce = false})
      : _equalsFn = equalsFn,
        super(coalesce);

  /// The currently-set value.
  T get value => _value;

  /// Sets the value and publishes an event to the stream.
  set value(T value) {
    if (_equalsFn(_value, value)) return;
    var previous = _value;
    _value = value;
    notifyChange(previous, value);
  }

  /// Listens to the given stream and sets the reference's value to whatever is
  /// emitted on the stream.
  ///
  /// Returns a [Future] that completes when the stream is done, analogous to
  /// `StreamController.addStream`.
  Future listen(Stream<T> stream) {
    _listenSub?.cancel();
    _listenSub = stream.listen((v) {
      value = v;
    });
    return _listenSub.asFuture();
  }

  /// A [Stream] of all non-null values on this view, including the current
  /// [value] at the time the stream is listened to (if it's non-null).
  ///
  /// This implementation will never emit equal consecutive data events.
  /// "Equality" is defined by [equalsFn].
  @override
  Stream<T> get nonNullValues => super.nonNullValues.distinct(_equalsFn);

  @override
  void dispose() {
    super.dispose();
    _listenSub?.cancel();
    _value = null;
  }
}

/// Merges multiple updates of [ObserveAware]s and emits a single update
/// notification stream.
class ObservableComposite<T> extends ChangeNotificationProvider<T> {
  final Map<Stream, StreamSubscription> _subscriptions =
      <Stream, StreamSubscription>{};
  final _disposer = Disposer.oneShot();
  final bool _withStackTrace;

  /// Changes are published synchronously by default. When [coalesce] is set,
  /// the changes in the current execution block are collected, and only the
  /// one event with null value will be published (in an async scheduled microtask).
  ObservableComposite(
      {bool coalesce = false,
      List<ObserveAware> values,
      bool withStackTrace = false})
      : _withStackTrace = withStackTrace,
        super(coalesce) {
    if (values != null) {
      for (var ref in values) {
        register(ref);
      }
    }
  }

  /// Starts listening on value changes (if not already doing so).
  ObserveAware register(ObserveAware value,
      {ObserveAware replaces, bool initialNotification = true}) {
    if (value == null) return null;
    Stream replacesStream = (replaces == null) ? null : replaces.stream;
    registerStream(value.stream,
        replaces: replacesStream, initialNotification: initialNotification);
    if (value is Disposable) {
      _disposer.addDisposable(value);
    }
    return value;
  }

  /// Stops listening on value changes.
  void unregister(ObserveAware value) {
    if (value == null) return;
    unregisterStream(value.stream);
  }

  /// Starts listening on value changes (if not already doing so).
  Stream registerStream(Stream stream,
      {Stream replaces, bool initialNotification = true}) {
    if (_subscriptions.containsKey(stream)) {
      // little sanity check
      assert(replaces == null);
      // nothing to do, already listening
      return stream;
    }
    if (replaces != null) {
      unregisterStream(replaces);
    }
    StackTrace stackTrace;
    assert(() {
      // stackTrace is only used in debugging
      if (_withStackTrace) {
        stackTrace = StackTrace.current;
      }
      return true;
    }());
    _subscriptions[stream] = stream.listen((_) {
      if (stackTrace != null) {
        print("Coalescer notified from $stackTrace");
      }
      notifyChange();
    });
    if (initialNotification) {
      notifyChange();
    }
    return stream;
  }

  /// Stops listening on stream events.
  void unregisterStream(Stream stream) {
    if (stream == null) return;
    StreamSubscription subs = _subscriptions.remove(stream);
    if (subs != null) {
      subs.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.values.forEach((subscription) => subscription.cancel());
    _subscriptions.clear();
    _disposer.dispose();
  }
}
