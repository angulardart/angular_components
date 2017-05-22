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

import '../../utils/disposer/disposer.dart';

/// Compares two objects for reference or content equality.
typedef bool EqualsFn<T>(T a, T b);

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
  bool _coalesce;
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
      _streamController = new StreamController<T>.broadcast(sync: true);
    }
    return _streamController.stream;
  }

  /// Provides a stream of change pairs.
  @override
  Stream<Change<T>> get changes {
    if (_changeController == null) {
      _changeController = new StreamController<Change<T>>.broadcast(sync: true);
    }
    return _changeController.stream;
  }

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
      _changeController.add(new Change(previous, next));
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
abstract class ObservableView<T> extends ChangeAware<T> {
  T get value;
}

/// A mutable object holder that allows listening on a stream of changes.
///
/// Changes to the value using `value=` are added to a broadcast stream. If the
/// new value is equivalent to the current value, nothing's added to the stream.
class ObservableReference<T> extends ChangeNotificationProvider<T>
    implements ObservableView<T>, ObserveAware<T>, Disposable {
  static bool _defaultEq(a, b) => a == b;

  T _value;
  EqualsFn _equalsFn;

  /// Creates a listenable value holder, starting with the given value.
  /// Optionally takes custom equality function.
  /// Changes are published synchronously by default. When [coalesce] is set,
  /// the changes in the current execution block are collected, and only the
  /// last value will be published (in an async scheduled microtask).
  ObservableReference(this._value,
      {EqualsFn equalsFn: _defaultEq, bool coalesce: false})
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

  @override
  void dispose() {
    super.dispose();
    _value = null;
  }
}

/// Merges multiple updates of [ObserveAware]s and emits a single update
/// notification stream.
class ObservableComposite extends ChangeNotificationProvider {
  Map<Stream, StreamSubscription> _subscriptions =
      <Stream, StreamSubscription>{};
  final _disposer = new Disposer.oneShot();
  final bool _withStackTrace;

  /// Changes are published synchronously by default. When [coalesce] is set,
  /// the changes in the current execution block are collected, and only the
  /// one event with null value will be published (in an async scheduled microtask).
  ObservableComposite(
      {bool coalesce: false,
      List<ObserveAware> values,
      bool withStackTrace: false})
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
      {ObserveAware replaces, bool initialNotification: true}) {
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
      {Stream replaces, bool initialNotification: true}) {
    if (_subscriptions.containsKey(stream)) {
      // little sanity check
      assert(replaces == null);
      // nothing to do, already listening
      return stream;
    }
    unregisterStream(stream);
    var stackTrace;
    if (_withStackTrace) {
      stackTrace = StackTrace.current;
    }
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
