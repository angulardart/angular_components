// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';

import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/browser/dom_service/angular_2.dart';
import '../../utils/browser/window/module.dart';

/// Bindings needed for the material ripple component.
const rippleBindings = const [
  windowBindings,
  domServiceBinding,
  const Provider(ManagedZone, useClass: Angular2ManagedZone)
];
