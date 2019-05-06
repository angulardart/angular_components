// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/model/date/time_zone_aware_clock.dart';

import 'model.dart';

const clockValue = Clock();

const datepickerClock =
    OpaqueToken('third_party.dart_src.acx.material_datepicker.datepickerClock');

/// Standard bindings needed by material datepicker components.
///
/// The provided [Clock], and the datepicker itself, will both use the system
/// time zone. Use [timeZoneAwareDatepickerProviders] if you need to set a
/// custom time zone.
const datepickerBindings = [
  popupBindings,
  _legacyClockBinding,
  ExistingProvider.forToken(datepickerClock, Clock),
];

/// Bindings needed by material datepicker components, for clients who need to
/// set a custom time zone.
///
/// Unlike [datepickerBindings], does not include [popupBindings]. You must
/// provide [popupBindings] separately.
///
/// The provided [Clock] uses system time, but the datepicker will use the
/// timezone indicated by [SettableTimeZone].
///
/// To use these bindings, you must initialize [SettableTimeZone] before
/// constructing the datepicker, or console errors will occur.
@Deprecated("use timeZoneAwareDatepickerModule")
const timeZoneAwareDatepickerProviders = [
  _sharedClockBindings,
  timeZoneAwareClockProviders,
];

const timeZoneAwareDatepickerModule =
    Module(include: [timeZoneAwareClockModule], provide: _sharedClockBindings);

const _sharedClockBindings = [
  _legacyClockBinding,
  ExistingProvider.forToken(datepickerClock, timeZoneAwareClock),
];

/// Binding for [Clock] without annotations. The datepicker no longer needs
/// this, but some clients may depend on having this here still.
// TODO(google): Remove this and fix clients.
const _legacyClockBinding = Provider(Clock, useValue: clockValue);

/// DI token for specifying a default date range, intended to be consumed by
/// some client-specified bindings for a [DatepickerModel].
const defaultDateRange = OpaqueToken('defaultDateRange');

/// DI token for specifying a default date range with a comparison range,
/// intended to be consumed by some client-specified bindings for a
/// [DatepickerModel].
const defaultDateComparison = OpaqueToken('defaultDateComparison');
