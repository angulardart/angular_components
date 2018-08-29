// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/model/date/date.dart';
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
  Provider(datepickerClock, useExisting: Clock),
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
const timeZoneAwareDatepickerProviders = [
  _legacyClockBinding,
  timeZoneAwareClockProviders,
  Provider(datepickerClock, useExisting: timeZoneAwareClock),
];

/// Binding for [Clock] without annotations. The datepicker no longer needs
/// this, but some clients may depend on having this here still.
// TODO(google): Remove this and fix clients.
const _legacyClockBinding = Provider(Clock, useValue: clockValue);

const defaultDateRange = OpaqueToken('defaultDateRange');
const defaultDateComparison = OpaqueToken('defaultDateComparison');

/// Bindings to create a per-app global date range. This basically creates a
/// mutable [DatepickerComparison] reference to feed into the
/// material-date-range-picker component, and then exposes that same reference
/// as the immutable [DatepickerSelection] interface that other components or
/// services can then inject.
///
/// If there's a binding to either the `defaultDateRange` or
/// `defaultDateComparison` tokens, these bindings will respect those.
/// For instance, a sensible set of bindings might look like:
///
///     bindings = const [
///       globalDateRangeBindings,
///       const Provider(defaultDateRangeToken,
///           useFactory: last7Days, deps: const [Clock]),
///       const Provider(Clock, useValue: const Clock()),
///     ];
///
/// (where `last7Days` comes from this package's `range.dart` library).
const globalDateRangeBindings = [
  Provider(DatepickerModel, useFactory: modelFactory),
  Provider(DatepickerSelection, useFactory: selectionFactory),
];

@Injectable()
DatepickerModel modelFactory(
        @Optional() @Inject(defaultDateComparison) DatepickerComparison cmp,
        @Optional() @Inject(defaultDateRange) DatepickerDateRange range) =>
    DatepickerModel(cmp ?? DatepickerComparison.noComparison(range));

@Injectable()
DatepickerSelection selectionFactory(DatepickerModel model) =>
    DatepickerSelection.wrap(model);
