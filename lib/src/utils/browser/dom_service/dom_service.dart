// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math' show max, min;

import '../../angular/managed_zone/interface.dart';
import '../../async/async.dart';
import '../../disposer/disposable_callback.dart';
// TODO(google): Consolidate this with RenderSync /Angular.

import '../../disposer/disposer.dart';

/// A callback from [DomService.scheduleRead] or [DomService.scheduleWrite].
typedef void DomReadWriteFn();

/// A callback that returns a future that completes in the next animation frame.
typedef Future<num> RequestAnimationFrame();

/// Utility class to synchronize DOM operations across components, e.g. to check
/// changes in the layout after a UI update or application event.
class DomService {
  static const _TURN_DONE_EVENT_TYPE = 'doms-turn';

  /// The maximum time the idle scheduler waits between events.
  static const int _MAX_IDLE_TIMER_MILLIS = 4000;

  /// The minimum time the idle scheduler waits between events.
  static const int _MIN_IDLE_TIMER_MILLIS = 400;

  /// The time to increment after each layout check.
  static const int _IDLE_TIMER_INC_MILLIS = 100;

  final _domReadQueue = new List<DomReadWriteFn>();
  final _domWriteQueue = new List<DomReadWriteFn>();
  final ManagedZone _managedZone;
  final Window _window;

  Zone _rootZone = Zone.ROOT;
  bool _insideDigest = false;
  Disposable _layoutObserveRead;
  bool _scheduledProcessQueue = false;
  StreamController _onLayoutChangedController;
  Stream _onLayoutChangedStream;
  StreamController _onQueuesProcessedController;
  Stream _onQueuesProcessedStream;
  int _nextFrameId = -1;
  Completer _nextFrameCompleter;
  Future<num> _nextFrameFuture;
  DomServiceState _state = DomServiceState.Idle;
  bool _crossAppInitialized = false;
  StreamController _onIdleController;
  Stream _onIdleStream;
  int _idleTimerMillis = _MAX_IDLE_TIMER_MILLIS;
  Timer _idleTimer;
  bool _inDispatchTurnDoneEvent = false;

  /// Optional callback to check if DOM has been mutated by angular in
  /// a zone turn.
  ///
  /// Can be used to reduce layout checks due to Zone turns that don't detect
  /// any changes and don't mutate the DOM.
  ///
  /// isDomMutatedPredicate should return true if DOM has been modified since
  /// last call to resetIsDomMutated.
  IsDomMutatedPredicate isDomMutatedPredicate;

  /// Optional callback to reset dom mutation state for predicate.
  Function resetIsDomMutated;
  bool _writeQueueChangedLayout = false;

  /// Creates an instance that automatically runs outside of [managedZone], and
  /// uses the browser-supplied ([Window]) for animation frames and resizing
  /// checks.
  DomService(this._managedZone, this._window);

  /// Initializes the DomService to send window events, in order to coordinate
  /// layout checks across apps on the same page.
  void init() {
    if (_crossAppInitialized) return;
    _crossAppInitialized = true;
    _managedZone.runOutside(() {
      _managedZone.onTurnDone.listen((_) {
        if (isDomMutatedPredicate == null || isDomMutatedPredicate()) {
          // Sending an event to DomService in other apps on the same page.
          _inDispatchTurnDoneEvent = true;
          _window.dispatchEvent(new Event(_TURN_DONE_EVENT_TYPE));
          _inDispatchTurnDoneEvent = false;
          // If dom has been mutated by angular, mark [_writeQueueChangedLayout]
          // to true. So that [_scheduleOnLayoutChanged] will be called normally
          // when there is a request to change layout.
          if (isDomMutatedPredicate != null && isDomMutatedPredicate()) {
            _writeQueueChangedLayout = true;
          }
          if (resetIsDomMutated != null) {
            resetIsDomMutated();
          }
        }
      });
    });
  }

  /// Indicates to users that we are currently processing items in the read
  /// queue.
  ///
  /// Client can optimize calls by not adding into the queue but instead
  /// is safe to execute the read synchronously.
  ///
  /// Example:
  ///     if (domService.isReadingDom) {
  ///       readClientMetrics();
  ///     } else {
  ///       domService.scheduleRead(readClientMetrics);
  ///     }
  bool get isReadingDom => (_state == DomServiceState.Reading);

  /// Indicates to users that we are currently processing items in the write
  /// queue.
  ///
  /// Client can optimize calls by not adding into the queue but instead
  /// is safe to execute the write synchronously.
  ///
  /// Example:
  ///     if (domService.isWritingDom) {
  ///       writeClientMetrics();
  ///     } else {
  ///       domService.scheduleWrite(writeClientMetrics);
  ///     }
  bool get isWritingDom => (_state == DomServiceState.Writing);

  /// Advances the animation frame future, without waiting for the window's
  /// callback. If there were already an animation frame scheduled, it will
  /// cancel it.
  ///
  /// ONLY FOR TESTING!
  /// DO NOT CALL THIS METHOD IN PRODUCTION CODE!
  void leap({num highResTimer, steps: 1}) {
    while (steps > 0) {
      if (_nextFrameFuture == null) return;
      if (highResTimer == null) {
        highResTimer = new DateTime.now().millisecondsSinceEpoch;
      }
      assert(_nextFrameCompleter != null);
      final Completer completer = _nextFrameCompleter;
      _window.cancelAnimationFrame(_nextFrameId);
      _nextFrameFuture = null;
      _nextFrameCompleter = null;
      completer.complete(highResTimer);
      steps--;
    }
  }

  /// A future that completes with an animation frame.
  ///
  /// Unlike the browser's animation frame, if there is one already scheduled,
  /// it reuses that one, avoiding creating multiple frames across components.
  Future<num> get nextFrame {
    if (_nextFrameFuture == null) {
      assert(_nextFrameCompleter == null);
      final completer = new Completer<num>.sync();
      _nextFrameCompleter = completer;
      _managedZone.runOutside(() {
        // Delayed initialization of the cross-app event sending.
        // TODO(google): figure out a better way to initialize this earlier
        init();
        _nextFrameId = _window.requestAnimationFrame((highResTimer) {
          // Protect against window implementation that does not cancel the frame.
          if (completer.isCompleted) return;
          if (completer == _nextFrameCompleter) {
            _nextFrameFuture = null;
            _nextFrameCompleter = null;
          }
          completer.complete(highResTimer);
        });
      });
      _nextFrameFuture =
          new ZonedFuture(completer.future, _managedZone.runOutside);
    }
    return _nextFrameFuture;
  }

  /// A stream that fires when the browser seems to be idle.
  ///
  /// **NOTE**:
  ///   - This is an EXPERIMENTAL feature, and should be used with extreme care.
  ///   - Subscriptions to the stream should be cancelled as soon as possible.
  Stream get onIdle {
    if (_onIdleStream == null) {
      _onIdleController = new StreamController.broadcast(
          sync: true, onListen: _resetIdleTimer, onCancel: _resetIdleTimer);
      // TODO(google): consider scoping it to be inside the managed zone:
      _onIdleStream =
          new ZonedStream(_onIdleController.stream, _managedZone.runOutside);
      // TODO(google): integrate with Chrome's new idle detection API
    }
    return _onIdleStream;
  }

  /// Schedules a coordinated DOM read. If already [isReadingDom], [fn] is
  /// executed *synchronously*.
  ///
  /// Otherwise, it will execute in the next animation frame. It is possible to
  /// cancel by calling [Disposable.dispose] on the return (deprecated). It
  /// is better to pass in a [DisposableCallback] instead
  /// DisposableCallback callback = new DisposableCallback(fn);
  /// domService.scheduleRead(callback);
  Disposable scheduleRead(DomReadWriteFn fn) {
    if (_state == DomServiceState.Reading) {
      fn();
      return Disposable.Noop;
    }
    // This is temporary until all the callers are fixed.
    DisposableCallback callback = new DisposableCallback(fn);
    _scheduleInQueue(callback.call, _domReadQueue);
    return callback;
  }

  /// Schedules a coordinated DOM write. If already [isWritingDom], [fn] is
  /// executed *synchronously*.
  ///
  /// Otherwise, it will execute in the next animation frame. It is possible to
  /// cancel by calling [Disposable.dispose] on the return (deprecated). It
  /// is better to pass in a [DisposableCallback] instead
  /// DisposableCallback callback = new DisposableCallback(fn);
  /// domService.scheduleWrite(callback);
  Disposable scheduleWrite(DomReadWriteFn fn) {
    if (_state == DomServiceState.Writing) {
      fn();
      return Disposable.Noop;
    }
    // This is temporary until all the callers are fixed.
    DisposableCallback callback = new DisposableCallback(fn);
    _scheduleInQueue(callback.call, _domWriteQueue);
    return callback;
  }

  void _scheduleInQueue(DomReadWriteFn fn, List<DomReadWriteFn> queue) {
    queue.add(fn);
    _scheduleProcessQueue();
  }

  /// A future-based API version of [scheduleRead].
  Future onRead() {
    final completer = new Completer.sync();
    scheduleRead(completer.complete);
    return new ZonedFuture(completer.future, _managedZone.runOutside);
  }

  /// A future-based API version of [scheduleWrite].
  Future onWrite() {
    final completer = new Completer.sync();
    scheduleWrite(completer.complete);
    return new ZonedFuture(completer.future, _managedZone.runOutside);
  }

  void _processQueues() {
    assert(_state == DomServiceState.Idle);
    // If all reads and writes were cancelled, prematurely exit.
    if (_domReadQueue.isEmpty && _domWriteQueue.isEmpty) {
      _scheduledProcessQueue = false;
      return;
    }

    // Execute all DOM reads.
    _state = DomServiceState.Reading;
    _processQueue(_domReadQueue);

    // Execute all DOM writes.
    _state = DomServiceState.Writing;
    final previousWriteQueueLength = _processQueue(_domWriteQueue);
    _writeQueueChangedLayout = previousWriteQueueLength > 0;

    // Mention we are now in an 'Idle'. state (neither reading or writing).
    _state = DomServiceState.Idle;

    // If we have mutated the DOM in this queue, subscribers to
    // `onLayoutChanged` will want to be notified, perhaps to recalculate
    // dimensions or positioning of their elements.
    if (_writeQueueChangedLayout) {
      _scheduleOnLayoutChanged();
    }

    // If there are more outstanding items in the queue, schedule a new frame.
    _scheduledProcessQueue = false;
    if (_domReadQueue.isNotEmpty || _domWriteQueue.isNotEmpty) {
      _scheduleProcessQueue();
    } else if (_onQueuesProcessedController != null) {
      _onQueuesProcessedController.add(this);
    }
  }

  int _processQueue(List<DomReadWriteFn> queue) {
    final int previousLength = queue.length;
    for (int i = 0; i < queue.length; i++) {
      DomReadWriteFn fn = queue[i];
      if (fn == null) continue;
      fn();
    }
    // Because we execute any other dom reads or writes synchronously, we
    // should not have scheduled any additional functions.
    assert(queue.length == previousLength);
    queue.clear();
    return previousLength;
  }

  /// A stream that fires when the queues have been processed and are now empty.
  Stream get onQueuesProcessed {
    if (_onQueuesProcessedStream == null) {
      _onQueuesProcessedController = new StreamController.broadcast(sync: true);
      _onQueuesProcessedStream = new ZonedStream(
          _onQueuesProcessedController.stream, _managedZone.runOutside);
    }
    return _onQueuesProcessedStream;
  }

  /// A stream that fires when a component should do a layout check.
  ///
  /// **NOTE**:
  /// - The stream fires *outside* of a framework managed zone
  /// - The stream fires *within* a scheduled DOM read queue, making it safe
  ///   to openly check elements size or positioning in this callback.
  Stream get onLayoutChanged {
    if (_onLayoutChangedStream == null) {
      _onLayoutChangedController = new StreamController.broadcast(sync: true);
      _onLayoutChangedStream = new ZonedStream(
          _onLayoutChangedController.stream, _managedZone.runOutside);
      _managedZone.runOutside(() {
        // Capture events from Angular
        _managedZone.onTurnStart.listen((_) {
          if (_state != DomServiceState.Idle) return;
          _insideDigest = true;
        });
        // Trigger a layout check after the digest.
        _managedZone.onTurnDone.listen((_) {
          if (_state != DomServiceState.Idle) return;
          _insideDigest = false;
          // Reduce layout checks to only those zone turns that mutated DOM.
          if (isDomMutatedPredicate == null ||
              isDomMutatedPredicate() ||
              _writeQueueChangedLayout) {
            _scheduleOnLayoutChanged();
            _writeQueueChangedLayout = false;
          }
        });
        _listenOnLayoutEvents(_window.onAnimationEnd);
        _listenOnLayoutEvents(_window.onResize);
        _listenOnLayoutEvents(_window.onTransitionEnd);
        // Listening Angular turn done events coming from other apps.
        _window.addEventListener(_TURN_DONE_EVENT_TYPE, (_) {
          if (!_inDispatchTurnDoneEvent) {
            _scheduleOnLayoutChanged();
          }
        });
      });
    }
    return _onLayoutChangedStream;
  }

  void _listenOnLayoutEvents(Stream events) {
    if (events == null) return; // happens only in tests with mocked window
    events.listen((_) => _scheduleOnLayoutChanged());
  }

  /// Tracks a layout change defined by [fn], and calls the [callback] function
  /// with the last stable value.
  ///
  /// If [framesToStabilize] is set, the callback will wait for the specified
  /// number of animation frames before it considers the value to be stable.
  /// If the value changes while waiting for stabilization, the animation frame
  /// count restarts. The recommended value depends on the use case:
  /// - visibility checks do not need animation frame stabilization,
  /// - size-tracking properties (e.g. widths on resize) may wait for 3+ frames
  ///   before reacting on the new size.
  ///
  /// The [callback] is assumed to do lightweight DOM updates only.
  /// If you want to trigger both model changes and async operations, you must
  /// set the [runInAngularZone] flag.
  ///
  /// Returns a subscription that allows pausing, resuming and canceling the
  /// observer.
  StreamSubscription trackLayoutChange(fn(), void callback(value),
      {int framesToStabilize: 1, bool runInAngularZone: false}) {
    // TODO(google): Move layout checking into ruler service when landed.
    Function trackerCallback = callback;
    if (runInAngularZone) {
      trackerCallback = (value) {
        _managedZone.runInside(() => callback(value));
      };
    }
    var tracker =
        new _ChangeTracker(this, fn, trackerCallback, framesToStabilize);
    return onLayoutChanged.listen((_) => tracker._onLayoutObserve());
  }

  /// Adds a new callback to the layout observer heartbeat.
  ///
  /// The layout observer heartbeat is a consistency check that is run outside
  /// of the Angular zone. If a component needs to synchronize its position,
  /// size or orientation to the ever-changing layout, it can run its
  /// observations in this callback. If there is a need to modify the DOM or
  /// trigger a new Angular digest, it can do it through the [updateLayout]
  /// method.
  ///
  /// Returns a subscription that allows pausing, resuming and canceling the
  /// observer.
  @Deprecated("Use onLayoutChanged instead")
  StreamSubscription addLayoutObserver(void domReadCallback()) =>
      onLayoutChanged.listen((_) => domReadCallback());

  String describeStability() {
    return {
      '_insideDigest': _insideDigest,
      '_scheduledProcessQueue': _scheduledProcessQueue,
      '_layoutObserveRead': _layoutObserveRead != null,
      '_nextFrameFuture': _nextFrameFuture != null,
      '_domReadQueue': _domReadQueue.length,
      '_domWriteQueue': _domWriteQueue.length,
    }.toString();
  }

  /// Whether there is any pending update.
  bool get hasPendingUpdate =>
      _insideDigest ||
      _scheduledProcessQueue ||
      (_layoutObserveRead != null) ||
      _nextFrameFuture != null ||
      _domReadQueue.isNotEmpty ||
      _domWriteQueue.isNotEmpty;

  /// Whether the view can be considered as stable.
  bool get isStable => !hasPendingUpdate;

  void _scheduleProcessQueue() {
    if (!_scheduledProcessQueue) {
      _scheduledProcessQueue = true;
      nextFrame.then((_) => _processQueues());
    }
  }

  // TODO(google): Consider deprecating from public API.
  void requestLayoutFrame() {
    _scheduleOnLayoutChanged();
  }

  void _scheduleOnLayoutChanged() {
    // If we have a previously scheduled layout check, return.
    if (_layoutObserveRead != null) return;
    // both layout changed and idle listeners can trigger the layout frame
    bool hasLayoutListener = _onLayoutChangedController?.hasListener == true;
    bool hasIdleListener = _onIdleController?.hasListener == true;
    if ((!hasLayoutListener) && (!hasIdleListener)) return;
    // Scheduling the layout observe on the next animation frame's DOM read.
    if (isReadingDom) {
      // We must not join the current DOM read phase, rather force it to be in
      // the next animation frame. The DOM write below will be executed after
      // the reads, and will schedule a read that will trigger a new animation
      // frame.
      scheduleWrite(() {});
      return;
    }
    _layoutObserveRead = scheduleRead(() {
      _layoutObserveRead = null;
      if (_onLayoutChangedController != null) {
        _onLayoutChangedController.add(this);
      }
      _resetIdleTimer();
    });
  }

  /// Returns the current state of the service.
  DomServiceState get state => _state;

  void _resetIdleTimer() {
    if (_onIdleController == null) return;
    _idleTimerMillis += _IDLE_TIMER_INC_MILLIS;
    _idleTimerMillis = min(_MAX_IDLE_TIMER_MILLIS, _idleTimerMillis);
    _cancelIdleTimer();
    if (!_onIdleController.hasListener) return;
    // running in root zone, in order to go outside of the activity tracking
    // TODO(google): implement proper activity tracking integration
    _rootZone.run(() {
      // TODO(google): consider adding animation frame counting that can be used:
      // - to shorten the minimum period
      // - to detect CPU activities that we are not aware of
      _idleTimerMillis = max(_MIN_IDLE_TIMER_MILLIS, _idleTimerMillis);
      _idleTimer = new Timer(new Duration(milliseconds: _idleTimerMillis), () {
        _idleTimer = null;
        _idleTimerMillis = _idleTimerMillis ~/ 2;
        _onIdleController.add(null);
        _scheduleOnLayoutChanged();
      });
    });
  }

  void _cancelIdleTimer() {
    if (_idleTimer != null) {
      _idleTimer.cancel();
      _idleTimer = null;
    }
  }

  /// Visible for testing only.
  set rootZone(Zone value) {
    _rootZone = value;
  }
}

/// State for [DomService] implementations to use.
enum DomServiceState {
  /// The DOM service is currently not processing the queue.
  Idle,

  /// The DOM service is executing all scheduled writes to the DOM.
  Writing,

  /// The DOM service is executing all scheduled reads to the DOM.
  Reading
}

class _ChangeTracker {
  final DomService _domService;
  final Function _fn;
  final Function _callback;
  final int _framesToStabilize;

  var _lastValue;
  int _stableFrameCounter = 0;

  _ChangeTracker(
      this._domService, this._fn, this._callback, this._framesToStabilize) {
    assert(_framesToStabilize > 0);
  }

  void _onLayoutObserve() {
    var value = _fn();
    if (value != _lastValue) {
      _lastValue = value;
      _stableFrameCounter = _framesToStabilize;
    }
    // zero means we have already sent that value to the callback
    if (_stableFrameCounter == 0) return;
    _stableFrameCounter--;
    if (_stableFrameCounter == 0) {
      // just got down to zero, need to invoke callback
      _domService.scheduleRead(() {
        _callback(_lastValue);
      });
    } else {
      // we need more frames to stabilize the value
      _domService.requestLayoutFrame();
    }
  }
}

typedef bool IsDomMutatedPredicate();
