// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/laminate/ruler/dom_ruler.dart';
import 'package:angular_components/laminate/ruler/ng_ruler.dart';
import 'package:angular_components/utils/angular/managed_zone/angular_2.dart';
import 'package:angular_components/utils/browser/dom_service/angular_2.dart';
import 'package:angular_components/utils/browser/window/module.dart';

/// Providers for using the ruler service.
const rulerBindings = [
  DomRuler,
  domServiceBinding,
  Provider(ManagedZone, useClass: Angular2ManagedZone),
  NgRuler,
  windowBindings
];
