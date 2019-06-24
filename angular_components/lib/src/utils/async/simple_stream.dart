// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

typedef StreamCallContextFunc = void Function(dynamic Function() func);
typedef StreamCallbackFunc<T> = void Function(T value);
typedef SubscriptionChangeListener<T> = void Function(
    StreamSubscription<T> subscription);

/// A ListenOnly Implementation of a [Stream].  It only supports the listen
/// method with the onData parameter.  Additionally, the streamsubscription can
/// only be cancelled.
/// This also acts like a [StreamController] via the add method.
///
/// Usage:
/// ```
/// Stream stream = SimpleStream();
/// StreamSubscription sub = stream.listen((item) {print('$item'));
/// stream.add('hi');
/// sub.cancel();
/// stream.add(hi);
/// ```
///
/// This does not behave like an actual stream.  A callback throwing an
/// exception will cause other callbacks to not execute and the if the stream
/// is synchronous, the error will propagate back to code adding the object
/// to the stream.
///
/// When a subscription is cancelled, it gets cleaned up and will not get
/// called but will remain in the stream's list of subscriptions until the
/// the cleanup microtask executes.  As such, calling [hasListener] on the
/// stream give the wrong result until the cleanup executes.  Cleanups for all
/// [SimpleStreams] will occur in the same microtask.
///
class SimpleStream<T> extends Stream<T> implements EventSink<T> {
  /// Determines if the stream is synchronous or asynchronous.
  final bool _isSync;

  /// The zone that the listeners were registered in.
  /// If this is null, callbacks from SimpleStream might
  /// run outside of ng change detection.
  final bool _runInZone;

  /// Called on the first subscription to the stream.
  SubscriptionChangeListener<T> _onListen;

  /// Called when the last subscription is removed.
  SubscriptionChangeListener<T> _onCancel;

  @override
  final bool isBroadcast = true;

  /// Using array as the assumption is that there will mainly be limited number
  /// of subscribers and overhead of a map is more.  It can always be made
  /// smarter.  If it is null, it means that the stream is closed.
  List<SimpleStreamSubscription<T>> _subscriptions = const [];

  /// List of items to send to avoid scheduling multiple microtasks for each
  /// item to be sent.
  List<T> _itemsToSend;

  /// A flag indicating that cleanup is required in case subscriptions are
  /// removed during processing.
  bool _subscriptionRemoved = false;

  /// List of streams to cleanup.
  static List<SimpleStream<dynamic>> _cleanupStreams = [];

  SimpleStream({bool isSync = false, bool runInZone = false})
      : _isSync = isSync,
        _runInZone = runInZone;

  SimpleStream.broadcast(
      {bool isSync = false,
      bool runInZone = false,
      SubscriptionChangeListener<T> onListen,
      SubscriptionChangeListener<T> onCancel})
      : _isSync = isSync,
        _runInZone = runInZone,
        _onListen = onListen,
        _onCancel = onCancel;

  bool get isSync => _isSync;

  @override
  Stream<T> asBroadcastStream(
      {void onListen(StreamSubscription<T> subscription),
      void onCancel(StreamSubscription<T> subscription)}) {
    if (onListen != null || onCancel != null) {
      throw UnsupportedError('Not supported outside constructor.');
    }
    return this;
  }

  /// Helper method to make it easy to replace this class with Dart's stream
  /// controller.
  Stream<T> get stream => this;

  /// Send an item to the subscriptions.
  @override
  void add(T item) {
    if (!hasListener) return;
    if (_isSync) {
      _sendItem(_subscriptions, item);
    } else {
      /// Only schedule a single micro-task for async streams.
      if (_itemsToSend == null) {
        _itemsToSend = [];
        scheduleMicrotask(_sendAsync);
      }
      _itemsToSend.add(item);
    }
  }

  /// Cleanup all the streams that were registered for cleanup.
  static void _cleanupTask() {
    for (int i = 0; i < _cleanupStreams.length; i++) {
      _cleanupStreams[i]._cleanUp();
    }
    _cleanupStreams.clear();
  }

  /// Cleanup subscriptions that might have been removed during callbacks.
  /// Go through the list of subscriptions and remove those with null callbacks.
  void _cleanUp() {
    if (hasListener) {
      // Loop over them all is faster than keeping track of a list and
      // looking up each one separately.
      List<SimpleStreamSubscription<T>> listeners = _subscriptions;
      assert(listeners.isNotEmpty);

      for (var liveCount = 0; liveCount < listeners.length; liveCount++) {
        var firstRemovedListener = listeners[liveCount];
        if (firstRemovedListener._stream != null) continue;
        // At least one removed listener. Collect live listeners at beginning
        // and truncate the list to only the live listeners.
        for (var i = liveCount + 1; i < listeners.length; i++) {
          var listener = listeners[i];
          if (listener._stream != null) {
            listeners[liveCount++] = listener;
          }
        }
        listeners.length = liveCount;
        // If there are no listeners left and onCancel is set, then call
        // onCancel to indicate that the last subscription has been removed.
        if (liveCount == 0 && _onCancel != null) {
          _onCancel(firstRemovedListener);
        }
        break;
      }
    }
    _subscriptionRemoved = false;
  }

  /// Sends a single item to all listeners.
  /// It validates that the callback is not null before making the call.
  /// If [len] is passed in, the item is sent to first [len] listeners.
  void _sendItem(List<SimpleStreamSubscription<T>> listeners, T item,
      [int len = -1]) {
    // Make sure we don't send the event to listeners that were added during
    // the callback.
    if (len == -1) {
      len = listeners.length;
    }
    for (int i = 0; i < len; i++) {
      listeners[i]._add(item);
    }
  }

  @override
  void addError(errorEvent, [StackTrace stackTrace]) {
    if (!hasListener) return;
    var listeners = _subscriptions;
    int len = listeners.length;
    for (int i = 0; i < len; i++) {
      var sub = listeners[i];
      var callback = sub._onError;
      // Cancel first in case something goes wrong in the callback.
      if (sub._cancelOnError == true) {
        sub._closeSubscription();
      }
      if (callback != null) {
        if (callback is ZoneBinaryCallback<Object, Object, Object>) {
          callback(errorEvent, stackTrace);
        } else if (callback is ZoneUnaryCallback<Object, Object>) {
          callback(errorEvent);
        }
      }
    }
  }

  @override
  void close() {
    if (_subscriptions != null) {
      var listeners = _subscriptions;
      // This will cause an exception to be thrown if a listener is added while
      // closing subscriptions.
      _subscriptions = null;
      for (int i = 0; i < listeners.length; i++) {
        listeners[i]._closeSubscription();
      }
    }
  }

  bool get isClosed => _subscriptions == null;

  bool get hasListener => _subscriptions != null && _subscriptions.isNotEmpty;

  void _sendAsync() {
    var listeners = _subscriptions;
    var sendList = _itemsToSend;
    _itemsToSend = null;
    // ensure stream did not close before microtask executed.
    if (listeners != null) {
      int len = listeners.length;
      for (int i = 0; i < sendList.length; i++) {
        T item = sendList[i];
        // pass in the length of the listeners to ensure there isn't a case
        // where a new listener gets the item if they joined during a callabck
        // when sending multiple items.
        _sendItem(listeners, item, len);
      }
    }
  }

  /// Remove a subscription.
  /// It marks a subscription for removal during a microtask to ensure that
  /// a subscription wasn't cancelled as a result of processing a callback.
  void _scheduleCleanup() {
    if (!_subscriptionRemoved) {
      _subscriptionRemoved = true;
      _cleanupStreams.add(this);
      // Schedule a microtask for cleanup to avoid cycles of listen/cancel/add.
      // This can be further optimized if needed by creating a static array of
      // streams that need to be cleaned up.  It might be needed for things
      // components such as the particle table during when navigating to another
      // view.
      if (_cleanupStreams.length == 1) {
        scheduleMicrotask(_cleanupTask);
      }
    }
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    // Don't allow listening to a closed stream, it will throw exception in
    // non checked mode since subscriptions will be null once the stream is
    // closed.
    assert(_subscriptions != null);
    Zone contextZone;
    if (_runInZone) {
      contextZone = Zone.current;
    }
    var sub = SimpleStreamSubscription<T>(
        this, onData, onDone, onError, cancelOnError, contextZone);
    if (_subscriptions.isEmpty) {
      _subscriptions = [sub];
    } else {
      _subscriptions.add(sub);
    }
    if (_onListen != null && _subscriptions.length == 1) {
      _onListen(sub);
    }
    return sub;
  }
}

/// A stream that will provide the last item that was added to the stream to
/// any new subscribers in addition to any new items.
class LastStateStream<T> extends SimpleStream<T> {
  /// The last item that was added to the stream.
  T _lastItem;

  LastStateStream(
      {bool isSync = false,
      bool runInZone = false,
      SubscriptionChangeListener<dynamic> onListen,
      SubscriptionChangeListener<dynamic> onCancel})
      : super.broadcast(
            isSync: isSync,
            runInZone: runInZone,
            onListen: onListen,
            onCancel: onCancel);

  @override
  void add(T item) {
    _lastItem = item;
    super.add(item);
  }

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError}) {
    SimpleStreamSubscription<T> sub = super.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    if (_lastItem != null) {
      /// If the stream is synchronous, send the item immediately, if it is
      /// asynchronous then make sure that items are not pending by checking
      /// that the the _itemsToSend list is not null otherwise a listener
      /// might receive the same data twice.
      if (_isSync) {
        _sendItem([sub], _lastItem);
      } else if (_itemsToSend == null) {
        scheduleMicrotask(() {
          _sendItem([sub], _lastItem);
        });
      }
    }
    return sub;
  }
}

/// An Empty stream that does not support any listeners but pretends to be
/// listening.
class EmptySimpleStream<T> extends SimpleStream<T> {
  EmptySimpleStream([bool isSync = false]) : super(isSync: isSync);

  @override
  StreamSubscription<T> listen(onData, {onError, onDone, cancelOnError}) {
    return SimpleStreamSubscription._empty();
  }
}

/// A [SimpleStream] implementation of [StreamSubscription].
///
/// Major differences:
/// * [cancel] returns null.
/// * Using [pause] is not supported.
///
class SimpleStreamSubscription<T> implements StreamSubscription<T> {
  @override
  final bool isPaused = false;
  SimpleStream<T> _stream;
  StreamCallbackFunc<T> _callback;
  Zone _contextZone;
  Function _doneCallback;
  Function _onError;
  bool _cancelOnError = false;

  factory SimpleStreamSubscription._empty() =>
      SimpleStreamSubscription(null, null, null, null, false, null);

  SimpleStreamSubscription(this._stream, this._callback, this._doneCallback,
      this._onError, this._cancelOnError, this._contextZone);

  @override
  Future<dynamic> cancel() {
    if (_stream != null) {
      // Set doneCallback to null so when [_closeSubscription] is called, we
      // don't call doneCallback.
      var stream = _stream;
      _doneCallback = null;
      _closeSubscription();
      stream._scheduleCleanup();
    }
    return null;
  }

  void _closeSubscription() {
    _stream = null;
    _callback = null;
    _onError = null;
    if (_doneCallback != null) {
      _doneCallback();
      _doneCallback = null;
    }
  }

  void _add(T data) {
    if (_callback != null) {
      if (_contextZone != null) {
        _contextZone.runUnary(_callback, data);
      } else {
        _callback(data);
      }
    }
  }

  @override
  void onData(handleData) {
    if (_stream != null) {
      _callback = handleData;
    }
  }

  @override
  void onError(handleError) {
    if (_stream != null) {
      _onError = handleError;
    }
  }

  @override
  void onDone(handleDone) {
    if (_stream != null) {
      _doneCallback = handleDone;
    }
  }

  @override
  void pause([resumeSignal]) => throw UnsupportedError('Not supported.');

  @override
  void resume() {
    throw UnsupportedError('Not supported.');
  }

  @override
  Future<S> asFuture<S>([S futureValue]) {
    throw UnsupportedError('Not supported.');
  }
}

/// Provides an interface for both [StreamController] and [Stream] for use with
/// output events in Angular components.
///
/// Reduces the amount of boilerplate needed by removing the need for a getter
/// that returns the stream for Angular.
class SimpleEmitter<T> extends SimpleStream<T> {
  SimpleEmitter(
      {bool isSync = true,
      bool runInZone = true,
      SubscriptionChangeListener<dynamic> onListen,
      SubscriptionChangeListener<dynamic> onCancel})
      : super.broadcast(
            isSync: isSync,
            runInZone: runInZone,
            onListen: onListen,
            onCancel: onCancel);

  /// Returns `this`.
  EventSink<T> get sink => this;
}
