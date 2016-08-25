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

library ads.acx2.utils.disposer.disposer;

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

final Logger _logger = new Logger('ads.acx2.utils.disposer');
const String _oneShotDisposerMemoryLeakWarning =
    'Possible memory leak detected: A disposable should not be added to '
    'one shot disposers after the dispose() method has been called.';

/// A function, that when called, will cleanup any resources or subscriptions.
typedef void DisposeFunction();

/// A class with a [dispose] method for cleaning up resources or subscriptions.
abstract class Disposable {
  /// A disposable that does nothing.
  static const Disposable Noop = const _NoopDisposable();

  /// Creates a simple disposable that just executes [disposeFn].
  factory Disposable(DisposeFunction disposeFn) = _SingleFunctionDisposable;

  /// Disposes this disposable and any resources it has open.
  void dispose();
}

/// A no-op implementation of [Disposable].
class _NoopDisposable implements Disposable {
  const _NoopDisposable();

  @override
  void dispose() {}
}

/// A simple implementation of [Disposable].
class _SingleFunctionDisposable implements Disposable {
  final DisposeFunction _disposeFn;

  _SingleFunctionDisposable(this._disposeFn);

  @override
  void dispose() {
    _disposeFn();
  }
}

/// Tracks disposables that are added to it for later disposal.
///
/// Example usage:
///     final disposer = new Disposer()
///       ..addDisposable(() => print('Clean up');)
///       ..addDisposable(stream.listen())
///       ..addDiposable(myCustomDisposable);
///
///     disposer.dispose();
///
/// Example usage of 'oneShot' mode.  Please use this for cases where there
/// is a single call to dispose as it will help detect potential memory leaks
/// where a disposable is being added after the disposer has been disposed.
/// This is very typical for Angular components where disposer.dispose() is
/// called in ngOnDestroy.
///
///     final disposer = new Disposer(oneShot : true);
///       ..addDisposable(() => print('Clean up');)
///       ..addDisposable(stream.listen())
///
///     disposer.dispose();
///     // The following call will assert.
///     disposer.addDiposable(myCustomDisposable);
///
/// Prefer typed functions whenever possible:
///   [addEventSink]
///   [addFunction]
///   [addStreamSubscription]
class Disposer implements Disposable {
  List<DisposeFunction> _disposeFunctions = null;
  List<StreamSubscription> _disposeSubs = null;
  List<EventSink> _disposeSinks = null;
  List<Disposable> _disposeDisposables = null;
  final bool _oneShot;
  bool _deprecated = false;
  bool _disposeCalled = false;

  /// Pass [oneShot] as true if no disposables are meant to be added after
  /// the dispose method is called.
  @Deprecated("Please use oneShot or multi instead")
  Disposer({bool oneShot: false})
      : _oneShot = oneShot,
        _deprecated = true;

  /// Convenience constructor for one shot mode or single dispose mode.
  Disposer.oneShot() : _oneShot = true;

  /// Convenience constructor for supporting multiple calls to dispose.
  Disposer.multi() : _oneShot = false;

  /// Registers [disposable] for disposal when [dispose] is called later.
  ///
  /// Prefer typed functions whenever possible, as this is megamorphic:
  ///   [addEventSink]
  ///   [addStreamSubscription]
  ///   [addFunction]
  dynamic/*=T*/ addDisposable/*<T>*/(/*=T*/ disposable) {
    // TODO(sigmund): `disposable_` is a workaround to make this code
    // strong-clean. We should be able to get rid of it once dartbug.com/26439
    // is addressed in the language.
    dynamic disposable_ = disposable;
    if (disposable_ is Disposable) {
      _disposeDisposables ??= [];
      _disposeDisposables.add(disposable as Disposable);
      _checkIfAlreadyDisposed();
    } else if (disposable_ is StreamSubscription) {
      addStreamSubscription(disposable_);
    } else if (disposable_ is EventSink) {
      addEventSink(disposable_);
    } else if (disposable_ is DisposeFunction) {
      addFunction(disposable_);
    } else {
      throw new ArgumentError.value(disposable, 'disposable',
          'Unsupported type: ${disposable.runtimeType}');
    }
    return disposable;
  }

  /// Registers [disposable].
  StreamSubscription/*<T>*/ addStreamSubscription/*<T>*/(
      StreamSubscription/*<T>*/ disposable) {
    _disposeSubs ??= [];
    _disposeSubs.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  /// Registers [disposable].
  EventSink/*<T>*/ addEventSink/*<T>*/(EventSink/*<T>*/ disposable) {
    _disposeSinks ??= [];
    _disposeSinks.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  /// Registers [disposable].
  DisposeFunction addFunction(DisposeFunction disposable) {
    assert(disposable != null);
    _disposeFunctions ??= [];
    _disposeFunctions.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  void _checkIfAlreadyDisposed() {
    if (_oneShot && _disposeCalled) {
      if (_deprecated) {
        _logger.severe(_oneShotDisposerMemoryLeakWarning, null /* error */,
            new Trace.current());
        assert(false); // For easy testing.
      } else {
        throw new StateError(_oneShotDisposerMemoryLeakWarning);
      }
    }
  }

  @override
  void dispose() {
    if (_disposeSubs != null) {
      int len = _disposeSubs.length;
      for (var i = 0; i < len; i++) {
        _disposeSubs[i].cancel();
      }
      _disposeSubs = null;
    }
    if (_disposeSinks != null) {
      int len = _disposeSinks.length;
      for (var i = 0; i < len; i++) {
        _disposeSinks[i].close();
      }
      _disposeSinks = null;
    }
    if (_disposeDisposables != null) {
      int len = _disposeDisposables.length;
      for (var i = 0; i < len; i++) {
        _disposeDisposables[i].dispose();
      }
      _disposeDisposables = null;
    }
    if (_disposeFunctions != null) {
      int len = _disposeFunctions.length;
      for (var i = 0; i < len; i++) {
        _disposeFunctions[i]();
      }
      _disposeFunctions = null;
    }
    _disposeCalled = true;
  }
}