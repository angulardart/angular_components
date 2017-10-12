// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

typedef void StreamCallContextFunc(dynamic func());
typedef void StreamCallbackFunc<T>(T value);
typedef void SubscriptionChangeListener<T>(StreamSubscription<T> subscription);

/// A ListenOnly Implementation of a Stream.  It only supports the listen
/// method with the onData parameter.  Additionally, the streamsubscription can
/// only be cancelled.
/// This also acts as a StreamController via the add method.
///
/// Usage: Stream stream = new SimpleStream(false);
/// StreamSubscription sub = stream.listen((item) {print('$item'));
/// stream.add('hi');
/// sub.cancel();
/// stream.add(hi);
///
/// This does not behave like an actual stream.   A callback throwing an
/// exception will cause other callbacks to not execute and the if the stream
/// is synchronous, the error will propagate back to code adding the object
/// to the stream.
///
/// When a subscription is cancelled, it gets cleaned up and will not get
/// called but will remain in the stream's list of subscriptions until the
/// the cleanup microtask executes.  As such, calling hasListener on the
/// stream give the wrong result until the cleanup executes.  Cleanups for all
/// SimpleStreams will occur in the same microtask.
///
class SimpleStream<T> extends StreamView<T> implements EventSink<T> {
  /// Determines if the stream is synchronous or asynchronous.
  final bool _isSync;

  /// Determines if the stream runs callbacks in the zone that the listeners
  /// were registered in. If this is false, callbacks from SimpleStream might
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
  List<SimpleStreamSubscription<T>> _subscriptions = [];

  /// List of items to send to avoid scheduling multiple micro tasks for each
  /// item to be sent.
  List<T> _itemsToSend;

  /// A flag indicating that cleanup is required in case subscriptions are
  /// removed during processing.
  bool _subscriptionRemoved = false;

  /// List of streams to cleanup.
  static List<SimpleStream> _cleanupStreams = [];

  SimpleStream({bool isSync: false, bool runInZone: false})
      : _isSync = isSync,
        _runInZone = runInZone,
        super(const Stream.empty());

  SimpleStream.broadcast(
      {bool isSync: false,
      bool runInZone: false,
      SubscriptionChangeListener<T> onListen,
      SubscriptionChangeListener<T> onCancel})
      : _isSync = isSync,
        _runInZone = runInZone,
        _onListen = onListen,
        _onCancel = onCancel,
        super(const Stream.empty());

  bool get isSync => _isSync;

  @override
  Stream<T> asBroadcastStream(
      {void onListen(StreamSubscription<T> subscription),
      void onCancel(StreamSubscription<T> subscription)}) {
    if (onListen != null || onCancel != null) {
      throw new UnsupportedError('Not supported outside constructor.');
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
      bool schedule = false;
      if (_itemsToSend == null) {
        _itemsToSend = [];
        schedule = true;
      }
      _itemsToSend.add(item);
      if (schedule) {
        scheduleMicrotask(_sendAsync);
      }
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
      SimpleStreamSubscription<T> lastSubscription;
      int i = listeners.length - 1;
      while (i >= 0) {
        var stream = listeners[i]._stream;
        if (stream == null) {
          lastSubscription = listeners.removeAt(i);
        }
        i--;
      }
      // If there are no listeners left and onCancel is set, then call onCancel
      // to indicate that the last subscription has been removed.
      if (listeners.isEmpty && lastSubscription != null && _onCancel != null) {
        _onCancel(lastSubscription);
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
        if (callback is ZoneBinaryCallback) {
          callback(errorEvent, stackTrace);
        } else if (callback is ZoneUnaryCallback) {
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
  void _scheduleCleanup(SimpleStreamSubscription<T> subscription) {
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
  StreamSubscription<T> listen(onData, {onError, onDone, cancelOnError}) {
    // Don't allow listening to a closed stream, it will throw exception in
    // non checked mode since subscriptions will be null once the stream is
    // closed.
    assert(_subscriptions != null);
    StreamCallContextFunc contextFunc;
    if (_runInZone) {
      contextFunc = Zone.current.run;
    }
    var sub = new SimpleStreamSubscription<T>(
        this, onData, onDone, onError, cancelOnError, contextFunc);
    _subscriptions.add(sub);
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
      {bool isSync: false,
      bool runInZone: false,
      SubscriptionChangeListener onListen,
      SubscriptionChangeListener onCancel})
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
  StreamSubscription<T> listen(onData, {onError, onDone, cancelOnError}) {
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
    return new SimpleStreamSubscription._empty();
  }
}

/// A SimpleStream implementation of [StreamSubscription].
///
/// Major differences:
///   Future returned by cancel is shared by all subscriptions.
///   Using [pause] is not supported.
///   _onError is not implemented by SimpleStream.
///
class SimpleStreamSubscription<T> implements StreamSubscription<T> {
  @override
  final bool isPaused = false;
  SimpleStream<T> _stream;
  StreamCallbackFunc<T> _callback;
  StreamCallContextFunc _contextFunc;
  Function _doneCallback;
  Function _onError;
  bool _cancelOnError = false;

  factory SimpleStreamSubscription._empty() =>
      new SimpleStreamSubscription(null, null, null, null, false, null);

  SimpleStreamSubscription(this._stream, this._callback, this._doneCallback,
      this._onError, this._cancelOnError, this._contextFunc);

  @override
  Future cancel() {
    if (_stream != null) {
      // Set doneCallback to null so when [_closeSubscription] is called, we
      // don't call doneCallback.
      var stream = _stream;
      _doneCallback = null;
      _closeSubscription();
      stream._scheduleCleanup(this);
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
      if (_contextFunc != null) {
        _contextFunc(() => _callback(data));
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
  void pause([resumeSignal]) => throw new UnsupportedError('Not supported.');

  @override
  void resume() {
    throw new UnsupportedError('Not supported.');
  }

  @override
  Future<S> asFuture<S>([S futureValue]) {
    throw new UnsupportedError('Not supported.');
  }
}
