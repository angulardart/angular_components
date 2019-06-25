// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/di.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:quiver/time.dart';

final _logger =
    Logger("third_party.dart_src.acx.model.date.time_zone_aware_clock");

/// See [TimeZoneAwareClock].
///
/// Deprecated in favor of TimeZoneAwareClock, since having two ways to perform
/// the same task is redundant, and since subclassing is more expressive.
@Deprecated('use the TimeZoneAwareClock class instead')
const timeZoneAwareClock = OpaqueToken('timeZoneAwareClock');

/// Provides [timeZoneAwareClock], an instance of [Clock] set to
/// [SettableTimeZone], which can change at runtime.
const timeZoneAwareClockProviders = <Provider>[
  FactoryProvider(SettableTimeZone, settableTimeZoneFactory),
  ClassProvider(TimeZoneAwareClock),
  ExistingProvider.forToken(timeZoneAwareClock, TimeZoneAwareClock),
];

/// DI module for [timeZoneAwareClock].
const timeZoneAwareClockModule = Module(provide: timeZoneAwareClockProviders);

/// Clock set to [SettableTimeZone], which can change at runtime.
///
/// [TimeZoneAwareClock.now()] will return a DateTime object whose
/// timezone-dependent fields are set to the current date and time in the
/// specified timezone.
///
/// Important caveats:
///
/// * It is an error to call [TimeZoneAwareClock.now()] before initializing
///   [SettableTimeZone]. If this occurs, a severe error is logged, and the
///   client's local time is returned.
/// * Do not call [DateTime.millisecondsSinceEpoch] or
///   [DateTime.microsecondsSinceEpoch] on [TimeZoneAwareClock.now()]. These
///   will return invalid data, due to the implementation strategy.
///   Use [DateTime.now()] to compute timestamps instead.
/// * As with all [Clock]s, this is set to the client's (browser's) time,
///   which may be incorrect or inaccurate.
// TODO(google): Consider returning a subclass of DateTime which forbids
// calling millisecondsSinceEpoch/microsecondsSinceEpoch.
@Injectable()
class TimeZoneAwareClock extends Clock {
  TimeZoneAwareClock(SettableTimeZone timeZone) : super(timeZone._now);

  /// Creates [TimeZoneAwareClock] that returns fixed [time] value.
  @visibleForTesting
  TimeZoneAwareClock.fixed(DateTime time) : super(() => time);

  @override
  String toString() => 'TimeZoneAwareClock';
}

@Injectable()
Clock clockFactory(SettableTimeZone timeZone) => TimeZoneAwareClock(timeZone);

/// Workaround to avoid making SettableTimeZone @Injectable(), since that gives
/// the error: 'Missing identifier "TimeFunction" from metadata map".
@Injectable()
SettableTimeZone settableTimeZoneFactory() => SettableTimeZone();

/// Wrapper to set/get a custom time zone for the [Clock] provided by
/// [timeZoneAwareClockProviders].
class SettableTimeZone {
  final TimeFunction _time;
  final _initialized = Completer<Null>();
  final bool _throwIfNotInitialized;

  /// The offset to add to UTC to get local time.
  ///
  /// May be null, indicating that the current time zone is unknown. In this
  /// case, [Clock.now()] will print an error and return system time.
  Duration get offsetFromUtc => _offsetFromUtc;
  set offsetFromUtc(Duration newOffset) {
    if (newOffset != null && newOffset.inMicroseconds == null) {
      throw ArgumentError.value(
          newOffset, 'newOffset' 'holds a null or undefined value');
    }
    if (newOffset != null && newOffset.inMicroseconds.isNaN) {
      throw ArgumentError.value(newOffset, 'newOffset' 'is NaN!');
    }

    if (!_initialized.isCompleted && newOffset != null) {
      _initialized.complete();
    }
    _offsetFromUtc = newOffset;
  }

  Duration _offsetFromUtc;

  /// Returns true iff [offsetFromUtc] is non-null.
  bool get isInitialized => _offsetFromUtc != null;

  /// Returns a future which completes when [offsetFromUtc] is first set to a
  /// non-null value, indicating that it's now safe to call [Clock.now()].
  Future<Null> get onInit => _initialized.future;

  /// Accepts a custom [timeFunc] for testing purposes, following the same
  /// pattern as [Clock].
  ///
  /// [throwIfNotInitialized] will cause [StateError] to be thrown if [now()]
  /// is called before [offsetFromUtc] is set. This will eventually be the only
  /// available behavior.
  // TODO(google): Default throwIfNotInitialized to true. Deprecate+remove it.
  SettableTimeZone(
      [TimeFunction timeFunc = systemTime, bool throwIfNotInitialized = false])
      : _time = timeFunc,
        _throwIfNotInitialized = throwIfNotInitialized;

  /// The current time, in the time zone given by [offsetFromUtc].
  ///
  /// Not for public use; call [Clock.now()] instead.
  DateTime _now() {
    var systemTime = _time();
    if (offsetFromUtc == null) {
      // Ensure that offsetFromUtc is set before calling now() on this object.
      if (_throwIfNotInitialized) {
        throw StateError(
            'TimeZoneAwareClock not initialized with time zone data');
      } else {
        _logger.severe('not initialized with time zone data');
        return systemTime;
      }
    } else if (systemTime.timeZoneOffset.inMicroseconds == null) {
      throw StateError(
          'System time has a null or undefined timezone offset! $systemTime');
    } else if (systemTime.timeZoneOffset.inMicroseconds.isNaN) {
      throw StateError('System time has a NaN timezone offset! $systemTime');
    }

    // To convert system time to UTC, subtract systemTime.timeZoneOffset.
    // To convert UTC to the Custom's local time, add [offsetFromUtc].
    var offset = offsetFromUtc - systemTime.timeZoneOffset;
    if (offset.inMicroseconds == null) {
      throw StateError('Computed time offset is null or undefined! '
          '$offsetFromUtc - ${systemTime.timeZoneOffset} = $offset');
    }
    if (offset.inMicroseconds.isNaN) {
      throw StateError('Computed time offset is NaN! '
          '$offsetFromUtc - ${systemTime.timeZoneOffset} = $offset');
    }
    return systemTime.add(offset);
  }
}
