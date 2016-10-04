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
